import 'dart:io';

import 'package:firedart/firedart.dart';
import 'package:firedart/firestore/firestore_gateway.dart';
import 'package:firedart/firestore/token_authenticator.dart';
import 'package:hive/hive.dart';

import 'configurations.dart';

Future<void> main() async {
  Firestore.initialize(Configurations.sdpStaging["projectId"]!,
      databaseId: Configurations.sdpStaging["storageBucket"]!);
  var firebaseAuth =
      FirebaseAuth(Configurations.sdpStaging["apiKey"]!, VolatileStore());
  await firebaseAuth.signInAnonymously();
  var auth = TokenAuthenticator.from(firebaseAuth)?.authenticate;

  var fs =
      Firestore(Configurations.sdpStaging["projectId"]!, authenticator: auth);

  await updateSDP(fs, firebaseAuth, auth);
  // final ids = (await fs.collection("device_id").document("devices").get())
  //     .map["ids"] as Map<String, dynamic>;
  // await Future.wait(ids.entries.map((e) =>
  //     fs.collection("device_id").document("devices").collection("ids").document(
  //         e.key).update(e.value)));

  // await fs
  //     .collection("device_id")
  //     .document("config")
  //     .update({"allowMultipleDevices": false});

  print("Succeed");
  exit(0);
}

Future<void> migrateAiTab(Firestore fs, FirebaseAuth firebaseAuth,
    Future<void>? Function(Map<String, String>, String)? auth) async {
  final aiTab = await fs.collection("betting").document("aiTab").get();

  Firestore.instance.dispose();

  Firestore.initialize(Configurations.wdProd["projectId"]!,
      databaseId: Configurations.wdProd["storageBucket"]!);
  firebaseAuth =
      FirebaseAuth(Configurations.wdProd["apiKey"]!, VolatileStore());
  await firebaseAuth.signInAnonymously();
  auth = TokenAuthenticator.from(firebaseAuth)?.authenticate;

  fs = Firestore(Configurations.wdProd["projectId"]!, authenticator: auth);

  await fs.collection("betting").document("aiTab").update(aiTab.map);
}

Future<void> migrateMembership(Firestore fs, FirebaseAuth firebaseAuth,
    Future<void>? Function(Map<String, String>, String)? auth) async {
  final membership =
      await fs.collection("betting").document("membership").get();
  Firestore.instance.dispose();

  Firestore.initialize(Configurations.prod["projectId"]!,
      databaseId: Configurations.prod["storageBucket"]!);
  firebaseAuth = FirebaseAuth(Configurations.prod["apiKey"]!, VolatileStore());
  await firebaseAuth.signInAnonymously();
  auth = TokenAuthenticator.from(firebaseAuth)?.authenticate;

  fs = Firestore(Configurations.prod["projectId"]!, authenticator: auth);

  await fs.collection("betting").document("membership").update(membership.map);
}

Future<void> updateSDP(Firestore fs, FirebaseAuth firebaseAuth,
    Future<void>? Function(Map<String, String>, String)? auth) async {
  final stagingErrors = await fs.collection("errorMessage").get();
  ;
  print(stagingErrors);

  Firestore.instance.dispose();

  Firestore.initialize(Configurations.sdpProd["projectId"]!,
      databaseId: Configurations.sdpProd["storageBucket"]!);
  firebaseAuth =
      FirebaseAuth(Configurations.sdpProd["apiKey"]!, VolatileStore());
  await firebaseAuth.signInAnonymously();
  auth = TokenAuthenticator.from(firebaseAuth)?.authenticate;

  fs = Firestore(Configurations.sdpProd["projectId"]!, authenticator: auth);
  List<Future> furs = [];
  for (int i = 0; i < stagingErrors.length; i++) {
    final e = stagingErrors[i];
    furs.add(fs.collection("errorMessage").document(e.id).set(e.map));
  }
  await Future.wait(furs);

}

