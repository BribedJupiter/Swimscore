import 'package:flutter/material.dart';

// DEFAULTS

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

// END DEFAULTS

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (useDefaults) {
      eventDataList = defaultEventData;
      teamList = defaultTeamList;
    }
    return MaterialApp(
      title: 'Swimscore',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue
          ),
        ),
      ),
      home: const EventPage(
          title: 'Swimscore'
      ),
    );
  }
}

class EventPage extends StatefulWidget {
  const EventPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<EventPage> createState() => _EventState();
}

class _EventState extends State<EventPage> {
  int _selectedIndex = 0;
  final List<Widget> _children = const [
    EventList(title: "Events"),
    Teams(),
    Settings(),
    Visualizer()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: _children[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt),
            label: 'Teams',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Visualizer',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightBlue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  final settingsTextController = TextEditingController();

  @override
  void dispose() {
    settingsTextController.dispose();
    super.dispose();
  }

  void onClearPressed() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Are you sure?"),
            content: SingleChildScrollView(
              child: ListBody(
                children: const [
                  Text("Are you sure you want to clear scoring data?"),
                  Text("This will delete team placing and scoring data.")
                ],
              ),
              ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator .of(context).pop();
                  },
                  child: const Text("Cancel")
              ),
              TextButton(
                  onPressed: () {
                    clearData();
                    Navigator .of(context).pop();
                  },
                  child: const Text("Yes")
              )
            ],
            );
        }
    );
  }

  void clearData() {
    for (EventData ed in eventDataList) {
      ed.placeTeams = List.filled (8, TeamData('None'), growable: true);
    }
    for (TeamData td in teamList) {
      td.score = 0;
    }
  }

  void onResetData() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Are you sure?"),
            content: SingleChildScrollView(
              child: ListBody(
                children: const [
                  Text("Are you sure you want to reset all data to their defaults?"),
                  Text("This will delete custom teams and events. Scoring data will also be cleared.")
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator .of(context).pop();
                  },
                  child: const Text("Cancel")
              ),
              TextButton(
                  onPressed: () {
                    //clearData();
                    resetData();
                    Navigator .of(context).pop();
                  },
                  child: const Text("Yes")
              )
            ],
          );
        }
    );
  }

  void resetData() {
    print(eventDataList);
    print(defaultEventData);
    eventDataList.clear();
    /*for (EventData ed in defaultEventData) {
      eventDataList.add(ed);
    }*/
    eventDataList = [];
    eventDataList.addAll(defaultEventData);
    print(eventDataList);
    print(teamList);
    print(defaultTeamList);
    teamList.clear();
    /*for (TeamData td in defaultTeamList) {
      teamList.add(td);
    }*/
    teamList = [];
    teamList.addAll(defaultTeamList);
    print(teamList);
    for (EventData ed in eventDataList) {
      ed.placesValues = defaultScoringValues;
    }
  }

  void onEditEvents(int addEditRemove) {

  }

  void onEditTeams(int addEditRemove) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          if (addEditRemove == 1) {
            return AlertDialog(
                title: Text("Add Team", textAlign: TextAlign.center),
                content: TextFormField(
                      controller: settingsTextController,
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Enter a team name'
                      ),
                    ),
                actions: [
                      TextButton(
                          onPressed: () {
                            Navigator .of(context).pop();
                          },
                          child: const Text("Cancel")
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator .of(context).pop();
                            teamList.add(TeamData(settingsTextController.text));
                          },
                          child: const Text("Submit")
                      )
                ]
            );
          }
          else if (addEditRemove == 2) {
            return AlertDialog(
                title: Text("Edit Team", textAlign: TextAlign.center,)
            );
          }
          else {
            return AlertDialog(
                title: Text("Remove Team", textAlign: TextAlign.center,)
            );
          }
        }
    );
  }

  void showCredits() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Credits", textAlign: TextAlign.center,),
            content: SingleChildScrollView(
              child: ListBody(
                children: const [
                  Text("This app was made by Jack Bauer, but it is made possible by its users. Thank you!"),
                  Text("If you have any suggestions, please direct them his way.")
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator .of(context).pop();
                  },
                  child: const Text("Thanks!")
              ),
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: ElevatedButton(
                onPressed: onClearPressed,
                child: const Text("Clear Scoring Data")
              )
            ),
          Center(
            child: ElevatedButton(
                onPressed: onResetData,
                child: const Text("Reset Defaults")
            ),
          ),
          const Divider(
            height: 20,
            thickness: 1,
            indent: 100,
            endIndent: 100,
            color: Colors.black,
          ),
            Center(
              child: ElevatedButton(
                  onPressed: () => onEditEvents(1),
                  child: const Text("Add Event")
              ),
            ),
            Center(
              child: ElevatedButton(
                  onPressed: () => onEditEvents(2),
                  child: const Text("Edit Event")
              ),
            ),
            Center(
              child: ElevatedButton(
                  onPressed: () => onEditEvents(3),
                  child: const Text("Remove Event")
              ),
            ),
          const Divider(
            height: 20,
            thickness: 1,
            indent: 100,
            endIndent: 100,
            color: Colors.black,
          ),
            Center(
              child: ElevatedButton(
                  onPressed: () => onEditTeams(1),
                  child: const Text("Add Team")
              ),
            ),
            Center(
              child: ElevatedButton(
                  onPressed: () => onEditTeams(2),
                  child: const Text("Edit Team")
              ),
            ),
            Center(
              child:
                ElevatedButton(
                    onPressed: () => onEditTeams(3),
                    child: const Text("Remove Team")
                ),
            ),
          const Divider(
            height: 20,
            thickness: 1,
            indent: 100,
            endIndent: 100,
            color: Colors.black,
          ),
            Center(
              child: ElevatedButton(
                  onPressed: showCredits,
                  child: const Text("Change Specific Event Scoring Rules")
              ),
            ),
            Center(
              child: ElevatedButton(
                  onPressed: showCredits,
                  child: const Text("Change Default Event Scoring Rules")
              ),
            ),
            Center(
              child: ElevatedButton(
                  onPressed: showCredits,
                  child: const Text("Credits") //TODO: Add dark mode
              ),
            ),
          ],
        ),
    );
  }
}

