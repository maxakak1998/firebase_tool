import 'package:firedart/firedart.dart';
import 'package:firedart/firestore/token_authenticator.dart';
import 'package:hive/hive.dart';

import 'configurations.dart';

Future<void> main() async {
  Firestore.initialize(Configurations.dev["projectId"]!,
      databaseId: Configurations.dev["storageBucket"]!);
  final firebaseAuth =
      FirebaseAuth(Configurations.dev["apiKey"]!, VolatileStore());
  await firebaseAuth.signInAnonymously();
  var auth = TokenAuthenticator.from(firebaseAuth)?.authenticate;

  final membershipPath = await Firestore(
          Configurations.dev["projectId"]!,
          authenticator: auth)
      .collection("betting")
      .document("membership")
      .get();
  print(membershipPath);
}