Future<void> updateMembershipCollection(Firestore fs) async {
  await fs.collection("betting").document("membership").update({
    // "bronze": [1],
    // "silver": [2],
    // "gold": [3],
    // "diamond": [4],
    // "contents": {
    //   "1": "Early Access to The Saturday Set\bl"
    //       "Access members only Pack Chat\bl"
    //       "[<b><jsonKey=amount_den_dollar>] den dollars (AUD\$[<jsonKey=amount_dollar>]) credited to your account each week [<0xFFFF9901><b><size=22><jsonKey=discount_percentage>% BONUS]\bl"
    //       "[<b>5] tickets per week to the monthly members draw [<0xFFFF9901><b><size=22>MINIMUM \$10K CASH GIVEN AWAY EACH MONTH!]\bl"
    //       "Cancel anytime",
    //   "2": "Early Access to The Saturday Set\bl"
    //       "Access members only Pack Chat\bl"
    //       "[<b><jsonKey=amount_den_dollar>] den dollars (AUD\$[<jsonKey=amount_dollar>]) credited to your account each week [<0xFFFF9901><b><size=22><jsonKey=discount_percentage>% BONUS]\bl"
    //       "[<b>10] tickets per week to the monthly members draw [<0xFFFF9901><b><size=22>MINIMUM \$10K CASH GIVEN AWAY EACH MONTH!]\bl"
    //       "Cancel anytime",
    //   "3": "Early Access to The Saturday Set\bl"
    //       "Access members only Pack Chat\bl"
    //       "[<b><jsonKey=amount_den_dollar>] den dollars (AUD\$[<jsonKey=amount_dollar>]) credited to your account each week [<0xFFFF9901><b><size=22><jsonKey=discount_percentage>% BONUS]\bl"
    //       "[<b>20] tickets per week to the monthly members draw [<0xFFFF9901><b><size=22>MINIMUM \$10K CASH GIVEN AWAY EACH MONTH!]\bl"
    //       "FREE T-shirt from the Wolfden Merch Store\bl"
    //       "Cancel anytime",
    //   "4": "[<b>Direct line of communication to the Wolfden team]\bl"
    //       "[<b>Access to all WolfdenAI form\nIncluding any new form products released during the year.]\bl"
    //       "[<b>A Day in the Den punting with the team]\bl"
    //       "[<b>1 piece of Merch from all merch drops in 2024]\bl"
    //       "[<b>1,600] tickets per month to the monthly members draw\n[<0xFF00E786><size=22><b>MINIMUM \$10K GIVEN AWAY EACH MONTH!]",
    // }
    // "thumbnailContents": {
    //   "1":
    //       "[<b><jsonKey=amount_den_dollar>] den dollars [<b>(AUD\$<jsonKey=amount_dollar>)] credited to your account each week [<0xFFFF9901><b><size=16><jsonKey=discount_percentage>% BONUS]\bl"
    //       "Cancel anytime",
    //   "2":
    //       "[<b><jsonKey=amount_den_dollar>] den dollars [<b>(AUD\$<jsonKey=amount_dollar>)] credited to your account each week [<0xFFFF9901><b><size=16><jsonKey=discount_percentage>% BONUS]\bl"
    //       "Cancel anytime",
    //   "3":
    //       "[<b><jsonKey=amount_den_dollar>] den dollars [<b>(AUD\$<jsonKey=amount_dollar>)] credited to your account each week [<0xFFFF9901><b><size=16><jsonKey=discount_percentage>% BONUS]\bl"
    //       "Cancel anytime",
    //   "4": "[<b>Direct line of communication to the Wolfden team]\bl"
    //       "[<b>Access to all WolfdenAI form\nIncluding any new form products released during the year.]"
    // }
    // "banners":[
    //   "https://wolfden-dev.s3.ap-southeast-2.amazonaws.com/ai/ai1.png",
    //   "https://wolfden-dev.s3.ap-southeast-2.amazonaws.com/ai/ai2.png",
    //   "https://wolfden-dev.s3.ap-southeast-2.amazonaws.com/ai/ai3.png",
    //   "https://wolfden-dev.s3.ap-southeast-2.amazonaws.com/ai/ai4.png",
    //   "https://wolfden-dev.s3.ap-southeast-2.amazonaws.com/ai/ai5.png",
    // ]
  });
  fs.collection("betting").document("membership");
}

Future<void> updateTabAiCollection(Firestore fs) async {
  // await fs.collection("betting").document("aiTab").update({
  //   // "emptyRaceAvailableAt": {"hour": 12, "minute": 0},
  //   "factorColors": {"1": "0xFF00E786", "-1": "0xFFFF0000"}
  // });
}

Future<void> updateFactors(Firestore fs) async {
  final aiTab = await fs.collection("betting").document("aiTab").get();
  final factors = aiTab["factors"] as Map<String, dynamic>;
  factors.addAll({
    "weightRise": "Weight Rise",
    "oldLegs": "Old Legs",
    "backmarker": "Back Marker",
    "slowTimeRaceLS": "Slow Time Race",
    "harderRace": "Harder Race",
    "lowAiTimeRating": "Low AI Time Rating",
    "goldenBullet": "Golden Bullet",
    "goodRoughie": "Good Roughie",
  });
  await fs.collection("betting").document("aiTab").update({"factors": factors});
}

Future<void> updateAiMeetingRefreshThrottle(Firestore fs) async {
  await fs
      .collection("betting")
      .document("aiTab")
      .update({"refreshThrottle": 5});
}
