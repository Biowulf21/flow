import 'package:flow/entity/category.dart';
import 'package:flow/l10n/extensions.dart';
import 'package:flow/objectbox.dart';
import 'package:flow/objectbox/objectbox.g.dart';
import 'package:flow/theme/theme.dart';
import 'package:flow/widgets/category_card.dart';
import 'package:flow/widgets/category_card_add.dart';
import 'package:flow/widgets/general/spinner.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  QueryBuilder<Category> qb() =>
      ObjectBox().box<Category>().query().order(Category_.createdDate);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("categories".t(context)),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: qb().watch(triggerImmediately: true),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Spinner.center();
            }

            final categories = snapshot.data!.find();

            return switch (categories.length) {
              0 => InkWell(
                  onTap: () => context.push("/category/new"),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("No categories huh"),
                        Text(
                          "Click anywhere to add a category",
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
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: CategoryCardAdd(
                          onTap: () => context.push("/category/new"),
                        ),
                      ),
                      ...categories.map(
                        (category) => Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: CategoryCard(
                            category: category,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  ),
                ),
            };
          },
        ),
      ),
    );
  }
}
