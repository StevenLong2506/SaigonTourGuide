import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:saigon_tour_guide/core/api_client.dart';
import 'package:saigon_tour_guide/main.dart';
import 'package:saigon_tour_guide/provider/auth_provider.dart';
import 'package:saigon_tour_guide/provider/favorites_provider.dart';
import 'package:saigon_tour_guide/provider/visited_places_provider.dart';

void main() {
  testWidgets('Hiện splash khi phiên đăng nhập chưa khôi phục xong', (
    WidgetTester tester,
  ) async {
    // Không gọi restoreSession() nên AuthProvider.loading vẫn là true —
    // RootScreen phải dừng ở SplashScreen, không chạm tới mạng hay secure
    // storage (2 thứ không có trong môi trường test).
    final apiClient = ApiClient();

    await tester.pumpWidget(
      MyApp(
        apiClient: apiClient,
        authProvider: AuthProvider(apiClient),
        favoritesProvider: FavoritesProvider(apiClient),
        visitedPlacesProvider: VisitedPlacesProvider(apiClient),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
