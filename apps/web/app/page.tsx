export default function HomePage() {
  return (
    <main style={{ minHeight: '100vh', display: 'grid', placeItems: 'center', background: '#07111f', color: '#f5f7ff', fontFamily: 'Arial, sans-serif' }}>
      <section style={{ textAlign: 'center', padding: '2rem', maxWidth: '720px' }}>
        <p style={{ textTransform: 'uppercase', letterSpacing: '0.3em', opacity: 0.8 }}>NEUNIVERSO</p>
        <h1 style={{ fontSize: 'clamp(2rem, 4vw, 3.25rem)', margin: '0.5rem 0 1rem' }}>Tu nueva base para la experiencia digital</h1>
        <p style={{ fontSize: '1.05rem', lineHeight: 1.7, opacity: 0.9 }}>
          Este proyecto quedó reiniciado con una estructura mínima, lista para crecer y desplegarse en Hostinger.
        </p>
      </section>
    </main>
  );
}
