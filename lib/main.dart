import 'dart:developer';

import 'package:flutter/material.dart';
//import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';

import 'models/data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:simple_animations/simple_animations.dart';
//import 'package:flutter_application_2/pages/home.dart';

class Album {
  final int userId;
  final int id;
  final String title;

  Album({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}

Future<Album> fetchAlbum() async {
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
  if (response.statusCode == 200) {
    return Album.fromJson(jsonDecode(response.body));
  } else {
    throw Exception("Failed to load album");
  }
}

Future<void> RequestToDataBase() async {
  print("Start RequestToDataBase");
  String row = await getDataFromDB();
  print("Receive data from database: $row");
}

Future<String> getDataFromDB() {
  return Future.delayed(Duration(seconds: 3), () => "Vitalii Yezghor TI-82");
}

void main() async {
  //future/then
  Future<String> future = Future.delayed(Duration(seconds: 2), () => "Request to the Data base");
  future.then((value) {
    print("Value = $value");
  });

  // async/await
  RequestToDataBase();

  Brightness brightness;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  brightness = (prefs.getBool("isDark") ?? false) ? Brightness.dark : Brightness.light;
  print("Run the app");
  runApp(MyApp(brightness: brightness));
}

class MyApp extends StatelessWidget {
  Brightness? brightness;

  MyApp({Key? key, this.brightness}) : super(key: key);

  static const String _title = 'Flutter Instagram Clone';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      //home: const MyStatefulWidget(),
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        brightness: brightness,
      ) /*);*/,
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => MyStatefulWidget(),
        '/friends-list': (BuildContext context) => ListFriends(group: "Favourite")
      },
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;

  static List<Widget> pages = <Widget>[
    HomePage(),
    SearchPage(),
    /*Text(
      'Search',
    ),*/
    AccountPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void changePage() {
    setState(() {
      if (pages.length > _selectedIndex + 1) {
        _selectedIndex += 1;
      } else {
        _selectedIndex -= 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const InstagramBar(),
        iconTheme: IconThemeData(color: Colors.green),
      ),
      body: pages[_selectedIndex], //Center(child: pages.elementAt(_selectedIndex),),
      bottomNavigationBar: BottomNavigationBar(
        /*CurvedNavigationBar(
        items: const [
          Icon(Icons.home),
          Icon(Icons.search),
          Icon(Icons.person),
        ],*/

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          changePage();
        },
        child: const Icon(Icons.navigation),
        backgroundColor: Colors.green,
      ),
      drawer: const DrawerWidget(),
    );
  }
}

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Search'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Account'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Data>(
      create: (context) => Data(),
      child: Column(
        children: [
          Text(
            "Account page",
            style: TextStyle(fontSize: 25),
          ),
          PersonalData(),
        ],
      ),
    );
  }
}

class PersonalData extends StatelessWidget {
  PersonalData({Key? key}) : super(key: key);
  dynamic result = "";
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text("Name: Vitaliy", style: TextStyle(fontSize: 20)),
          Text("Surname: Yezghor", style: TextStyle(fontSize: 20)),
          PersonAge(),
          RaisedButton(
              onPressed: () /*async*/ {
                //result = await Navigator.push(context, MaterialPageRoute(builder: (context) => ListFriends(group: "Favourite")));
                //print("!!! RETURN $result");
                Navigator.pushNamed(context, '/friends-list');
              },
              child: Text("Friends List $result", style: TextStyle(fontSize: 15))),
          Text("Animation", style: TextStyle(fontSize: 20)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Bar(height: 0.3, label: "2013"),
              Bar(height: 0.5, label: "2014"),
              Bar(height: 0.7, label: "2015"),
            ],
          )
          //MyHomePage(),
        ],
      ),
    );
  }
}

class Bar extends StatefulWidget {
  final double height;
  final String label;

  const Bar({Key? key, required this.height, required this.label}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState(this.height, this.label);
}

class _MyHomePageState extends State<Bar> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation colorAnimation;
  late Animation sizeAnimation;
  final double height;
  final String label;

  final int _baseDurationMs = 1000;
  final double _maxElementHeight = 100;

  _MyHomePageState(this.height, this.label);
  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(seconds: 2));

    colorAnimation = ColorTween(begin: Colors.blue, end: Colors.yellow).animate(controller);
    sizeAnimation = Tween<double>(begin: 0.0, end: height).animate(controller);

    controller.addListener(() {
      setState(() {});
    });

    controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: sizeAnimation.value * _maxElementHeight, //(1 - sizeAnimation.value) * _maxElementHeight, //sizeAnimation.value,
          width: 40, //sizeAnimation.value,
          color: colorAnimation.value,
        ),
        Text(label),
      ],
    );
  }
}

