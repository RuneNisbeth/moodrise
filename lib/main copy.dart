import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';


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
  // READ FILE FROM FIREBASE
  //final Stream<QuerySnapshot> moods = FirebaseFirestore.instance.collection('moods').snapshots();
  const HomePageWidget();

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

// OpenWeather.com api key = efb52228910f94f7a93a69174c6b8130
// api call for 7-day daily weather forecast. 
// https://api.openweathermap.org/data/2.5/onecall?lat=33.44&lon=-94.04
// &exclude=current,minutely,hourly,alerts&appid=47dced083ea25cf48cf2d5a4c6d50e4c
// lat=55.68&lon=12.59 ≈ Nyhavn
  var date;
  var tempt;
  var clouds;
  var uvi;
  var sunrise;
  var sunset; 

  Future getWeather () async {
    var weatherComURL = Uri.parse('https://api.openweathermap.org/data/2.5/onecall?lat=55.68&lon=12.59&exclude=current,minutely,hourly,alerts&appid=47dced083ea25cf48cf2d5a4c6d50e4c');
    http.Response response = await http.get(weatherComURL);
    var result = jsonDecode(response.body);
    setState((){
      this.date = result["daily"][0]['dt'];
      this.clouds = result["daily"][0]['clouds'];
      this.uvi = result["daily"][0]['uvi'];
      this.sunrise = result["daily"][0]['sunrise'];
      this.sunset = result["daily"][0]['sunset'];
      this.tempt =  result["daily"][0]['temp']['day'];
      
      // PRINT WEATHER DATA TO CONSOLE
      print("WEATHER DATA: date=$date clouds=$clouds tempt=$tempt sunrise=$sunrise sunset=$sunset uvi=$uvi");
    });

    // UPLOAD WEATHER DATA TO FIREBASE 
    CollectionReference moods = FirebaseFirestore.instance.collection('moods');
    moods
      .add({'date':date, 'clouds': clouds, 'tempt':tempt, 'sunrise':sunrise, 'sunset':sunset, 'uvi':uvi})
      .then((value) => print('Mood added'))
      .catchError((error) => print('Failed to add mood : $error'));  

  }

  @override
  void initState(){
    super.initState();
    this.getWeather();
  }
  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white,
                fontSize: 22,
              );
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFFFFB700),
        automaticallyImplyLeading: false,
        // ignore: prefer_const_constructors
        title: Text(
          'MoodRise',
          style: textStyle,
        ),
        actions: [],
        centerTitle: false,
        elevation: 2,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [],
          ),
        ),
      ),
    );
  }
}