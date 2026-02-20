import 'package:bondly_app/features/ai/data/api/gemini_service.dart';
import 'package:bondly_app/features/ai/domain/models/feed_insight.dart';
import 'package:bondly_app/features/ai/domain/models/reward_recommendation.dart';
import 'package:bondly_app/features/ai/domain/models/sentiment_result.dart';
import 'package:bondly_app/features/ai/domain/repositories/ai_repository.dart';
import 'package:logger/logger.dart';
import 'package:multiple_result/multiple_result.dart';

class DefaultAIRepository extends AIRepository {
  final GeminiService _geminiService;
  final Logger _log = Logger(printer: PrettyPrinter(methodCount: 0));

  DefaultAIRepository(this._geminiService);

  @override
  Future<Result<PersonalizedFeedResult, Exception>> personalizeFeed({
    required String userId,
    required List<Map<String, dynamic>> feedItems,
    required Map<String, dynamic> userProfile,
  }) async {
    try {
      final feedSummaries = feedItems.take(20).map((f) {
        return {
          'id': f['id'],
          'header': f['header'],
          'body': (f['body'] as String?)?.substring(0, (f['body'] as String).length.clamp(0, 100)),
          'type': f['type'],
          'likes': f['likesCount'],
          'comments': f['commentsCount'],
          'sender': f['senderName'],
        };
      }).toList();

      final prompt = '''
Eres un asistente de IA para una plataforma de reconocimiento de empleados llamada Bondly.
Analiza las publicaciones del feed y ordénalas por relevancia para el usuario.

Perfil del usuario:
- Nombre: ${userProfile['name']}
- Puntos mensuales: ${userProfile['monthlyPoints']}
- Puntos recibidos: ${userProfile['pointsReceived']}
- Empresa: ${userProfile['company']}

Publicaciones del feed (JSON):
${feedSummaries.toString()}

Responde SOLO con un JSON con esta estructura exacta:
{
  "orderedIds": ["id1", "id2", ...],
  "insights": {
    "id1": {"feedId": "id1", "relevanceScore": 0.95, "reason": "Razón breve"},
    "id2": {"feedId": "id2", "relevanceScore": 0.8, "reason": "Razón breve"}
  }
}

Criterios de relevancia:
1. Publicaciones con más interacción (likes, comentarios)
2. Publicaciones recientes
3. Publicaciones de reconocimiento tienen prioridad
4. Diversidad de tipos de contenido
''';

      final response = await _geminiService.generateJsonResponse(prompt);

      final orderedIds = (response['orderedIds'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          feedItems.map((f) => f['id'].toString()).toList();

      final insightsMap = <String, FeedInsight>{};
      final rawInsights = response['insights'] as Map<String, dynamic>? ?? {};
      for (final entry in rawInsights.entries) {
        insightsMap[entry.key] = FeedInsight.fromJson(
          entry.value as Map<String, dynamic>,
        );
      }

      return Result.success(PersonalizedFeedResult(
        orderedFeedIds: orderedIds,
        insights: insightsMap,
      ));
    } catch (e) {
      _log.e('Feed personalization error: $e');
      return Result.error(Exception('No se pudo personalizar el feed: $e'));
    }
  }

  @override
  Future<Result<List<RewardRecommendation>, Exception>> getRewardRecommendations({
    required Map<String, dynamic> userProfile,
    required List<Map<String, dynamic>> availableRewards,
  }) async {
    try {
      final rewardSummaries = availableRewards.take(15).map((r) {
        return {
          'id': r['id'],
          'name': r['name'],
          'description': (r['description'] as String?)?.substring(
            0,
            (r['description'] as String).length.clamp(0, 80),
          ),
          'points': r['points'],
          'category': r['category'],
          'likes': r['likesCount'],
        };
      }).toList();

      final prompt = '''
Eres un asistente de IA para Bondly, una plataforma de recompensas para empleados.
Recomienda las mejores recompensas para este usuario.

Perfil del usuario:
- Nombre: ${userProfile['name']}
- Puntos disponibles: ${userProfile['availablePoints']}
- Puntos mensuales: ${userProfile['monthlyPoints']}
- Empresa: ${userProfile['company']}

Recompensas disponibles (JSON):
${rewardSummaries.toString()}

Responde SOLO con un JSON con esta estructura exacta:
{
  "recommendations": [
    {"rewardId": "id1", "reason": "Razón personalizada en español", "matchScore": 0.95},
    {"rewardId": "id2", "reason": "Razón personalizada en español", "matchScore": 0.8}
  ]
}

Criterios:
1. Recomendar máximo 5 recompensas
2. Priorizar las que el usuario puede pagar con sus puntos
3. Considerar popularidad (likes)
4. Dar razones personalizadas y motivadoras en español
''';

      final response = await _geminiService.generateJsonResponse(prompt);

      final recommendations = (response['recommendations'] as List<dynamic>?)
              ?.map((r) => RewardRecommendation.fromJson(r as Map<String, dynamic>))
              .toList() ??
          [];

      return Result.success(recommendations);
    } catch (e) {
      _log.e('Reward recommendations error: $e');
      return Result.error(
        Exception('No se pudieron obtener recomendaciones: $e'),
      );
    }
  }

  @override
  Future<Result<SentimentResult, Exception>> analyzeSentiment({
    required String text,
  }) async {
    try {
      final prompt = '''
Eres un analizador de sentimiento para Bondly, una plataforma de reconocimiento de empleados.
Analiza el sentimiento del siguiente texto de una publicación o comentario.

Texto: "$text"

Responde SOLO con un JSON con esta estructura exacta:
{
  "sentiment": "positive",
  "confidence": 0.92,
  "summary": "Resumen breve del sentimiento en español"
}

Reglas:
- "sentiment" debe ser exactamente: "positive", "neutral" o "negative"
- "confidence" debe ser un número entre 0.0 y 1.0
- "summary" debe ser una frase corta en español (máximo 15 palabras)
''';

      final response = await _geminiService.generateJsonResponse(prompt);

      final result = SentimentResult.fromValues(
        sentimentLabel: response['sentiment'] as String? ?? 'neutral',
        confidence: (response['confidence'] as num?)?.toDouble() ?? 0.5,
        summary: response['summary'] as String? ?? 'Sin análisis disponible',
      );

      return Result.success(result);
    } catch (e) {
      _log.e('Sentiment analysis error: $e');
      return Result.error(
        Exception('No se pudo analizar el sentimiento: $e'),
      );
    }
  }
}
