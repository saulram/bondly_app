import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/strings_admin.dart';
import 'package:bondly_app/config/strings_suggestions.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/admin/domain/models/admin_module.dart';
import 'package:bondly_app/features/admin/domain/models/admin_suggestion.dart';
import 'package:bondly_app/features/admin/ui/viewmodels/admin_suggestions_viewmodel.dart';
import 'package:bondly_app/features/admin/ui/widgets/admin_empty_state.dart';
import 'package:bondly_app/features/admin/ui/widgets/admin_permission_guard.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/suggestions/ui/widgets/suggestion_status_chip.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AdminSuggestionsScreen extends StatefulWidget {
  static const String route = '/admin/suggestions';

  const AdminSuggestionsScreen({super.key});

  @override
  State<AdminSuggestionsScreen> createState() => _AdminSuggestionsScreenState();
}

class _AdminSuggestionsScreenState extends State<AdminSuggestionsScreen> {
  late AdminSuggestionsViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = getIt<AdminSuggestionsViewModel>();
    _vm.load();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;

    return AdminPermissionGuard(
      module: AdminModule.manageSuggestions,
      child: ModelProvider<AdminSuggestionsViewModel>(
        model: _vm,
        child: ModelBuilder<AdminSuggestionsViewModel>(
          builder: (context, vm, _) => Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  StringsAdmin.suggestionsTitle,
                  style: GoogleFonts.montserrat(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  StringsAdmin.suggestionsSubtitle,
                  style: GoogleFonts.montserrat(
                      fontSize: 13, color: colors.textMuted),
                ),
                const SizedBox(height: 16),
                _buildFilters(vm, colors),
                const SizedBox(height: 12),
                Expanded(
                  child: vm.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : vm.error != null
                          ? AdminEmptyState(
                              icon: LucideIcons.alertCircle,
                              message: vm.error!,
                              ctaLabel: StringsAdmin.retry,
                              onCta: vm.load)
                          : vm.items.isEmpty
                              ? const AdminEmptyState(
                                  icon: LucideIcons.messageCircle,
                                  message: StringsAdmin.noSuggestionsFound,
                                )
                              : _SuggestionsList(vm: vm, colors: colors),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilters(
      AdminSuggestionsViewModel vm, BondlyColorScheme colors) {
    Widget chip(String? value, String label) {
      final selected = vm.statusFilter == value;
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ChoiceChip(
          label: Text(label),
          selected: selected,
          onSelected: (_) => vm.setStatusFilter(value),
        ),
      );
    }

    return Wrap(
      children: [
        chip(null, StringsAdmin.all),
        ...StringsSuggestions.statusLabels.entries
            .map((e) => chip(e.key, e.value)),
      ],
    );
  }
}

class _SuggestionsList extends StatelessWidget {
  final AdminSuggestionsViewModel vm;
  final BondlyColorScheme colors;

  const _SuggestionsList({required this.vm, required this.colors});

  String _authorOf(AdminSuggestion s) =>
      (!s.isAnonymous && s.authorName?.isNotEmpty == true)
          ? s.authorName!
          : StringsSuggestions.anonymousTag;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: vm.items.length,
      separatorBuilder: (_, __) => Divider(height: 1, color: colors.border),
      itemBuilder: (ctx, i) {
        final s = vm.items[i];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: colors.surfaceElevated,
            child: Icon(
              s.isAnonymous ? LucideIcons.userX : LucideIcons.user,
              size: 18,
              color: colors.textMuted,
            ),
          ),
          title: Text(
            s.title?.isNotEmpty == true ? s.title! : s.message,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.montserrat(
                fontSize: 14, fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            [
              _authorOf(s),
              if (s.category != null) s.category!,
              if (s.createdAt != null)
                DateFormat('dd MMM', 'es').format(s.createdAt!),
            ].join(' · '),
            style: GoogleFonts.montserrat(
                fontSize: 12, color: colors.textMuted),
          ),
          trailing: SuggestionStatusChip(status: s.status),
          onTap: () => _showDetail(ctx, s),
        );
      },
    );
  }

  void _showDetail(BuildContext context, AdminSuggestion s) {
    final noteCtrl = TextEditingController(text: s.adminNote);
    final author = _authorOf(s);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.surface,
        title: Text(
          StringsAdmin.suggestionDetail,
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: (MediaQuery.of(context).size.width - 32).clamp(0.0, 520.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(s.isAnonymous ? LucideIcons.userX : LucideIcons.user,
                        size: 16, color: colors.textMuted),
                    const SizedBox(width: 6),
                    Text(author,
                        style: GoogleFonts.montserrat(
                            fontSize: 13, fontWeight: FontWeight.w600)),
                    const Spacer(),
                    if (s.createdAt != null)
                      Text(
                        DateFormat('dd MMM yyyy', 'es').format(s.createdAt!),
                        style: GoogleFonts.montserrat(
                            fontSize: 12, color: colors.textMuted),
                      ),
                  ],
                ),
                if (s.category != null) ...[
                  const SizedBox(height: 8),
                  Text('${StringsAdmin.suggestionCategory}: ${s.category}',
                      style: GoogleFonts.montserrat(
                          fontSize: 12, color: colors.textSecondary)),
                ],
                if (s.title?.isNotEmpty == true) ...[
                  const SizedBox(height: 12),
                  Text(s.title!,
                      style: GoogleFonts.montserrat(
                          fontSize: 15, fontWeight: FontWeight.w700)),
                ],
                const SizedBox(height: 8),
                Text(s.message,
                    style: GoogleFonts.montserrat(
                        fontSize: 14, height: 1.4)),
                const SizedBox(height: 16),
                Text(StringsAdmin.suggestionStatus,
                    style: GoogleFonts.montserrat(
                        fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  children: StringsSuggestions.statusLabels.entries.map((e) {
                    final selected = s.status == e.key;
                    return ChoiceChip(
                      label: Text(e.value),
                      selected: selected,
                      onSelected: (_) {
                        vm.updateStatus(s, e.key);
                        Navigator.pop(ctx);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: noteCtrl,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: StringsAdmin.suggestionAdminNote,
                    hintText: StringsAdmin.suggestionAdminNoteHint,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              _confirmDelete(context, s);
            },
            child: const Text(StringsAdmin.delete),
          ),
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(StringsAdmin.cancel)),
          FilledButton(
            onPressed: () {
              vm.updateNote(
                  s, noteCtrl.text.trim().isEmpty ? null : noteCtrl.text.trim());
              Navigator.pop(ctx);
            },
            child: const Text(StringsAdmin.saveNote),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, AdminSuggestion s) {
    showDialog(
      context: context,
      // Pop with the dialog's own ctx: this screen lives inside the admin
      // ShellRoute navigator, but showDialog pushes onto the root navigator.
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.surface,
        title: Text(StringsAdmin.confirmDeleteTitle,
            style: GoogleFonts.montserrat(fontWeight: FontWeight.bold)),
        content: Text(StringsAdmin.confirmDeleteMessage,
            style: GoogleFonts.montserrat()),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(StringsAdmin.cancel)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              vm.delete(s.id);
            },
            child: const Text(StringsAdmin.delete),
          ),
        ],
      ),
    );
  }
}
