import 'dart:io';

import 'package:favorite_places_app/Provider/user_places.dart';
import 'package:favorite_places_app/model/place.dart';
import 'package:favorite_places_app/widgets/image_input.dart';
import 'package:favorite_places_app/widgets/location_input.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddNewPlacesScreen extends ConsumerStatefulWidget {
  const AddNewPlacesScreen({super.key});
  static String id = "AddNewPlacesScreen";

  @override
  ConsumerState<AddNewPlacesScreen> createState() => _AddNewPlacesScreenState();
}

class _AddNewPlacesScreenState extends ConsumerState<AddNewPlacesScreen> {
  String? _enteredTitle;
  File? _selectedImage;
  //adding the lag and longitute of hamirpur HP because we dont have accest to google maps
  
  PlaceLocation selectedLocaion =
      PlaceLocation(latitude: 31.6862, longitude: 76.5213, address: 'home');
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  void addNewPlace() {
    if (globalKey.currentState!.validate() || _selectedImage != null) {
      globalKey.currentState!.save();
      ref
          .read(userPlacesProvider.notifier)
          .addPlace(_enteredTitle!, _selectedImage!, selectedLocaion!);

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Add New Places"),
      ),
      body: Form(
        key: globalKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  autocorrect: true,
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  onChanged: (value) => _enteredTitle = value,
                  decoration: const InputDecoration(
                    label: Text("Title"),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length == 1 ||
                        value.trim().length > 50) {
                      return "Must be between 1 to 50";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                ImageInput(
                  onPickImage: (image) => _selectedImage = image,
                ),
                const SizedBox(
                  height: 15,
                ),
                LocationInput(),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: addNewPlace,
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [Icon(Icons.add), Text("Add Place")],
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
