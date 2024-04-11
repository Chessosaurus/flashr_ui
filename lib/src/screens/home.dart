import 'package:flutter/material.dart';

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