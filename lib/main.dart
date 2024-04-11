import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Streaming App UI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Suchfunktion
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // Nutzerprofil
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Suchleiste
            const TextField(
              decoration: InputDecoration(
                labelText: 'Suche nach Filmen, Serien, Genres etc.',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            // Kategorien-Tabs
            /*const TabBar(
              tabs: [
                Tab(text: 'Alle'),
                Tab(text: 'Filme'),
                Tab(text: 'Serien'),
              ],
            ),*/
            // Film Listenansichten
            CategorySection(title: 'Deine Watchlist'),
            CategorySection(title: 'Für dich Empfohlen'),
            CategorySection(title: 'Von Freunden Empfohlen'),
            // Weitere Listen ...
          ],
        ),
      ),
    );
  }
}

class CategorySection extends StatelessWidget {
  final String title;

  CategorySection({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10, // Hier die Anzahl der Elemente eintragen
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 120,
                  color: Colors.grey, // Hier würde das Bild des Films oder der Serie stehen
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}


