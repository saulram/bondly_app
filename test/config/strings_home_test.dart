import 'package:bondly_app/config/strings_home.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('badgeCostInfo', () {
    test('describes an unknown cost without inventing a value', () {
      expect(
        StringsHome.badgeCostInfo(const []),
        'El costo depende de la insignia seleccionada',
      );
    });

    test('shows a single configured cost', () {
      expect(
        StringsHome.badgeCostInfo(const [50, 50]),
        'Cada insignia cuesta 50 puntos',
      );
    });

    test('shows the configured cost range', () {
      expect(
        StringsHome.badgeCostInfo(const [200, 50, 100]),
        'Las insignias cuestan entre 50 y 200 puntos',
      );
    });
  });
}
