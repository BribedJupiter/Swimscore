import 'package:flutter/material.dart';

var defaultEventData = <EventData>[
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
var defaultTeamList = <TeamData>[
  TeamData("Home"),
  TeamData("Away")
];
List<EventData> eventDataList = [];
List<TeamData> teamList = [];
bool useDefaults = true;

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
      body: const Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: EventList(title: 'Events',),
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

class EventList extends StatefulWidget {
  const EventList({super.key, required this.title});

  final String title;

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  int items = eventDataList.length;
  void _eventPressed() {
    /*setState(() {

    });*/
    Navigator.push(context, MaterialPageRoute(builder: (context) => const PlaceList()));
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(30),
        itemCount: items,
        itemBuilder: (context, i) {
          return ElevatedButton(
              onPressed: _eventPressed,
              child: Text(eventDataList[i].distance.toString() + " " + eventDataList[i].name),
          );
        }
    );
  }
}

class PlaceList extends StatelessWidget {
  const PlaceList({super.key});

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Places'), //TODO: Make it display event and distance data
      ),
      body: Center(
        child: ListView.builder(
          padding: const EdgeInsets.all(30),
          itemCount: 8, //TODO: Make dynamic with events
          itemBuilder: (context, i) {
            return Text("Placeholder");
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
  int places = 0;
  bool isRelay = false;
  List<String> placeTeams = []; // The order of the list is the order of the teams that score i.e. Kirkwood, Kirkwood, Webster, Ladue...
  List<int> placesValues = []; // The point value of each placement i.e. 6, 5, 4, 3, 2, 1

  EventData(this.distance, this.name, this.places, this.isRelay) {
    //placeTeams.length = places;
    //placesValues.length = places;
  }
}

class TeamData {
  // Designed to hold all the data for each individual team
  String name = 'none';
  int score = 0;

  TeamData(this.name);
}