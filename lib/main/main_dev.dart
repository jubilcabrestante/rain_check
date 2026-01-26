import 'package:rain_check/firebase_options.dart';
import 'package:rain_check/main.dart';

void main() async {
  // TalkerService.talker.debug("DEV");

  await firebaseMain(DefaultFirebaseOptions.currentPlatform);
}
