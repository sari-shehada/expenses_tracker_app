import 'dart:async';

import 'package:expenses_tracker/app/expenses_tracker_app.dart';
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
  });
}

class _FakeAuthRepository implements AuthRepository {
  final _controller = StreamController<AuthUser?>.broadcast();

  @override
  Stream<AuthUser?> get authStateChanges => _controller.stream;

  void emit(AuthUser? user) => _controller.add(user);

  Future<void> dispose() => _controller.close();

  @override
  Future<void> signInWithGoogle() async {}

  @override
  Future<void> signOut() async {}
}
