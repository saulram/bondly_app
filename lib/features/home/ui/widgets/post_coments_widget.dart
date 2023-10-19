import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/home/domain/models/company_feed_model.dart';
import 'package:bondly_app/features/home/ui/viewmodels/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moment_dart/moment_dart.dart';

class PostCommentsWidget extends StatefulWidget {
  final List<Comment>? comments;
  final String feedId;
  final int feedIndex;
  const PostCommentsWidget(
      {super.key,
      this.comments = const [],
      required this.feedId,
      required this.feedIndex});

  @override
  State<PostCommentsWidget> createState() => _PostCommentsWidgetState();
}

class _PostCommentsWidgetState extends State<PostCommentsWidget> {
  final TextEditingController _commentController = TextEditingController();
  bool busy = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        _buildCommentsHeader(),
        const SizedBox(height: 10),
        _buildCommentsBody(),
      ],
    );
  }

  Widget _buildCommentsHeader() {
    return SizedBox(
      height: 65,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        CircleAvatar(
          backgroundImage: getIt<HomeViewModel>().user!.avatar != null
              ? NetworkImage(getIt<HomeViewModel>().user!.avatar!)
              : null,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: _commentController,
            maxLines: 10,
            minLines: 1,
            decoration: InputDecoration(
              hintText: 'Agrega un comentario',
              fillColor: AppColors.backgroundColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              focusColor: AppColors.backgroundColor,
              filled: true,
            ),
          ),
        ),
        const SizedBox(width: 10),
        busy
            ? const CircularProgressIndicator.adaptive()
            : IconButton(
                onPressed: () {
                  _handleCreateComment();
                },
                icon: const Icon(Iconsax.arrow_right),
              ),
      ]),
    );
  }

  Widget _buildCommentsBody() {
    return Column(
      children: widget.comments!.map((comment) {
        return _buildSingleComment(comment);
      }).toList(),
    );
  }

  Widget _buildSingleComment(Comment comment) {
    //if timestamp is null, return empty string otherwise format it with moment
    DateTime commentDate = comment.timeStamp != null
        ? DateTime.parse(comment.timeStamp!)
        : DateTime.now();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          CircleAvatar(
            radius: 15,
            backgroundImage: NetworkImage(comment.user.avatar ?? ''),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                comment.user.completeName,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                Moment(commentDate).fromNow(),
                style: const TextStyle(
                  fontSize: 11,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: 320,
                child: Text(
                  comment.message ?? '',
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleCreateComment() {
    if (_commentController.text.isNotEmpty) {
      setState(() {
        busy = true;
      });
      getIt<HomeViewModel>()
          .createComment(
              widget.feedId, _commentController.text, widget.feedIndex)
          .then((value) {
        setState(() {
          busy = false;
        });
        _commentController.clear();
      });
    }
  }
}
