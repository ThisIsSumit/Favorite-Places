import 'package:favorite_places_app/Provider/user_places.dart';
import 'package:favorite_places_app/model/place.dart';
import 'package:favorite_places_app/screens/add_new_places_screen.dart';
import 'package:favorite_places_app/screens/place_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritePlaces extends ConsumerWidget {
  FavoritePlaces({super.key});

  Widget content = const Center(child: Text("no places added yet"));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPlaces = ref.watch(userPlacesProvider);
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  Navigator.of(context).push<Place>(MaterialPageRoute(
                      builder: (context) => const AddNewPlacesScreen()));
                },
                icon: const Icon(Icons.add))
          ],
          title: const Text("Favorite Places"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: userPlaces.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PlaceDetailScreen(place: userPlaces[index])));
                },
                leading: CircleAvatar(
                  radius: 26,
                  backgroundImage: FileImage(userPlaces[index].image),
                ),
                title: Text(
                  userPlaces[index].name,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              );
            },
          ),
        ));
  }
}
