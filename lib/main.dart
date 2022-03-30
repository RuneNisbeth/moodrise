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
  var mood;
  var sliderValue;

  Future getWeather () async {
    var weatherComURL = Uri.parse('https://api.openweathermap.org/data/2.5/onecall?lat=55.68&lon=12.59&exclude=current,minutely,hourly,alerts&appid=47dced083ea25cf48cf2d5a4c6d50e4c&units=metric');
    http.Response response = await http.get(weatherComURL);
    var result = jsonDecode(response.body);
    setState((){
      this.date = DateTime.fromMillisecondsSinceEpoch(result["daily"][0]['dt'] * 1000);
      this.clouds = result["daily"][0]['clouds'];
      this.uvi = result["daily"][0]['uvi'];
      this.sunrise = DateTime.fromMillisecondsSinceEpoch(result["daily"][0]['sunrise'] * 1000);
      this.sunset = DateTime.fromMillisecondsSinceEpoch(result["daily"][0]['sunset'] * 1000);
      this.tempt =  result["daily"][0]['temp']['day'];
      
      // PRINT WEATHER DATA TO CONSOLE
      print("WEATHER DATA: date=$date clouds=$clouds tempt=$tempt sunrise=$sunrise sunset=$sunset uvi=$uvi");
    });  
  }

  Future uploadMood () async{
    // UPLOAD WEATHER DATA TO FIREBASE 
    CollectionReference moods = FirebaseFirestore.instance.collection('moods');
    moods
      .add({'date':date, 'mood':mood ,'clouds': clouds, 'tempt':tempt, 'sunrise':sunrise, 'sunset':sunset, 'uvi':uvi})
      .then((value) => print('Mood added'))
      .catchError((error) => print('Failed to add mood : $error'));
    print('Mood uploaded');  
  }

  @override
  void initState(){
    super.initState();
    this.getWeather();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  color: Color(0xFFEEEEEE),
                ),
              ),
              Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(0xFFEEEEEE),
                ),
                child: Text(
                  'Good evening  😌',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                      ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  color: Color(0xFFEEEEEE),
                ),
                child: Text(
                  'How are you feeling today?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Color(0xFF151E55),
                        fontSize: 30,
                      ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 80,
                decoration: BoxDecoration(
                  color: Color(0xFFEEEEEE),
                ),
              ),
              Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  color: Color(0xFFEEEEEE),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 0, 25, 0),
                  child: Container(
                    width: double.infinity,
                    child: Slider.adaptive(
                      activeColor: Color(0xD9FFCB30),
                      inactiveColor: Color(0xFF9E9E9E),
                      min: 0,
                      max: 10,
                      value: sliderValue ??= 5,
                      label: sliderValue.toString(),
                      divisions: 20,
                      onChanged: (newValue) {
                        setState(() => sliderValue = newValue);
                      },
                    ),
                  ),
                ),
              ),
              TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Color(0xEC456BBA)),
                ),
                onPressed: () {
                  mood = sliderValue;
                  print('Mood updated');
                  uploadMood();
                },
                child: Text('OK', 
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
