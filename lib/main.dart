import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:moodrise/homePage.dart';
import 'package:moodrise/savedPage.dart';
import 'insightsPage.dart';
import 'advice_page.dart';
import 'package:flutter/cupertino.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCIwHtOPFKy_jHrArTxlzcjWBar-TeeI_c",
      appId: "1:275694460331:web:c97b401267238acb8b86ee",
      messagingSenderId: "275694460331",
      projectId: "moodrise-dtu",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
      home: const HomePageWidget(),
    );
  }
}

class HomePageWidget extends StatefulWidget {
  const HomePageWidget();

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  int _currentPageIndex = 0;
  
  void _onItemTapped(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  final screens = [
    HomePage(),
    InsightsPage(),
    AdvicePage(), 
  ];

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return 
    
    Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xD9FFCB30),
        automaticallyImplyLeading: false,
        title: Text(
          'MoodRise',
          style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white,
                fontSize: 22,
              ),
        ),
        actions: [],
        centerTitle: true,
        elevation: 2,
      ),
      backgroundColor: Color(0xFFF1F1F0),
      body: screens[_currentPageIndex],
      bottomNavigationBar: CupertinoTabScaffold(
        backgroundColor: Color(0xFFF1F1F0),
        tabBar: CupertinoTabBar(items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.wb_sunny_rounded),
              label: '', //'HomePage',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.insights),
              label: '', //'Insights',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.lightbulb),
              label: '', //'Advice',
            ),
        ],
        activeColor: Color(0xd9ffcb30),
        iconSize: 35,
        backgroundColor: Color(0xFFFFFFFF),
        ), 
        tabBuilder: (context, index) {
          switch (index) {
            case 0:
              return CupertinoTabView(builder: (context) {
                return CupertinoPageScaffold(
                  child: HomePage(),
                );
              });
            case 1:
              return CupertinoTabView(builder: (context) {
                return CupertinoPageScaffold(
                  child: InsightsPage(),
                );
              });
            case 2:
              return CupertinoTabView(builder: (context) {
                return CupertinoPageScaffold(
                  child: AdvicePage(),
                );
              });
            default: return CupertinoTabView(builder: (context) {
                return CupertinoPageScaffold(
                  child: HomePage(),
                );
              });
          }}
      ),
    );
  }
}