class ListFriends extends StatelessWidget {
  String group;
  final dynamic returnValue = "Return value using pop";
  ListFriends({Key? key, required this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Friends List $group")),
        body: Column(children: [
          Text("Vitalii Yezghor", style: TextStyle(fontSize: 15)),
          RaisedButton(
              onPressed: () {
                Navigator.pop(context, returnValue);
              },
              child: Text('Назад')),
        ]));
  }
}

class PersonAge extends StatelessWidget {
  const PersonAge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Consumer<Data>(
        builder: (context, Data, child) {
          return Text("Age ${Data.getAge}", style: TextStyle(fontSize: 40));
        },
      ),
      ElevatedButton(
        onPressed: () {
          Provider.of<Data>(context, listen: false).incrementUsersAge();
        },
        child: Text("Add"),
      )
    ]);
  }
}

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  //State
  String dataSearch = "Search Vitalii Yezghor";
  late Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  void _onChangeState(newDataSearch) {
    setState(() {
      dataSearch = newDataSearch;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Search Page"),
        BoxSearch(
          data: dataSearch,
          onChange: _onChangeState,
        ),
        FutureBuilder<Album>(
          future: futureAlbum,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(
                snapshot.data!.title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return const CircularProgressIndicator();
          },
        )
      ],
    );
  }
}

class BoxSearch extends StatelessWidget {
  final String data;
  final Function onChange;
  BoxSearch({Key? key, required this.data, required this.onChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Box search:",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        MyTextField(
          onChange: onChange,
        ),
        RecentlySearched(
          data: data,
        ),
      ],
    );
  }
}

class RecentlySearched extends StatelessWidget {
  final String data;
  RecentlySearched({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        data,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final Function onChange;
  MyTextField({Key? key, required this.onChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (newDataSearch) => onChange(newDataSearch),
    );
  }
}

class InstagramBar extends StatelessWidget {
  const InstagramBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          "Instagram",
          style: TextStyle(color: Colors.black),
        ),
        Icon(
          Icons.send,
          color: Colors.black,
        ),
      ],
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  final String data = "Data TI-82 Vitalii Yezghor";
  @override
  Widget build(BuildContext context) {
    return Provider<String>(
      create: (context) => data,
      child: Column(
        children: [
          StoriesWidget(),
          PostsWidget(),
        ],
      ),
    );
  }
}

class PostsWidget extends StatelessWidget {
  PostsWidget({Key? key}) : super(key: key);
  final List<String> followers = [
    "Vitaliy",
    "Ann",
    "Mark",
    "Joy",
    "AnnXX"
  ];
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: followers.length,
            itemBuilder: (BuildContext context, int index) {
              return PostWidget(userName: followers[index]);
            }));
  }
}

class PostWidget extends StatelessWidget {
  final String userName;
  const PostWidget({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            // user
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(left: 10),
                        width: 45,
                        height: 45,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        )),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        userName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: const [
                    Padding(
                      child: Icon(Icons.more_horiz),
                      padding: EdgeInsets.only(right: 10),
                    )
                  ],
                )
              ],
            ),
            // Picture
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Container(
                height: 250,
                color: Colors.yellow,
              ),
            ),
            // Like
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.favorite),
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Icon(Icons.insert_comment_outlined),
                      ),
                    ],
                  ),
                  const Icon(Icons.bookmark)
                ],
              ),
            ),
            // Comments
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    userName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 5),
                  Text(Provider.of<String>(context)) // context.watch<String>()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class StoriesWidget extends StatelessWidget {
  StoriesWidget({Key? key}) : super(key: key);
  final List<String> subscribers = [
    "Vitaliy",
    "Ann",
    "Mark",
    "Joy",
    "AnnXX"
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 110.0,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: subscribers.length,
            itemBuilder: (BuildContext context, int index) {
              return StoryWidget(userName: subscribers[index]);
            }));
  }
}

class StoryWidget extends StatelessWidget {
  final String userName;
  const StoryWidget({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Container(width: 65, height: 65, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.amber, border: Border.all(width: 2, color: Colors.red))),
          Text(userName),
        ],
      ),
    );
  }
}
