-- Initial Database Setup for NEUNIVERSO
-- This script is automatically run when PostgreSQL container starts

-- Create schema if needed
CREATE SCHEMA IF NOT EXISTS public;

-- Create tables (add your schema here as needed)
-- Example: Users table with authentication
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

-- Grant permissions
GRANT ALL PRIVILEGES ON SCHEMA public TO neuniverso;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO neuniverso;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO neuniverso;
