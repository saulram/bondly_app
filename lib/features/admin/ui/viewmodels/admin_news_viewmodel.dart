import 'package:bondly_app/features/admin/data/repositories/supabase_admin_news_repository.dart';
import 'package:bondly_app/features/admin/domain/models/admin_news.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';

class AdminNewsViewModel extends NavigationModel {
  final SupabaseAdminNewsRepository _repo;

  List<AdminNews> _news = [];
  bool _isLoading = false;
  String? _error;

  AdminNewsViewModel(this._repo);

  List<AdminNews> get news => _news;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final r = await _repo.getNews();
    r.when((data) => _news = data, (e) => _error = e.toString());

    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleHidden(AdminNews item) async {
    final r = await _repo.toggleHidden(item.id, !item.hidden);
    r.when((_) => load(), (e) {
      _error = e.toString();
      notifyListeners();
    });
  }

  Future<bool> createNews(
      {required String title, String? content}) async {
    final r = await _repo.createNews(title: title, content: content);
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

  Future<bool> updateNews({
    required String newsId,
    required String title,
    String? content,
  }) async {
    final r =
        await _repo.updateNews(newsId: newsId, title: title, content: content);
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

  Future<bool> deleteNews(String newsId) async {
    final r = await _repo.deleteNews(newsId);
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
}
