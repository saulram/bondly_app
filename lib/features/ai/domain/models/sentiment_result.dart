enum SentimentType {
  positive,
  neutral,
  negative,
}

class SentimentResult {
  final SentimentType sentiment;
  final double confidence;
  final String summary;

  SentimentResult({
    required this.sentiment,
    required this.confidence,
    required this.summary,
  });

  factory SentimentResult.fromValues({
    required String sentimentLabel,
    required double confidence,
    required String summary,
  }) {
    SentimentType type;
    switch (sentimentLabel.toLowerCase()) {
      case 'positive':
        type = SentimentType.positive;
        break;
      case 'negative':
        type = SentimentType.negative;
        break;
      default:
        type = SentimentType.neutral;
    }
    return SentimentResult(
      sentiment: type,
      confidence: confidence,
      summary: summary,
    );
  }
}
