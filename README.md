# flasher_ui

flashr ist eine moderene Cross-Plattform App zum Swipen von Filmen/Serien und sich mit seinen Freunden zu vernetzen.

Dieses Repository beinhaltet die UI der flashr App.

## Getting Started
Die Umgebungsvariablen werden benötigt
Dafür wird der API Key und die URL in folgende Datei geschrieben `assets/.env`.

Installieren der Flutter Dependencies:

```bash
cd flutter
dart pub get
cd ..
```

Ausführen der Flutter der App:

```bash
flutter run
```

## Verwendete Tools

- [Flutter](https://flutter.dev/) - Verwendet für das User Interface der App
- [Supabase](https://supabase.com/) - Dient zur Speicherung von Einbettungen und anderen Filmdaten in der Datenbank
- [TMDB API](https://developer.themoviedb.org/docs) - Dient zum Abrufen von Filmdaten
