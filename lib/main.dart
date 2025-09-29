import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:port_karo/firebase_options.dart';
import 'package:port_karo/res/app_constant.dart';
import 'package:port_karo/res/notification_service.dart';
import 'package:port_karo/utils/routes/routes.dart';
import 'package:port_karo/utils/routes/routes_name.dart';
import 'package:port_karo/view_model/add_address_view_model.dart';
import 'package:port_karo/view_model/add_wallet_view_model.dart';
import 'package:port_karo/view_model/address_delete_view_model.dart';
import 'package:port_karo/view_model/address_show_view_model.dart';
import 'package:port_karo/view_model/goods_type_view_model.dart';
import 'package:port_karo/view_model/help_and_support_view_model.dart';
import 'package:port_karo/view_model/login_view_model.dart';
import 'package:port_karo/view_model/on_boarding_view_model.dart';
import 'package:port_karo/view_model/order_view_model.dart';
import 'package:port_karo/view_model/port_banner_view_model.dart';
import 'package:port_karo/view_model/privacy_policy_view_model.dart';
import 'package:port_karo/view_model/profile_update_view_model.dart';
import 'package:port_karo/view_model/profile_view_model.dart';
import 'package:port_karo/view_model/register_view_model.dart';
import 'package:port_karo/view_model/select_vehicles_view_model.dart';
import 'package:port_karo/view_model/service_type_view_model.dart';
import 'package:port_karo/view_model/terms_and_condition_view_model.dart';
import 'package:port_karo/view_model/user_history_view_model.dart';
import 'package:port_karo/view_model/wallet_history_view_model.dart';
import 'package:provider/provider.dart';

String? fcmToken;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  // 🔹 Get FCM Token
  fcmToken = await FirebaseMessaging.instance.getToken();
  if (kDebugMode) {
    print("✅ FCM Token: $fcmToken");
  }

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //

  runApp(const MyApp());
}

double screenHeight = 0.0;
double screenWidth = 0.0;
double topPadding = 0.0;
double bottomPadding = 0.0;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final notificationService = NotificationService(navigatorKey: navigatorKey);

  @override
  void initState() {
    super.initState();
    notificationService.requestedNotificationPermission();
    notificationService.firebaseInit(context);
    notificationService.setupInteractMassage(context);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    topPadding = MediaQuery.of(context).padding.top;
    bottomPadding = MediaQuery.of(context).padding.bottom;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarDividerColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context)=> RegisterViewModel()),
          ChangeNotifierProvider(create: (context)=> ProfileViewModel()),
          ChangeNotifierProvider(create: (context)=> AuthViewModel()),
          ChangeNotifierProvider(create: (context)=> ProfileUpdateViewModel()),
          ChangeNotifierProvider(create: (context)=> OrderViewModel()),
          ChangeNotifierProvider(create: (context)=> SelectVehiclesViewModel()),
          ChangeNotifierProvider(create: (context)=> ServiceTypeViewModel()),
          ChangeNotifierProvider(create: (context)=> AddAddressViewModel()),
          ChangeNotifierProvider(create: (context)=> AddressShowViewModel()),
          ChangeNotifierProvider(create: (context)=> AddressDeleteViewModel()),
          ChangeNotifierProvider(create: (context)=> TermAndConditionViewModel()),
          ChangeNotifierProvider(create: (context)=> PrivacyPolicyViewModel()),
          ChangeNotifierProvider(create: (context)=> HelpAndSupportViewModel()),
          ChangeNotifierProvider(create: (context)=> UserHistoryViewModel()),
          ChangeNotifierProvider(create: (context)=> AddWalletViewModel()),
          ChangeNotifierProvider(create: (context)=> WalletHistoryViewModel()),
          ChangeNotifierProvider(create: (context)=> PortBannerViewModel()),
          ChangeNotifierProvider(create: (context)=> OnBoardingViewModel()),
          ChangeNotifierProvider(create: (context)=> GoodsTypeViewModel()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: RoutesName.splash,
          onGenerateRoute: (settings){
            if (settings.name !=null){
              return MaterialPageRoute(builder: Routers.generateRoute(settings.name!),
              settings: settings,
              );
            }
            return null;
          },
          title: AppConstant.appName,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
         // home: const SplashScreen(),
        ),
      ),
    );
  }
}