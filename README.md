# manage-applications

# 🗂️ Flutter Manage Applications

Un'applicazione desktop sviluppata in Flutter per gestire e tenere traccia delle candidature di lavoro.

## ✨ Funzionalità principali

- Aggiunta e modifica delle candidature
- Stato dell'invio (candidato, in attesa, ecc.)
- Note personalizzate
- Gestione delle aziende
  - Visualizzazione delle aziende registrate
  - Collegamento delle candidature a una specifica azienda
  - Dettaglio delle candidature per ciascuna azienda

## ⚙️ Tecnologie usate

- [Flutter](https://flutter.dev)
- Dart
- SQLite

---

## 🖥️ Requisiti

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- Un editor come **VS Code** o **Android Studio**
- Un sistema operativo supportato:
  - Windows
  - macOS
  - Linux

---

## 🚀 Come avviare il progetto

### 1. Clona il repository

```bash
git clone https://github.com/tuo-username/manage_applications.git
cd manage_applications
```

### 2. Abilita il supporto desktop 

```bash
flutter config --enable-windows-desktop
flutter config --enable-macos-desktop
flutter config --enable-linux-desktop
```

### 3. Installa le dipendenze

```bash
flutter pub get
```

### 4. Avvia il progetto

```bash
flutter run -d windows   # oppure -d macos o -d linux a seconda del tuo sistema
```
