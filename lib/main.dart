import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Instagram Clone';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: const MyStatefulWidget(),
      theme: ThemeData.light(),
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

  static const List<Widget> pages = <Widget>[
    HomePage(),
    Text(
      'Search',
    ),
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
      body: pages[
          _selectedIndex], //Center(child: pages.elementAt(_selectedIndex),),
      bottomNavigationBar: BottomNavigationBar(/*CurvedNavigationBar(
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
    return Container(
      child: Text("ACCOUNT PAGE"),
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StoriesWidget(),
        PostsWidget(),
      ],
    );
  }
}

class PostsWidget extends StatelessWidget {
  PostsWidget({Key? key}) : super(key: key);
  final List<String> followers = ["Vitaliy", "Ann", "Mark", "Joy", "AnnXX"];
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
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)
          ),
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
                  const Text("Cool!")
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
  final List<String> subscribers = ["Vitaliy", "Ann", "Mark", "Joy", "AnnXX"];
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
          Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.amber,
                  border: Border.all(width: 2, color: Colors.red))),
          Text(userName),
        ],
      ),
    );
  }
}
