import 'dart:typed_data';

import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/dimensions.dart';
import 'package:bondly_app/config/strings_admin.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/admin/domain/models/admin_banner.dart';
import 'package:bondly_app/features/admin/domain/models/admin_module.dart';
import 'package:bondly_app/features/admin/ui/viewmodels/admin_banners_viewmodel.dart';
import 'package:bondly_app/features/admin/data/validators/banner_image_validator.dart';
import 'package:bondly_app/features/admin/ui/widgets/admin_empty_state.dart';
import 'package:bondly_app/features/admin/ui/widgets/admin_permission_guard.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';

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
                      onPressed: () => _showBannerDialog(context, vm, colors),
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
                                  onCta: () =>
                                      _showBannerDialog(context, vm, colors))
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

  void _showBannerDialog(
      BuildContext context, AdminBannersViewModel vm, BondlyColorScheme colors,
      {AdminBanner? banner}) {
    final nameCtrl = TextEditingController(text: banner?.name);
    final slugCtrl = TextEditingController(text: banner?.slug);
    final descCtrl = TextEditingController(text: banner?.description);
    Uint8List? imageBytes;
    String? imageError;
    var saving = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => PopScope(
          canPop: !saving,
          child: AlertDialog(
            backgroundColor: colors.surface,
            title: Text(
              banner == null ? StringsAdmin.addBanner : StringsAdmin.editBanner,
              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
            ),
            content: SizedBox(
              width: 400,
              child: IgnorePointer(
                ignoring: saving,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: saving
                          ? null
                          : () async {
                              final picked = await ImagePicker()
                                  .pickImage(source: ImageSource.gallery);
                              if (picked == null || !ctx.mounted) return;
                              final bytes = await picked.readAsBytes();
                              if (!ctx.mounted) return;
                              try {
                                BannerImageValidator.validate(bytes);
                                setDialogState(() {
                                  imageBytes = bytes;
                                  imageError = null;
                                });
                              } on FormatException catch (e) {
                                setDialogState(() => imageError = e.message);
                              }
                            },
                      child: AspectRatio(
                        aspectRatio: 2,
                        child: imageBytes != null
                            ? Image.memory(imageBytes!, fit: BoxFit.cover)
                            : (banner?.image != null
                                ? Image.network(banner!.image!,
                                    fit: BoxFit.cover)
                                : DecoratedBox(
                                    decoration: BoxDecoration(
                                        color: colors.surfaceElevated),
                                    child: const Center(
                                        child: Icon(LucideIcons.image)),
                                  )),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Imagen panorámica (recomendado 2:1)',
                            style: TextStyle(
                                color: colors.textMuted, fontSize: 12))),
                    if (imageError != null)
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(imageError!,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 12))),
                    const SizedBox(height: 10),
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
            ),
            actions: [
              TextButton(
                  onPressed: saving ? null : () => Navigator.pop(ctx),
                  child: const Text(StringsAdmin.cancel)),
              FilledButton(
                onPressed: saving
                    ? null
                    : () async {
                        if (nameCtrl.text.isEmpty) return;
                        setDialogState(() => saving = true);
                        bool ok;
                        if (banner == null) {
                          ok = await vm.createBanner(
                            name: nameCtrl.text,
                            slug: slugCtrl.text.isEmpty ? null : slugCtrl.text,
                            description:
                                descCtrl.text.isEmpty ? null : descCtrl.text,
                            imageBytes: imageBytes,
                          );
                        } else {
                          ok = await vm.updateBanner(
                            bannerId: banner.id,
                            name: nameCtrl.text,
                            slug: slugCtrl.text.isEmpty ? null : slugCtrl.text,
                            description:
                                descCtrl.text.isEmpty ? null : descCtrl.text,
                            imageBytes: imageBytes,
                          );
                        }
                        if (!ctx.mounted) return;
                        setDialogState(() => saving = false);
                        if (ok) {
                          Navigator.pop(ctx);
                          return;
                        }
                        final message =
                            vm.error ?? 'No se pudo guardar el banner.';
                        await showDialog<void>(
                          context: ctx,
                          builder: (errorContext) => AlertDialog(
                            title: const Text('No se pudo guardar'),
                            content: Text(message),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(errorContext),
                                child: const Text('Aceptar'),
                              ),
                            ],
                          ),
                        );
                      },
                child: saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text(StringsAdmin.save),
              ),
            ],
          ),
        ),
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
        itemBuilder: (_, i) => _BannerCard(
            banner: vm.banners[i], vm: vm, colors: colors, onEdit: onEdit),
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
        content:
            Text('¿Eliminar "${b.name}"?', style: GoogleFonts.montserrat()),
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
