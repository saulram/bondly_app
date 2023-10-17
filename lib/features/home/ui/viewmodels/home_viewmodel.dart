import 'package:bondly_app/features/auth/domain/handlers/session_token_handler.dart';
import 'package:bondly_app/features/auth/domain/models/user_model.dart';
import 'package:bondly_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:bondly_app/features/auth/domain/usecases/user_usecase.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/home/domain/models/company_banners_model.dart';
import 'package:bondly_app/features/home/domain/usecases/get_company_banners.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:multiple_result/multiple_result.dart';

class HomeViewModel extends NavigationModel {
  final UserUseCase _userUseCase;
  final SessionTokenHandler _tokenHandler;
  final GetCompanyBannersUseCase _bannersUseCase;
  User? user;
  Logger log = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );

  HomeViewModel(this._userUseCase, this._tokenHandler, this._bannersUseCase) {
    log.i("HomeViewModel created");
  }

  Future<void> maybeSetUpUser() async {
    final Result<User, Exception> result = await _userUseCase.invoke();
    result.when((user) {
      this.user = user;
      log.i("HomeViewModel### User: ${user.toJson()}");
      notifyListeners();
      getCompanyBanners();
    }, (error) {
      log.e(error.toString());
      _tokenHandler.clear();
    });
  }

  ///Handle Navigation of bottombar
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  PageController pageController = PageController();

  void onTabTapped(int index) {
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }

  void onPageChanged(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  List<String> _bannersList = [];
  List<String> get bannersList => _bannersList;
  set bannersList(List<String> urisList) {
    _bannersList = urisList;
    log.i("HomeViewModel### BannersList: $urisList");
    notifyListeners();
  }

  ///Handle Banners
  CompanyBanners? _banners;

  Future<void> getCompanyBanners() async {
    log.i("Get Company Banners for user: ${user?.completeName}");
    final Result<CompanyBanners, Exception> result =
        await _bannersUseCase.invoke();
    result.when((banners) {
      _banners = banners;

      log.i("HomeViewModel### Banners: ${banners.toJson()}");
      List<String> uris = _banners!.banners!.map((banner) {
        return banner.image!;
      }).toList();
      bannersList = uris;
    }, (error) {
      log.e(error.toString());
      if (error is TokenNotFoundException) {
        // Dispatch logout
      }
    });
  }
}
