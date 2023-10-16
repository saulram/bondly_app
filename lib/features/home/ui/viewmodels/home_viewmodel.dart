import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:flutter/cupertino.dart';

class HomeViewModel extends NavigationModel{

  ///Handle Navigation of bottombar
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  PageController pageController = PageController();

  void onTabTapped(int index) {
    pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
  }

  void onPageChanged(int index) {
    _currentIndex = index;
    notifyListeners();
  }


}