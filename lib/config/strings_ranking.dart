class StringsRanking {
  StringsRanking._();

  // Header
  static const String title = 'Top 3 de colaboradores';
  static const String ranking = 'Ranking';

  // Period tabs
  static const String periodMonth = 'Este mes';
  static const String periodQuarter = 'Trimestre';
  static const String periodYear = 'Este año';

  // Count label
  static const String countLabel = 'rec.';

  // Section
  static const String seeAll = 'Ver todo';

  // Empty state
  static const String emptyTitle = 'No hay datos de ranking';
  static const String emptyBody =
      'Los reconocimientos aparecerán aquí cuando haya actividad';

  // Footer
  static String footerText(int count) =>
      'Mostrando top $count · Actualizado hoy';
}
