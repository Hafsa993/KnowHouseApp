import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

class FirebaseTestSetup {
  static Future<void> initialize() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    
  }
  
  static FakeFirebaseFirestore getFakeFirestore() {
    return FakeFirebaseFirestore();
  }
}