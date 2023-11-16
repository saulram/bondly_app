import 'package:bondly_app/features/auth/domain/handlers/session_token_handler.dart';
import 'package:bondly_app/features/auth/domain/models/user_model.dart';
import 'package:bondly_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:bondly_app/features/auth/domain/usecases/user_usecase.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/home/domain/models/announcement_model.dart';
import 'package:bondly_app/features/home/domain/models/badge_model.dart';
import 'package:bondly_app/features/home/domain/models/category_badges.dart';
import 'package:bondly_app/features/home/domain/models/company_banners_model.dart';
import 'package:bondly_app/features/home/domain/models/company_categories.dart';
import 'package:bondly_app/features/home/domain/models/company_feed_model.dart';
import 'package:bondly_app/features/home/domain/models/embassys_model.dart';
import 'package:bondly_app/features/home/domain/usecases/create_acknowlegment.dart';
import 'package:bondly_app/features/home/domain/usecases/create_feed_comment.dart';
import 'package:bondly_app/features/home/domain/usecases/get_announcements.dart';
import 'package:bondly_app/features/home/domain/usecases/get_category_badges.dart';
import 'package:bondly_app/features/home/domain/usecases/get_company_banners.dart';
import 'package:bondly_app/features/home/domain/usecases/get_company_categories.dart';
import 'package:bondly_app/features/home/domain/usecases/get_company_collaborators.dart';
import 'package:bondly_app/features/home/domain/usecases/get_company_feeds.dart';
import 'package:bondly_app/features/home/domain/usecases/get_user_embassys.dart';
import 'package:bondly_app/features/home/domain/usecases/handle_like.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:logger/logger.dart';
import 'package:multiple_result/multiple_result.dart';

/// This class represents the view model for the home screen.
/// It extends the NavigationModel class and contains methods to handle user setup,
/// navigation, fetching company banners, feeds, categories, creating comments and handling likes.
/// It also contains properties to store the user, banners list, feeds and current index of the bottom bar.
class HomeViewModel extends NavigationModel {
  ///Use Cases
  final UserUseCase _userUseCase;
  final SessionTokenHandler _tokenHandler;
  final GetCompanyBannersUseCase _bannersUseCase;
  final GetCompanyFeedsUseCase _feedsUseCase;
  final CreateFeedCommentUseCase _createFeedCommentUseCase;
  final HandleLikesUseCase _handleLikesUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;
  final GetCategoryBadgesUseCase _getCategoryBadgesUseCase;
  final GetCompanyCollaboratorsUseCase _getCompanyCollaboratorsUseCase;
  final CreateAcknowledgmentUseCase _createAcknowledgmentUseCase;
  final GetCompanyAnnouncementsUseCase _getCompanyAnnouncementsUseCase;
  final GetUserEmbassysUseCase _getUserEmbassysUseCase;

  final GlobalKey<FlutterMentionsState> mentionsKey =
      GlobalKey<FlutterMentionsState>();

