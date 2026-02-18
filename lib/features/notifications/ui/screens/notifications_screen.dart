import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/dimensions.dart';
import 'package:bondly_app/config/strings_notifications.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class NotificationsScreen extends StatelessWidget {
  static const String route = "/notificationsScreen";

  const NotificationsScreen({super.key});

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
    // TODO: Replace with actual notifications list from API
    const notifications = <_NotificationData>[];

    if (notifications.isEmpty) {
      return _buildEmptyState(colors);
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingScreen,
        vertical: 12,
      ),
      itemCount: notifications.length,
      separatorBuilder: (_, __) => Divider(
        color: colors.border,
        height: 1,
      ),
      itemBuilder: (context, index) {
        final item = notifications[index];
        return _NotificationTile(item: item);
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
  final String title;
  final String body;
  final String timeAgo;
  final NotificationType type;
  final bool isRead;

  const _NotificationData({
    required this.title,
    required this.body,
    required this.timeAgo,
    required this.type,
    required this.isRead,
  });
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
