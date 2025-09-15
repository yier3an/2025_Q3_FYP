# Wise Workout – Fitness Professional (Flutter Web Prototype)

This is a **hardcoded** prototype of the Fitness Professional web app based on your WBS and UI mockups.  
No Firebase yet. It includes:

- Login (hardcoded account)
- Dashboard (metrics cards)
- Workout List (create/edit/delete in-memory)
- User Chats (list + simple chat screen)
- Settings (profile form)

## Hardcoded Account
- **Email**: `pro@wiseworkout.app`
- **Password**: `Password123!`

## Run (web)
```bash
flutter pub get
flutter run -d chrome
```

## Routes
- `/` — Login
- `/dash` — Dashboard
- `/workouts` — Workout List
- `/chats` — User Chats
- `/chat` — Chat room
- `/settings` — Settings

Later we can swap the mock services with Firebase (Auth, Firestore, Storage).
