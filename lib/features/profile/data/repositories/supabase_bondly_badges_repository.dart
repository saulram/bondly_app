import 'package:bondly_app/features/profile/domain/models/bondly_badges_model.dart';
import 'package:bondly_app/features/profile/domain/repositories/bondly_badges_repository.dart';
import 'package:bondly_app/src/supabase_client_provider.dart';
import 'package:multiple_result/multiple_result.dart';

class SupabaseBondlyBadgesRepository extends BondlyBadgesRepository {
  final SupabaseClientProvider _provider;

  SupabaseBondlyBadgesRepository(this._provider);

  String? get _currentUserId => _provider.client.auth.currentUser?.id;

  @override
  Future<Result<BondlyBadges, Exception>> getBondlyBadges() async {
    try {
      // Get ambassador badges from ambassadors table
      final embassyResponse = await _provider.client
          .from('ambassadors')
          .select('*, badge:badges(*)')
          .eq('user_id', _currentUserId!)
          .eq('visible', true);

      final embassyItems = _groupByBadge(embassyResponse as List, 'badge');
      final embassys = Embassys(
        count: embassyItems.length,
        embassys: embassyItems
            .map((item) => Embassy(
                  badgeId: BondlyBadge.fromSupabase(
                      item['badge'] as Map<String, dynamic>),
                  quantity: item['quantity'] as int,
                ))
            .toList(),
      );

      // Get my received badges from badge_reports
      final myBadgesResponse = await _provider.client
          .from('badge_reports')
          .select('*, badge:badges(*)')
          .eq('receiver_id', _currentUserId!);

      final myBadgeItems = _groupByBadge(myBadgesResponse as List, 'badge');
      final myBadges = MyBadges(
        count: myBadgeItems.length,
        myBadges: myBadgeItems
            .map((item) => MyBadge(
                  badgeId: BondlyBadge.fromSupabase(
                      item['badge'] as Map<String, dynamic>),
                  quantity: item['quantity'] as int,
                ))
            .toList(),
      );

      // Get categories with their badges
      final categoriesResponse = await _provider.client
          .from('badge_categories')
          .select('*, badges(*)')
          .eq('visible', true);

      final categories = (categoriesResponse as List).map((cat) {
        final catMap = cat as Map<String, dynamic>;
        final badgesList = (catMap['badges'] as List?) ?? [];
        return BondlyCategory(
          id: catMap['id'] ?? '',
          name: catMap['name'] ?? '',
          account: catMap['account'] ?? 0,
          description: catMap['description'] ?? '',
          imageUrl: catMap['image_url'] ?? '',
          categoryBadges: badgesList
              .map((b) => BondlyBadge.fromSupabase(b as Map<String, dynamic>))
              .toList(),
        );
      }).toList();

      return Result.success(BondlyBadges(
        embassys: embassys,
        myBadges: myBadges,
        categories: categories,
      ));
    } catch (exception) {
      return Result.error(exception as Exception);
    }
  }

  List<Map<String, dynamic>> _groupByBadge(List rows, String badgeKey) {
    final Map<String, Map<String, dynamic>> grouped = {};
    for (final row in rows) {
      final badge = row[badgeKey] as Map<String, dynamic>?;
      if (badge == null) continue;
      final badgeId = badge['id'] as String;
      if (grouped.containsKey(badgeId)) {
        grouped[badgeId]!['quantity'] =
            (grouped[badgeId]!['quantity'] as int) + 1;
      } else {
        grouped[badgeId] = {
          'badge': badge,
          'quantity': 1,
        };
      }
    }
    return grouped.values.toList();
  }
}
