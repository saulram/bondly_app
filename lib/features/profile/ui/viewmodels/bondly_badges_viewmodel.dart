import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/profile/domain/models/bondly_badges_model.dart';
import 'package:bondly_app/features/profile/domain/usecases/get_bondly_badges_usecase.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class BondlyBadgesViewModel extends NavigationModel {
  final GetBondlyBadgesUseCase _getBondlyBadgesUseCase;
  final PageController scrollController = PageController();
  final Logger logger = Logger(
    printer: PrettyPrinter(),
  );

  BondlyBadgesViewModel(this._getBondlyBadgesUseCase) {
    logger.i("BondlyBadgesViewModel created");
    getBondlyBadges();
  }

  BondlyBadges _bondlyBadges = BondlyBadges(
    embassys: Embassys(
      count: 0,
      embassys: [],
    ),
    myBadges: MyBadges(
      count: 0,
      myBadges: [],
    ),
    categories: [],
  );

  BondlyBadges get bondlyBadges => _bondlyBadges;
  set bondlyBadges(BondlyBadges bondlyBadges) {
    _bondlyBadges = bondlyBadges;
    notifyListeners();
  }

  Future<void> getBondlyBadges() async {
    busy = true;
    try {
      var response = await _getBondlyBadgesUseCase.invoke();

      response.when((badges) {
        bondlyBadges = badges;
        busy = false;
      }, (error) => {logger.e(error)});
    } catch (e) {
      logger.e(e);
    }
  }

  @override
  void dispose() {
    logger.i("BondlyBadgesViewModel disposed");
    super.dispose();
  }
}
