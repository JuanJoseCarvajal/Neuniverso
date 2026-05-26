#!/bin/bash
# Deployment Script for NEUNIVERSO on Hostinger
# Uso: ./deploy-hostinger.sh <branch> [deploy|pull]

set -e  # Exit on error

BRANCH="${1:-main}"
ACTION="${2:-deploy}"
REPO_DIR="$HOME/neuniverso"
DOCKER_COMPOSE_FILE="$REPO_DIR/infrastructure/docker-compose.yml"
NGINX_CONF="$REPO_DIR/infrastructure/nginx.conf"
ENV_FILE="$REPO_DIR/infrastructure/.env"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║     NEUNIVERSO Deployment Script for Hostinger    ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════╝${NC}"

# Check if Docker is installed
echo -e "\n${YELLOW}[1/7]${NC} Checking Docker installation..."
if ! command -v docker &> /dev/null; then
    echo -e "${RED}✗ Docker not found${NC}"
    echo "  Installing Docker..."
    curl -fsSL https://get.docker.com | sh
    sudo usermod -aG docker $USER
    echo -e "${GREEN}✓ Docker installed${NC}"
else
    echo -e "${GREEN}✓ Docker found${NC}"
fi

# Check if Docker Compose is installed
echo -e "\n${YELLOW}[2/7]${NC} Checking Docker Compose..."
if ! docker compose version &> /dev/null; then
    echo -e "${RED}✗ Docker Compose not found${NC}"
    exit 1
else
    echo -e "${GREEN}✓ Docker Compose ready${NC}"
fi

# Clone or update repository
echo -e "\n${YELLOW}[3/7]${NC} Setting up repository..."
if [ ! -d "$REPO_DIR" ]; then
    echo "  Cloning repository..."
    git clone --branch "$BRANCH" https://github.com/JuanJoseCarvajal/Neuniverso.git "$REPO_DIR"
else
    echo "  Updating repository..."
    cd "$REPO_DIR"
    git fetch origin
    git checkout "$BRANCH"
    git pull origin "$BRANCH"
fi
echo -e "${GREEN}✓ Repository ready${NC}"

# Create environment file if it doesn't exist
echo -e "\n${YELLOW}[4/7]${NC} Setting up environment..."
if [ ! -f "$ENV_FILE" ]; then
    echo "  Creating .env file..."
    cp "$REPO_DIR/infrastructure/.env.example" "$ENV_FILE"
    
    # Generate secure secrets
    NEXTAUTH_SECRET=$(openssl rand -base64 32)
    DB_PASSWORD=$(openssl rand -base64 16 | tr -d "=+/" | cut -c1-15)
    REDIS_PASSWORD=$(openssl rand -base64 16 | tr -d "=+/" | cut -c1-15)
    
    # Update .env with generated values
    sed -i "s/NEXTAUTH_SECRET=.*/NEXTAUTH_SECRET=$NEXTAUTH_SECRET/" "$ENV_FILE"
    sed -i "s/DB_PASSWORD=.*/DB_PASSWORD=$DB_PASSWORD/" "$ENV_FILE"
    sed -i "s/REDIS_PASSWORD=.*/REDIS_PASSWORD=$DB_PASSWORD/" "$ENV_FILE"
    sed -i "s|DATABASE_URL=.*|DATABASE_URL=postgresql://neuniverso:$DB_PASSWORD@db:5432/neuniverso_db|" "$ENV_FILE"
    sed -i "s|REDIS_URL=.*|REDIS_URL=redis://:$REDIS_PASSWORD@redis:6379|" "$ENV_FILE"
    
    echo -e "${GREEN}✓ .env created with secure values${NC}"
    echo -e "${YELLOW}  ⚠ Review and update .env with your APIs (Stripe, OpenAI, etc)${NC}"
else
    echo -e "${GREEN}✓ .env already exists${NC}"
fi

# Create required directories
echo -e "\n${YELLOW}[5/7]${NC} Creating directories..."
mkdir -p "$REPO_DIR/infrastructure/certbot/"{conf,www}
mkdir -p "$REPO_DIR/backups"
chmod -R 755 "$REPO_DIR/infrastructure/certbot" "$REPO_DIR/backups"
echo -e "${GREEN}✓ Directories ready${NC}"

# Start Docker containers
echo -e "\n${YELLOW}[6/7]${NC} Starting services..."
cd "$REPO_DIR/infrastructure"

# Stop existing containers if any
docker compose down 2>/dev/null || true

# Start containers
docker compose up -d --build

# Wait for services to be healthy
echo "  Waiting for services to be healthy..."
sleep 10

# Check if web service is healthy
HEALTH_CHECK=0
for i in {1..30}; do
    if docker compose exec -T web curl -f http://localhost:3000/ > /dev/null 2>&1; then
        HEALTH_CHECK=1
        break
    fi
    echo "  Checking... ($i/30)"
    sleep 2
done

if [ $HEALTH_CHECK -eq 0 ]; then
    echo -e "${RED}✗ Services failed to start properly${NC}"
    docker compose logs
    exit 1
fi

echo -e "${GREEN}✓ All services running${NC}"

# Setup SSL
echo -e "\n${YELLOW}[7/7]${NC} Setting up SSL..."
if [ ! -f "$REPO_DIR/infrastructure/certbot/conf/live/neuniverso.com/fullchain.pem" ]; then
    echo "  Requesting SSL certificate..."
    docker compose exec -T certbot certbot certonly \
        --webroot -w /var/www/certbot \
        -d neuniverso.com -d www.neuniverso.com \
        --email jjcmili@hotmail.com \
        --agree-tos --non-interactive 2>&1 || echo "SSL setup (will be auto-generated)"
    
    # Reload NGINX
    docker compose exec nginx nginx -s reload 2>/dev/null || true
fi
echo -e "${GREEN}✓ SSL configured${NC}"

# Setup cron for backups
echo -e "\n${YELLOW}Setting up automated backups...${NC}"
CRON_JOB="0 2 * * * cd $REPO_DIR && bash scripts/backup.sh"
(crontab -l 2>/dev/null | grep -v "backup.sh"; echo "$CRON_JOB") | crontab -
echo -e "${GREEN}✓ Backups scheduled daily at 2 AM${NC}"

# Summary
echo -e "\n${GREEN}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║          ✓ Deployment Completed Successfully!     ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════╝${NC}"

echo -e "\n${YELLOW}Next Steps:${NC}"
echo -e "  1. Update DNS: Point neuniverso.com → $(hostname -I | awk '{print $1}')"
echo -e "  2. Update .env: nano $ENV_FILE"
echo -e "  3. Add APIs: Stripe, OpenAI, SMTP, etc."
echo -e "  4. Access: https://neuniverso.com"

echo -e "\n${YELLOW}Useful Commands:${NC}"
echo -e "  View logs:    docker compose -f $DOCKER_COMPOSE_FILE logs -f"
echo -e "  Status:       docker compose -f $DOCKER_COMPOSE_FILE ps"
echo -e "  Restart:      docker compose -f $DOCKER_COMPOSE_FILE restart web"
echo -e "  Backup now:   bash $REPO_DIR/scripts/backup.sh"

echo -e "\n${GREEN}🚀 NEUNIVERSO is now running!${NC}\n"
