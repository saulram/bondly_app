import 'package:bondly_app/features/home/ui/viewmodels/home_viewmodel.dart';
import 'package:bondly_app/features/home/ui/widgets/gold_bordered_container.dart';
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.45,
        child: GoldBorderedContainer(
          child: Column(
            children: [
              Text(
                "Embajadas",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Expanded(
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    itemCount: model.embassys.length,
                    itemBuilder: (ctx, index) {
                      return AspectRatio(
                        aspectRatio: 1,
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        "https://api.bondly.mx/${model.embassys[index].badgeId!.image!}"),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              model.embassys[index].badgeId!.name!,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
