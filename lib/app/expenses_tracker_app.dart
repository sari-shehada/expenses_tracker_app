import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/auth/presentation/bloc/authentication_bloc.dart';
import '../features/auth/presentation/bloc/authentication_event.dart';
import '../features/auth/presentation/pages/authentication_gate.dart';
import 'app_theme.dart';
import 'dependency_injection.dart';

class ExpensesTrackerApp extends StatelessWidget {
  const ExpensesTrackerApp({this.authenticationBloc, super.key});

  final AuthenticationBloc? authenticationBloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          (authenticationBloc ?? serviceLocator<AuthenticationBloc>())
            ..add(const AuthenticationSubscriptionRequested()),
      child: MaterialApp(
        theme: AppTheme.light,
        home: const AuthenticationGate(),
      ),
    );
  }
}
