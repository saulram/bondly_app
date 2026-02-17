import 'package:bondly_app/features/profile/domain/models/cart_model.dart';
import 'package:bondly_app/features/profile/domain/models/rewards_list_model.dart';
import 'package:bondly_app/features/profile/domain/repositories/cart_repository.dart';
import 'package:bondly_app/src/supabase_client_provider.dart';
import 'package:multiple_result/multiple_result.dart';

class SupabaseCartRepository extends CartRepository {
  final SupabaseClientProvider _provider;

  SupabaseCartRepository(this._provider);

  String? get _currentUserId => _provider.client.auth.currentUser?.id;

  @override
  Future<Result<RewardList, Exception>> getShoppingItems() async {
    try {
      final response = await _provider.client
          .from('rewards')
          .select()
          .eq('enable', true)
          .eq('visible', true);

      final rewards = (response as List)
          .map((row) => Reward.fromSupabase(row as Map<String, dynamic>))
          .toList();

      return Result.success(RewardList(rewards: rewards));
    } catch (exception) {
      return Result.error(exception as Exception);
    }
  }

  @override
  Future<Result<UserCart, Exception>> getUserShoppingCart() async {
    try {
      final response = await _provider.client
          .from('carts')
          .select('*, cart_items(*, reward:rewards(*))')
          .eq('user_id', _currentUserId!)
          .eq('type', 'active')
          .single();

      return Result.success(UserCart.fromSupabase(response));
    } catch (exception) {
      return Result.error(exception as Exception);
    }
  }

  @override
  Future<Result<UserCart, Exception>> bulkAddCartItems(
    Map<String, dynamic> items,
    String cartId,
  ) async {
    try {
      final rows = (items['items'] as List).map((item) => {
            'cart_id': cartId,
            'reward_id': item['reward_id'],
            'quantity': item['quantity'],
          }).toList();

      await _provider.client.from('cart_items').insert(rows);

      return getUserShoppingCart();
    } catch (exception) {
      return Result.error(exception as Exception);
    }
  }

  @override
  Future<Result<UserCart, Exception>> pushCartItem(
    String cartId,
    String itemId,
  ) async {
    try {
      final existing = await _provider.client
          .from('cart_items')
          .select()
          .eq('cart_id', cartId)
          .eq('reward_id', itemId);

      if ((existing as List).isNotEmpty) {
        final currentQty = existing.first['quantity'] as int;
        await _provider.client
            .from('cart_items')
            .update({'quantity': currentQty + 1})
            .eq('id', existing.first['id']);
      } else {
        await _provider.client.from('cart_items').insert({
          'cart_id': cartId,
          'reward_id': itemId,
          'quantity': 1,
        });
      }

      return getUserShoppingCart();
    } catch (exception) {
      return Result.error(exception as Exception);
    }
  }

  @override
  Future<Result<UserCart, Exception>> pullCartItem(
    String cartId,
    String itemId,
  ) async {
    try {
      final existing = await _provider.client
          .from('cart_items')
          .select()
          .eq('cart_id', cartId)
          .eq('reward_id', itemId);

      if ((existing as List).isNotEmpty) {
        final currentQty = existing.first['quantity'] as int;
        if (currentQty <= 1) {
          await _provider.client
              .from('cart_items')
              .delete()
              .eq('id', existing.first['id']);
        } else {
          await _provider.client
              .from('cart_items')
              .update({'quantity': currentQty - 1})
              .eq('id', existing.first['id']);
        }
      }

      return getUserShoppingCart();
    } catch (exception) {
      return Result.error(exception as Exception);
    }
  }

  @override
  Future<Result<UserCart, Exception>> clearShoppingCart(String cartId) async {
    try {
      await _provider.client
          .from('cart_items')
          .delete()
          .eq('cart_id', cartId);

      return getUserShoppingCart();
    } catch (exception) {
      return Result.error(exception as Exception);
    }
  }

  @override
  Future<Result<bool, Exception>> checkOutCart(String cartId) async {
    try {
      await _provider.client
          .from('carts')
          .update({'type': 'checkout'})
          .eq('id', cartId);

      return Result.success(true);
    } catch (exception) {
      return Result.error(exception as Exception);
    }
  }
}
