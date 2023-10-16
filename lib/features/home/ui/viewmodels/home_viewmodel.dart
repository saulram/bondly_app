import 'package:bondly_app/features/auth/domain/models/user_model.dart';
import 'package:bondly_app/features/auth/domain/usecases/session_token_usecase.dart';
import 'package:bondly_app/features/auth/domain/usecases/user_usecase.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/home/domain/models/company_banners_model.dart';
import 'package:bondly_app/features/home/domain/usecases/get_company_banners.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:multiple_result/multiple_result.dart';

class HomeViewModel extends NavigationModel {
  final UserUseCase _userUseCase;
  final SessionTokenUseCase _tokenUseCase;
  final GetCompanyBannersUseCase _bannersUseCase;
  User? user;
  String? token;
  Logger log = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );

  HomeViewModel(this._userUseCase, this._tokenUseCase, this._bannersUseCase) {
    log.i("HomeViewModel created");
    maybeSetUpUser();
    getCompanyBanners();
  }

  Future<void> maybeSetUpUser() async {
    final Result<User, Exception> result = await _userUseCase.invoke();
    result.when((user) {
      this.user = user;
      log.i("HomeViewModel### User: ${user.toJson()}");
      notifyListeners();
    }, (error) {
      log.e(error.toString());
      _tokenUseCase.update(null);
    });
  }

  ///Handle Navigation of bottombar
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  PageController pageController = PageController();

  void onTabTapped(int index) {
    pageController.animateToPage(index,
        duration: Duration(milliseconds: 500), curve: Curves.ease);
  }

  void onPageChanged(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  List<String> banners = [];

  ///Handle Banners
  CompanyBanners? _banners;
  Future<void> getCompanyBanners() async {
    final Result<CompanyBanners, Exception> result =
        await _bannersUseCase.invoke();
    result.when((banners) {
      _banners = banners;
      log.i("HomeViewModel### Banners: ${banners.toJson()}");
      notifyListeners();
    }, (error) {
      log.e(error.toString());
    });
  }
}
