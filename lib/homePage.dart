import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moodrise/savedPage.dart';
import 'main.dart';

/// TO DO

class HomePage extends StatefulWidget {
  // READ FILE FROM FIREBASE
  //final Stream<QuerySnapshot> moods = FirebaseFirestore.instance.collection('moods').snapshots();
  const HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  CollectionReference moods = FirebaseFirestore.instance.collection('moods');

  var date;
  var tempt;
  var clouds;
  var uvi;
  var sunrise;
  var sunset; 
  var mood;
  var sliderValue;
  var textController;

  Future getWeather () async {
    // OpenWeather.com api key = efb52228910f94f7a93a69174c6b8130
    // api call for 7-day daily weather forecast. 
    // https://api.openweathermap.org/data/2.5/onecall?lat=33.44&lon=-94.04
    // &exclude=current,minutely,hourly,alerts&appid=47dced083ea25cf48cf2d5a4c6d50e4c
    // lat=55.68&lon=12.59 ≈ Nyhavn
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
    // CREATE A TODAY TIMESTAMP TO MATCH WITH RECORDS IN DATABASE
    DateTime now = DateTime.now();
    DateTime today = DateTime.utc(now.year, now.month, now.day, 00, 00, 00);
    Timestamp timestamp = Timestamp.fromDate(today);
    
    // GET DOCUMENTS
    QuerySnapshot todaysDocuments = await moods.where('date', isGreaterThan: timestamp).get();
    
    // CHECK IF THERE ALREADY EXIST A DOCUMENT FOR TODAY
    if(todaysDocuments.docs.isEmpty){ // if not then upload
      moods
      .add({'date':date, 'mood':mood ,'clouds': clouds, 'tempt':tempt, 'sunrise':sunrise, 'sunset':sunset, 'uvi':uvi})
      .then((value) => print('Mood added'))
      .catchError((error) => print('Failed to add mood : $error'));
      print('Mood uploaded as $mood');
    }
    else{ // If document exist for today then update mood
      todaysDocuments.docs[0].reference.update({'mood':mood});
    }
  }
  
  @override
  void initState(){
    super.initState();
    getWeather();
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
                fontWeight: FontWeight.w600,
              ),
        ),
        actions: [],
        centerTitle: true,
        elevation: 2,
      ),
      backgroundColor: Color(0xFFEEEEEE),
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
                'Hi, welcome back 👋 ',
                textAlign: TextAlign.center,
                style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
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
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                color: Color(0xFFEEEEEE),
              ),
              child: Visibility(
                visible: sliderValue != null,
                child: Align(
                  alignment: AlignmentDirectional(0, 1),
                  child: TextFormField(
                    controller: textController,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: sliderValue.toString(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                    ),
                    style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Color(0xFF434343),
                          fontSize: 35,
                        ),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                  ),
                ),
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
                    divisions: 10,
                    onChanged: (newValue) {
                      setState(() => sliderValue = newValue);
                    },
                  ),
                ),
              ),
            ),Container(
                width: double.infinity,
                height: 70,
                decoration: BoxDecoration(
                  color: Color(0xFFEEEEEE),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    if ((sliderValue != null))
                      Stack(
                        children: [
                          if ((sliderValue) == 0.0)
                            Text(
                              'I couldn\'t feel worse',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Color(0xFF434343),
                                fontSize: 16,
                                  ),
                            ),
                          if ((sliderValue) == 1.0)
                            Text(
                              'I\'m feeling terrible',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Color(0xFF434343),
                                fontSize: 16,
                              ),
                            ),
                          if ((sliderValue) == 2.0)
                            Text(
                              'I\'m feeling very bad',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Color(0xFF434343),
                                fontSize: 16,
                              ),
                            ),
                          if ((sliderValue) == 3.0)
                            Text(
                              'I\'m feeling bad',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Color(0xFF434343),
                                fontSize: 16,
                              ),
                            ),
                          if ((sliderValue) == 4.0)
                            Text(
                              'I\'m feeling less than OK',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Color(0xFF434343),
                                fontSize: 16,
                              ),
                            ),
                          if ((sliderValue) == 5.0)
                            Text(
                                'So-so',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Color(0xFF434343),
                                fontSize: 16,
                              ),
                              ),
                          if ((sliderValue) == 6.0)
                            Text(
                              'I\'m feeling OK',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Color(0xFF434343),
                                fontSize: 16,
                              ),
                            ),
                          if ((sliderValue) == 7.0)
                            Text(
                              'I\'m feeling good',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Color(0xFF434343),
                                fontSize: 16,
                              ),
                            ),
                          if ((sliderValue) == 8.0)
                            Text(
                              'I\'m feeling very good',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Color(0xFF434343),
                                fontSize: 16,
                              ),
                            ),
                          if ((sliderValue) == 9.0)
                            Text(
                              'I\'m feeling great',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Color(0xFF434343),
                                fontSize: 16,
                              ),
                            ),
                          if ((sliderValue) == 10.0)
                            Text(
                              'I\'m feeling really great',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Color(0xFF434343),
                                fontSize: 16,
                              ),)
                        ],
                      ),
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color(0xFFEEEEEE),
                      ),
                    ),
                  ],
                ),
              ),
            ElevatedButton.icon(
              icon: Icon(
                Icons.save_alt_rounded,
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFF28C17)),
              ),
              onPressed: () async {
                mood = sliderValue;
                uploadMood();
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SavedPage(sliderValue: sliderValue,),),
                );
              },
              label: Text('Log my mood', 
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    )
    );
  }
}