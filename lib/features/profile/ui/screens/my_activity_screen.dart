import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/strings_profile.dart';
import 'package:bondly_app/ui/shared/app_body_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class MyActivityScreen extends StatefulWidget {

  static const String route = "/myActivityScreen";

  const MyActivityScreen({super.key});

  @override
  State<MyActivityScreen> createState() => _MyActivityScreenState();
}

class _MyActivityScreenState extends State<MyActivityScreen> {
  bool addMargin = false;
  double top = 0.0;
  String _value = "";

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              leading: GestureDetector(
                onTap: context.pop,
                child: const Icon(
                  Iconsax.arrow_left,
                ),
              ),
              backgroundColor: theme.scaffoldBackgroundColor,
              iconTheme: IconThemeData(
                color: theme.unselectedWidgetColor, //change your color here
              ),
              expandedHeight: 248.0,
              floating: false,
              pinned: true,
              flexibleSpace: LayoutBuilder(
                builder: (context, constraints) {
                  top = constraints.biggest.height;

                  return FlexibleSpaceBar(
                    centerTitle: true,
                    background: SafeArea(
                      child: Padding(
                          padding: const EdgeInsets.only(top: 40.0),
                          child: BodyLayout(
                            enableBanners: true,
                            child: Container(),
                          ),
                      ),
                    ),
                    title: top < 120.0 ? Text(
                      StringsProfile.myActivity,
                      style: theme.textTheme.titleLarge,
                    ) : const SizedBox(),
                  );
                },
              )
            ),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(_buildChips(theme)),
              pinned: true,
            )
          ];
        },
        body: _buildActivityFeed(theme)
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(
        left: 12.0,
        right: 12.0,
        top: 8.0
      ),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.secondaryColor,

              theme.primaryColor,
            ],
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20.0))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            StringsProfile.myActivityHeader,
            style: theme.textTheme.titleLarge!.copyWith(
              color: Colors.white
            ),
          ),
          const SizedBox(height: 12.0),
          Text(
            StringsProfile.myActivitySubHeader,
            style: theme.textTheme.labelLarge!.copyWith(
              height: 1.4,
              fontSize: 16.0,
              color: Colors.white
            ),
          )
        ],
      ),
    );
  }

  Widget _buildActivityFeed(ThemeData theme) {
    return Column(
      children: [
        _buildHeader(theme),
        _buildActivityItem(
          icon: Iconsax.add,
          title: "Has canjeado una recompensa",
          description: "Canjeaste recompensa del posho feli",
          date: "08/12/22",
          theme
        )
      ],
    );
  }

  Widget _buildActivityItem(ThemeData theme, {
    required IconData icon,
    required String title,
    required String description,
    required String date}) {
    return Container(
      margin: const EdgeInsets.only(
        top: 16.0,
        left: 12.0,
        right: 12.0
      ),
      width: double.infinity,
      padding: const EdgeInsets.only(
        top: 12.0,
        bottom: 12.0,
        left: 8.0,
        right: 16.0
      ),
      decoration: BoxDecoration(
        color: theme.dividerColor,
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        border: Border.all(color: theme.cardColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
              icon,
              color: theme.unselectedWidgetColor
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.headlineSmall!.copyWith(
                    fontSize: 18.0
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                    description
                ),
                const SizedBox(height: 24.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    date
                  ),
                ),
              ],
            ),
          ),
        ],
      )
    );
  }

  Container _buildChips(ThemeData theme) {
    List<String> options = [
      'Puntos',
      'Recompensas',
      'Social',
    ];
    return Container(
      color: theme.scaffoldBackgroundColor,
      height: 60.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List<Widget>.generate(
          options.length,
          (int index) {
            return Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: ChoiceChip(
                backgroundColor: AppColors.secondaryColor,
                selectedColor: AppColors.tertiaryColor,
                label: Text(
                  options[index],
                  style: theme.textTheme.headlineSmall!.copyWith(
                    color: AppColors.backgroundColor,
                    fontSize: 18.0
                  ),
                ),
                selected: _value == options[index],
                onSelected: (bool selected) {
                  setState(() {
                    _value = selected ? options[index] : "";
                  });
                },
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._header);

  final Container _header;

  @override
  double get minExtent => _header.constraints?.maxHeight ?? 60;
  @override
  double get maxExtent => _header.constraints?.maxHeight ?? 60;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      child: _header,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
/*
 return SizedBox(
      height: 48.0,
      child: ChipsChoice<String>.single(
        value: _value,
        onChanged: (selected) {
          setState(() {
            _value = selected;
            print(selected);
          });
        },
        choiceItems: C2Choice.listFrom<String, String>(
            source: options,
            value: (i, v) => v,
            label: (i, v) => v,
        ),
        choiceBuilder: (item, i) {
          return SizedBox(
            width: 70,
            height: 100,
            child: Text(
              item.label,
            ),
          );
        },
      )
    );
*/