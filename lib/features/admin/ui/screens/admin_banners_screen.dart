import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/dimensions.dart';
import 'package:bondly_app/config/strings_admin.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/admin/domain/models/admin_banner.dart';
import 'package:bondly_app/features/admin/domain/models/admin_module.dart';
import 'package:bondly_app/features/admin/ui/viewmodels/admin_banners_viewmodel.dart';
import 'package:bondly_app/features/admin/ui/widgets/admin_empty_state.dart';
import 'package:bondly_app/features/admin/ui/widgets/admin_permission_guard.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AdminBannersScreen extends StatefulWidget {
  static const String route = '/admin/banners';

  const AdminBannersScreen({super.key});

  @override
  State<AdminBannersScreen> createState() => _AdminBannersScreenState();
}

class _AdminBannersScreenState extends State<AdminBannersScreen> {
  late AdminBannersViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = getIt<AdminBannersViewModel>();
    _vm.load();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;

    return AdminPermissionGuard(
      module: AdminModule.manageBanners,
      child: ModelProvider<AdminBannersViewModel>(
        model: _vm,
        child: ModelBuilder<AdminBannersViewModel>(
          builder: (context, vm, _) => Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      StringsAdmin.bannersTitle,
                      style: GoogleFonts.montserrat(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    FilledButton.icon(
                      onPressed: () =>
                          _showBannerDialog(context, vm, colors),
                      icon: const Icon(LucideIcons.plus, size: 16),
                      label: const Text(StringsAdmin.addBanner),
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
                          : vm.banners.isEmpty
                              ? AdminEmptyState(
                                  icon: LucideIcons.image,
                                  message: StringsAdmin.noBannersFound,
                                  ctaLabel: StringsAdmin.addBanner,
                                  onCta: () => _showBannerDialog(
                                      context, vm, colors))
                              : _BannersGrid(
                                  vm: vm,
                                  colors: colors,
                                  onEdit: (b) => _showBannerDialog(
                                      context, vm, colors,
                                      banner: b)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBannerDialog(BuildContext context, AdminBannersViewModel vm,
      BondlyColorScheme colors,
      {AdminBanner? banner}) {
    final nameCtrl = TextEditingController(text: banner?.name);
    final slugCtrl = TextEditingController(text: banner?.slug);
    final descCtrl = TextEditingController(text: banner?.description);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.surface,
        title: Text(
          banner == null ? StringsAdmin.addBanner : StringsAdmin.editBanner,
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                    labelText: StringsAdmin.bannerName,
                    border: const OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: slugCtrl,
                decoration: InputDecoration(
                    labelText: StringsAdmin.bannerSlug,
                    border: const OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descCtrl,
                maxLines: 2,
                decoration: const InputDecoration(
                    labelText: 'Descripción',
                    border: OutlineInputBorder()),
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
              if (nameCtrl.text.isEmpty) return;
              bool ok;
              if (banner == null) {
                ok = await vm.createBanner(
                  name: nameCtrl.text,
                  slug: slugCtrl.text.isEmpty ? null : slugCtrl.text,
                  description:
                      descCtrl.text.isEmpty ? null : descCtrl.text,
                );
              } else {
                ok = await vm.updateBanner(
                  bannerId: banner.id,
                  name: nameCtrl.text,
                  slug: slugCtrl.text.isEmpty ? null : slugCtrl.text,
                  description:
                      descCtrl.text.isEmpty ? null : descCtrl.text,
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

class _BannersGrid extends StatelessWidget {
  final AdminBannersViewModel vm;
  final BondlyColorScheme colors;
  final ValueChanged<AdminBanner> onEdit;

  const _BannersGrid(
      {required this.vm, required this.colors, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      final cols = constraints.maxWidth > 700 ? 3 : 2;
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: cols,
          mainAxisSpacing: AppDimensions.paddingCard,
          crossAxisSpacing: AppDimensions.paddingCard,
          childAspectRatio: 1.6,
        ),
        itemCount: vm.banners.length,
        itemBuilder: (_, i) =>
            _BannerCard(banner: vm.banners[i], vm: vm, colors: colors, onEdit: onEdit),
      );
    });
  }
}

class _BannerCard extends StatelessWidget {
  final AdminBanner banner;
  final AdminBannersViewModel vm;
  final BondlyColorScheme colors;
  final ValueChanged<AdminBanner> onEdit;

  const _BannerCard(
      {required this.banner,
      required this.vm,
      required this.colors,
      required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppDimensions.radiusCard)),
              child: banner.image != null
                  ? Image.network(
                      banner.image!,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: colors.surfaceElevated,
                        child: Icon(LucideIcons.image,
                            size: 40, color: colors.textMuted),
                      ),
                    )
                  : Container(
                      color: colors.surfaceElevated,
                      child: Icon(LucideIcons.image,
                          size: 40, color: colors.textMuted),
                    ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        banner.name,
                        style: GoogleFonts.montserrat(
                            fontSize: 13, fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (banner.slug != null)
                        Text(
                          banner.slug!,
                          style: GoogleFonts.montserrat(
                              fontSize: 11, color: colors.textMuted),
                        ),
                    ],
                  ),
                ),
                Switch(
                  value: banner.isActive,
                  onChanged: (_) => vm.toggleActive(banner),
                  activeThumbColor: colors.accent,
                ),
                IconButton(
                  icon: Icon(LucideIcons.pencil,
                      size: 16, color: colors.textMuted),
                  onPressed: () => onEdit(banner),
                ),
                IconButton(
                  icon: Icon(LucideIcons.trash2,
                      size: 16, color: Colors.red.shade400),
                  onPressed: () => _confirmDelete(context, banner),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, AdminBanner b) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: colors.surface,
        title: Text(StringsAdmin.confirmDeleteTitle,
            style: GoogleFonts.montserrat(fontWeight: FontWeight.bold)),
        content: Text('¿Eliminar "${b.name}"?',
            style: GoogleFonts.montserrat()),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(StringsAdmin.cancel)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              vm.deleteBanner(b.id);
            },
            child: const Text(StringsAdmin.delete),
          ),
        ],
      ),
    );
  }
}
