import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/features/home/ui/widgets/post_mentions_widget.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';

class UserActivityItem extends StatelessWidget {
  final String id;
  final String type;
  final String title;
  final String description;
  final String date;
  final bool read;
  final Function(String activityId) onTap;


  const UserActivityItem({
    super.key,
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.date,
    required this.read,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    IconData icon;
    switch (type) {
      case "Reconocimientos":
        icon = IconsaxBold.medal_star;
        break;
      case "Recompensas":
        icon = IconsaxBold.box;
        break;
      default:
        icon = IconsaxBold.activity;
        break;
    }

    var parsedDate = DateTime.parse(date).toString();
    parsedDate =
        parsedDate.replaceRange(parsedDate.length - 13, parsedDate.length, "").trim();

    return GestureDetector(
      onTap: () {
        onTap.call(id);
      },
      child: Container(
          margin: const EdgeInsets.only(top: 16.0, left: 12.0, right: 12.0),
          width: double.infinity,
          padding: const EdgeInsets.only(
              top: 12.0, bottom: 12.0, left: 8.0, right: 16.0),
          decoration: BoxDecoration(
            color: theme.dividerColor,
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            border: Border.all(color: theme.cardColor),
          ),
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: theme.unselectedWidgetColor,
                    size: 36.0,
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.headlineSmall!
                              .copyWith(fontSize: 18.0),
                        ),
                        const SizedBox(height: 8.0),
                        PostMentionsWidget(
                          text: description,
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 24.0),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0
                          ),
                          decoration: BoxDecoration(
                            color: theme.dividerColor,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Text(parsedDate)
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 24.0,
                  )
                ],
              ),
              !read ? const Positioned(
                top: 0,
                right: 0,
                child: Icon(
                  IconsaxBold.notification_status,
                  color: AppColors.secondaryColor,
                ),
              ) : Container()
            ],
          )
      ),
    );
  }
}