class Teams extends StatefulWidget {
  const Teams({super.key});

  @override
  State<Teams> createState() => _TeamsState();
}

class _TeamsState extends State<Teams> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(30),
        itemCount: teamList.length,
        itemBuilder: (context, i) {
          return Card(
            color: Colors.blue,
            child: SizedBox(
              width: 60,
              height: 40,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(teamList[i].name + ": ", style: TextStyle(color: Colors.white, fontSize: 24)),
                    Text(teamList[i].score.toString(), style: TextStyle(color: Colors.white, fontSize: 24))
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
}

class Visualizer extends StatefulWidget {
  const Visualizer({super.key});

  @override
  State<Visualizer> createState() => _VisualizerState();
}

class _VisualizerState extends State<Visualizer> {
  @override
  Widget build(BuildContext context) {
    return const Text("Visualizer");
  }
}

class EventList extends StatefulWidget {
  const EventList({super.key, required this.title});

  final String title;

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  // Display the list of events
  int items = eventDataList.length;
  void _eventPressed(int i) {
    currentEventData = eventDataList[i];
    Navigator.push(context, MaterialPageRoute(builder: (context) => const PlaceList()));
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(30),
        itemCount: items,
        itemBuilder: (context, i) {
          return ElevatedButton(
              onPressed: () => _eventPressed(i),
              child: Text(eventDataList[i].distance.toString() + " " + eventDataList[i].name),
          );
        }
    );
  }
}

class PlaceList extends StatefulWidget {
  const PlaceList({super.key});

  @override
  State<PlaceList> createState() => _PlaceListState();
}

class _PlaceListState extends State<PlaceList> {
  // Display the list of places

  void onPlacePressed(int index) {
    // Display the team selector
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            //constraints: BoxConstraints.expand(width: 500, height: 400),
            padding: const EdgeInsets.all(50),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.lightBlue,
            ),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: teamList.length+1,
                itemBuilder: (context, i) {
                  if (i == 0) {
                    return DefaultTextStyle(
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Arial',
                          fontSize: 28,
                        ),
                        child: Text(index.toString(), textAlign: TextAlign.center,),
                    );
                  }
                  else {return ElevatedButton(
                      onPressed: () => onTeamPressed(index, i-1),
                      child: Text(teamList[i-1].name),
                  );}
                }
            ),
          ),
        );
      }
    );
  }

  void onTeamPressed(int placeIndex, int teamIndex) {
    for (TeamData td in teamList) {
      print (td.name);
    }
    print ("Team index: " + teamIndex.toString());
    print ("Place index: " + placeIndex.toString());
    currentEventData.placeTeams[placeIndex-1] = teamList[teamIndex];
    teamList[teamIndex].score += currentEventData.placesValues[placeIndex-1];
    Navigator .of(context, rootNavigator: true).pop();
    setState(() {});
  }

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentEventData.distance.toString() + " " + currentEventData.name),
      ),
      body: Center(
        child: ListView.builder(
          padding: const EdgeInsets.all(30),
          itemCount: currentEventData.places,
          itemBuilder: (context, i) {
            ElevatedButton eb;
            if (currentEventData.placeTeams[i].name == "None") {
              eb = ElevatedButton(
                //This is the list of places
                onPressed: () => onPlacePressed(i + 1),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                child: Text((i + 1).toString() + ": "),
              );
            } else {
              eb = ElevatedButton(
                //This is the list of places
                  onPressed: () => onPlacePressed(i + 1),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: Text((i + 1).toString() + ": " + currentEventData.placeTeams[i].name),
              );
            }
            return eb;
          },
        ),
      ),
    );
  }
}

class EventData {
  // Designed to hold all the data for each individual event, and to be accessible by everything that needs it
  int distance = -1;
  String name = 'none';
  int places = 8;
  bool isRelay = false;
  List<TeamData> placeTeams = List.filled (8, TeamData('None'), growable: true); // The order of the list is the order of the teams that score i.e. Kirkwood, Kirkwood, Webster, Ladue... TODO: Set list length to variable
  List<int> placesValues = defaultScoringValues; // The point value of each placement i.e. 6, 5, 4, 3, 2, 1

  EventData(this.distance, this.name, this.places, this.isRelay);
}

class TeamData {
  // Designed to hold all the data for each individual team
  String name = 'none';
  int score = 0;
  //TODO: Make it so you can pick a color for your team and when you click a place the button turns that color

  TeamData(this.name);
}
