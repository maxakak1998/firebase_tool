import 'dart:io';

import 'package:firedart/firedart.dart';
import 'package:firedart/firestore/firestore_gateway.dart';
import 'package:firedart/firestore/token_authenticator.dart';
import 'package:hive/hive.dart';

import 'configurations.dart';

Future<void> main() async {
  Firestore.initialize(Configurations.sdpStaging["projectId"]!,
      databaseId: Configurations.sdpStaging["storageBucket"]!);
  final firebaseAuth =
      FirebaseAuth(Configurations.sdpStaging["apiKey"]!, VolatileStore());
  await firebaseAuth.signInAnonymously();
  var auth = TokenAuthenticator.from(firebaseAuth)?.authenticate;

  final fs =
      Firestore(Configurations.sdpStaging["projectId"]!, authenticator: auth);
  //await updateMembershipCollection(fs);
  // await updateAiMeetingRefreshThrottle(fs);
  await updateSDP(fs);
  print("Succeed");
  exit(0);
}

Future<void> updateMembershipCollection(Firestore fs) async {
  await fs.collection("betting").document("membership").update({
    // "bronze": [1],
    // "silver": [2],
    // "gold": [3],
    // "diamond": [4],
    "contents": {
      "1": "Early Access to The Saturday Set\bl"
          "Access members only Pack Chat\bl"
          "[<b><jsonKey=amount_den_dollar>] den dollars (AUD\$[<jsonKey=amount_dollar>]) credited to your account each week [<0xFFFF9901><b><size=22><jsonKey=discount_percentage>% BONUS]\bl"
          "[<b><jsonKey=tickets>] tickets per week to the monthly members draw [<0xFFFF9901><b><size=22>MINIMUM \$10K CASH GIVEN AWAY EACH MONTH!]\bl"
          "Cancel anytime",
      "2": "Early Access to The Saturday Set\bl"
          "Access members only Pack Chat\bl"
          "[<b><jsonKey=amount_den_dollar>] den dollars (AUD\$[<jsonKey=amount_dollar>]) credited to your account each week [<0xFFFF9901><b><size=22><jsonKey=discount_percentage>% BONUS]\bl"
          "[<b><jsonKey=tickets>] tickets per week to the monthly members draw [<0xFFFF9901><b><size=22>MINIMUM \$10K CASH GIVEN AWAY EACH MONTH!]\bl"
          "Cancel anytime",
      "3": "Early Access to The Saturday Set\bl"
          "Access members only Pack Chat\bl"
          "[<b><jsonKey=amount_den_dollar>] den dollars (AUD\$[<jsonKey=amount_dollar>]) credited to your account each week [<0xFFFF9901><b><size=22><jsonKey=discount_percentage>% BONUS]\bl"
          "[<b><jsonKey=tickets>] tickets per week to the monthly members draw [<0xFFFF9901><b><size=22>MINIMUM \$10K CASH GIVEN AWAY EACH MONTH!]\bl"
          "FREE T-shirt from the Wolfden Merch Store\bl"
          "Cancel anytime",
      "4": "[<b>Direct line of communication to the Wolfden team]\bl"
          "[<b>Access to all WolfdenAI form\nIncluding any new form products released during the year.]\bl"
          "[<b>A Day in the Den punting with the team]\bl"
          "[<b>1 piece of Merch from all merch drops in 2024]\bl"
          "[<b><numberFormat=#,###><jsonKey=tickets>] tickets per month to the monthly members draw\n[<0xFF00E786><size=22><b>MINIMUM \$10K GIVEN AWAY EACH MONTH!]",
    },
    "thumbnailContents": {
      "1":
          "[<b><jsonKey=amount_den_dollar>] den dollars [<b>(AUD\$<jsonKey=amount_dollar>)] credited to your account each week [<0xFFFF9901><b><size=16><jsonKey=discount_percentage>% BONUS]\bl"
              "Cancel anytime",
      "2":
          "[<b><jsonKey=amount_den_dollar>] den dollars [<b>(AUD\$<jsonKey=amount_dollar>)] credited to your account each week [<0xFFFF9901><b><size=16><jsonKey=discount_percentage>% BONUS]\bl"
              "Cancel anytime",
      "3":
          "[<b><jsonKey=amount_den_dollar>] den dollars [<b>(AUD\$<jsonKey=amount_dollar>)] credited to your account each week [<0xFFFF9901><b><size=16><jsonKey=discount_percentage>% BONUS]\bl"
              "Cancel anytime",
      "4": "[<b>Direct line of communication to the Wolfden team]\bl"
          "[<b>Access to all WolfdenAI form\nIncluding any new form products released during the year.]"
    }
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

Future<void> userUserGuidelines(Firestore fs) async {
  await fs.collection("user").document("text").update({
    "community_guideline": """
Community guidelines are essential to maintain a safe and respectful environment for people in Pack Chat and on the feed. Below are some general guidelines you might consider following while you experience the feed and Pack Chat.

Respect and Courtesy
• Treat every member with respect.
• Avoid using strong or offensive language. Keep conversations civil and constructive.

Content Restrictions 
• No promotion or distribution of illegal content, including but not limited to drugs, piracy, or explicit materials, no adult or nudity allowed in here
• Avoid spamming the feed or Pack Chat. This includes sending repeated messages, advertisements, or self•promotion, youtube links, audio messages, emojis, or any other chat links in the intention of promoting the other site.

Moderation and Reporting 
• Respect decisions made by moderators. They are here to ensure the feed and Pack Chat remains safe and respectful.

No Impersonation 
• Do not pretend to be someone else, including other chat room members or moderators. 
• Creating multiple accounts to deceive or disrupt the community will be grounds for a ban.

Stay on Topic 
• Pack Chat has two topics, Racing and Sports, please stick to it. 

Promotion and Advertising 
• Do not promote products, services, or other websites unless it's relevant to the conversation and permitted by the feed or Pack Chat.
• Unsolicited promotions or repeated advertisements will be viewed as spam.

Be Mindful of the Platform 
• While some discussions can be intense or emotional, remember that everyone is here to connect and communicate. Approach discussions with an open mind and be ready to agree to disagree.
      """
  });
}
