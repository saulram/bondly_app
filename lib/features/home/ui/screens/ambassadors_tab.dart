import 'package:bondly_app/features/home/ui/viewmodels/home_viewmodel.dart';
import 'package:flutter/material.dart';

class AmbassadorsTab extends StatefulWidget {
  final HomeViewModel model;
  const AmbassadorsTab({Key? key, required this.model}) : super(key: key);

  @override
  State<AmbassadorsTab> createState() => _AmbassadorsTabState();
}

class _AmbassadorsTabState extends State<AmbassadorsTab> {
  late HomeViewModel model;
  @override
  void initState() {
    model = widget.model;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(child: Center(child: Text("Ambassadors Tab"))
    );
  }
}
