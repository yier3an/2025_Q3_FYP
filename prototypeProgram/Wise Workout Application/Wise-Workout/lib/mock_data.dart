
import 'services/auth_service_mock.dart';

class FeedPost {
  final String author;
  final String timeAgo;
  final String text;
  final int likes;
  final int comments;
  FeedPost(this.author, this.timeAgo, this.text, this.likes, this.comments);
}

class Goal {
  final String title;
  final String bold;
  final String trailing;
  Goal(this.title, this.bold, this.trailing);
}

class Exercise {
  final String title;
  final String totalText;
  final String completedText;
  final bool edited;
  Exercise(this.title, this.totalText, this.completedText, {this.edited=false});
}

class MockData {
  static final accounts = <AppUser>[
    AppUser(id: 'u1', email: 'user@demo.com', password: 'password123', displayName: 'Irfaan'),
    AppUser(id: 'u2', email: 'instructor@demo.com', password: 'password123', displayName: 'Coach Kim', tier: 'Premium User'),
    AppUser(id: 'u3', email: 'admin@demo.com', password: 'password123', displayName: 'Admin A', tier: 'Premium User'),
  ];

  static final goals = <Goal>[
    Goal('Run:', '5 KM', 'remaining'),
    Goal('Pullups:', '3 sets of 20', 'remaining'),
    Goal('Sit-ups:', '5 sets of 30', 'remaining'),
  ];

  static final feed = <FeedPost>[
    FeedPost('Daniel', '2 hrs ago', 'I’ve completed my daily goal of 2.4 km run', 6, 18),
    FeedPost('Jane', '2 hrs ago', 'I’ve completed my daily goal of 60 Push-up', 60, 10),
    FeedPost('Amy', '2 hrs ago', 'I’ve completed my daily goal of 2.4 km run', 29, 8),
  ];

  static final exercises = <Exercise>[
    Exercise('Pushups', 'Total: 60', 'Completed: 15'),
    Exercise('Run', 'Total: 2.4 KM', 'Completed: 700 m'),
    Exercise('Situps', 'Total: 5 KM', 'Completed: 700 m'),
  ];

  static void upsertExercise({int? index, required Exercise ex}) {
    if (index == null) {
      exercises.add(ex);
    } else {
      exercises[index] = ex;
    }
  }
}
