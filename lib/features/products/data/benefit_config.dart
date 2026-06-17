import 'package:all_benefits_group/features/products/presentation/benefit_detail_page.dart';

class BenefitConfig {
  final String title;
  final String coverPath;
  final String bebeMessage;
  final String bebeImagePath;
  final List<BenefitItemData> items;
  final String ctaText;
  final String skipText;

  const BenefitConfig({
    required this.title,
    required this.coverPath,
    required this.bebeMessage,
    this.bebeImagePath = 'assets/images/bebe/bebe-hello.png',
    required this.items,
    this.ctaText = 'CONTACTANOS',
    this.skipText = 'SALTAR',
  });
}

final Map<String, BenefitConfig> benefitConfigs = {
  'Seguros': BenefitConfig(
    title: 'Seguros',
    coverPath: 'assets/images/portadas/seguros.webp',
    bebeMessage: 'Protege lo que más quieres con cobertura completa.',
    bebeImagePath: 'assets/images/bebe/seguros.png',
    items: [
      const BenefitItemData(
        imagePath: 'assets/images/items/seguros.webp',
        title: 'Protege a tu familia',
        description: 'Asegura su bienestar y construye tranquilidad.',
      ),
      const BenefitItemData(
        imagePath: 'assets/images/items/seguros.webp',
        title: 'Cobertura integral',
        description: 'Desde vida hasta autos y hogar.',
      ),
      const BenefitItemData(
        imagePath: 'assets/images/items/seguros.webp',
        title: 'Activación rápida',
        description: 'Empieza a estar protegido en 24h.',
      ),
    ],
  ),
  'Finanzas': BenefitConfig(
    title: 'Finanzas',
    coverPath: 'assets/images/portadas/finanzas.webp',
    bebeMessage: 'Hablemos de cómo hacer que tu dinero haga más por ti.',
    bebeImagePath: 'assets/images/bebe/finanzas-bebe.png',
    items: [
      const BenefitItemData(
        imagePath: 'assets/images/items/finanzas.webp',
        title: 'Protege a tu familia',
        description: 'Asegura su bienestar y construye tranquilidad.',
      ),
      const BenefitItemData(
        imagePath: 'assets/images/items/finanzas.webp',
        title: 'Haz crecer tu patrimonio',
        description: 'Invierte hoy para un futuro más sólido y próspero.',
      ),
      const BenefitItemData(
        imagePath: 'assets/images/items/finanzas.webp',
        title: 'Alcanza tus metas',
        description: 'Define tus objetivos y hazlos realidad paso a paso.',
      ),
    ],
  ),
  'Taxes': BenefitConfig(
    title: 'Taxes',
    coverPath: 'assets/images/portadas/taxes.webp',
    bebeMessage: 'Te ayudamos a maximizar tu reembolso y cumplir con el IRS.',
    bebeImagePath: 'assets/images/bebe/taxes.png',
    items: [
      const BenefitItemData(
        imagePath: 'assets/images/items/taxes.webp',
        title: 'Declaración personal',
        description: 'Rápida, segura y sin complicaciones.',
      ),
      const BenefitItemData(
        imagePath: 'assets/images/items/taxes.webp',
        title: 'Taxes para negocios',
        description: 'Optimiza las finanzas de tu empresa.',
      ),
      const BenefitItemData(
        imagePath: 'assets/images/items/taxes.webp',
        title: 'ITIN y más',
        description: 'Trámites migratorios fiscales sin estrés.',
      ),
    ],
  ),
  'Academia': BenefitConfig(
    title: 'Academia',
    coverPath: 'assets/images/portadas/academia.webp',
    bebeMessage: 'Capacítate y certifícate para crecer profesionalmente.',
    bebeImagePath: 'assets/images/bebe/academy.png',
    items: [
      const BenefitItemData(
        imagePath: 'assets/images/items/academia.webp',
        title: 'Cursos en línea',
        description: 'Aprende a tu ritmo, donde quieras.',
      ),
      const BenefitItemData(
        imagePath: 'assets/images/items/academia.webp',
        title: 'Certificaciones',
        description: 'Avala tus conocimientos con credenciales reales.',
      ),
      const BenefitItemData(
        imagePath: 'assets/images/items/academia.webp',
        title: 'Mentorías',
        description: 'Acompañamiento de expertos en tu área.',
      ),
    ],
  ),
  'Inmigración': BenefitConfig(
    title: 'Inmigración',
    coverPath: 'assets/images/portadas/inmigracion.webp',
    bebeMessage: 'Te guiamos paso a paso en tu proceso migratorio.',
    bebeImagePath: 'assets/images/bebe/inmigracion.png',
    items: [
      const BenefitItemData(
        imagePath: 'assets/images/items/inmigracion.webp',
        title: 'Visas y residencia',
        description: 'Asesoría experta para cada etapa.',
      ),
      const BenefitItemData(
        imagePath: 'assets/images/items/inmigracion.webp',
        title: 'Ciudadanía',
        description: 'Preparación completa para el examen.',
      ),
      const BenefitItemData(
        imagePath: 'assets/images/items/inmigracion.webp',
        title: 'Trámites legales',
        description: 'Documentación clara y sin confusiones.',
      ),
    ],
  ),
  'Compañías': BenefitConfig(
    title: 'Compañías',
    coverPath: 'assets/images/portadas/compañias.webp',
    bebeMessage: 'Formaliza y protege tu negocio con nosotros.',
    bebeImagePath: 'assets/images/bebe/company.png',
    items: [
      const BenefitItemData(
        imagePath: 'assets/images/items/compañias.webp',
        title: 'Constitución',
        description: 'Crea tu empresa de forma rápida y segura.',
      ),
      const BenefitItemData(
        imagePath: 'assets/images/items/compañias.webp',
        title: 'Permisos',
        description: 'Gestiona licencias y documentos legales.',
      ),
      const BenefitItemData(
        imagePath: 'assets/images/items/compañias.webp',
        title: 'Protección legal',
        description: 'Cobertura para imprevistos empresariales.',
      ),
    ],
  ),
  'Crédito': BenefitConfig(
    title: 'Crédito',
    coverPath: 'assets/images/portadas/credito.webp',
    bebeMessage: 'Repara y eleva tu puntaje de crédito con estrategia.',
    bebeImagePath: 'assets/images/bebe/credit.png',
    items: [
      const BenefitItemData(
        imagePath: 'assets/images/items/credito.webp',
        title: 'Reparación',
        description: 'Mejora tu historial paso a paso.',
      ),
      const BenefitItemData(
        imagePath: 'assets/images/items/credito.webp',
        title: 'Monitoreo',
        description: 'Seguimiento constante de tu puntaje.',
      ),
      const BenefitItemData(
        imagePath: 'assets/images/items/credito.webp',
        title: 'Asesoría',
        description: 'Estrategias para obtener mejores tasas.',
      ),
    ],
  ),
  'Real Estate': BenefitConfig(
    title: 'Real Estate',
    coverPath: 'assets/images/portadas/realstate.webp',
    bebeMessage: 'Encuentra la propiedad ideal o invierte con confianza.',
    bebeImagePath: 'assets/images/bebe/realstate.png',
    items: [
      const BenefitItemData(
        imagePath: 'assets/images/items/realstate.webp',
        title: 'Compra',
        description: 'Asesoría integral para adquirir tu hogar.',
      ),
      const BenefitItemData(
        imagePath: 'assets/images/items/realstate.webp',
        title: 'Venta',
        description: 'Maximiza el valor de tu propiedad.',
      ),
      const BenefitItemData(
        imagePath: 'assets/images/items/realstate.webp',
        title: 'Inversión',
        description: 'Genera ingresos con bienes raíces.',
      ),
    ],
  ),
  'Préstamos': BenefitConfig(
    title: 'Préstamos',
    coverPath: 'assets/images/portadas/prestamos.webp',
    bebeMessage: 'Obtén el capital que necesitas sin complicaciones.',
    bebeImagePath: 'assets/images/bebe/prestamos.png',
    items: [
      const BenefitItemData(
        imagePath: 'assets/images/items/prestamos.webp',
        title: 'Personales',
        description: 'Rápidos, flexibles y con buenas tasas.',
      ),
      const BenefitItemData(
        imagePath: 'assets/images/items/prestamos.webp',
        title: 'Negocios',
        description: 'Capital para hacer crecer tu empresa.',
      ),
      const BenefitItemData(
        imagePath: 'assets/images/items/prestamos.webp',
        title: 'Hipotecarios',
        description: 'Financiamiento para tu hogar soñado.',
      ),
    ],
  ),
  'Voces de Conciencia': BenefitConfig(
    title: 'Voces de Conciencia',
    coverPath: 'assets/images/portadas/voces.webp',
    bebeMessage: 'Lo que nadie te enseñó, hoy lo aprendes acá. Historias que despiertan.',
    bebeImagePath: 'assets/images/bebe/voces.png',
    items: [
      const BenefitItemData(
        imagePath: 'assets/images/items/voces.webp',
        title: 'Historias reales',
        description: 'Testimonios que inspiran y transforman.',
      ),
      const BenefitItemData(
        imagePath: 'assets/images/items/voces.webp',
        title: 'Conciencia social',
        description: 'Aprende sobre temas que importan.',
      ),
      const BenefitItemData(
        imagePath: 'assets/images/items/voces.webp',
        title: 'Comunidad',
        description: 'Conecta con personas que piensan como tú.',
      ),
    ],
  ),
  'Notario': BenefitConfig(
    title: 'Notario',
    coverPath: 'assets/images/portadas/notario.png',
    bebeMessage: 'Servicios notariales confiables para tus documentos importantes.',
    items: [
      const BenefitItemData(
        imagePath: 'assets/images/items/notario.png',
        title: 'Autenticaciones',
        description: 'Certifica la autenticidad de tus documentos.',
      ),
      const BenefitItemData(
        imagePath: 'assets/images/items/notario.png',
        title: 'Escrituras',
        description: 'Elaboración y firma de escrituras públicas.',
      ),
      const BenefitItemData(
        imagePath: 'assets/images/items/notario.png',
        title: 'Declaraciones juradas',
        description: 'Legaliza tus declaraciones ante autoridades.',
      ),
    ],
  ),
};
