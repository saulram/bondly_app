class StringsSuggestions {
  StringsSuggestions._();

  // Product identity — "Voz": tu voz dentro de Bondly
  static const String voz = 'Voz';
  static const String screenTitle = 'Tu Voz';
  static const String screenSubtitle =
      'Comparte ideas, sugerencias o inquietudes. Tú decides si con nombre o de forma anónima.';

  // Form
  static const String subjectLabel = 'Asunto (opcional)';
  static const String subjectHint = 'Resume tu idea en pocas palabras';
  static const String categoryLabel = 'Categoría';
  static const String messageLabel = 'Tu mensaje';
  static const String messageHint = 'Cuéntanos con detalle...';
  static const String anonymousLabel = 'Enviar de forma anónima';
  static const String anonymousHelp =
      'Nadie podrá ver quién lo envió, ni siquiera los administradores.';
  static const String send = 'Enviar';
  static const String sending = 'Enviando...';
  static const String sentSuccess = '¡Gracias! Tu voz fue enviada.';
  static const String sendError = 'No se pudo enviar. Intenta de nuevo.';
  static const String messageRequired = 'Escribe tu mensaje antes de enviar.';

  // Categories
  static const List<String> categories = [
    'General',
    'Ambiente laboral',
    'Reconocimientos',
    'Recompensas',
    'Tecnología',
    'Otro',
  ];

  // My suggestions
  static const String mySuggestions = 'Mis envíos';
  static const String noneYet = 'Aún no has enviado nada. ¡Tu voz cuenta!';
  static const String anonymousTag = 'Anónimo';

  // Status value → label (shared with admin; keys match suggestion_status enum)
  static const Map<String, String> statusLabels = {
    'nueva': 'Nueva',
    'en_revision': 'En revisión',
    'resuelta': 'Resuelta',
    'archivada': 'Archivada',
  };

  static String statusLabel(String status) => statusLabels[status] ?? status;
}
