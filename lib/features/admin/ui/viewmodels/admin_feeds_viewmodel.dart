import 'package:bondly_app/features/admin/data/repositories/supabase_admin_feeds_repository.dart';
import 'package:bondly_app/features/admin/domain/models/admin_feed.dart';
import 'package:bondly_app/features/admin/domain/models/paginated_result.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';

class AdminFeedsViewModel extends NavigationModel {
  final SupabaseAdminFeedsRepository _repo;

  PaginatedResult<AdminFeed> _result = PaginatedResult.empty();
  bool _isLoading = false;
  String? _error;
  String _search = '';
  String? _typeFilter;
  int _page = 1;
  static const int _pageSize = 20;

  AdminFeedsViewModel(this._repo);

  PaginatedResult<AdminFeed> get result => _result;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get typeFilter => _typeFilter;
  int get page => _page;

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final r = await _repo.getFeeds(
      search: _search.isEmpty ? null : _search,
      type: _typeFilter,
      page: _page,
      pageSize: _pageSize,
    );
    r.when((data) => _result = data, (e) => _error = e.toString());

    _isLoading = false;
    notifyListeners();
  }

  void onSearch(String value) {
    _search = value;
    _page = 1;
    load();
  }

  void setTypeFilter(String? type) {
    if (type == _typeFilter) return;
    _typeFilter = type;
    _page = 1;
    load();
  }

  void setPage(int p) {
    if (p == _page) return;
    _page = p;
    load();
  }

  Future<void> toggleVisible(AdminFeed feed) async {
    final r = await _repo.toggleVisible(feed.id, !feed.visible);
    r.when((_) => load(), (e) {
      _error = e.toString();
      notifyListeners();
    });
  }

  Future<void> toggleHighlighted(AdminFeed feed) async {
    final r = await _repo.toggleHighlighted(feed.id, !feed.isHighlighted);
    r.when((_) => load(), (e) {
      _error = e.toString();
      notifyListeners();
    });
  }

  Future<bool> deleteFeed(String feedId) async {
    final r = await _repo.deleteFeed(feedId);
    bool ok = false;
    r.when((_) {
      ok = true;
      load();
    }, (e) {
      _error = e.toString();
      notifyListeners();
    });
    return ok;
  }

  Future<List<AdminFeedComment>> getComments(String feedId) async {
    final r = await _repo.getComments(feedId);
    return r.when((data) => data, (_) => []);
  }

  Future<bool> deleteComment(String commentId) async {
    final r = await _repo.deleteComment(commentId);
    return r.when((_) => true, (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    });
  }
}
