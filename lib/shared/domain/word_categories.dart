import 'dart:math';

enum WordCategory {
  food,
  countries,
  animals,
  movies,
  sports,
  technology,
  professions,
  colors,
}

extension WordCategoryExtension on WordCategory {
  String get displayName {
    switch (this) {
      case WordCategory.food:
        return 'Yemek & İçecek';
      case WordCategory.countries:
        return 'Ülkeler';
      case WordCategory.animals:
        return 'Hayvanlar';
      case WordCategory.movies:
        return 'Film & Dizi';
      case WordCategory.sports:
        return 'Spor';
      case WordCategory.technology:
        return 'Teknoloji';
      case WordCategory.professions:
        return 'Meslekler';
      case WordCategory.colors:
        return 'Renkler';
    }
  }

  List<String> get words {
    switch (this) {
      case WordCategory.food:
        return [
          'Pizza', 'Sushi', 'Burger', 'Pasta', 'Tacos', 'Ice Cream',
          'Chocolate', 'Coffee', 'Wine', 'Cheese', 'Bread', 'Soup',
          'Salad', 'Sandwich', 'Cookies', 'Cake', 'Fruit', 'Vegetables'
        ];
      case WordCategory.countries:
        return [
          'Japan', 'France', 'Brazil', 'Australia', 'Canada', 'Germany',
          'Italy', 'Spain', 'Mexico', 'India', 'China', 'Russia',
          'Egypt', 'Norway', 'Thailand', 'Argentina', 'Morocco', 'Greece'
        ];
      case WordCategory.animals:
        return [
          'Lion', 'Elephant', 'Dolphin', 'Eagle', 'Penguin', 'Tiger',
          'Giraffe', 'Whale', 'Butterfly', 'Octopus', 'Kangaroo', 'Panda',
          'Wolf', 'Bear', 'Monkey', 'Zebra', 'Owl', 'Shark'
        ];
      case WordCategory.movies:
        return [
          'Star Wars', 'Marvel', 'Disney', 'Horror', 'Comedy', 'Action',
          'Romance', 'Thriller', 'Animation', 'Documentary', 'Musical',
          'Adventure', 'Fantasy', 'Drama', 'Sci-Fi', 'Western', 'Mystery', 'Biography'
        ];
      case WordCategory.sports:
        return [
          'Soccer', 'Basketball', 'Tennis', 'Swimming', 'Baseball', 'Golf',
          'Volleyball', 'Rugby', 'Boxing', 'Skiing', 'Cycling', 'Running',
          'Wrestling', 'Surfing', 'Hockey', 'Gymnastics', 'Climbing', 'Dancing'
        ];
      case WordCategory.technology:
        return [
          'Smartphone', 'Computer', 'Internet', 'Robot', 'Drone', 'VR',
          'AI', 'Blockchain', 'Cloud', 'Gaming', 'Social Media', 'Streaming',
          'Cryptocurrency', 'App', 'Website', 'Software', 'Hardware', 'Coding'
        ];
      case WordCategory.professions:
        return [
          'Doctor', 'Teacher', 'Engineer', 'Artist', 'Chef', 'Pilot',
          'Lawyer', 'Nurse', 'Police', 'Firefighter', 'Scientist', 'Musician',
          'Writer', 'Photographer', 'Designer', 'Mechanic', 'Farmer', 'Architect'
        ];
      case WordCategory.colors:
        return [
          'Red', 'Blue', 'Green', 'Yellow', 'Purple', 'Orange',
          'Pink', 'Brown', 'Black', 'White', 'Gray', 'Turquoise',
          'Magenta', 'Cyan', 'Lime', 'Maroon', 'Navy', 'Gold'
        ];
    }
  }

  String getRandomWord() {
    final random = Random();
    final wordList = words;
    return wordList[random.nextInt(wordList.length)];
  }
}