library swim_score.classes;

class EventData {
  // Designed to hold all the data for each individual event, and to be accessible by everything that needs it
  int distance = -1;
  String name = 'none';
  int places = 8;
  bool isRelay = false;
  List<TeamData> placeTeams = List.filled (8, TeamData('None'), growable: true); // The order of the list is the order of the teams that score i.e. Kirkwood, Kirkwood, Webster, Ladue... TODO: Set list length to variable
  List<int> placesValues = []; // The point value of each placement i.e. 6, 5, 4, 3, 2, 1

  EventData(this.distance, this.name, this.places, this.isRelay);
}

class TeamData {
  // Designed to hold all the data for each individual team
  String name = 'none';
  int score = 0;
  //TODO: Make it so you can pick a color for your team and when you click a place the button turns that color

  TeamData(this.name);
}
