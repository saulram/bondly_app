import 'package:bondly_app/features/admin/data/repositories/supabase_admin_suggestions_repository.dart';
import 'package:bondly_app/features/admin/domain/models/admin_suggestion.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';

class AdminSuggestionsViewModel extends NavigationModel {
  final SupabaseAdminSuggestionsRepository _repo;

  List<AdminSuggestion> _items = [];
  bool _isLoading = false;
  String? _error;
  String? _statusFilter;

  AdminSuggestionsViewModel(this._repo);

  List<AdminSuggestion> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get statusFilter => _statusFilter;

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final r = await _repo.getSuggestions(status: _statusFilter);
    r.when((data) => _items = data, (e) => _error = e.toString());

    _isLoading = false;
    notifyListeners();
  }

  Future<void> setStatusFilter(String? status) async {
    _statusFilter = status;
    await load();
  }

  Future<void> updateStatus(AdminSuggestion item, String status) async {
    final r = await _repo.updateStatus(item.id, status);
    r.when((_) => load(), (e) {
      _error = e.toString();
      notifyListeners();
    });
  }

  Future<void> updateNote(AdminSuggestion item, String? note) async {
    final r = await _repo.updateNote(item.id, note);
    r.when((_) => load(), (e) {
      _error = e.toString();
      notifyListeners();
    });
  }

  Future<void> delete(String id) async {
    final r = await _repo.delete(id);
    r.when((_) => load(), (e) {
      _error = e.toString();
      notifyListeners();
    });
  }
}
