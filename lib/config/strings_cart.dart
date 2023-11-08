class StringsCart {
  static const String importantTitle = 'IMPORTANTE';

  static String confirmationMessageBody(String itemCount, String total) {
    return '''Acabas de seleccionar $itemCount producto(s) para canjear tus puntos.
Al dar click al botón CONFIRMAR se generará un canje que restará $total puntos de tu estado de cuenta, lo cual es irreversible. ¿Estás seguro de los premios que quieres canjear?''';
  }

  static const String cancel = 'Cancelar';
  static const String confirm = 'Confirmar';
  static const String hhrr =
      "¡Canje exitoso! Recursos Humanos se pondrá en contacto contigo";
  static const String emptyCartMessage =
      'No tienes productos en tu carrito, puedes:';
  static const String notEnoughPoints =
      "No tienes suficientes puntos para canjear este producto";
  static const String goToRewards = 'Ir a Recompensas';
  static const String total = 'Total';
}
