import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saigon_tour_guide/core/date_formats.dart';
import 'package:saigon_tour_guide/provider/visited_places_provider.dart';
import 'package:saigon_tour_guide/screen/place_detail_screen.dart';

class VisitedPlaceScreen extends StatefulWidget{
  const VisitedPlaceScreen({super.key});
  @override
  State<VisitedPlaceScreen> createState() => _VisitedPlaceScreenState();
}

class _VisitedPlaceScreenState extends State<VisitedPlaceScreen>{
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(mounted) context.read<VisitedPlacesProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đã ghé thăm'),
      ),
      body: Consumer<VisitedPlacesProvider>(
        builder: (context, visited, _){
          if (visited.loading && visited.items.isEmpty){
            return const Center(child: CircularProgressIndicator());
          }
          if(visited.items.isEmpty){
            return ListView(
              children: const [
                SizedBox(height: 120),
                Center(child: Text('Chưa ghé thăm địa điểm nào'))
              ],
            );
          }
          return RefreshIndicator(
            onRefresh: visited.load, 
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: visited.items.length,
              separatorBuilder: (_,__) => const Divider(height: 1),
              itemBuilder: (context, idx){
                final v = visited.items[idx];
                return ListTile(
                  leading: v.place.primaryImage != null 
                  ? CircleAvatar(backgroundImage: NetworkImage(v.place.primaryImage!))
                  : const CircleAvatar(child: Icon(Icons.place)),
                  title: Text(v.place.name),
                  subtitle: Text(v.visitedAt != null ? 'Ghé thăm ${AppDateFormat.display.format(v.visitedAt!)}' : v.place.ward),
                  trailing: IconButton(
                    onPressed: () => context.read<VisitedPlacesProvider>().removeVisited(v.place.id), 
                    icon: Icon(Icons.delete_outline)
                  ),
                  onTap: () => Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (_) => PlaceDetailScreen(placeId: v.place.id))
                  ),
                );
              },
            )
          );
        }
      ),
    );
  }
}