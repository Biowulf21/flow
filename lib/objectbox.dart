import 'dart:developer';
import 'dart:io';
import 'dart:math' hide log;

import 'package:flow/entity/account.dart';
import 'package:flow/entity/category.dart';
import 'package:flow/entity/icon/parser.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:material_symbols_icons/symbols.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:flow/objectbox/objectbox.g.dart';

class ObjectBox {
  static ObjectBox? _instance;

  /// The Store of this app.
  late final Store store;

  factory ObjectBox() {
    if (_instance == null) {
      throw Exception(
        "You must initialize ObjectBox by calling initialize().",
      );
    }

    return _instance!;
  }

  Box<T> box<T>() => store.box<T>();

  ObjectBox._internal(this.store);

  static Future<String> _databaseDirectory() async {
    final appDataDir = await getApplicationSupportDirectory();

    return p.join(appDataDir.path, kDebugMode ? "__debug" : null);
  }

  static Future<ObjectBox> initialize() async {
    final store = await openStore(directory: await _databaseDirectory());

    log("Admin.isAvailable(): ${Admin.isAvailable()}");

    if (kDebugMode && Admin.isAvailable()) {
      log("[Flow] Admin.isAvailable(): ${Admin.isAvailable()}");
      Admin(store);
    }

    return _instance = ObjectBox._internal(store);
  }

  Future<void> populateDummyData() async {
    final firstAccount =
        box<Account>().query(Account_.name.equals("Alpha")).build().findFirst();

    if (firstAccount != null) {
      await addDummyData();
      return;
    }

    await _createAndPutDebugData();
  }

  Future<void> _createAndPutDebugData() async {
    Category categoryServices = Category(
      iconCode: IconCode.fromMaterialSymbols(Symbols.electrical_services),
      name: "Online subscriptions",
    );
    Category categoryPaychecks = Category(
      iconCode: IconCode.fromMaterialSymbols(Symbols.payments_rounded),
      name: "Paycheck",
    );
    Category categoryEducation = Category(
      iconCode: IconCode.fromMaterialSymbols(Symbols.school_rounded),
      name: "Education",
    );
    Category categoryShopping = Category(
      iconCode: IconCode.fromMaterialSymbols(Symbols.shopping_bag_rounded),
      name: "Shopping",
    );
    Category categoryEatOut = Category(
      iconCode: IconCode.fromMaterialSymbols(Symbols.restaurant_rounded),
      name: "Eating out",
    );
    Category categoryBeverages = Category(
      iconCode: IconCode.fromMaterialSymbols(Symbols.coffee_rounded),
      name: "Coffee & tea",
    );

    box<Category>().putMany([
      categoryServices,
      categoryPaychecks,
      categoryEducation,
      categoryShopping,
      categoryEatOut,
      categoryBeverages,
    ]);

    Account accountAlpha = Account(
      name: "Alpha",
      currency: "MNT",
      iconCode: IconCode.fromMaterialSymbols(Symbols.variables_rounded),
    )
      ..updateBalance(
        384500,
        title: "Balance Nov 2023",
      )
      ..createTransaction(
        amount: -5241,
        title: "iCould",
        category: categoryServices,
        transactionDate: DateTime.now() - const Duration(days: 7),
      )
      ..createTransaction(
        amount: -27500,
        title: "Netflix",
        category: categoryServices,
        transactionDate: DateTime.now() - const Duration(days: 4),
      )
      ..createTransaction(
        amount: 20000,
        title: "Translation work pay",
        category: categoryPaychecks,
        transactionDate: DateTime.now() - const Duration(days: 4),
      );

    Account accountBeta = Account(
      name: "Beta",
      currency: "MNT",
      iconCode: IconCode.fromMaterialSymbols(Symbols.bento_rounded),
    )
      ..updateBalance(36850000, title: "Savings starting balance")
      ..createTransaction(
        amount: -3875000,
        title: "Tuition for Fall",
        category: categoryEducation,
        transactionDate: DateTime.now() - const Duration(days: 21),
      )
      ..createTransaction(
        amount: -12690000,
        title: "Macbook pro",
        category: categoryShopping,
        transactionDate: DateTime.now() - const Duration(days: 21),
      )
      ..createTransaction(
        amount: 512000,
        title: "Salary portion",
        category: categoryPaychecks,
        transactionDate: DateTime.now() - const Duration(days: 21),
      );

    await box<Account>().putManyAsync([accountAlpha, accountBeta]);
  }

  Future<void> addDummyData() async {
    Account account = await box<Account>()
        .getAllAsync()
        .then((value) => value[Random().nextInt(value.length)]);

    Category category = await box<Category>()
        .getAllAsync()
        .then((value) => value[Random().nextInt(value.length)]);

    final ({double min, double max, double multiplier}) randomVal =
        switch (category.name) {
      "Online subscriptions" => (min: 4.0, max: 12.0, multiplier: -3500.0),
      "Paycheck" => (min: 30.0, max: 1500.0, multiplier: 3500.0),
      "Education" => (min: 25.0, max: 75.0, multiplier: -3500.0),
      "Shopping" => (min: 8.0, max: 100.0, multiplier: -3500.0),
      "Eating out" => (min: 8.0, max: 128.0, multiplier: -3500.0),
      "Coffee & tea" => (min: 6.0, max: 20.0, multiplier: -3500.0),
      _ => (min: 4.0, max: 100.0, multiplier: -3500.0),
    };

    account.createTransaction(
      amount: (Random().nextDouble() * (randomVal.max - randomVal.min) +
              randomVal.min) *
          randomVal.multiplier,
      category: category,
      title: "R_${[
        "turkey",
        "rock",
        "end",
        "hydrant",
        "stove",
        "act",
        "laugh",
        "team",
        "zebra",
        "rose",
        "nose",
        "friends",
        "channel",
        "tree",
        "root",
        "increase",
        "trousers",
        "school",
        "tin",
        "egg",
        "fact",
        "cherry",
        "laborer",
        "hall",
        "chance",
        "addition",
        "request",
        "wrist",
        "pipe",
        "war",
        "size",
        "rice",
        "stem",
        "toad",
        "twig",
        "event",
        "silver",
        "rings",
        "grass",
        "development",
        "hill",
        "pickle",
        "carpenter",
        "view",
        "cave",
        "test",
        "hose",
        "education",
        "worm",
        "trouble",
        "cap",
        "quilt",
        "lumber",
        "baby",
        "hour",
        "sack",
        "quiet",
        "chin",
        "thread",
        "servant",
        "animal",
        "song",
        "babies",
        "walk",
        "woman",
        "gold",
        "soap",
        "lake",
        "spot",
        "example",
        "rest",
        "glass",
        "minute",
        "hand",
        "thrill",
        "reason",
        "pocket",
        "thumb",
        "road",
        "ticket",
        "lock",
        "magic",
        "collar",
        "middle",
        "grandmother",
        "nerve",
        "passenger",
        "basketball",
        "bridge",
        "veil",
        "bikes",
        "friend",
        "hope",
        "coal",
        "duck",
        "edge",
        "flame",
        "page",
        "grape",
        "smoke"
      ][Random().nextInt(100)]}",
    );
  }

  Future<void> wipeDatabase() async {
    store.close();
    final dir = await _databaseDirectory();
    await Directory(dir).delete(recursive: true);

    _instance = null;
    await ObjectBox.initialize();
  }
}
