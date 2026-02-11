import 'package:flutter/material.dart';
import 'package:iterable_flutter_sdk/iterable_flutter_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'screens/user_screen.dart';
import 'screens/events_screen.dart';
import 'screens/messages_screen.dart';
import 'screens/settings_screen.dart';
import 'utils/iterable_config.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Iterable SDK
  await _initializeIterable();
  
  runApp(const IterableFlutterTigerApp());
}

Future<void> _initializeIterable() async {
  try {
    // Initialize the SDK
    await IterableFlutterSdk.initialize(
      apiKey: IterableAppConfig.apiKey,
      config: IterableConfig(
        autoPushRegistration: true,  // Automatic push token registration
        enableEmbeddedMessaging: true,
        // logLevel removed in iOS SDK 6.6.6 - controlled via native logDelegate
        // logLevel: IterableLogLevel.debug,
      ),
    );
    
    // Set up URL handler for deep links
    IterableFlutterSdk.setUrlHandler((url, context) {
      debugPrint('📱 Deep link received: $url');
      // Handle deep link navigation here
      return true;
    });
    
    // Set up custom action handler
    IterableFlutterSdk.setCustomActionHandler((action, context) {
      debugPrint('⚡ Custom action received: ${action.type}');
      // Handle custom actions here
      return true;
    });
    
    debugPrint('✅ Iterable SDK initialized successfully');
  } catch (e) {
    debugPrint('❌ Error initializing Iterable SDK: $e');
  }
}

class IterableFlutterTigerApp extends StatelessWidget {
  const IterableFlutterTigerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Iterable Flutter Tiger',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppConstants.primaryColor,
          primary: AppConstants.primaryColor,
          secondary: AppConstants.secondaryColor,
        ),
        scaffoldBackgroundColor: AppConstants.backgroundColor,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: AppConstants.primaryColor,
          foregroundColor: Colors.white,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingLarge,
              vertical: AppConstants.paddingMedium,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(AppConstants.paddingMedium),
        ),
        useMaterial3: true,
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = const [
    HomeScreen(),
    UserScreen(),
    EventsScreen(),
    MessagesScreen(),
    SettingsScreen(),
  ];
  
  final List<NavigationDestination> _destinations = const [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outline),
      selectedIcon: Icon(Icons.person),
      label: 'User',
    ),
    NavigationDestination(
      icon: Icon(Icons.event_outlined),
      selectedIcon: Icon(Icons.event),
      label: 'Events',
    ),
    NavigationDestination(
      icon: Icon(Icons.message_outlined),
      selectedIcon: Icon(Icons.message),
      label: 'Messages',
    ),
    NavigationDestination(
      icon: Icon(Icons.settings_outlined),
      selectedIcon: Icon(Icons.settings),
      label: 'Settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: _destinations,
      ),
    );
  }
}
