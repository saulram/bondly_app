import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/home/ui/widgets/single_post_widget.dart';
import 'package:bondly_app/features/profile/ui/viewmodels/activity_detail_viewmodel.dart';
import 'package:bondly_app/ui/shared/app_sliver_layout.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';

class ActivityDetailScreen extends StatefulWidget {
  static const String route = "/activityDetailScreen";
  static const String idParam = "activityId";
  static const String feedIdParam = "activityFeedId";
  static const String readParam = "activityStatus";

  final ActivityDetailViewModel model = getIt<ActivityDetailViewModel>();
  final String activityId;
  final String feedId;
  final bool isRead;

  ActivityDetailScreen({
    super.key,
    required this.activityId,
    required this.feedId,
    required this.isRead,
  });

  @override
  State<ActivityDetailScreen> createState() => _ActivityDetailScreenState();
}

class _ActivityDetailScreenState extends State<ActivityDetailScreen> {

  @override
  void initState() {
    super.initState();
    widget.model.load(widget.feedId, widget.activityId, widget.isRead);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return ModelProvider<ActivityDetailViewModel>(
      model: widget.model,
        child: ModelBuilder<ActivityDetailViewModel>(builder: (context, model, child) {
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            body: SafeArea(
              child: BondlySliverLayout(
                title: "",
                child: model.post != null && !model.busy
                    ? Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          SinglePostWidget(post: model.post!, index: 0)
                        ],
                      )
                    )
                    : (model.busy ? _showLoading() : _showNoConnectionError())
              ),
            ),
          );
        })
    );
  }

  Widget _showLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _showNoConnectionError() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).cardColor),
          color: Theme.of(context).dividerColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ]
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            IconsaxBold.forbidden_2,
            color: Theme.of(context).unselectedWidgetColor,
            size: 64.0,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Text(
              "No pudimos cargar los datos, por favor reintente más tarde",
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}