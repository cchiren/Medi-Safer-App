import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:logger/logger.dart';

import 'constants/font_family.dart';
import 'extensions/route_ext.dart';
import 'utils/firebase_utils.dart';
import 'utils/notification_utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseUtils.init();
  await NotificationUtils.init();
  await setPreferredOrientations();
  KakaoSdk.init(
    nativeAppKey: 'd1b04f21384ab915b528a8f3f8b71410',
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: RouteExt.values.first.name,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: FontFamily.pretendard,
        scaffoldBackgroundColor: Colors.white,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
      ],
      locale: const Locale('ko'),
      getPages: RouteExt.pageBuilders,
    );
  }
}

Future<void> setPreferredOrientations() async {
  try {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  } catch (e) {
    Logger().e(e);
  }
}