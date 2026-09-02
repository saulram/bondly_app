import 'package:bondly_app/features/home/data/repositories/api/banners_api.dart';
import 'package:bondly_app/features/home/data/repositories/default_banners_repository.dart';
import 'package:bondly_app/features/home/domain/models/company_banners_model.dart';
import 'package:bondly_app/features/home/domain/repositories/banners_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBannersAPI extends Mock implements BannersAPI {}

void main() {
  late MockBannersAPI api;
  late DefaultBannersRepository repository;

  setUp(() {
    api = MockBannersAPI();
    repository = DefaultBannersRepository(api);
  });

  test('returns an empty successful banner collection', () async {
    when(() => api.getCompanyBanners())
        .thenAnswer((_) async => CompanyBanners(success: true, banners: []));

    final result = await repository.getBanners();

    expect(result.isSuccess(), isTrue);
    expect(result.getOrThrow().banners, isEmpty);
  });

  test('returns one or many banners unchanged', () async {
    final banners = [
      Banner(id: 'one', image: 'https://one'),
      Banner(id: 'two', image: 'https://two'),
    ];
    when(() => api.getCompanyBanners()).thenAnswer(
        (_) async => CompanyBanners(success: true, banners: banners));

    final result = await repository.getBanners();

    expect(result.getOrThrow().banners, same(banners));
  });

  test('maps unexpected API exceptions to NoConnectionException', () async {
    when(() => api.getCompanyBanners())
        .thenThrow(StateError('network unavailable'));

    final result = await repository.getBanners();

    expect(result.isError(), isTrue);
    expect(result.tryGetError(), isA<NoConnectionException>());
  });

  test('preserves TokenNotFoundException for authentication handling',
      () async {
    when(() => api.getCompanyBanners()).thenThrow(TokenNotFoundException());

    final result = await repository.getBanners();

    expect(result.isError(), isTrue);
    expect(result.tryGetError(), isA<TokenNotFoundException>());
  });
}
