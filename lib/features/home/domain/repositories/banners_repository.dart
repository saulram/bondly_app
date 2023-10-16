import 'package:bondly_app/features/home/domain/models/company_banners_model.dart';
import 'package:multiple_result/multiple_result.dart';

/// This file contains the [BannersRepository] abstract class and several exception classes.
/// The [BannersRepository] class defines the contract for retrieving company banners.
/// The exception classes are used to handle different error scenarios that may occur during the login process.
abstract class BannersRepository {
  /// Retrieves the company banners.
  ///
  /// Returns a [Result] object that contains either the [CompanyBanners] or an [Exception].
  Future<Result<CompanyBanners, Exception>> getBanners(String token);
}

/// Exception thrown when there is no internet connection.
class NoConnectionException implements Exception {}

/// Exception thrown when the default company is used.
class DefaultCompanyException implements Exception {}

/// Exception thrown when the authentication token is not found.
class TokenNotFoundException implements Exception {}
