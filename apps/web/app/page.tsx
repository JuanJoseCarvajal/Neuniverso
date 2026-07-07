const pillars = [
  {
    title: "Neuroconsciencia",
    copy: "Espacios digitales que ayudan a pensar mejor, sentir con claridad y convertir ideas internas en accion.",
  },
  {
    title: "Universo creativo",
    copy: "Una identidad expansiva para productos, experiencias, contenidos y comunidades con alma propia.",
  },
  {
    title: "Tecnologia viva",
    copy: "Arquitectura preparada para crecer con inteligencia artificial, datos, comercio y automatizacion.",
  },
  {
    title: "Comunidad orbital",
    copy: "Un punto de encuentro para creadores, aprendices, marcas y personas que quieren construir futuro.",
  },
];

const roadmap = [
  {
    date: "01",
    title: "Fundacion digital",
    copy: "Sitio web publico, identidad de marca, narrativa central y base tecnica lista para desplegar.",
  },
  {
    date: "02",
    title: "Experiencias interactivas",
    copy: "Herramientas, contenido guiado y recorridos que conectan conocimiento, creatividad y proposito.",
  },
  {
    date: "03",
    title: "Ecosistema inteligente",
    copy: "Integracion de IA, comunidad, membresias y servicios para convertir Neuniverso en una plataforma.",
  },
];

export default function HomePage() {
  return (
    <main className="page">
      <nav className="nav" aria-label="Navegacion principal">
        <a className="brand" href="#inicio" aria-label="Neuniverso inicio">
          <span className="brand-mark">N</span>
          <span>Neuniverso</span>
        </a>
        <div className="nav-links">
          <a href="#concepto">Concepto</a>
          <a href="#experiencia">Experiencia</a>
          <a href="#ruta">Ruta</a>
        </div>
      </nav>

      <section className="hero" id="inicio">
        <div>
          <p className="eyebrow">Neuro + universo</p>
          <h1>
            <span className="gradient-text">Neuniverso</span>
          </h1>
          <p className="hero-copy">
            Un ecosistema digital para expandir ideas, consciencia y creacion.
            Aqui la tecnologia no se siente fria: funciona como una constelacion
            para ordenar pensamiento, impulsar proyectos y conectar personas.
          </p>
          <div className="hero-actions">
            <a className="button button-primary" href="#concepto">
              Explorar concepto
            </a>
            <a className="button button-secondary" href="#ruta">
              Ver ruta
            </a>
          </div>
        </div>

        <div className="cosmos" aria-hidden="true">
          <div className="orbit" />
          <div className="core" />
          <span className="node node-one" />
          <span className="node node-two" />
          <span className="node node-three" />
          <div className="signal">
            <span />
            <span />
            <span />
          </div>
        </div>
      </section>

      <section className="section" id="concepto">
        <div className="section-inner">
          <div className="section-header">
            <p className="eyebrow">Concepto matriz</p>
            <h2>Una marca para construir desde adentro hacia afuera.</h2>
            <p className="section-lead">
              Neuniverso une mente, cosmos y sistemas digitales. La propuesta
              es crear una plataforma que pueda empezar como presencia web y
              crecer hacia comunidad, productos, aprendizaje, IA y experiencias
              transformadoras.
            </p>
          </div>

          <div className="pillars">
            {pillars.map((pillar, index) => (
              <article className="pillar" key={pillar.title}>
                <span className="index">{String(index + 1).padStart(2, "0")}</span>
                <h3>{pillar.title}</h3>
                <p>{pillar.copy}</p>
              </article>
            ))}
          </div>
        </div>
      </section>

      <section className="section experience" id="experiencia">
        <div className="section-inner experience-grid">
          <div className="metrics" aria-label="Capacidades principales">
            <div className="metric">
              <strong>IA</strong>
              <span>Automatizacion, asistentes y experiencias personalizadas.</span>
            </div>
            <div className="metric">
              <strong>360</strong>
              <span>Marca, comunidad, contenido, servicios y comercio.</span>
            </div>
            <div className="metric">
              <strong>∞</strong>
              <span>Escalable desde una landing hasta una plataforma completa.</span>
            </div>
            <div className="metric">
              <strong>ES</strong>
              <span>Experiencia pensada primero para una audiencia hispana.</span>
            </div>
          </div>

          <article className="experience-card">
            <p className="eyebrow">Experiencia</p>
            <h2>El sitio como portal, no como folleto.</h2>
            <p>
              La primera pantalla presenta Neuniverso como una entidad clara y
              memorable. Las siguientes capas explican su sistema: pensamiento,
              creatividad, tecnologia y comunidad. Esta base ya queda preparada
              para sumar blog, tienda, membresias, panel privado o agentes de IA.
            </p>
          </article>
        </div>
      </section>

      <section className="section" id="ruta">
        <div className="section-inner">
          <div className="section-header">
            <p className="eyebrow">Ruta de expansion</p>
            <h2>De presencia digital a plataforma viva.</h2>
          </div>

          <div className="roadmap">
            {roadmap.map((step) => (
              <article className="step" key={step.title}>
                <time>{step.date}</time>
                <div>
                  <h3>{step.title}</h3>
                  <p>{step.copy}</p>
                </div>
              </article>
            ))}
          </div>
        </div>
      </section>

      <footer className="footer">
        <div className="footer-inner">
          <strong>NEUNIVERSO</strong>
          <span>Inteligencia, consciencia y creacion digital.</span>
        </div>
      </footer>
    </main>
  );
}
