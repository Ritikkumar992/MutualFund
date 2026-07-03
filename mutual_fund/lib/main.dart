import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/storage_service.dart';
import 'core/theme.dart';
import 'features/auth/viewmodels/auth_viewmodel.dart';
import 'features/auth/views/login_screen.dart';
import 'features/schemes/viewmodels/schemes_viewmodel.dart';
import 'features/schemes/views/scheme_list_screen.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'features/schemes/models/scheme_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter(); // initialize hive.
  Hive.registerAdapter(SchemeAdapter());

  final storageService = StorageService();
  final isLoggedIn = await storageService.isLoggedIn();

  runApp(MyApp(
    storageService: storageService,
    initialIsLoggedIn: isLoggedIn,
  ));
}

class MyApp extends StatelessWidget {
  final StorageService storageService;
  final bool initialIsLoggedIn;

  const MyApp({
    super.key,
    required this.storageService,
    required this.initialIsLoggedIn,
  });

  @override
  Widget build(BuildContext context){
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(storageService)..checkLoginStatus(),
        ),
        ChangeNotifierProvider(
          create: (_) => SchemesViewModel(),
        ),
      ],
      child: MaterialApp(
        title: 'Mutual Fund',
        theme: AppTheme.lightTheme,
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        home: initialIsLoggedIn ? const SchemeListScreen() : const LoginScreen(),
      ),
    );
  }
}
