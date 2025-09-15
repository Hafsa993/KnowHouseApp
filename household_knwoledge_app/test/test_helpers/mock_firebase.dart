import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/mockito.dart';

class MockFirebaseApp extends Mock implements FirebaseApp {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

void setupMockFirebase() {
    when(Firebase.initializeApp()).thenAnswer((_) async => MockFirebaseApp());
    when(FirebaseFirestore.instance).thenReturn(MockFirebaseFirestore());
}