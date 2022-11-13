library swim_score.classes;

import 'classes.dart';

List<EventData> defaultEventData = [
  EventData(200, 'Medley Relay', 8, true),
  EventData(200, 'Free', 8, false),
  EventData(200, 'IM', 8, false),
  EventData(50, 'Free', 8, false),
  EventData(0, 'Diving', 8, false),
  EventData(100, 'Fly', 8, false),
  EventData(100, 'Free', 8, false),
  EventData(500, 'Free', 8, false),
  EventData(200, 'Free Relay', 8, true),
  EventData(100, 'Back', 8, false),
  EventData(100, 'Breast', 8, false),
  EventData(400, 'Free Relay', 8, true)
];
List<TeamData> defaultTeamList = [
  TeamData("Home"),
  TeamData("Away")
];
List<int> defaultScoringValues = [8, 7, 6, 5, 4, 3, 2, 1];
List<EventData> eventDataList = [];
List<TeamData> teamList = [];
bool useDefaults = true;

EventData currentEventData = defaultEventData[0];
