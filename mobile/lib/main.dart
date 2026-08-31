import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saigon_tour_guide/core/api_client.dart';
import 'package:saigon_tour_guide/core/app_theme.dart';
import 'package:saigon_tour_guide/provider/auth_provider.dart';
import 'package:saigon_tour_guide/provider/favorites_provider.dart';
import 'package:saigon_tour_guide/provider/visited_places_provider.dart';
import 'package:saigon_tour_guide/root_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final apiClient = ApiClient();
  final authProvider = AuthProvider(apiClient);

  apiClient.onUnauthorized = authProvider.forceLogout;
  authProvider.restoreSession();

  runApp(MyApp(apiClient: apiClient, authProvider: authProvider));
}

class MyApp extends StatelessWidget {
  final ApiClient apiClient;
  final AuthProvider authProvider;
  const MyApp({super.key, required this.apiClient, required this.authProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiClient>.value(value: apiClient),
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ChangeNotifierProvider<FavoritesProvider>(create: (_) => FavoritesProvider(apiClient)),
        ChangeNotifierProvider<VisitedPlacesProvider>(create: (_)=> VisitedPlacesProvider(apiClient)),
      ],
      child: MaterialApp(
        title: 'Saigon Tour Guide',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const RootScreen(),
      ),
    );
  }
}

