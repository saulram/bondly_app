import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/home/ui/widgets/single_post_widget.dart';
import 'package:bondly_app/features/profile/ui/viewmodels/activity_detail_viewmodel.dart';
import 'package:bondly_app/ui/shared/app_body_layout.dart';
import 'package:flutter/material.dart';

class ActivityDetailScreen extends StatefulWidget {
  static const String route = "/activityDetailScreen";
  static const String idParam = "activityId";
  static const String readParam = "activityStatus";

  final ActivityDetailViewModel model = getIt<ActivityDetailViewModel>();
  final String activityId;
  final bool isRead;

  ActivityDetailScreen({
    super.key,
    required this.activityId,
    required this.isRead,
  });

  @override
  State<ActivityDetailScreen> createState() => _ActivityDetailScreenState();
}

class _ActivityDetailScreenState extends State<ActivityDetailScreen> {

  @override
  void initState() {
    super.initState();
    widget.model.load(widget.activityId, widget.isRead);
  }

  @override
  Widget build(BuildContext context) {
    return ModelProvider<ActivityDetailViewModel>(
      model: widget.model,
        child: ModelBuilder<ActivityDetailViewModel>(builder: (context, model, child) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: SafeArea(
              child: BodyLayout(
                enableBanners: true,
                child: model.post != null
                    ? Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          SinglePostWidget(post: model.post!, index: 0)
                        ],
                      )
                    )
                    : const Center(
                  child: CircularProgressIndicator(),
                )
              ),
            ),
          );
        })
    );
  }
}