import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'test_helpers/firebase_test_setup.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  setUp(() async {
    await FirebaseTestSetup.initialize();
  });
  
  await testMain();
}