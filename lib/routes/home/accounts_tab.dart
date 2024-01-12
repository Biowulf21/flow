import 'package:flow/entity/account.dart';
import 'package:flow/objectbox.dart';
import 'package:flow/objectbox/objectbox.g.dart';
import 'package:flow/theme/theme.dart';
import 'package:flow/widgets/account_card.dart';
import 'package:flow/widgets/account_card_skeleton.dart';
import 'package:flow/widgets/spinner.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AccountsTab extends StatefulWidget {
  const AccountsTab({super.key});

  @override
  State<AccountsTab> createState() => _AccountsTabState();
}

class _AccountsTabState extends State<AccountsTab> {
  QueryBuilder<Account> qb() =>
      ObjectBox().box<Account>().query().order(Account_.createdDate);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Query<Account>>(
        stream: qb().watch(triggerImmediately: true),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Spinner.center();
          }

          final accounts = snapshot.data!.find();

          return switch (accounts.length) {
            0 => InkWell(
                onTap: () => context.push("/account/new"),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("No accounts huh"),
                      Text(
                        "Click anywhere to create an account",
                        style: context.textTheme.bodySmall?.semi(context),
                      ),
                    ],
                  ),
                ),
              ),
            _ => SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ...accounts.map(
                      (account) => Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: AccountCard(account: account),
                      ),
                    ),
                    AccountCardSkeleton(
                      onTap: () => context.push("/account/new"),
                    ),
                    const SizedBox(height: 16.0),
                    const SizedBox(height: 64.0),
                  ],
                ),
              ),
          };
        });
  }
}
