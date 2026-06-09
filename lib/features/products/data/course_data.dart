class CourseData {
  final String icon;
  final String imagePath;
  final String name;
  final String shortDesc;
  final String fullDescription;
  final List<String> benefits;

  const CourseData({
    required this.icon,
    required this.imagePath,
    required this.name,
    required this.shortDesc,
    required this.fullDescription,
    required this.benefits,
  });
}

final List<CourseData> allCourses = [
  CourseData(
    icon: '📊',
    imagePath: 'assets/images/cursos/taxes.png',
    name: 'Taxes Individuales',
    shortDesc: 'Domina impuestos sin miedo',
    fullDescription:
        'Aprende a preparar declaraciones de impuestos personales en Estados Unidos de manera práctica y profesional. Este curso está diseñado para que entiendas cómo funcionan los ingresos, dependientes, créditos, deducciones y documentos necesarios para presentar taxes correctamente.',
    benefits: [
      'Es una habilidad con demanda todos los años.',
      'Puedes ayudar a familias, trabajadores independientes y personas de la comunidad a cumplir con sus obligaciones fiscales, mientras desarrollas una nueva fuente de ingresos en temporada de taxes.',
    ],
  ),
  CourseData(
    icon: '🏢',
    imagePath: 'assets/images/cursos/taxes.png',
    name: 'Taxes Corporativos',
    shortDesc: 'Optimiza tu negocio fiscalmente',
    fullDescription:
        'Este curso te enseña cómo funcionan los impuestos para negocios, compañías, contratistas y emprendedores. Aprenderás sobre gastos deducibles, organización de documentos, reportes y responsabilidades fiscales de una empresa.',
    benefits: [
      'Te prepara para atender a dueños de negocio que necesitan apoyo profesional.',
      'Es ideal si deseas ampliar tus servicios, trabajar con empresas o entender mejor cómo manejar la parte fiscal de tu propio negocio.',
    ],
  ),
  CourseData(
    icon: '🚀',
    imagePath: 'assets/images/cursos/llc.png',
    name: 'Apertura de Compañías LLC, S-CORP y C-CORP',
    shortDesc: 'LLC, S-Corp, C-Corp en 1 día',
    fullDescription:
        'Aprende paso a paso cómo se crea una compañía en Estados Unidos y cuáles son las diferencias entre una LLC, una S-CORP y una C-CORP. Este curso te ayuda a entender estructuras, documentos, registros y procesos básicos para formalizar un negocio.',
    benefits: [
      'Podrás orientar a emprendedores que quieren iniciar correctamente, proteger su proyecto y dar el primer paso hacia una empresa formal.',
      'Es un servicio muy solicitado por personas que desean trabajar por cuenta propia o crecer empresarialmente.',
    ],
  ),
  CourseData(
    icon: '📚',
    imagePath: 'assets/images/cursos/bookeeping.png',
    name: 'Bookkeeping',
    shortDesc: 'Contabilidad práctica para negocios',
    fullDescription:
        'El bookkeeping es la base del orden financiero de un negocio. En este curso aprenderás a registrar ingresos, gastos, facturas, recibos y movimientos financieros para mantener una empresa organizada.',
    benefits: [
      'Muchos negocios pequeños necesitan alguien que les ayude a mantener sus cuentas claras.',
      'Esta habilidad puede abrirte oportunidades laborales, permitirte trabajar de forma independiente o complementar servicios como taxes, payroll y apertura de compañías.',
    ],
  ),
  CourseData(
    icon: '🛡️',
    imagePath: 'assets/images/cursos/licencias.png',
    name: 'Licencias de Seguros',
    shortDesc: 'Vida, Salud + certificación oficial',
    fullDescription:
        'Prepárate para entrar a una industria con grandes oportunidades de crecimiento. Este curso te guía en los conceptos del mundo de los seguros, productos, clientes, regulaciones y preparación para obtener tu licencia.',
    benefits: [
      'Una licencia de seguros puede convertirse en una carrera profesional con potencial de crecimiento.',
      'Te permite ayudar a familias a protegerse y construir una actividad comercial seria, flexible y con oportunidades a largo plazo.',
    ],
  ),
  CourseData(
    icon: '💼',
    imagePath: 'assets/images/cursos/ventas.png',
    name: 'Ventas',
    shortDesc: 'Técnicas probadas para cerrar',
    fullDescription:
        'Aprende a vender con estrategia, seguridad y confianza. Este curso te enseña cómo comunicar el valor de un producto o servicio, manejar objeciones, conectar con clientes y cerrar oportunidades de manera profesional.',
    benefits: [
      'Saber vender puede cambiar completamente tus resultados.',
      'No importa si tienes un negocio, trabajas por comisión o quieres emprender: las ventas son una habilidad que puede ayudarte a crecer, generar más ingresos y comunicarte con más seguridad.',
    ],
  ),
  CourseData(
    icon: '📱',
    imagePath: 'assets/images/cursos/redes.png',
    name: 'Redes Sociales',
    shortDesc: 'Marketing digital para tu marca',
    fullDescription:
        'Aprende a usar las redes sociales como una herramienta de growth, no solo de entretenimiento. Este curso te enseña cómo crear contenido, atraer clientes, mejorar tu imagen, promocionar servicios y construir presencia digital.',
    benefits: [
      'Puedes impulsar tu negocio, atraer prospectos, posicionar tu marca personal y convertir tus plataformas en una vitrina profesional abierta todos los días.',
    ],
  ),
  CourseData(
    icon: '💰',
    imagePath: 'assets/images/cursos/payroll.png',
    name: 'Payroll',
    shortDesc: 'Nómina y cumplimiento IRS',
    fullDescription:
        'Este curso te enseña los fundamentos del manejo de nómina: pagos a empleados, horas trabajadas, deducciones, registros y procesos administrativos relacionados con trabajadores.',
    benefits: [
      'Toda empresa con empleados necesita manejar payroll correctamente.',
      'Aprender esta habilidad te permite ofrecer apoyo administrativo, trabajar con negocios.',
    ],
  ),
  CourseData(
    icon: '🗽',
    imagePath: 'assets/images/cursos/inmigraciones.png',
    name: 'Inmigración',
    shortDesc: 'Visa, Green Card, ciudadanía',
    fullDescription:
        'Aprende sobre procesos migratorios comunes, formularios básicos y apoyo administrativo para personas que necesitan organizar sus trámites. Este curso está enfocado en brindar conocimiento práctico para servir mejor a la comunidad inmigrante.',
    benefits: [
      'Es un área de alta necesidad.',
      'Muchas familias buscan orientación, organización y acompañamiento en sus procesos.',
    ],
  ),
  CourseData(
    icon: '📢',
    imagePath: 'assets/images/cursos/marketing.png',
    name: 'Marketing',
    shortDesc: 'Estrategia y ejecución digital',
    fullDescription:
        'Aprende cómo atraer clientes, crear mensajes efectivos, promocionar productos y construir estrategias para hacer crecer un negocio. Este curso te ayuda a entender qué decir, cómo decirlo y dónde comunicarlo para generar más atención e interés.',
    benefits: [
      'El marketing es clave para cualquier negocio.',
      'Puedes tener un excelente servicio, pero si nadie lo conoce, no crece. Este curso te enseña a posicionarte mejor, aumentar tu visibilidad y convertir tu mensaje en oportunidades reales.',
    ],
  ),
  CourseData(
    icon: '⚖️',
    imagePath: 'assets/images/cursos/notario.png',
    name: 'Notario',
    shortDesc: 'Funciones y responsabilidades',
    fullDescription:
        'Aprende las funciones básicas del servicio notarial, el manejo de documentos, firmas, identidad y procesos comunes relacionados con notarizaciones.',
    benefits: [
      'Es un servicio práctico, necesario y de alta demanda.',
      'Puede convertirse en una excelente habilidad para complementar otros servicios como taxes, inmigración, apertura de compañías y trámites administrativos.',
    ],
  ),
];
