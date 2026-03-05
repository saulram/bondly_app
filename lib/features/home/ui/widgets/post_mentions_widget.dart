import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/features/home/ui/widgets/user_profile_bottom_sheet.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class PostMentionsWidget extends StatefulWidget {
  final String text;
  final TextStyle? style;

  const PostMentionsWidget({super.key, required this.text, this.style});

  @override
  State<PostMentionsWidget> createState() => _PostMentionsWidgetState();
}

class _PostMentionsWidgetState extends State<PostMentionsWidget> {
  String text = "";
  @override
  void initState() {
    text = widget.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;
    List<TextSpan> textSpans = [];

    // Web format: @[userName](userId) — userId can be hex or UUID with dashes
    RegExp webRegex = RegExp(r"\@\[([^\]]+)\]\(([a-f0-9\-]+)\)");
    // Mobile format: @[__userId__](__userName__)
    RegExp mobileRegex =
        RegExp(r"\@\[(__)([a-f0-9\-]+)(__)\]\((__)([^\]]+)(__)\)");

    // Collect all matches from both formats with their positions
    List<_MentionMatch> allMatches = [];

    for (Match match in webRegex.allMatches(text)) {
      // Skip if this is actually a mobile format match (contains __)
      if (mobileRegex.hasMatch(text.substring(match.start, match.end))) {
        continue;
      }
      allMatches.add(_MentionMatch(
        start: match.start,
        end: match.end,
        userName: match.group(1)!,
        userId: match.group(2)!,
      ));
    }

    for (Match match in mobileRegex.allMatches(text)) {
      allMatches.add(_MentionMatch(
        start: match.start,
        end: match.end,
        userName: match.group(5)!,
        userId: match.group(2)!,
      ));
    }

    // Sort by position in the text
    allMatches.sort((a, b) => a.start.compareTo(b.start));

    int currentIndex = 0;

    for (final mention in allMatches) {
      // Add the text before the mention
      if (mention.start > currentIndex) {
        String beforeMention = text.substring(currentIndex, mention.start);
        textSpans.add(TextSpan(text: beforeMention, style: widget.style));
      }

      // Add the mention as a styled, tappable span
      final userId = mention.userId;
      final userName = mention.userName;
      textSpans.add(TextSpan(
        text: "@$userName",
        style: widget.style?.copyWith(
          color: colors.accent,
          fontWeight: FontWeight.w600,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            showUserProfileBottomSheet(context, userId, userName);
          },
      ));

      currentIndex = mention.end;
    }

    // Add the remaining text
    if (currentIndex < text.length) {
      String remainingText = text.substring(currentIndex);
      textSpans.add(TextSpan(text: remainingText, style: widget.style));
    }

    return RichText(
      text: TextSpan(children: textSpans),
    );
  }
}

class _MentionMatch {
  final int start;
  final int end;
  final String userName;
  final String userId;

  _MentionMatch({
    required this.start,
    required this.end,
    required this.userName,
    required this.userId,
  });
}
