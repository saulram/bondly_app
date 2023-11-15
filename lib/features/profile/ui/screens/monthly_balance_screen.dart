import 'package:bondly_app/ui/shared/app_sliver_layout.dart';
import 'package:flutter/material.dart';

class MonthlyBalanceScreen extends StatelessWidget {
  static const String route = "/monthlyBalanceScreen";

  const MonthlyBalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BondlySliverLayout(
      child: Center(
        child: Text("Upcoming...Monthly Balance Screen"),
      ),
      title: "Estado de cuenta",
    );
  }
}
