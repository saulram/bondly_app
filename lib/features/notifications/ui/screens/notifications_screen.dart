import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/dimensions.dart';
import 'package:bondly_app/config/strings_notifications.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/auth/domain/usecases/user_usecase.dart';
import 'package:bondly_app/features/profile/domain/models/user_activity.dart';
import 'package:bondly_app/features/profile/domain/repositories/activity_repository.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class NotificationsScreen extends StatefulWidget {
  static const String route = "/notificationsScreen";

  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _userUseCase = getIt<UserUseCase>();
  final _activityRepository = getIt<ActivityRepository>();
  List<_NotificationData> _notifications = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final userResult = await _userUseCase.invoke();
      final user = userResult.tryGetSuccess();
      if (user?.id == null) throw StateError('No active session');
      final activityResult =
          await _activityRepository.getActivityList(user!.id!, 100, 0);
      final holder = activityResult.tryGetSuccess();
      if (holder == null) throw activityResult.tryGetError()!;
      if (!mounted) return;
      setState(() {
        _notifications =
            holder.activity.map(_NotificationData.fromActivity).toList();
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'No pudimos cargar tus notificaciones.';
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _markAsRead(_NotificationData item) async {
    if (item.isRead) return;
    final index = _notifications.indexWhere((value) => value.id == item.id);
    if (index < 0) return;
    setState(() => _notifications[index] = item.copyWith(isRead: true));
    try {
      final result = await _activityRepository.updateActivityStatus(item.id);
      if (result.isError()) throw result.tryGetError()!;
    } catch (_) {
      if (!mounted) return;
      setState(() => _notifications[index] = item);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo marcar como leída.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;
    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, colors),
            Expanded(
              child: _buildBody(colors),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, BondlyColorScheme colors) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingScreen,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colors.surfaceElevated,
                shape: BoxShape.circle,
              ),
              child: Icon(
                LucideIcons.arrowLeft,
                size: 20,
                color: colors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            StringsNotifications.title,
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BondlyColorScheme colors) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, style: TextStyle(color: colors.textSecondary)),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _loadNotifications,
              icon: const Icon(LucideIcons.refreshCw, size: 16),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_notifications.isEmpty) {
      return _buildEmptyState(colors);
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingScreen,
        vertical: 12,
      ),
      itemCount: _notifications.length,
      separatorBuilder: (_, __) => Divider(
        color: colors.border,
        height: 1,
      ),
      itemBuilder: (context, index) {
        final item = _notifications[index];
        return InkWell(
          onTap: () => _markAsRead(item),
          child: _NotificationTile(item: item),
        );
      },
    );
  }

  Widget _buildEmptyState(BondlyColorScheme colors) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingXxl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colors.accentSoft,
                shape: BoxShape.circle,
              ),
              child: Icon(
                LucideIcons.bellOff,
                size: 36,
                color: colors.accent,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              StringsNotifications.emptyTitle,
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              StringsNotifications.emptyBody,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: colors.textMuted,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Data model placeholder ─────────────────────────────────────────────

enum NotificationType { recognition, reward, system }

class _NotificationData {
  final String id;
  final String title;
  final String body;
  final String timeAgo;
  final NotificationType type;
  final bool isRead;

  const _NotificationData({
    required this.id,
    required this.title,
    required this.body,
    required this.timeAgo,
    required this.type,
    required this.isRead,
  });

  factory _NotificationData.fromActivity(UserActivityItem activity) {
    final searchable = '${activity.title} ${activity.content}'.toLowerCase();
    final type =
        searchable.contains('canje') || searchable.contains('recompensa')
            ? NotificationType.reward
            : searchable.contains('reconoc') || searchable.contains('insignia')
                ? NotificationType.recognition
                : NotificationType.system;
    final createdAt = DateTime.tryParse(activity.createdAt);
    return _NotificationData(
      id: activity.id,
      title: activity.title.isEmpty ? 'Notificación' : activity.title,
      body: activity.content,
      timeAgo: _formatTimeAgo(createdAt),
      type: type,
      isRead: activity.read,
    );
  }

  _NotificationData copyWith({bool? isRead}) => _NotificationData(
        id: id,
        title: title,
        body: body,
        timeAgo: timeAgo,
        type: type,
        isRead: isRead ?? this.isRead,
      );

  static String _formatTimeAgo(DateTime? date) {
    if (date == null) return '';
    final difference = DateTime.now().difference(date.toLocal());
    if (difference.inMinutes < 1) return 'Ahora';
    if (difference.inHours < 1) return 'Hace ${difference.inMinutes} min';
    if (difference.inDays < 1) return 'Hace ${difference.inHours} h';
    if (difference.inDays < 7) return 'Hace ${difference.inDays} d';
    return '${date.toLocal().day.toString().padLeft(2, '0')}/'
        '${date.toLocal().month.toString().padLeft(2, '0')}/'
        '${date.toLocal().year}';
  }
}

// ─── List tile widget ───────────────────────────────────────────────────

class _NotificationTile extends StatelessWidget {
  final _NotificationData item;
  const _NotificationTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: item.isRead ? colors.surfaceElevated : colors.accentSoft,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _iconForType(item.type),
              size: 20,
              color: item.isRead ? colors.textMuted : colors.accent,
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: item.isRead ? FontWeight.w400 : FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    color: colors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.timeAgo,
                  style: GoogleFonts.montserrat(
                    fontSize: 11,
                    color: colors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          // Unread indicator
          if (!item.isRead)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(top: 6, left: 8),
              decoration: BoxDecoration(
                color: colors.accent,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  static IconData _iconForType(NotificationType type) {
    switch (type) {
      case NotificationType.recognition:
        return LucideIcons.award;
      case NotificationType.reward:
        return LucideIcons.gift;
      case NotificationType.system:
        return LucideIcons.info;
    }
  }
}
