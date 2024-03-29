// Flutter and other packages
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as path; //TODO: Causes issues with context no idea why
import 'package:sqflite/sqflite.dart';

// Dart packages
import 'dart:async';

// Custom imports
import 'globals.dart' as g;
import 'classes.dart';

// Start of program
void main() {
  runApp(const MyApp());
}

// Base class
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) { //TODO: Upon first load teams show up twice
    if (g.useDefaults) {
      for (EventData ed in g.defaultEventData) {
        g.eventDataList.add(ed);
      }
      for (TeamData td in g.defaultTeamList) {
        g.teamList.add(td);
      }
      for (EventData ed in g.eventDataList) {
        ed.placesValues = g.defaultScoringValues;
      }
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

// Base screen and App bar
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

// Settings screen
class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  final settingsTextController = TextEditingController();
  final settingsTextControllerTwo = TextEditingController();
  final settingsTextControllerThree = TextEditingController();
  final settingsTextControllerFour = TextEditingController();

  @override
  void dispose() {
    settingsTextController.dispose();
    settingsTextControllerTwo.dispose();
    settingsTextControllerThree.dispose();
    settingsTextControllerFour.dispose();
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
    for (EventData ed in g.eventDataList) {
      ed.placeTeams = List.filled (8, TeamData('None'), growable: true);
    }
    for (TeamData td in g.teamList) {
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
                  Text("Are you sure you want to reset teams and events to their defaults?"),
                  Text("This will delete custom teams and events. This will also delete all scoring data.")
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
    g.eventDataList.clear();
    print (g.eventDataList);
    g.eventDataList.addAll(g.defaultEventData);
    g.teamList.clear();
    print (g.defaultTeamList);
    g.teamList.addAll(g.defaultTeamList);
    for (EventData ed in g.eventDataList) {
      ed.placesValues = g.defaultScoringValues;
    }
    setState(() {

    });
  }

  void onEditEvents(int addEditRemove) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          if (addEditRemove == 1) {
            return AlertDialog(
              title: const Text("Add Event", textAlign: TextAlign.center,),
              content: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: settingsTextController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: "Enter a stroke"
                      ),
                    ),
                    TextFormField(
                      controller: settingsTextControllerTwo,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: "Enter a distance (no units)"
                      ),
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator .of(context).pop();
                    },
                    child: Text("Cancel")
                ),
                TextButton(
                    onPressed: () {
                      bool found = false;
                      for (EventData ed in g.eventDataList) {
                        if ((ed.name.toLowerCase() == settingsTextController.text.toLowerCase()) && (int.parse(settingsTextControllerTwo.text) == ed.distance)) { //TODO: Check for parseint errors
                          found = true;
                        }
                      }
                      if (settingsTextController.text.isNotEmpty && settingsTextControllerTwo.text.isNotEmpty && !found) { //TODO: Check for duplicates
                        g.eventDataList.add(EventData(int.parse(settingsTextControllerTwo.text), settingsTextController.text, 8, false)); //TODO: Implement place & relay
                        Navigator .of(context).pop();
                      } else {
                        Navigator .of(context).pop();
                        wariningAlert("Event add failed. Must enter both a stroke and distance. Duplicates are not allowed.");
                      }
                    },
                    child: Text("Submit")
                ),
              ],
            );
          }
          else if (addEditRemove == 2) {
            return AlertDialog(
              title: const Text("Edit Event", textAlign: TextAlign.center,),
              content: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: settingsTextController,
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: "Enter the stroke to edit"
                      ),
                    ),
                    TextFormField(
                      controller: settingsTextControllerTwo,
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: "Enter the distance to edit (no units)"
                      ),
                    ),
                    TextFormField(
                      controller: settingsTextControllerThree,
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: "Enter the new stroke"
                      ),
                    ),
                    TextFormField(
                      controller: settingsTextControllerFour,
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: "Enter the new distance (no units)"
                      ),
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator .of(context).pop();
                    },
                    child: Text("Cancel")
                ),
                TextButton(
                    onPressed: () {
                      bool found = false;
                      EventData? toChange;
                      for (EventData ed in g.eventDataList) {
                        if ((ed.name.toLowerCase() == settingsTextController.text.toLowerCase()) && (int.parse(settingsTextControllerTwo.text) == ed.distance)) { //TODO: Check for parseint errors
                          found = true;
                          toChange = ed;
                        }
                      }
                      if (settingsTextController.text.isNotEmpty && settingsTextControllerTwo.text.isNotEmpty && settingsTextControllerThree.text.isNotEmpty && settingsTextControllerFour.text.isNotEmpty && found) { //TODO: Check for duplicates
                        toChange?.name = settingsTextControllerThree.text; //TODO: Implement place & relay
                        toChange?.distance = int.parse(settingsTextControllerFour.text); //TODO: Reset defaults keeps edited events
                        Navigator .of(context).pop();
                      } else {
                        Navigator .of(context).pop();
                        wariningAlert("Event add failed. Must enter both a stroke and distance for both the old and new event.");
                      }
                    },
                    child: Text("Submit")
                ),
              ],
            );
          }
          else {
            return AlertDialog(
              title: const Text("Remove Event", textAlign: TextAlign.center,),
              content: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: settingsTextController,
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: "Enter a stroke to remove"
                      ),
                    ),
                    TextFormField(
                      controller: settingsTextControllerTwo,
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: "Enter a distance to remove (no units)"
                      ),
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator .of(context).pop();
                    },
                    child: Text("Cancel")
                ),
                TextButton(
                    onPressed: () {
                      bool found = false;
                      EventData? toRemove;
                      for (EventData ed in g.eventDataList) {
                        if ((ed.name.toLowerCase() == settingsTextController.text.toLowerCase()) && (int.parse(settingsTextControllerTwo.text) == ed.distance)) { //TODO: Check for parseint errors
                          toRemove = ed;
                          found = true;
                        }
                      }
                      if (found) { //TODO: Check for duplicates
                        g.eventDataList.remove(toRemove); //TODO: Implement place & relay
                        Navigator .of(context).pop();
                      } else {
                        Navigator .of(context).pop();
                        wariningAlert("Event remove failed. Must enter both a stroke and distance. ");
                      }
                    },
                    child: Text("Submit")
                ),
              ],
            );
          }
        });
  }

  void wariningAlert(String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(text),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator .of(context).pop();
                  },
                  child: Text("Dismiss", textAlign: TextAlign.center)
              )
            ],
          );
        });
  }

  void onEditTeams(int addEditRemove) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          if (addEditRemove == 1) {
            return AlertDialog(
                title: const Text("Add Team", textAlign: TextAlign.center),
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
                            if (settingsTextController.text.isEmpty) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Error"),
                                      content: Text("Team add failed. Must enter a team name."),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator .of(context).pop();
                                            },
                                            child: Text("Dismiss", textAlign: TextAlign.center)
                                        )
                                      ],
                                    );
                                  });
                            } else {
                              g.teamList.add(TeamData(settingsTextController.text));
                            }
                          },
                          child: const Text("Submit")
                      )
                ]
            );
          }
          else if (addEditRemove == 2) {
            return AlertDialog(
                title: const Text("Edit Team", textAlign: TextAlign.center,),
                content: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    TextFormField(
                      controller: settingsTextController,
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: "Enter the team name you'd like to change"
                      ),
                    ),
                    TextFormField(
                      controller: settingsTextControllerTwo,
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: "Enter the new team name"
                      )
                    )
                  ]
                  )
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator .of(context).pop();
                      },
                      child: Text("Cancel")
                  ),
                  TextButton(
                      onPressed: () {
                        bool worked = false;
                        for (TeamData td in g.teamList) {
                          if (td.name.toLowerCase() == settingsTextController.text.toLowerCase()) {
                            td.name = settingsTextControllerTwo.text;
                            worked = true;
                          }
                        }
                        Navigator .of(context).pop();
                        if (!worked) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    title: Text("Error"),
                                    content: Text("Team name change failed. Could not find team."),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator .of(context).pop();
                                          },
                                          child: Text("Dismiss", textAlign: TextAlign.center)
                                      )
                                    ],
                                );
                              });
                        }
                      },
                      child: Text("Submit")
                  ),
                ],
            );
          }
          else {
            return AlertDialog(
                title: Text("Remove Team", textAlign: TextAlign.center,),
                content: TextFormField(
                  controller: settingsTextController,
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: "Enter the team to remove"
                    )
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
                      bool found = false;
                      TeamData? toRemove;
                      for (TeamData td in g.teamList) {
                        if (td.name.toLowerCase() == settingsTextController.text.toLowerCase()) {
                          toRemove = td;
                          found = true;
                        }
                      }
                      g.teamList.remove(toRemove);
                      Navigator .of(context).pop();
                      if (!found) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Error"),
                                content: Text("Team removal failed. Could not find team."),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator .of(context).pop();
                                      },
                                      child: Text("Dismiss", textAlign: TextAlign.center)
                                  )
                                ],
                              );
                            });
                      }
                    },
                    child: const Text("Submit")
                )
              ],
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

