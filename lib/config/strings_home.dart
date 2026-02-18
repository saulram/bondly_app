class StringsHome {
  // Tabs
  static const String tabFeed = 'Feed';
  static const String tabRecognize = 'Reconocer';
  static const String tabBadges = 'Embajadas';

  // Announcements
  static const String announcementTitle = 'Avisos';
  static const String announcementsSubHeader = 'Avisos de la empresa';
  static const String announcementDefaultBody =
      'Visita las recompensas, hay nuevas opciones para elegir';

  // Slider banners
  static const String bannerTag1 = 'Nuevo';
  static const String bannerTitle1 = 'Porque merecemos\nser reconocidos';
  static const String bannerSubtitle1 =
      'Descubre las nuevas recompensas disponibles';
  static const String bannerTag2 = 'Destacado';
  static const String bannerTitle2 = 'Reconoce el esfuerzo\nde tu equipo';
  static const String bannerSubtitle2 = 'Envía puntos y celebra los logros';
  static const String bannerTitle3 = 'Nuevas recompensas\ndisponibles';
  static const String bannerSubtitle3 = 'Revisa el catálogo actualizado';

  // Points / Badges
  static const String pointsLabel = 'puntos';
  static const String pointsDescription = 'para reconocer a tus compañeros';
  static const String badgePickSubtitle = 'Elige un tipo de insignia';
  static const String badgeCompetencias = 'Competencias';
  static const String badgeEspeciales = 'Especiales';
  static const String badgeValores = 'Valores';

  // Feed
  static const String feedTagRecognition = 'Reconocimiento';
  static const String feedLike = 'Me gusta';
  static const String feedComment = 'Comentar';
  static const String feedEmptyTitle = 'No hay reconocimientos aún';
  static const String feedEmptyBody =
      'Sé el primero en reconocer a un compañero';
  static const String feedCommentPlaceholder = 'Escribe un comentario...';

  static String feedLikeCount(int count) => '$count me gusta';
  static String feedCommentCount(int count) => '$count comentarios';
  static String feedViewAllComments(int count) =>
      'Ver los $count comentarios';

  // Acknowledgment
  static const String acknowledgMentInputHint = 'Escribe tu reconocimiento';
  static const String acknowledgmentInputButtonText = 'Reconocer';

  static String acknowledgmentCategorySubHeader(String categoryCount) {
    return 'Elige entre los $categoryCount tipos de insignias y decide que tipo de reconocimiento quieres otorgar';
  }

  static String acknowledgmentAmountOfPoints(String pointsToGive) {
    return 'Tienes $pointsToGive puntos para reconocer a tus compañeros.';
  }
}
