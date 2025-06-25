import 'package:favourite_places/RiverPod/add_place.dart';
import 'package:favourite_places/widget/camera_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlaces extends ConsumerStatefulWidget {
  const AddPlaces({super.key});

  @override
  ConsumerState<AddPlaces> createState() => _AddPlacesState();
}

class _AddPlacesState extends ConsumerState<AddPlaces> {
  final _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void addPlace() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    ref.read(userPlacesProvider.notifier).addPlace(_textController.text);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add new place"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _textController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "This field can't be empty";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    label: Text("Add"),
                    hintText: "Add new place",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Cameraring(),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton.icon(
                    onPressed: addPlace,
                    icon: Icon(Icons.add),
                    label: Text("Add place"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
