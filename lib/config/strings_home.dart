class StringsHome {
  static const String tabRecognize = "Reconocer";
  static const String tabFeed = "Feed";
  static const String tabNews = "Avisos";
  static const String tabBadges = "Embajadas";
  static const String acknowledgMentInputHint ="Escribe tu reconocimiento";
  static const String acknowledgmentInputButtonText = 'Reconocer';

  static String acknowledgmentCategorySubHeader(String categoryCount) {
    return 'Elige entre los $categoryCount tipos de insignias y decide que tipo de reconocimiento quieres otorgar';
  }
  static String acknowledgmentAmountOfPoints(String pointsToGive) {
    return 'Tienes $pointsToGive puntos para reconocer a tus compañeros.';
  }
}
