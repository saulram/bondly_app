import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/strings_admin.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/admin/domain/models/admin_ambassador.dart';
import 'package:bondly_app/features/admin/domain/models/admin_module.dart';
import 'package:bondly_app/features/admin/ui/viewmodels/admin_ambassadors_viewmodel.dart';
import 'package:bondly_app/features/admin/ui/widgets/admin_empty_state.dart';
import 'package:bondly_app/features/admin/ui/widgets/admin_permission_guard.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AdminAmbassadorsScreen extends StatefulWidget {
  static const String route = '/admin/ambassadors';

  const AdminAmbassadorsScreen({super.key});

  @override
  State<AdminAmbassadorsScreen> createState() =>
      _AdminAmbassadorsScreenState();
}

class _AdminAmbassadorsScreenState extends State<AdminAmbassadorsScreen> {
  late AdminAmbassadorsViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = getIt<AdminAmbassadorsViewModel>();
    _vm.load();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;

    return AdminPermissionGuard(
      module: AdminModule.manageAmbassadors,
      child: ModelProvider<AdminAmbassadorsViewModel>(
        model: _vm,
        child: ModelBuilder<AdminAmbassadorsViewModel>(
          builder: (context, vm, _) => Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      StringsAdmin.navAmbassadors,
                      style: GoogleFonts.montserrat(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    OutlinedButton.icon(
                      onPressed: () => _confirmRecalculate(context, vm, colors),
                      icon: const Icon(LucideIcons.refreshCw, size: 16),
                      label:
                          const Text(StringsAdmin.recalculateAmbassadors),
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
                          : vm.ambassadors.isEmpty
                              ? AdminEmptyState(
                                  icon: LucideIcons.star,
                                  message:
                                      StringsAdmin.noAmbassadorsFound,
                                )
                              : _AmbassadorsList(
                                  vm: vm, colors: colors),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmRecalculate(BuildContext context,
      AdminAmbassadorsViewModel vm, BondlyColorScheme colors) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: colors.surface,
        title: Text(
          StringsAdmin.recalculateAmbassadors,
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
        content: Text(
          StringsAdmin.confirmRecalculate,
          style: GoogleFonts.montserrat(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(StringsAdmin.cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              await vm.recalculate();
            },
            child: const Text(StringsAdmin.confirm),
          ),
        ],
      ),
    );
  }
}

class _AmbassadorsList extends StatelessWidget {
  final AdminAmbassadorsViewModel vm;
  final BondlyColorScheme colors;

  const _AmbassadorsList({required this.vm, required this.colors});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: vm.ambassadors.length,
      separatorBuilder: (_, __) => Divider(height: 1, color: colors.border),
      itemBuilder: (ctx, i) {
        final a = vm.ambassadors[i];
        return _AmbassadorTile(ambassador: a, vm: vm, colors: colors);
      },
    );
  }
}

class _AmbassadorTile extends StatelessWidget {
  final AdminAmbassador ambassador;
  final AdminAmbassadorsViewModel vm;
  final BondlyColorScheme colors;

  const _AmbassadorTile(
      {required this.ambassador, required this.vm, required this.colors});

  static final _dateFormat = DateFormat('MMM yyyy', 'es');

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: colors.accentSoft,
        backgroundImage: ambassador.userAvatar != null
            ? CachedNetworkImageProvider(ambassador.userAvatar!)
            : null,
        child: ambassador.userAvatar == null
            ? Text(
                (ambassador.userName?.isNotEmpty == true
                    ? ambassador.userName![0]
                    : '?'),
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold, color: colors.accent),
              )
            : null,
      ),
      title: Text(
        ambassador.userName ?? ambassador.userEmail ?? '—',
        style: GoogleFonts.montserrat(
            fontSize: 14, fontWeight: FontWeight.w600),
      ),
      subtitle: Row(
        children: [
          if (ambassador.badgeImage != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: CachedNetworkImage(
                imageUrl: ambassador.badgeImage!,
                width: 20,
                height: 20,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Icon(LucideIcons.award,
                    size: 16, color: colors.textMuted),
              ),
            )
          else
            Icon(LucideIcons.award, size: 16, color: colors.textMuted),
          const SizedBox(width: 4),
          Text(
            ambassador.badgeName ?? '—',
            style: GoogleFonts.montserrat(
                fontSize: 12, color: colors.textMuted),
          ),
          if (ambassador.date != null) ...[
            const SizedBox(width: 8),
            Text(
              _dateFormat.format(ambassador.date!),
              style: GoogleFonts.montserrat(
                  fontSize: 11, color: colors.textMuted),
            ),
          ],
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            ambassador.visible
                ? StringsAdmin.ambassadorVisible
                : StringsAdmin.ambassadorHidden,
            style: GoogleFonts.montserrat(
              fontSize: 11,
              color: ambassador.visible ? Colors.green : colors.textMuted,
            ),
          ),
          const SizedBox(width: 4),
          Switch(
            value: ambassador.visible,
            onChanged: (_) => vm.toggleVisible(ambassador),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}
