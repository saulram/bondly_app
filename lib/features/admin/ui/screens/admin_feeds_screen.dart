import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/constants.dart';
import 'package:bondly_app/config/strings_admin.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/admin/domain/models/admin_feed.dart';
import 'package:bondly_app/features/admin/domain/models/admin_module.dart';
import 'package:bondly_app/features/admin/ui/viewmodels/admin_feeds_viewmodel.dart';
import 'package:bondly_app/features/admin/ui/widgets/admin_empty_state.dart';
import 'package:bondly_app/features/admin/ui/widgets/admin_permission_guard.dart';
import 'package:bondly_app/features/admin/ui/widgets/admin_search_bar.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AdminFeedsScreen extends StatefulWidget {
  static const String route = '/admin/feeds';

  const AdminFeedsScreen({super.key});

  @override
  State<AdminFeedsScreen> createState() => _AdminFeedsScreenState();
}

class _AdminFeedsScreenState extends State<AdminFeedsScreen> {
  late AdminFeedsViewModel _vm;

  static const _typeLabels = {
    'reconocimiento': StringsAdmin.feedTypeRecognition,
    'canje': StringsAdmin.feedTypeExchange,
    'comentario': StringsAdmin.feedTypeComment,
    'recompensa': StringsAdmin.feedTypeReward,
  };

