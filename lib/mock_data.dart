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
  final String bold;     // the part rendered bold (e.g., "5 KM")
  final String trailing; // e.g., "remaining"
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
    FeedPost('Jane',   '2 hrs ago', 'I’ve completed my daily goal of 60 Push-ups', 60, 10),
    FeedPost('Amy',    '2 hrs ago', 'I’ve completed my daily goal of 2.4 km run', 29, 8),
    FeedPost('Daniel', '2 hrs ago', 'I’ve completed my daily goal of 100 pushups', 45, 12),
  ];

  static final ongoing = <Exercise>[
    Exercise('Pushup', 'Total: 60', 'Completed: 15'),
    Exercise('Run', 'Total: 2.4 KM', 'Completed: 700m'),
    Exercise('Situps', 'Total: 5 KM', 'Completed: 700m'),
    Exercise('Dumbbell Seated Lateral Raises', 'Total: 3 sets of 10', 'Completed: 2 sets', edited: true),
  ];

  static final completed = <Exercise>[
    Exercise('Warmup Jog', 'Total: 500 m', 'Completed: 500 m'),
    Exercise('Pullups', 'Total: 3 sets of 10', 'Completed: 3 sets', edited: true),
  ];
}