  User? user;
  Logger log = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );

  HomeViewModel(
      this._userUseCase,
      this._tokenHandler,
      this._bannersUseCase,
      this._feedsUseCase,
      this._createFeedCommentUseCase,
      this._handleLikesUseCase,
      this._getCategoriesUseCase,
      this._getCategoryBadgesUseCase,
      this._getCompanyCollaboratorsUseCase,
      this._createAcknowledgmentUseCase,
      this._getCompanyAnnouncementsUseCase,
      this._getUserEmbassysUseCase) {
    log.i("HomeViewModel created");
  }

  /// Sets up the user and fetches banners and feeds.
  Future<void> setUp() async {
    await setUpUser();
  }

  /// Sets up the user.
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

  /// Fetches banners, feeds and categories.
  Future<void> handleHomeCalls() async {
    await Future.wait([
      getCompanyBanners(),
      getCompanyFeeds(),
      getUserEmbassys(),
      getCompanyCategories(),
      getCompanyCollaborators(),
      handleGetAnnounceMents(),
    ]);
  }

  /// Handles navigation of the bottom bar.
  int _currentIndex = 1;

  int get currentIndex => _currentIndex;

  PageController pageController = PageController(
    initialPage: 1,
    keepPage: true,
  );

  /// Animates to the selected page.
  void onTabTapped(int index) {
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }

  /// Handles page change.
  void onPageChanged(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  List<String> _bannersList = [];
  List<String> get bannersList => _bannersList;

  /// Sets the banners list.
  set bannersList(List<String> urisList) {
    _bannersList = urisList;
    log.i("HomeViewModel### BannersList: $urisList");
    notifyListeners();
  }

  CompanyBanners? _banners;

  /// Fetches company banners.
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

  /// Sets the feeds.
  set feeds(CompanyFeed feeds) {
    _feeds = feeds;
    notifyListeners();
  }

  /// Fetches company feeds.
  Future<void> getCompanyFeeds() async {
    log.i("Get Company Feeds for user: ${user?.completeName}");
    final Result<CompanyFeed, Exception> result = await _feedsUseCase.invoke();
    result.when((feeds) {
      log.i("HomeViewModel### Feeds: ${feeds.data.length}");
      feeds.data.sort((a, b) {
        return b.createdAt.compareTo(a.createdAt);
      });
      this.feeds = feeds;
    }, (error) {
      log.e(error.toString());
      if (error is TokenNotFoundException) {
        // Dispatch logout
      }
    });
  }

  /// Creates a comment for a feed.
  Future<void> createComment(String feedId, String message, int index) async {
    log.i("Create Comment for feed: $feedId");
    final Result<FeedData, Exception> result =
        await _createFeedCommentUseCase.invoke(feedId, message);
    result.when((feedUpdated) {
      log.i("HomeViewModel### Comment: ${feedUpdated}");
      getCompanyFeeds();
    }, (error) {
      log.e(error.toString());
      if (error is TokenNotFoundException) {
        // Dispatch logout
      }
    });
  }

  /// Handles likes for a feed.
  Future<void> handleLikes(String feedId) async {
    log.i("Handle Like for feed: $feedId");
    final Result<bool, Exception> result =
        await _handleLikesUseCase.invoke(feedId);
    result.when((isLiked) {
      log.i("HomeViewModel### isLiked: $isLiked");
      getCompanyFeeds();
    }, (error) {
      log.e(error.toString());
      if (error is TokenNotFoundException) {
        // Dispatch logout
      }
    });
  }

  Categories _categories = Categories(categories: []);
  Categories get categories => _categories;
  set categories(Categories categories) {
    _categories = categories;
    notifyListeners();
  }

  /// Fetches company categories.
  Future<void> getCompanyCategories() async {
    log.i("Get Company Categories for user: ${user?.completeName}");
    final Result<Categories, Exception> result =
        await _getCategoriesUseCase.invoke();
    result.when((categories) {
      this.categories = categories;
      log.i("HomeViewModel### Categories: ${categories.categories?.length}");
    }, (error) {
      log.e(error.toString());
      if (error is TokenNotFoundException) {
        // Dispatch logout
      }
    });
  }

  String? _selectedCategory;
  String? get selectedCategory => _selectedCategory;
  set selectedCategory(String? category) {
    loadingBadges = true;
    _selectedCategory = category;

    category != null ? getCategoryBadges() : null;
    notifyListeners();
  }

  bool _loadingBadges = false;
  bool get loadingBadges => _loadingBadges;
  set loadingBadges(bool loading) {
    _loadingBadges = loading;
    notifyListeners();
  }

  Badges _badges = Badges(badges: []);
  Badges get badges => _badges;
  set badges(Badges badges) {
    _badges = badges;
    notifyListeners();
  }

  Future<void> getCategoryBadges() async {
    log.i("Get Category Badges for user: ${user?.completeName}");
    final Result<Badges, Exception> result =
        await _getCategoryBadgesUseCase.invoke(selectedCategory!);
    result.when((badges) {
      log.i("HomeViewModel### Badges: ${badges.badges.length}");
      this.badges = badges;
      loadingBadges = false;
    }, (error) {
      log.e(error.toString());
      if (error is TokenNotFoundException) {
        // Dispatch logout
      }
    });
  }

  Badge? _selectedBadge;
  Badge? get selectedBadge => _selectedBadge;
  set selectedBadge(Badge? badge) {
    _selectedBadge = badge;
    notifyListeners();
  }

  List<User> _collaborators = [];
  List<User> get collaborators => _collaborators;
  set collaborators(List<User> collaborators) {
    _collaborators = collaborators;
    notifyListeners();
  }

  List<Map<String, dynamic>> _collaboratorsList = [];
  List<Map<String, dynamic>> get collaboratorsList => _collaboratorsList;
  set collaboratorsList(List<Map<String, dynamic>> data) {
    _collaboratorsList = data;

    notifyListeners();
  }

  Future<void> getCompanyCollaborators() async {
    log.i("Get Company Collaborators for company: ${user?.companyName}");
    final Result<List<User>, Exception> result =
        await _getCompanyCollaboratorsUseCase.invoke();
    result.when((collaborators) {
      log.i("HomeViewModel### Collaborators: ${collaborators.length}");
      collaboratorsList = collaborators
          .map((collaborator) {
            return {
              "id": collaborator.id ?? "No Name",
              "display": collaborator.completeName ?? "No Name",
              "avatar": collaborator.avatar ??
                  "https://api.minimalavatars.com/avatar/random/png",
              "user_id": collaborator.id ?? "No Id"
            };
          })
          .cast<Map<String, dynamic>>()
          .toList();
    }, (error) {
      log.e(" ### ComapanyCollaborators Error: $error");
      if (error is TokenNotFoundException) {
        // Dispatch logout
      }
    });
  }

  List<String> _collaboratorsIds = [];
  List<String> get collaboratorsIds => _collaboratorsIds;
  set collaboratorsIds(List<String> ids) {
    _collaboratorsIds = ids;
    notifyListeners();
  }

  void pushCollaboratorId(String id) {
    collaboratorsIds = [...collaboratorsIds, id];
    notifyListeners();
  }

  bool _creatingAcknowledgment = false;
  bool get creatingAcknowledgment => _creatingAcknowledgment;
  set creatingAcknowledgment(bool creating) {
    _creatingAcknowledgment = creating;
    notifyListeners();
  }

  Future<void> handleSubmitAcknowledgment() async {
    log.i("Handle Submit Acknowledgment for user: ${user?.completeName}");
    //check that we have a selected badge and a message written before make the call to api
    if (selectedBadge != null &&
        mentionsKey.currentState!.controller!.text.isNotEmpty) {
      final Result<bool, Exception> result =
          await _createAcknowledgmentUseCase.invoke(
              selectedBadge!.id!,
              mentionsKey.currentState!.controller!.markupText,
              collaboratorsIds);
      result.when((success) {
        log.i("HomeViewModel### Success: $success");
        getCompanyFeeds();
        collaboratorsIds = [];
        selectedCategory = null;
        selectedBadge = null;
      }, (error) {
        log.e(error.toString());
        if (error is TokenNotFoundException) {
          // Dispatch logout
        }
      });
    }
  }

  CarouselController carouselController = CarouselController();

  List<Announcement> _announcements = [];

  List<Announcement> get announcements => _announcements;

  set announcements(List<Announcement> data) {
    _announcements = data;
    notifyListeners();
  }

  Future<void> handleGetAnnounceMents() async {
    log.i("Get Company Announcements for company: ${user?.companyName}");
    final Result<Announcements, Exception> result =
        await _getCompanyAnnouncementsUseCase.invoke();
    result.when((results) {
      log.i("HomeViewModel### Announcements: ${results.announcement?.length}");
      announcements = results.announcement ?? [];
    }, (error) {
      log.e(" ### ComapanyCollaborators Error: $error");
      if (error is TokenNotFoundException) {
        // Dispatch logout
      }
    });
  }

  int currentAnnouncementIndex = 0;
  void onAnnouncementChanged(int index) {
    currentAnnouncementIndex = index;
    notifyListeners();
  }

  List<Embassy> _embassys = [];
  List<Embassy> get embassys => _embassys;
  set embassys(List<Embassy> data) {
    _embassys = data;
    notifyListeners();
  }

  Future<void> getUserEmbassys() async {
    log.i("Get User Embassys for user: ${user?.completeName}");
    final Result<List<Embassy>, Exception> result =
        await _getUserEmbassysUseCase.invoke(user!.id!);
    result.when((results) {
      log.i("HomeViewModel### Embassys: ${results.length}");
      embassys = results;
    }, (error) {
      log.e(" ### ComapanyCollaborators Error: $error");
      if (error is TokenNotFoundException) {
        // Dispatch logout
      }
    });
  }
}
