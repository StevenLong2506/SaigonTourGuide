import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saigon_tour_guide/core/api_client.dart';
import 'package:saigon_tour_guide/provider/favorites_provider.dart';
import 'package:saigon_tour_guide/screen/place_detail_screen.dart';
import 'package:saigon_tour_guide/widget/place_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<FavoritesProvider>().load();
    });
  }

  Future<void> _toggleFavorite(int placeId) async {
    try {
      await context.read<FavoritesProvider>().toggle(placeId);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getErrorMessage(e))));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yêu thích')),
      body: Consumer<FavoritesProvider>(
        builder: (context, favorites, _) {
          if (favorites.loading && favorites.places.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (favorites.error != null && favorites.places.isEmpty) {
            return ListView(
              children: [
                const SizedBox(height: 120),
                Center(child: Text(favorites.error!)),
              ],
            );
          }
          if (favorites.places.isEmpty) {
            return ListView(
              children: [
                const SizedBox(height: 120),
                Center(child: Text('Chưa có địa điểm nào yêu thích')),
              ],
            );
          }

          return RefreshIndicator(
            onRefresh: favorites.load,
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
              itemCount: favorites.places.length,
              itemBuilder: (context, index) {
                final place = favorites.places[index];
                return Stack(
                  children: [
                    PlaceCard(
                      place: place.toSummary(),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PlaceDetailScreen(placeId: place.id),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: InkWell(
                        onTap: () => _toggleFavorite(place.id),
                        child: const CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.black45,
                          child: Icon(
                            Icons.favorite,
                            size: 16,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
