import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/ranking/domain/models/ranked_user.dart';
import 'package:bondly_app/features/ranking/domain/usecases/get_ranking_usecase.dart';
import 'package:logger/logger.dart';

class RankingViewModel extends NavigationModel {
  final GetRankingUseCase _getRankingUseCase;

  final Logger log = Logger(printer: PrettyPrinter(methodCount: 0));

  RankingViewModel(this._getRankingUseCase);

  static const List<String> periodKeys = ['month', 'quarter', 'year'];

  int _selectedPeriod = 0;
  int get selectedPeriod => _selectedPeriod;
  set selectedPeriod(int index) {
    _selectedPeriod = index;
    notifyListeners();
    fetchRanking();
  }

  bool _loading = false;
  bool get loading => _loading;

  List<RankedUser> _users = [];
  List<RankedUser> get users => _users;

  List<RankedUser> get topThree =>
      _users.length >= 3 ? _users.sublist(0, 3) : _users;

  List<RankedUser> get rest => _users.length > 3 ? _users.sublist(3) : [];

  Future<void> setUp() async {
    await fetchRanking();
  }

  Future<void> fetchRanking() async {
    _loading = true;
    notifyListeners();

    final result = await _getRankingUseCase.invoke(
      period: periodKeys[_selectedPeriod],
      limit: 10,
    );

    result.when(
      (users) {
        log.i('RankingViewModel### Ranking fetched: ${users.length} users');
        _users = users;
      },
      (error) {
        log.e('RankingViewModel### Error: $error');
        _users = [];
      },
    );

    _loading = false;
    notifyListeners();
  }
}