  @override
  void initState() {
    super.initState();
    _vm = getIt<AdminFeedsViewModel>();
    _vm.load();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;
    final isNarrow =
        MediaQuery.of(context).size.width < Constants.mobileBreakpoint;

    return AdminPermissionGuard(
      module: AdminModule.manageFeeds,
      child: ModelProvider<AdminFeedsViewModel>(
        model: _vm,
        child: ModelBuilder<AdminFeedsViewModel>(
          builder: (context, vm, _) => Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        StringsAdmin.feedsTitle,
                        style: GoogleFonts.montserrat(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (!vm.isLoading)
                      Text(
                        '${vm.result.total} ${StringsAdmin.rows}',
                        style: GoogleFonts.montserrat(
                            fontSize: 13, color: colors.textMuted),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                if (isNarrow)
                  Column(
                    children: [
                      AdminSearchBar(
                        hint: StringsAdmin.searchFeeds,
                        onChanged: vm.onSearch,
                      ),
                      const SizedBox(height: 8),
                      _typeDropdown(vm, colors, expanded: true),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: AdminSearchBar(
                          hint: StringsAdmin.searchFeeds,
                          onChanged: vm.onSearch,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _typeDropdown(vm, colors),
                    ],
                  ),
                const SizedBox(height: 16),
                Expanded(
                  child: vm.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : vm.error != null
                          ? AdminEmptyState(
                              icon: LucideIcons.alertCircle,
                              message: vm.error!,
                              ctaLabel: StringsAdmin.retry,
                              onCta: vm.load,
                            )
                          : vm.result.items.isEmpty
                              ? AdminEmptyState(
                                  icon: LucideIcons.messageSquare,
                                  message: StringsAdmin.noFeedsFound,
                                )
                              : ListView.separated(
                                  itemCount: vm.result.items.length,
                                  separatorBuilder: (_, __) => Divider(
                                      height: 1, color: colors.border),
                                  itemBuilder: (ctx, i) => _FeedRow(
                                    feed: vm.result.items[i],
                                    vm: vm,
                                    colors: colors,
                                    typeLabels: _typeLabels,
                                  ),
                                ),
                ),
                if (!vm.isLoading && vm.result.totalPages > 1)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(LucideIcons.chevronLeft,
                              color: colors.textSecondary),
                          onPressed: vm.result.hasPrevPage
                              ? () => vm.setPage(vm.page - 1)
                              : null,
                        ),
                        Text(
                          '${vm.page} ${StringsAdmin.pageOf} ${vm.result.totalPages}',
                          style: GoogleFonts.montserrat(
                              fontSize: 13, color: colors.textSecondary),
                        ),
                        IconButton(
                          icon: Icon(LucideIcons.chevronRight,
                              color: colors.textSecondary),
                          onPressed: vm.result.hasNextPage
                              ? () => vm.setPage(vm.page + 1)
                              : null,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _typeDropdown(AdminFeedsViewModel vm, BondlyColorScheme colors,
      {bool expanded = false}) {
    final dropdown = Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: vm.typeFilter != null ? colors.accent : colors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: vm.typeFilter,
          isExpanded: expanded,
          hint: Text(StringsAdmin.filterByType,
              style: GoogleFonts.montserrat(
                  fontSize: 13, color: colors.textMuted)),
          style:
              GoogleFonts.montserrat(fontSize: 13, color: colors.textPrimary),
          dropdownColor: colors.surface,
          onChanged: vm.setTypeFilter,
          items: [
            DropdownMenuItem(
              value: null,
              child: Text(StringsAdmin.all,
                  style: GoogleFonts.montserrat(
                      fontSize: 13, color: colors.textMuted)),
            ),
            ..._typeLabels.entries.map((e) => DropdownMenuItem(
                  value: e.key,
                  child: Text(e.value),
                )),
          ],
        ),
      ),
    );
    return expanded ? SizedBox(width: double.infinity, child: dropdown) : dropdown;
  }
}

class _FeedRow extends StatelessWidget {
  final AdminFeed feed;
  final AdminFeedsViewModel vm;
  final BondlyColorScheme colors;
  final Map<String, String> typeLabels;

  const _FeedRow({
    required this.feed,
    required this.vm,
    required this.colors,
    required this.typeLabels,
  });

  static final _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    final subtitle = [
      if (feed.senderName != null) feed.senderName!,
      if (feed.type != null) typeLabels[feed.type] ?? feed.type!,
      if (feed.createdAt != null) _dateFormat.format(feed.createdAt!),
    ].join(' · ');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Icon(
            feed.isHighlighted ? LucideIcons.star : LucideIcons.messageSquare,
            size: 18,
            color: feed.isHighlighted ? Colors.amber : colors.textMuted,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feed.header?.isNotEmpty == true
                      ? feed.header!
                      : (feed.body ?? '—'),
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: feed.visible
                        ? colors.textPrimary
                        : colors.textMuted,
                    decoration:
                        feed.visible ? null : TextDecoration.lineThrough,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.montserrat(
                      fontSize: 11, color: colors.textMuted),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(LucideIcons.messagesSquare,
                size: 16, color: colors.textMuted),
            tooltip: StringsAdmin.viewComments,
            onPressed: () => _showCommentsDialog(context),
          ),
          IconButton(
            icon: Icon(
              feed.isHighlighted ? LucideIcons.starOff : LucideIcons.star,
              size: 16,
              color: colors.textMuted,
            ),
            tooltip: feed.isHighlighted
                ? StringsAdmin.unhighlightFeed
                : StringsAdmin.highlightFeed,
            onPressed: () => vm.toggleHighlighted(feed),
          ),
          IconButton(
            icon: Icon(
              feed.visible ? LucideIcons.eyeOff : LucideIcons.eye,
              size: 16,
              color: feed.visible ? Colors.orange : Colors.green,
            ),
            tooltip:
                feed.visible ? StringsAdmin.hideFeed : StringsAdmin.showFeed,
            onPressed: () => vm.toggleVisible(feed),
          ),
          IconButton(
            icon: const Icon(LucideIcons.trash2, size: 16, color: Colors.red),
            tooltip: StringsAdmin.deleteFeed,
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.surface,
        title: Text(StringsAdmin.confirmDeleteTitle,
            style: GoogleFonts.montserrat(fontWeight: FontWeight.bold)),
        content: const Text(StringsAdmin.confirmDeleteFeed),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(StringsAdmin.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              final ok = await vm.deleteFeed(feed.id);
              if (ok && ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text(StringsAdmin.delete),
          ),
        ],
      ),
    );
  }

  void _showCommentsDialog(BuildContext context) {
    // Held outside the builder so dialog rebuilds don't refire the query;
    // reassigned explicitly after a delete.
    var commentsFuture = vm.getComments(feed.id);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.surface,
        title: Text(StringsAdmin.commentsTitle,
            style: GoogleFonts.montserrat(fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: (MediaQuery.of(context).size.width - 32).clamp(0.0, 480.0),
          child: StatefulBuilder(
            builder: (ctx, setDialogState) =>
                FutureBuilder<List<AdminFeedComment>>(
              future: commentsFuture,
              builder: (ctx, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox(
                    height: 80,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final comments = snapshot.data!;
                if (comments.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(StringsAdmin.noComments),
                  );
                }
                return ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 400),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: comments.length,
                    separatorBuilder: (_, __) =>
                        Divider(height: 1, color: colors.border),
                    itemBuilder: (ctx, i) {
                      final c = comments[i];
                      return ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text(c.message,
                            style: GoogleFonts.montserrat(fontSize: 13)),
                        subtitle: Text(c.userName ?? '—',
                            style: GoogleFonts.montserrat(
                                fontSize: 11, color: colors.textMuted)),
                        trailing: IconButton(
                          icon: const Icon(LucideIcons.trash2,
                              size: 15, color: Colors.red),
                          tooltip: StringsAdmin.deleteComment,
                          onPressed: () async {
                            final ok = await vm.deleteComment(c.id);
                            if (ok) {
                              setDialogState(() {
                                commentsFuture = vm.getComments(feed.id);
                              });
                            }
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(StringsAdmin.cancel),
          ),
        ],
      ),
    );
  }
}
