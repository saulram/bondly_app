import 'package:bondly_app/config/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class PostMentionsWidget extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const PostMentionsWidget({super.key, required this.text, this.style});

  @override
  Widget build(BuildContext context) {
    List<TextSpan> textSpans = [];

    RegExp regex = RegExp(r"\@\[([^\]]+)\]\(([a-f0-9]+)\)");
    Iterable<Match> matches = regex.allMatches(text);

    int currentIndex = 0;

    for (Match match in matches) {
      String userName = match.group(1)!;
      String userId = match.group(2)!;

      // Add the text before the mention
      if (match.start > currentIndex) {
        String beforeMention = text.substring(currentIndex, match.start);
        textSpans.add(TextSpan(text: beforeMention, style: style));
      }

      // Add the mention
      textSpans.add(TextSpan(
        text: "@$userName",
        style: style?.copyWith(color: AppColors.secondaryColor),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            // Handle the mention tap
            print("User ID: $userId");
          },
      ));

      currentIndex = match.end;
    }

    // Add the remaining text
    if (currentIndex < text.length) {
      String remainingText = text.substring(currentIndex);
      textSpans.add(TextSpan(text: remainingText, style: style));
    }

    return RichText(
      text: TextSpan(children: textSpans),
    );
  }
}
