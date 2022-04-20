import 'dart:async';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'combichart.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class InsightsPage extends StatefulWidget {
  const InsightsPage();

  @override
  _InsightsPage createState() => _InsightsPage();
}

class _InsightsPage extends State<InsightsPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  static List<Mood> moodData = [];
  static List<Sun> sunData = [];
  
  void _updateData(List<Mood> newMoodData, List<Sun> newSunData) {
    setState(() {
      moodData = newMoodData;
      sunData = newSunData;
    });
  }

  final CollectionReference moodCollection = FirebaseFirestore.instance.collection('moods');
  // get mood stream
  Stream<QuerySnapshot> get moods {
    return moodCollection.snapshots();
  }

  num _calculateSunValue(Timestamp sunset, Timestamp sunrise, num clouds){
    num _cloudImportance = 0.005;
    num _secondsToHoursConvert = 0.000277777778;
    num sunValue = (sunset.seconds - sunrise.seconds) * _secondsToHoursConvert * (1 - clouds * _cloudImportance);
    return sunValue;
  }

  Future<List<Mood>> getMoods() async{
    List<Mood> moodList = [];
    try {
      await moodCollection.get().then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          Mood newMood = Mood(element['date'].toDate(), element['mood']);
          
          moodList.add(newMood);
        });
      });
      moodList.sort((Mood a, Mood b) => a.date.compareTo(b.date));
      return moodList;
    } catch (e) { print(e.toString());
      return moodList;
    }
  }

  Future<List<Sun>> getSuns() async{
    List<Sun> sunList = [];
    try {
      await moodCollection.get().then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          Sun newSun = Sun(element['date'].toDate(), _calculateSunValue(element['sunset'], element['sunrise'], element['clouds']));
          sunList.add(newSun);
        });
      });
      sunList.sort((Sun a, Sun b) => a.date.compareTo(b.date)); 
      return sunList;
    } catch (e) { print(e.toString());
      return sunList;
    }
  } 

  
  static List<charts.Series<dynamic, DateTime>> _createSampleData() {
    // DUMMY DATA 
    final latest_mood_dummy = [
      new Mood(DateTime.utc(2022, 4, 16) , 1),  new Mood(DateTime.utc(2022, 4, 15) , 5),
      new Mood(DateTime.utc(2022, 4, 14) , 5),  new Mood(DateTime.utc(2022, 4, 13) , 6),
      new Mood(DateTime.utc(2022, 4, 12) , 5),  new Mood(DateTime.utc(2022, 4, 11) , 5),];
    final latest_sun_dummy = [
      new Sun(DateTime.utc(2022, 4, 16) , 1),   new Sun(DateTime.utc(2022, 4, 15) , 2),
      new Sun(DateTime.utc(2022, 4, 14) , 1),   new Sun(DateTime.utc(2022, 4, 13) , 3),
      new Sun(DateTime.utc(2022, 4, 12) , 5),   new Sun(DateTime.utc(2022, 4, 11) , 4),
    ];

    return [
      // ignore: unnecessary_new
      new charts.Series<Mood, DateTime>(
        id: 'Mood',
        colorFn: (_, __) => charts.MaterialPalette.black,
        domainFn: (Mood mood, _) => mood.date, //mode.date
        measureFn: (Mood mood, _) => mood.mood,
        data: moodData,
      ) // Configure our custom bar renderer for this series.
      ..setAttribute(charts.measureAxisIdKey, 'secondaryMeasureAxisId'),
        
      new charts.Series<Sun, DateTime>(
        id: 'Sun',
        colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
        domainFn: (Sun sun, _) => sun.date, //sun.date
        measureFn: (Sun sun, _) => sun.sun,
        data: sunData,
      )
      ..setAttribute(charts.rendererIdKey, 'customBar'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<dynamic>.value(
      value: moods, 
      initialData: 25.toString(),
      child: Scaffold(
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
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(25, 50, 25, 0),
                child: Text(
                  'Your average mood and daylight hours',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Color(0xFF151E55),
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Container(
                width: double.infinity,
                height: 25,
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(15, 5, 25, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.solidSquare,
                            color: Colors.yellow,
                            size: 12,
                          ),
                          Text(
                            ' Daylight',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Color(0xFF151E55),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              ),
                          ),
                        ]
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.trending_up_rounded,
                            color: Colors.black,
                            size: 16,
                          ),
                          Text(
                            ' Mood',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Color(0xFF151E55),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              ),
                          ),
                        ]
                      ),
                    ],
                  ),
                ),
              ),
            Container(
              width: double.infinity,
              height: 350,
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
              ),
              child: Container(
                width: 100,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 0, 30, 30),
                  child: NumericComboLineBarChart(_createSampleData()),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 25,
              decoration: BoxDecoration(
                color: Color(0xFFEEEEEE),
              ),
              child: Container()//MoodList(),
            ),
            ElevatedButton.icon(
                icon: Icon(
                  Icons.sync,
                ),
                label: Text('Update graph', 
                  textAlign: TextAlign.center,
                  style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFF28C17)),
                ),
                onPressed: () async {
                  //get moods
                  _updateData(await getMoods(), await getSuns());
                },
            ),
          ]),
      ),
    ),));
  }
}

