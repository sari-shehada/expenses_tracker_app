import 'package:flutter/material.dart';

import 'app/bootstrap.dart';
import 'app/expenses_tracker_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await bootstrap();

  runApp(const ExpensesTrackerApp());
}
