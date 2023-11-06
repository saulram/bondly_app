import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/strings_profile.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/profile/ui/screens/activity_detail_screen.dart';
import 'package:bondly_app/features/profile/ui/viewmodels/my_activity_viewmodel.dart';
import 'package:bondly_app/features/profile/ui/widgets/user_activity_item.dart';
import 'package:bondly_app/ui/shared/app_body_layout.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyActivityScreen extends StatefulWidget {
  static const String route = "/myActivityScreen";

  const MyActivityScreen({super.key});

  @override
  State<MyActivityScreen> createState() => _MyActivityScreenState();
}

class _MyActivityScreenState
    extends State<MyActivityScreen>
    with AutomaticKeepAliveClientMixin<MyActivityScreen> {
  late MyActivityViewModel _viewModel;
  bool addMargin = false;

  double top = 0.0;
  String _value = "";

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<MyActivityViewModel>();
    _viewModel.load();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: _buildBody(theme),
    );
  }

  Widget _buildBody(ThemeData theme) {
    return ModelProvider<MyActivityViewModel>(
      model: _viewModel,
      child: ModelBuilder<MyActivityViewModel>(builder: (context, model, widget) {
        var length = model.activities.length + (model.nextPage > -1 ? 1 : 0);
        return Stack(
          children: [
            NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                        leading: GestureDetector(
                          onTap: context.pop,
                          child: const Icon(
                            IconsaxOutline.arrow_left,
                          ),
                        ),
                        backgroundColor: theme.scaffoldBackgroundColor,
                        iconTheme: IconThemeData(
                          color: theme.unselectedWidgetColor,
                        ),
                        expandedHeight: 260.0,
                        floating: false,
                        pinned: true,
                        flexibleSpace: LayoutBuilder(
                          builder: (context, constraints) {
                            top = constraints.biggest.height;

                            return FlexibleSpaceBar(
                              centerTitle: true,
                              background: SafeArea(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 44.0),
                                  child: BodyLayout(
                                    enableBanners: true,
                                    child: Container(),
                                  ),
                                ),
                              ),
                              title: top < 120.0
                                  ? Text(
                                StringsProfile.myActivity,
                                style: theme.textTheme.titleLarge,
                              )
                                  : const SizedBox(),
                            );
                          },
                        )),
                    /*
                  Leaving this commented until create filter feature
                  SliverPersistentHeader(
                    delegate: _SliverAppBarDelegate(_buildChips(theme)),
                    pinned: true,
                  )*/
                  ];
                },
                body: NotificationListener<ScrollEndNotification>(
                  onNotification: (notification) {
                    var metrics = notification.metrics;
                    if (metrics.atEdge && metrics.pixels > 0) {
                      model.loadActivity();
                    }

                    return true;
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 24.0),
                    child: ListView.builder(
                        padding: const EdgeInsets.only(top: 16.0),
                        itemCount: length,
                        itemBuilder: (context, index) {
                          if (index < model.activities.length) {
                            var item = model.activities[index];

                            if (index == 0) {
                              return Column(
                                children: [
                                  _buildHeaderCard(theme),
                                  UserActivityItem(
                                      key: Key(item.id),
                                      id: item.feedId,
                                      type: item.type,
                                      title: item.title,
                                      description: item.content,
                                      date: item.createdAt,
                                      read: item.read,
                                      onTap: (string) {
                                        context.push(
                                          ActivityDetailScreen.route,
                                          extra: {ActivityDetailScreen.idParam: string}
                                        );
                                      }
                                  )
                                ],
                              );
                            }

                            return UserActivityItem(
                                key: Key(item.id),
                                id: item.feedId,
                                type: item.type,
                                title: item.title,
                                description: item.content,
                                date: item.createdAt,
                                read: item.read,
                                onTap: (string) {
                                  context.push(
                                    ActivityDetailScreen.route,
                                    extra: {ActivityDetailScreen.idParam: string}
                                  );

                                  if (!item.read) {
                                    item.read = true;
                                    setState(() {});
                                    model.updateReadStatus(item.id);
                                  }
                                }
                            );
                          }

                          return Container(
                              margin: const EdgeInsets.only(top: 16),
                              child: model.notificationMessage.isEmpty && model.busy
                                  ? const Center(child: CircularProgressIndicator())
                                  : Container());
                        }),
                  ),
                )
            ),
            !model.errorShown && model.notificationMessage.isNotEmpty
                ? Positioned(
                bottom: 24.0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 16.0),
                  decoration: BoxDecoration(
                      color: theme.dividerColor,
                      border: Border.all(color: AppColors.secondaryColor),
                      borderRadius: BorderRadius.circular(16.0)),
                  child: Text(
                    model.notificationMessage,
                    style:
                    theme.textTheme.bodyLarge!.copyWith(fontSize: 18.0),
                    textAlign: TextAlign.center,
                  ),
                ))
                : Container()
          ],
        );
      })
    );
  }

  Widget _buildHeaderCard(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(
        left: 12.0,
        right: 12.0,
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
          borderRadius: const BorderRadius.all(Radius.circular(20.0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            StringsProfile.myActivityHeader,
            style: theme.textTheme.titleLarge!.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 12.0),
          Text(
            StringsProfile.myActivitySubHeader,
            style: theme.textTheme.labelLarge!
                .copyWith(height: 1.4, fontSize: 16.0, color: Colors.white),
          )
        ],
      ),
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
                      color: AppColors.backgroundColor, fontSize: 18.0),
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
