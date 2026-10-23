import '../models/campus_event.dart';

final List<CampusEvent> sampleEvents = [
  CampusEvent(
    id: 'e01',
    title: 'Game Programming Workshop',
    category: EventCategory.technology,
    dateTime: DateTime(2026, 11, 3, 9, 30),
    venue: 'Computer Engineering Lab B7',
    description:
        'A hands-on introduction to game programming. Build a small 2D game '
        'step by step: the game loop, sprites, player input and collision '
        'detection. Bring your laptop; mentors will help each table.',
    imagePath: 'assets/images/game_workshop.jpg',
    capacity: 30,
    initialAvailablePlaces: 12,
  ),
  CampusEvent(
    id: 'e02',
    title: 'AI & Computer Vision Talk',
    category: EventCategory.technology,
    dateTime: DateTime(2026, 11, 6, 18, 0),
    venue: 'Main Auditorium',
    description:
        'An evening talk on how machines learn to see: image '
        'classification, object tracking and real-world demos, followed by '
        'a Q&A session with graduate researchers.',
    imagePath: 'assets/images/ai_vision_talk.jpg',
    capacity: 120,
    initialAvailablePlaces: 0,
  ),
  CampusEvent(
    id: 'e03',
    title: 'IEEEXtreme 26',
    category: EventCategory.technology,
    dateTime: DateTime(2026, 11, 25, 21, 0),
    venue: 'Computer Engineering Lab B7',
    description:
        'Join the campus team room for the 24-hour IEEEXtreme programming '
        'competition. Teams of three solve algorithmic problems through the '
        'night. Computers, snacks and coffee are provided.',
    imagePath: 'assets/images/hackathon.jpg',
    capacity: 60,
    initialAvailablePlaces: 1,
  ),
  CampusEvent(
    id: 'e04',
    title: 'Student Jazz Night',
    category: EventCategory.arts,
    dateTime: DateTime(2026, 11, 12, 20, 30),
    venue: 'Culture Center Stage',
    description:
        'The university jazz ensemble and guest student bands perform '
        'classics and original pieces. Doors open thirty minutes before '
        'the show.',
    imagePath: 'assets/images/jazz_night.jpg',
    capacity: 150,
    initialAvailablePlaces: 64,
  ),
  CampusEvent(
    id: 'e05',
    title: 'Campus Bike Race',
    category: EventCategory.sports,
    dateTime: DateTime(2026, 11, 8, 9, 0),
    venue: 'Campus Ring Road - Start at Main Gate',
    description:
        'A 10 km bike race on the closed campus ring road. City and road '
        'bikes race in separate groups. Helmets are required; a few rental '
        'bikes are available at the start line.',
    imagePath: 'assets/images/bike_race.jpg',
    capacity: 80,
    initialAvailablePlaces: 37,
  ),
  CampusEvent(
    id: 'e06',
    title: '3x3 Basketball Tournament',
    category: EventCategory.sports,
    dateTime: DateTime(2026, 11, 15, 13, 0),
    venue: 'Indoor Sports Hall',
    description:
        'Quick 10-minute games in a group stage followed by knockouts. '
        'Register individually and get matched into a team on the day.',
    imagePath: 'assets/images/basketball.jpg',
    capacity: 48,
    initialAvailablePlaces: 6,
  ),
  CampusEvent(
    id: 'e07',
    title: 'Kite Flying Day',
    category: EventCategory.social,
    dateTime: DateTime(2026, 11, 21, 13, 0),
    venue: 'Campus Sports Field',
    description:
        'Build your own kite at the craft table or bring one from home, '
        'then fly it with friends on the open field. Hot drinks are served '
        'and the most creative kite wins a small prize.',
    imagePath: 'assets/images/kite_day.jpg',
    capacity: 40,
    initialAvailablePlaces: 22,
  ),
];
