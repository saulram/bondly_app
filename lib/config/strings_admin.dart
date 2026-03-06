class StringsAdmin {
  StringsAdmin._();

  // App bar & navigation
  static const String adminPanelTitle = 'Panel de Administración';
  static const String backToApp = 'Volver a la app';
  static const String adminBadge = 'Admin';
  static const String superAdminBadge = 'Super Admin';

  // Sidebar sections
  static const String navDashboard = 'Dashboard';
  static const String navUsers = 'Usuarios';
  static const String navBadges = 'Insignias';
  static const String navRewards = 'Recompensas';
  static const String navExchanges = 'Canjes';
  static const String navBanners = 'Banners';
  static const String navNews = 'Noticias';
  static const String navAmbassadors = 'Embajadores';
  static const String navReports = 'Reportes';
  static const String navSettings = 'Configuración';
  static const String navPermissions = 'Permisos';
  static const String navZones = 'Zonas';

  // Dashboard
  static const String dashboardTitle = 'Resumen General';
  static const String statTotalUsers = 'Total Usuarios';
  static const String statActiveUsers = 'Usuarios Activos';
  static const String statMonthRecognitions = 'Reconocimientos del Mes';
  static const String statMonthExchanges = 'Canjes del Mes';
  static const String statPointsCirculating = 'Puntos en Circulación';
  static const String statActiveBadges = 'Insignias Activas';
  static const String statActiveRewards = 'Recompensas Activas';
  static const String chartRecognitionTrends = 'Tendencia de Reconocimientos';
  static const String chartBadgeUsage = 'Uso de Insignias (Top 10)';
  static const String quickActions = 'Acciones Rápidas';
  static const String quickAddUser = 'Agregar Usuario';
  static const String quickCreateBadge = 'Crear Insignia';
  static const String quickNewReward = 'Nueva Recompensa';
  static const String quickViewReports = 'Ver Reportes';
  static const String recentActivity = 'Actividad Reciente';
  static const String loadingStats = 'Cargando estadísticas...';
  static const String errorLoadingStats = 'Error al cargar estadísticas';

  // Users
  static const String usersTitle = 'Gestión de Usuarios';
  static const String searchUsers = 'Buscar por nombre o correo...';
  static const String filterByRole = 'Rol';
  static const String filterByZone = 'Zona';
  static const String filterByStatus = 'Estado';
  static const String filterActive = 'Activo';
  static const String filterInactive = 'Inactivo';
  static const String roleClient = 'Cliente';
  static const String roleAdmin = 'Admin';
  static const String roleSuperAdmin = 'Super Admin';
  static const String colName = 'Nombre';
  static const String colEmail = 'Correo';
  static const String colRole = 'Rol';
  static const String colStatus = 'Estado';
  static const String colPoints = 'Puntos';
  static const String colActions = 'Acciones';
  static const String addUser = 'Agregar Usuario';
  static const String editUser = 'Editar Usuario';
  static const String deactivateUser = 'Desactivar';
  static const String activateUser = 'Activar';
  static const String userDetail = 'Detalle del Usuario';
  static const String userBasicInfo = 'Información Básica';
  static const String userRoleAndPoints = 'Rol y Puntos';
  static const String userZoneAssignment = 'Asignación de Zona';
  static const String noUsersFound = 'No se encontraron usuarios';
  static const String loadingUsers = 'Cargando usuarios...';

  // Badges
  static const String badgesTitle = 'Gestión de Insignias';
  static const String badgesTab = 'Insignias';
  static const String categoriesTab = 'Categorías';
  static const String addBadge = 'Nueva Insignia';
  static const String editBadge = 'Editar Insignia';
  static const String badgeName = 'Nombre';
  static const String badgeCategory = 'Categoría';
  static const String badgeValue = 'Valor en puntos';
  static const String badgeImage = 'Imagen';
  static const String badgeActive = 'Activa';
  static const String noBadgesFound = 'No hay insignias registradas';

  // Rewards
  static const String rewardsTitle = 'Gestión de Recompensas';
  static const String addReward = 'Nueva Recompensa';
  static const String editReward = 'Editar Recompensa';
  static const String rewardName = 'Nombre';
  static const String rewardDescription = 'Descripción';
  static const String rewardCategory = 'Categoría';
  static const String rewardPoints = 'Costo en puntos';
  static const String rewardDeadline = 'Fecha límite';
  static const String rewardEnabled = 'Habilitada';
  static const String noRewardsFound = 'No hay recompensas registradas';

  // Exchanges
  static const String exchangesTitle = 'Gestión de Canjes';
  static const String colUser = 'Usuario';
  static const String colReward = 'Recompensa';
  static const String colCode = 'Código';
  static const String colExchangeStatus = 'Estado';
  static const String colDate = 'Fecha';
  static const String statusPending = 'En espera';
  static const String statusDelivered = 'Entregado';
  static const String statusReceived = 'Recibido';
  static const String noExchangesFound = 'No hay canjes registrados';

  // Banners
  static const String bannersTitle = 'Gestión de Banners';
  static const String addBanner = 'Nuevo Banner';
  static const String editBanner = 'Editar Banner';
  static const String bannerName = 'Nombre';
  static const String bannerSlug = 'Slug';
  static const String bannerImage = 'Imagen';
  static const String bannerActive = 'Activo';
  static const String noBannersFound = 'No hay banners registrados';

  // News
  static const String newsTitle = 'Gestión de Noticias';
  static const String addNews = 'Nueva Noticia';
  static const String editNews = 'Editar Noticia';
  static const String newsArticleTitle = 'Título';
  static const String newsContent = 'Contenido';
  static const String newsHidden = 'Oculta';
  static const String noNewsFound = 'No hay noticias registradas';

  // Reports
  static const String reportsTitle = 'Reportes y Analítica';
  static const String tabRecognitionTrends = 'Reconocimientos';
  static const String tabPointsEconomy = 'Economía de Puntos';
  static const String tabEngagement = 'Engagement';
  static const String exportCsv = 'Exportar CSV';
  static const String selectDateRange = 'Seleccionar rango';
  static const String noReportData = 'No hay datos para el período seleccionado';

  // Settings
  static const String settingsTitle = 'Configuración';
  static const String zonesTitle = 'Zonas';
  static const String permissionsTitle = 'Permisos de Administradores';
  static const String addZone = 'Nueva Zona';
  static const String editZone = 'Editar Zona';
  static const String zoneName = 'Nombre de la zona';
  static const String zoneDescription = 'Descripción';
  static const String zoneParent = 'Zona padre';
  static const String noZonesFound = 'No hay zonas configuradas';

  // Common actions
  static const String save = 'Guardar';
  static const String cancel = 'Cancelar';
  static const String delete = 'Eliminar';
  static const String edit = 'Editar';
  static const String confirm = 'Confirmar';
  static const String yes = 'Sí';
  static const String no = 'No';
  static const String search = 'Buscar';
  static const String loading = 'Cargando...';
  static const String errorGeneric = 'Ocurrió un error. Intenta de nuevo.';
  static const String successSave = 'Guardado correctamente';
  static const String successDelete = 'Eliminado correctamente';
  static const String confirmDeleteTitle = '¿Eliminar elemento?';
  static const String confirmDeleteMessage =
      'Esta acción no se puede deshacer. ¿Deseas continuar?';
  static const String noPermission =
      'No tienes permisos para acceder a esta sección.';
  static const String accessDenied = 'Acceso denegado';
  static const String stepNext = 'Siguiente';
  static const String stepBack = 'Atrás';
  static const String stepFinish = 'Finalizar';
  static const String pageOf = 'de';
  static const String rows = 'registros';
  static const String rowsPerPage = 'Por página';
  static const String emptyState = 'No hay elementos que mostrar';
  static const String uploadImage = 'Subir imagen';
  static const String changeImage = 'Cambiar imagen';
  static const String imagePlaceholder = 'Sin imagen';
}