// Team screen TODO: Rename to score screen?
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
        itemCount: g.teamList.length,
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
                    Text(g.teamList[i].name + ": ", style: TextStyle(color: Colors.white, fontSize: 24)),
                    Text(g.teamList[i].score.toString(), style: TextStyle(color: Colors.white, fontSize: 24))
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
}

// Visualizer screen
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

// Event screen
class EventList extends StatefulWidget {
  const EventList({super.key, required this.title});

  final String title;

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  // Display the list of events
  int items = g.eventDataList.length;
  void _eventPressed(int i) {
    g.currentEventData = g.eventDataList[i];
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
              child: Text(g.eventDataList[i].distance.toString() + " " + g.eventDataList[i].name),
          );
        }
    );
  }
}

// Places sceen - subscreen of event screen
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
                itemCount: g.teamList.length+1,
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
                      child: Text(g.teamList[i-1].name),
                  );}
                }
            ),
          ),
        );
      }
    );
  }

  void onTeamPressed(int placeIndex, int teamIndex) {
    for (TeamData td in g.teamList) {
      print (td.name);
    }
    print ("Team index: " + teamIndex.toString());
    print ("Place index: " + placeIndex.toString());
    g.currentEventData.placeTeams[placeIndex-1] = g.teamList[teamIndex];
    g.teamList[teamIndex].score += g.currentEventData.placesValues[placeIndex-1];
    Navigator .of(context, rootNavigator: true).pop();
    setState(() {});
  }

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(g.currentEventData.distance.toString() + " " + g.currentEventData.name),
      ),
      body: Center(
        child: ListView.builder(
          padding: const EdgeInsets.all(30),
          itemCount: g.currentEventData.places,
          itemBuilder: (context, i) {
            ElevatedButton eb;
            if (g.currentEventData.placeTeams[i].name == "None") {
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
                  child: Text((i + 1).toString() + ": " + g.currentEventData.placeTeams[i].name),
              );
            }
            return eb;
          },
        ),
      ),
    );
  }
}
