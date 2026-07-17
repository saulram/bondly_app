import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/dimensions.dart';
import 'package:bondly_app/config/strings_suggestions.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/suggestions/domain/models/suggestion.dart';
import 'package:bondly_app/features/suggestions/ui/viewmodels/suggestions_viewmodel.dart';
import 'package:bondly_app/features/suggestions/ui/widgets/suggestion_status_chip.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SuggestionsScreen extends StatefulWidget {
  static const String route = '/suggestionsScreen';

  const SuggestionsScreen({super.key});

  @override
  State<SuggestionsScreen> createState() => _SuggestionsScreenState();
}

class _SuggestionsScreenState extends State<SuggestionsScreen> {
  late final SuggestionsViewModel _viewModel;
  final _titleCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<SuggestionsViewModel>();
    _viewModel.setUp();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSend(SuggestionsViewModel model) async {
    final message = _messageCtrl.text.trim();
    if (message.isEmpty) {
      _snack(StringsSuggestions.messageRequired);
      return;
    }
    final ok = await model.submit(
      message: message,
      title: _titleCtrl.text.trim().isEmpty ? null : _titleCtrl.text.trim(),
    );
    if (!mounted) return;
    if (ok) {
      _titleCtrl.clear();
      _messageCtrl.clear();
      _snack(StringsSuggestions.sentSuccess);
    } else {
      _snack(StringsSuggestions.sendError);
    }
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return ModelProvider<SuggestionsViewModel>(
      model: _viewModel,
      child: ModelBuilder<SuggestionsViewModel>(
        builder: (context, model, child) {
          final colors = Theme.of(context).extension<BondlyColorScheme>()!;
          return Scaffold(
            backgroundColor: colors.bg,
            body: SafeArea(
              child: Column(
                children: [
                  _buildHeader(colors),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(
                        AppDimensions.paddingScreen,
                        8,
                        AppDimensions.paddingScreen,
                        AppDimensions.paddingScreen,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            StringsSuggestions.screenSubtitle,
                            style: GoogleFonts.montserrat(
                              fontSize: 13,
                              color: colors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildForm(colors, model),
                          const SizedBox(height: 28),
                          _buildMineSection(colors, model),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BondlyColorScheme colors) {
    return SizedBox(
      height: 56,
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: AppDimensions.paddingScreen),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: colors.surfaceElevated,
                  shape: BoxShape.circle,
                ),
                child: Icon(LucideIcons.arrowLeft,
                    size: 18, color: colors.textPrimary),
              ),
            ),
            Text(
              StringsSuggestions.screenTitle,
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(width: 36),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(BondlyColorScheme colors, SuggestionsViewModel model) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingCard),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _titleCtrl,
            decoration: InputDecoration(
              labelText: StringsSuggestions.subjectLabel,
              hintText: StringsSuggestions.subjectHint,
              border: const OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            // `value` stays synced with the model on rebuild (so it resets after
            // submit); `initialValue` would not.
            // ignore: deprecated_member_use
            value: model.category,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: StringsSuggestions.categoryLabel,
              border: const OutlineInputBorder(),
              isDense: true,
            ),
            items: StringsSuggestions.categories
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (v) => model.category = v,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _messageCtrl,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: StringsSuggestions.messageLabel,
              hintText: StringsSuggestions.messageHint,
              border: const OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: model.anonymous,
            onChanged: (v) => model.anonymous = v,
            activeThumbColor: colors.accent,
            title: Text(
              StringsSuggestions.anonymousLabel,
              style: GoogleFonts.montserrat(
                  fontSize: 14, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              StringsSuggestions.anonymousHelp,
              style: GoogleFonts.montserrat(
                  fontSize: 12, color: colors.textMuted),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: model.sending ? null : () => _onSend(model),
              icon: model.sending
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(LucideIcons.send, size: 16),
              label: Text(model.sending
                  ? StringsSuggestions.sending
                  : StringsSuggestions.send),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMineSection(
      BondlyColorScheme colors, SuggestionsViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          StringsSuggestions.mySuggestions,
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        if (model.mine.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              StringsSuggestions.noneYet,
              style: GoogleFonts.montserrat(
                  fontSize: 13, color: colors.textMuted),
            ),
          )
        else
          ...model.mine.map((s) => _SuggestionTile(item: s, colors: colors)),
      ],
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  final Suggestion item;
  final BondlyColorScheme colors;

  const _SuggestionTile({required this.item, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.title?.isNotEmpty == true
                      ? item.title!
                      : item.message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                      fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
              SuggestionStatusChip(status: item.status),
            ],
          ),
          if (item.title?.isNotEmpty == true) ...[
            const SizedBox(height: 4),
            Text(
              item.message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.montserrat(
                  fontSize: 12, color: colors.textSecondary),
            ),
          ],
          const SizedBox(height: 6),
          Row(
            children: [
              if (item.category != null) ...[
                Text(item.category!,
                    style: GoogleFonts.montserrat(
                        fontSize: 11, color: colors.textMuted)),
                const SizedBox(width: 8),
              ],
              if (item.createdAt != null)
                Text(
                  DateFormat('dd MMM yyyy', 'es').format(item.createdAt!),
                  style: GoogleFonts.montserrat(
                      fontSize: 11, color: colors.textMuted),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
