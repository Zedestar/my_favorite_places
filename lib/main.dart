import 'package:favourite_places/RiverPod/add_place.dart';
import 'package:favourite_places/pages/add_places.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'My favourite place'),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final placesList = ref.watch(userPlacesProvider);
    final stream = ref.read(userPlacesProvider.notifier).app;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: StreamBuilder(
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final places = snapshot.data ?? [];
            return ListView.builder(
              itemCount: places.length,
              itemBuilder: (context, index) {
                final place = places[index];
                return ListTile(
                  title: Text(place.name),
                  subtitle: Text(place.address),
                  leading: CircleAvatar(
                    backgroundImage: FileImage(place.imageUrl.toFilePath()),
                  ),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext context) {
              return AddPlaces();
            }),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}


          //  ListView.builder(
          //   itemCount: placesList.length,
          //   itemBuilder: (contex, index) {
          //     final item = placesList[index];
          //     return Padding(
          //       padding: const EdgeInsets.symmetric(
          //         vertical: 8,
          //       ),
          //       child: InkWell(
          //         onTap: () {
          //           Navigator.of(context).push(
          //             MaterialPageRoute(
          //               builder: (BuildContext context) {
          //                 return PlaceDetailsPage(place: item);
          //               },
          //             ),
          //           );
          //         },
          //         child: ListTile(
          //           leading: CircleAvatar(
          //             radius: 28,
          //             backgroundColor: Colors.grey[200],
          //             child: ClipOval(
          //               child: Image.file(
          //                 item.image,
          //                 width: 56,
          //                 height: 56,
          //                 fit: BoxFit.cover,
          //               ),
          //             ),
          //           ),
          //           title: Text(
          //             item.title,
          //             style: TextStyle(fontSize: 22),
          //           ),
          //           subtitle: Text(item.location?.address ?? ""),
          //         ),
          //       ),
          //     );
          //   },
          // ),