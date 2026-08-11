import 'dart:async';

import 'package:expenses_tracker/app/app_theme.dart';
import 'package:expenses_tracker/app/expenses_tracker_app.dart';
import 'package:expenses_tracker/features/auth/domain/auth_exceptions.dart';
import 'package:expenses_tracker/features/auth/domain/auth_repository.dart';
import 'package:expenses_tracker/features/auth/domain/auth_user.dart';
import 'package:expenses_tracker/features/auth/presentation/bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('builds the application root', (tester) async {
    final repository = _FakeAuthRepository();
    addTearDown(repository.dispose);
    final bloc = AuthenticationBloc(repository: repository);

    await tester.pumpWidget(ExpensesTrackerApp(authenticationBloc: bloc));
    await tester.pump();
    repository.emit(null);
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.theme, same(AppTheme.light));
  });

  testWidgets('shows a dismissible offline sheet and allows another attempt', (
    tester,
  ) async {
    final repository = _FakeAuthRepository(
      signInError: const AuthNetworkUnavailable(),
    );
    addTearDown(repository.dispose);
    final bloc = AuthenticationBloc(repository: repository);

    await tester.pumpWidget(ExpensesTrackerApp(authenticationBloc: bloc));
    await tester.pump();
    repository.emit(null);
    await tester.pump();

    await tester.tap(find.text('Continue with Google'));
    await tester.pumpAndSettle();

    expect(find.text('No internet connection'), findsOneWidget);
    expect(
      find.text(
        'Check your connection, then use Continue with Google to try again.',
      ),
      findsOneWidget,
    );
    expect(repository.googleSignInCalls, 1);

    await tester.tap(find.text('Got it'));
    await tester.pumpAndSettle();

    expect(find.text('No internet connection'), findsNothing);
    expect(find.text('Continue with Google'), findsOneWidget);

    await tester.tap(find.text('Continue with Google'));
    await tester.pumpAndSettle();

    expect(find.text('No internet connection'), findsOneWidget);
    expect(repository.googleSignInCalls, 2);
  });
}

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.signInError});

  final _controller = StreamController<AuthUser?>.broadcast();
  final Object? signInError;
  int googleSignInCalls = 0;

  @override
  Stream<AuthUser?> get authStateChanges => _controller.stream;

  void emit(AuthUser? user) => _controller.add(user);

  Future<void> dispose() => _controller.close();

  @override
  Future<void> signInWithGoogle() async {
    googleSignInCalls++;
    if (signInError case final error?) {
      throw error;
    }
  }

  @override
  Future<void> signOut() async {}
}
