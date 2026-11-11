import 'package:cloud_firestore/cloud_firestore.dart';

import 'assignment_emulator.dart';

FirebaseFirestore createFirestoreClient() => assignmentEmulatorEnabled
    ? assignmentEmulatorFirestore()
    : FirebaseFirestore.instance;
