import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/suggestions/domain/models/suggestion.dart';
import 'package:bondly_app/features/suggestions/domain/usecases/get_my_suggestions_usecase.dart';
import 'package:bondly_app/features/suggestions/domain/usecases/submit_suggestion_usecase.dart';
import 'package:logger/logger.dart';

class SuggestionsViewModel extends NavigationModel {
  final SubmitSuggestionUseCase _submitUseCase;
  final GetMySuggestionsUseCase _getMineUseCase;

  final Logger log = Logger(printer: PrettyPrinter(methodCount: 0));

  SuggestionsViewModel(this._submitUseCase, this._getMineUseCase);

  bool _sending = false;
  bool get sending => _sending;

  bool _anonymous = false;
  bool get anonymous => _anonymous;
  set anonymous(bool value) {
    _anonymous = value;
    notifyListeners();
  }

  String? _category;
  String? get category => _category;
  set category(String? value) {
    _category = value;
    notifyListeners();
  }

  List<Suggestion> _mine = [];
  List<Suggestion> get mine => _mine;

  Future<void> setUp() async {
    await loadMine();
  }

  Future<void> loadMine() async {
    final result = await _getMineUseCase.invoke();
    result.when(
      (items) => _mine = items,
      (error) {
        log.e('SuggestionsViewModel### loadMine: $error');
        _mine = [];
      },
    );
    notifyListeners();
  }

  /// Returns true when the suggestion was submitted successfully.
  Future<bool> submit({required String message, String? title}) async {
    _sending = true;
    notifyListeners();

    final result = await _submitUseCase.invoke(
      message: message,
      title: title,
      category: _category,
      anonymous: _anonymous,
    );

    bool ok = false;
    result.when(
      (_) => ok = true,
      (error) => log.e('SuggestionsViewModel### submit: $error'),
    );

    _sending = false;
    if (ok) {
      _anonymous = false;
      _category = null;
      await loadMine();
    } else {
      notifyListeners();
    }
    return ok;
  }
}
