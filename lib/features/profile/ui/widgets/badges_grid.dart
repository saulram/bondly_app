import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/features/profile/domain/models/bondly_badges_model.dart';
import 'package:flutter/material.dart';

enum BadgeType { embassys, myBadges, categories }

class BadgesGrid extends StatefulWidget {
  final Embassys? embassys;
  final MyBadges? myBadges;
  final List<BondlyCategory>? categories;
  final BadgeType type;

  const BadgesGrid({
    super.key,
    required this.size,
    this.embassys,
    this.myBadges,
    this.categories,
    required this.type,
  });

  final Size size;

  @override
  State<BadgesGrid> createState() => _BadgesGridState();
}

class _BadgesGridState extends State<BadgesGrid> {
  late Embassys? embassys;
  late MyBadges? myBadges;
  late List<BondlyCategory>? categories;
  late Size size;
  final List<Color> bondlyColors = [
    AppColors.primaryColor,
    AppColors.secondaryColor,
    AppColors.tertiaryColor,
    AppColors.primaryColorLight,
    AppColors.secondaryColorLight,
    AppColors.tertiaryColorLight,
  ];

  @override
  void initState() {
    embassys = widget.embassys;
    size = widget.size;
    myBadges = widget.myBadges;
    categories = widget.categories;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //select between embassys, myBadges or categories to show
    //the badges grid

    return Container(
      padding: const EdgeInsets.all(10),
      height: 400,
      child: widget.type == BadgeType.categories
          ? _buildGrid(categories!)
          : GridView.builder(
              itemCount:
                  embassys?.count ?? myBadges?.count ?? categories?.length ?? 0,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemBuilder: (context, index) {
                if (widget.type == BadgeType.embassys) {
                  final embassy = embassys?.embassys[index];
                  return _buildBadge(
                      badge: embassy?.badgeId, quantity: embassy?.quantity);
                } else if (widget.type == BadgeType.myBadges) {
                  final myBadge = myBadges?.myBadges[index];
                  return _buildBadge(
                      badge: myBadge?.badgeId, quantity: myBadge?.quantity);
                }
              },
            ),
    );
  }

  Widget _buildBadge({BondlyBadge? badge, int? quantity}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.network(
          "${badge?.image}",
          height: 50,
          width: 50,
        ),
        Text(
          badge!.name,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        quantity != 0
            ? Text(
                "$quantity",
                style: Theme.of(context).textTheme.labelSmall,
              )
            : Container(),
      ],
    );
  }

  Widget _buildGrid(List<BondlyCategory> bondlyCategories) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: size.height * .3,
      width: size.width,
      child: ListView.builder(
          itemCount: bondlyCategories.length,
          itemBuilder: (context, i) {
            //picking random color from bondlyColors list
            final color = bondlyColors[i % bondlyColors.length];
            return Column(
              children: [
                Container(
                    width: size.width,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: color,
                    ),
                    child: Text(bondlyCategories[i].name,
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppColors.backgroundColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ))),
                SizedBox(
                  height: 250,
                  child: GridView.builder(
                    itemCount: bondlyCategories[i].categoryBadges.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      final badge = bondlyCategories[i].categoryBadges[index];
                      return _buildBadge(badge: badge, quantity: 0);
                    },
                  ),
                ),
              ],
            );
          }),
    );
  }
}
