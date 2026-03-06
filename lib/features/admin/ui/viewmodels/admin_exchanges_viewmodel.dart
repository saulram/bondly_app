import 'package:bondly_app/features/admin/data/repositories/supabase_admin_exchanges_repository.dart';
import 'package:bondly_app/features/admin/domain/models/admin_exchange.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';

class AdminExchangesViewModel extends NavigationModel {
  final SupabaseAdminExchangesRepository _repo;

  List<AdminExchange> _exchanges = [];
  bool _isLoading = false;
  String? _error;
  String _search = '';
  String? _statusFilter;

  AdminExchangesViewModel(this._repo);

  List<AdminExchange> get exchanges => _exchanges;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get statusFilter => _statusFilter;

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final r = await _repo.getExchanges(
      search: _search.isEmpty ? null : _search,
      status: _statusFilter,
    );
    r.when((data) => _exchanges = data, (e) => _error = e.toString());

    _isLoading = false;
    notifyListeners();
  }

  void onSearch(String value) {
    _search = value;
    load();
  }

  void setStatusFilter(String? status) {
    _statusFilter = status;
    load();
  }

  Future<void> updateStatus(AdminExchange exchange, String newStatus) async {
    final r = await _repo.updateStatus(exchange.id, newStatus);
    r.when((_) => load(), (e) {
      _error = e.toString();
      notifyListeners();
    });
  }
}
