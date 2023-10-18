import 'package:bondly_app/features/auth/domain/handlers/session_token_handler.dart';
import 'package:bondly_app/features/auth/domain/models/user_model.dart';
import 'package:bondly_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:bondly_app/features/auth/domain/usecases/user_usecase.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/home/domain/models/company_banners_model.dart';
import 'package:bondly_app/features/home/domain/models/company_feed_model.dart';
import 'package:bondly_app/features/home/domain/usecases/get_company_banners.dart';
import 'package:bondly_app/features/home/domain/usecases/get_company_feeds.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:multiple_result/multiple_result.dart';

class HomeViewModel extends NavigationModel {
  final UserUseCase _userUseCase;
  final SessionTokenHandler _tokenHandler;
  final GetCompanyBannersUseCase _bannersUseCase;
  final GetCompanyFeedsUseCase _feedsUseCase;

  User? user;
  Logger log = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );

  HomeViewModel(this._userUseCase, this._tokenHandler, this._bannersUseCase,
      this._feedsUseCase) {
    log.i("HomeViewModel created");
  }

  Future<void> setUp() async {
    //wait for setup of user and then get banners & feeds
    await setUpUser();
  }

  Future<void> setUpUser() async {
    final Result<User, Exception> result = await _userUseCase.invoke();
    result.when((user) {
      this.user = user;
      log.i("HomeViewModel### User: ${user.toJson()}");
      notifyListeners();
      handleHomeCalls();
    }, (error) {
      log.e(error.toString());
      _tokenHandler.clear();
    });
  }

  Future<void> handleHomeCalls() async {
    await getCompanyBanners();
    await getCompanyFeeds();
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

      log.i("HomeViewModel### Get Banners Success");
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

  CompanyFeed _feeds = CompanyFeed(data: [], success: false);
  CompanyFeed get feeds => _feeds;
  set feeds(CompanyFeed feeds) {
    _feeds = feeds;
    notifyListeners();
  }

  Future<void> getCompanyFeeds() async {
    log.i("Get Company Feeds for user: ${user?.completeName}");
    final Result<CompanyFeed, Exception> result = await _feedsUseCase.invoke();
    result.when((feeds) {
      log.i("HomeViewModel### Feeds: ${feeds.data.length}");
      this.feeds = feeds;
    }, (error) {
      log.e(error.toString());
      if (error is TokenNotFoundException) {
        // Dispatch logout
      }
    });
  }
}
