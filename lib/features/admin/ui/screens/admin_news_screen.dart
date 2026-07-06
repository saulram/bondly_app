import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/strings_admin.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/admin/domain/models/admin_module.dart';
import 'package:bondly_app/features/admin/domain/models/admin_news.dart';
import 'package:bondly_app/features/admin/ui/viewmodels/admin_news_viewmodel.dart';
import 'package:bondly_app/features/admin/ui/widgets/admin_empty_state.dart';
import 'package:bondly_app/features/admin/ui/widgets/admin_permission_guard.dart';
import 'package:bondly_app/features/admin/ui/widgets/admin_status_badge.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AdminNewsScreen extends StatefulWidget {
  static const String route = '/admin/news';

  const AdminNewsScreen({super.key});

  @override
  State<AdminNewsScreen> createState() => _AdminNewsScreenState();
}

class _AdminNewsScreenState extends State<AdminNewsScreen> {
  late AdminNewsViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = getIt<AdminNewsViewModel>();
    _vm.load();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;

    return AdminPermissionGuard(
      module: AdminModule.manageBanners,
      child: ModelProvider<AdminNewsViewModel>(
        model: _vm,
        child: ModelBuilder<AdminNewsViewModel>(
          builder: (context, vm, _) => Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      StringsAdmin.newsTitle,
                      style: GoogleFonts.montserrat(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    FilledButton.icon(
                      onPressed: () => _showNewsDialog(context, vm, colors),
                      icon: const Icon(LucideIcons.plus, size: 16),
                      label: const Text(StringsAdmin.addNews),
                    ),
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
                              onCta: vm.load)
                          : vm.news.isEmpty
                              ? AdminEmptyState(
                                  icon: LucideIcons.newspaper,
                                  message: StringsAdmin.noNewsFound,
                                  ctaLabel: StringsAdmin.addNews,
                                  onCta: () => _showNewsDialog(
                                      context, vm, colors))
                              : _NewsList(
                                  vm: vm,
                                  colors: colors,
                                  onEdit: (n) => _showNewsDialog(
                                      context, vm, colors,
                                      item: n)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showNewsDialog(
      BuildContext context, AdminNewsViewModel vm, BondlyColorScheme colors,
      {AdminNews? item}) {
    final titleCtrl = TextEditingController(text: item?.title);
    final contentCtrl = TextEditingController(text: item?.content);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.surface,
        title: Text(
          item == null ? StringsAdmin.addNews : StringsAdmin.editNews,
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: (MediaQuery.of(context).size.width - 32).clamp(0.0, 500.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: InputDecoration(
                    labelText: StringsAdmin.newsArticleTitle,
                    border: const OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: contentCtrl,
                maxLines: 6,
                decoration: InputDecoration(
                    labelText: StringsAdmin.newsContent,
                    border: const OutlineInputBorder()),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(StringsAdmin.cancel)),
          FilledButton(
            onPressed: () async {
              if (titleCtrl.text.isEmpty) return;
              bool ok;
              if (item == null) {
                ok = await vm.createNews(
                  title: titleCtrl.text,
                  content: contentCtrl.text.isEmpty ? null : contentCtrl.text,
                );
              } else {
                ok = await vm.updateNews(
                  newsId: item.id,
                  title: titleCtrl.text,
                  content: contentCtrl.text.isEmpty ? null : contentCtrl.text,
                );
              }
              if (ok && ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text(StringsAdmin.save),
          ),
        ],
      ),
    );
  }
}

class _NewsList extends StatelessWidget {
  final AdminNewsViewModel vm;
  final BondlyColorScheme colors;
  final ValueChanged<AdminNews> onEdit;

  const _NewsList(
      {required this.vm, required this.colors, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: vm.news.length,
      separatorBuilder: (_, __) => Divider(height: 1, color: colors.border),
      itemBuilder: (ctx, i) {
        final n = vm.news[i];
        return ListTile(
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colors.surfaceElevated,
              borderRadius: BorderRadius.circular(8),
            ),
            child: n.image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(n.image!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                            LucideIcons.newspaper,
                            color: colors.textMuted)))
                : Icon(LucideIcons.newspaper, color: colors.textMuted, size: 20),
          ),
          title: Text(
            n.title ?? '(Sin título)',
            style: GoogleFonts.montserrat(
                fontSize: 14, fontWeight: FontWeight.w600),
          ),
          subtitle: n.createdAt != null
              ? Text(
                  DateFormat('dd MMM yyyy', 'es').format(n.createdAt!),
                  style: GoogleFonts.montserrat(
                      fontSize: 12, color: colors.textMuted),
                )
              : null,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AdminStatusBadge(
                status: !n.hidden
                    ? AdminStatusType.active
                    : AdminStatusType.inactive,
                customLabel: n.hidden ? 'Oculta' : 'Visible',
              ),
              const SizedBox(width: 4),
              IconButton(
                icon: Icon(LucideIcons.pencil,
                    size: 16, color: colors.textMuted),
                onPressed: () => onEdit(n),
              ),
              IconButton(
                icon: Icon(
                    n.hidden ? LucideIcons.eye : LucideIcons.eyeOff,
                    size: 16,
                    color: n.hidden ? Colors.green : Colors.orange),
                tooltip: n.hidden ? 'Mostrar' : 'Ocultar',
                onPressed: () => vm.toggleHidden(n),
              ),
              IconButton(
                icon: Icon(LucideIcons.trash2,
                    size: 16, color: Colors.red.shade400),
                onPressed: () => _confirmDelete(ctx, n),
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, AdminNews n) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: colors.surface,
        title: Text(StringsAdmin.confirmDeleteTitle,
            style: GoogleFonts.montserrat(fontWeight: FontWeight.bold)),
        content: Text('¿Eliminar "${n.title}"?',
            style: GoogleFonts.montserrat()),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(StringsAdmin.cancel)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              vm.deleteNews(n.id);
            },
            child: const Text(StringsAdmin.delete),
          ),
        ],
      ),
    );
  }
}
