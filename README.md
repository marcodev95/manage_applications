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
- Salvataggio e gestione dei colloqui  
  - Associazione dei referenti ai colloqui  
  - Gestione dei follow-up  
  - Storico completo degli eventi legati ai colloqui (rinvii, annullamenti, ecc.)

## ⚙️ Tecnologie usate

- [Flutter](https://flutter.dev)
- Dart
- SQLite
- Riverpod (per la gestione dello stato)

---

## 🖥️ Requisiti

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- Un editor come **VS Code** o **Android Studio**
- Sistema operativo supportato: Windows

---

## 🚀 Come avviare il progetto

### 1. Clona il repository

```bash
git clone https://github.com/marcodev95/manage_applications.git
cd manage_applications
```

### 2. Abilita il supporto desktop 

```bash
flutter config --enable-windows-desktop
```

### 3. Installa le dipendenze

```bash
flutter pub get
```

### 4. Avvia il progetto

```bash
flutter run -d windows
```

## ⚠️ Nota sui dati

I dati presenti nel database sono fittizi e utilizzati solo a scopo dimostrativo.
Non contengono informazioni reali o sensibili.

## 🚧 Prossimi sviluppi
- Migliorare la gestione responsive dell’interfaccia
- Aggiungere notifiche per i follow-up e i colloqui imminenti
- Aggiungere una schermata riepilogativa nella homepage per visualizzare tutti i colloqui del mese corrente
- Altri miglioramenti e bugfix minori sono in corso di sviluppo