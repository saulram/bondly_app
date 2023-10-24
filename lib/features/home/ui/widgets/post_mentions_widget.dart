import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/theme.dart';
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
    List<TextSpan> textSpans = [];

    RegExp webRegex = RegExp(r"\@\[([^\]]+)\]\(([a-f0-9]+)\)");
    RegExp mobileRegex = RegExp(r"\@\[(__)([a-f0-9]+)(__)\]\((__)([^\]]+)(__)\)");

    int currentIndex = 0;

    // Función para procesar las coincidencias
    void processMatch(Match match, bool isMobileFormat) {
      String userName, userId;

      if (isMobileFormat) {
        userId = match.group(2)!;
        userName = match.group(5)!;
      } else {
        userName = match.group(1)!;
        userId = match.group(2)!;
      }

      // Add the text before the mention
      if (match.start > currentIndex) {
        String beforeMention = text.substring(currentIndex, match.start);
        textSpans.add(TextSpan(text: beforeMention, style: widget.style));
      }

      // Add the mention
      textSpans.add(TextSpan(
        text: "@$userName",
        style: style?.copyWith(color: context.isDarkMode
            ? AppColors.secondaryColorLight
            : AppColors.secondaryColor
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            debugPrint("Mention tapped: $userId");
          },
      ));

      currentIndex = match.end;
    }

    // Procesar las coincidencias del formato web
    for (Match match in webRegex.allMatches(text)) {
      processMatch(match, false);
    }

    // Procesar las coincidencias del formato móvil
    for (Match match in mobileRegex.allMatches(text)) {
      processMatch(match, true);
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
