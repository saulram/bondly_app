import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/profile/domain/models/account_statement_model.dart';
import 'package:bondly_app/features/profile/ui/viewmodels/account_statement_viewmodel.dart';
import 'package:bondly_app/ui/shared/app_sliver_layout.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthlyBalanceScreen extends StatelessWidget {
  static const String route = "/monthlyBalanceScreen";

  const MonthlyBalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModelProvider<AccountStatementViewModel>(
      model: getIt<AccountStatementViewModel>(),
      child: ModelBuilder<AccountStatementViewModel>(
          builder: (context, model, child) {
        return BondlySliverLayout(
          title: "Estado de cuenta",
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _buildTransactionsHeader(context),
                const SizedBox(
                  height: 15,
                ),
                model.busy
                    ? const Center(
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : Expanded(
                        child: Column(
                          children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(),
                                  Text(
                                    "Saldo actual: ${model.accountStatement.balance}",
                                    textAlign: TextAlign.start,
                                  ),
                                  Text(
                                      "Movimientos del mes: ${model.accountStatement.transactions?.length}"),
                                  Text(
                                      "Ultima actualización: ${formatDate(model.accountStatement.updatedAt.toString())}")
                                ]),
                            const SizedBox(
                              height: 15,
                            ),
                            _buildTransactionsList(context, model),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTransactionsList(
      BuildContext context, AccountStatementViewModel model) {
    return Expanded(
      child: ListView.builder(
        itemCount: model.accountStatement.transactions?.length ?? 0,
        itemBuilder: (context, index) {
          return _buildTransactionItem(
              context, model.accountStatement.transactions![index]);
        },
      ),
    );
  }

  Widget _buildTransactionItem(BuildContext context, Transaction transaction) {
    bool isPositive = transaction.amount! > 0;
    return ListTile(
      leading: Icon(
        !isPositive
            ? IconsaxOutline.arrow_circle_up
            : IconsaxOutline.arrow_circle_down,
        color: isPositive ? AppColors.tertiaryColor : AppColors.secondaryColor,
      ),
      title: Text(
        transaction.name ?? "",
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      subtitle: Text(
        formatDate(transaction.date.toString()),
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: Text(
        transaction.amount.toString(),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isPositive
                ? AppColors.tertiaryColor
                : AppColors.secondaryColor),
      ),
    );
  }

  String formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    DateFormat formatter = DateFormat('MM/dd/yyyy hh:mm');
    return formatter.format(parsedDate);
  }

  Widget _buildTransactionsHeader(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 4,
          child: Text(
            "Historial de transacciones",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Flexible(
          flex: 3,
          child: Chip(
            label: Text(
              getFirstAndLastDayOfMonth(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  String getFirstAndLastDayOfMonth() {
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    String formattedFirstDay =
        "${firstDayOfMonth.day}/${firstDayOfMonth.month}/${firstDayOfMonth.year}";
    String formattedLastDay =
        "${lastDayOfMonth.day}/${lastDayOfMonth.month}/${lastDayOfMonth.year}";

    return "$formattedFirstDay - $formattedLastDay";
  }
}
