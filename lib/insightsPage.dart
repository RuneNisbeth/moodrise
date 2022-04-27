import 'dart:async';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'combichart.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

/// TO DO 
/// * Look 7 or 31 or 365 days back insted of Whats in week 33, April og 2022
/// * Average data to weeks and months in year view and month view. 
/// * Make easier to see the dates. MON, TUE, WED, THU, FRI or make the y-ticks right below the datapoints.
/// * Hardcoded month (31 days) and year (365 days)
/// * Limit mood axis to 10 in graph.


class InsightsPage extends StatefulWidget {
  const InsightsPage();

  @override
  _InsightsPage createState() => _InsightsPage();
}

class _InsightsPage extends State<InsightsPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  static List<Mood> moodData = [];
  static List<Sun> sunData = [];
  DateTime today = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 59);
  static DateTime startDateGraph = DateTime.now().subtract(Duration(days:7));
  static DateTime endDateGraph = DateTime.now();
  int weekMonthYear = 0; // 1=Week, 2=Month, 3=Year
  
  
  _initGetMoodsAndSuns() async {
    List<Mood> justMoodData = await getMoods();
    List<Sun> justSunData = await getSuns();
    setState(() {
      weekMonthYear = weekMonthYear;
      moodData = justMoodData.where((element) => element.date.isAfter(startDateGraph) && element.date.isBefore(endDateGraph) ).toList();
      sunData = justSunData.where((element) => element.date.isAfter(startDateGraph) && element.date.isBefore(endDateGraph) ).toList();
    });
  }

  _initGetSuns() async {
    return getSuns();
  }

  @override
  void initState() {
    // TODO: implement initState getMoods(), await getSuns()
    super.initState();
    _initGetMoodsAndSuns();
  }
  



  void _previousWeekMonthYear(DateTime newEndDateGraph, DateTime newStartDateGraph){
    if(weekMonthYear == 0){ _updateWeekMonthYear(endDateGraph.subtract(Duration(days:7)), startDateGraph.subtract(Duration(days:7))); }
    if(weekMonthYear == 1){ _updateWeekMonthYear(endDateGraph.subtract(Duration(days:31)), startDateGraph.subtract(Duration(days:31))); }
    if(weekMonthYear == 2){ _updateWeekMonthYear(endDateGraph.subtract(Duration(days:365)), startDateGraph.subtract(Duration(days:365))); }
  }
  
  void _nextWeekMonthYear(DateTime newEndDateGraph, DateTime newStartDateGraph){
    if(weekMonthYear == 0){ _updateWeekMonthYear(endDateGraph.add(Duration(days:7)), startDateGraph.add(Duration(days:7))); }
    if(weekMonthYear == 1){ _updateWeekMonthYear(endDateGraph.add(Duration(days:31)), startDateGraph.add(Duration(days:31))); }
    if(weekMonthYear == 2){ _updateWeekMonthYear(endDateGraph.add(Duration(days:365)), startDateGraph.add(Duration(days:365))); }
  }

  void _updateWeekMonthYear(DateTime newEndDateGraph, DateTime newStartDateGraph){
    endDateGraph = newEndDateGraph;
    startDateGraph = newStartDateGraph;
  }

  void _updateData(List<Mood> newMoodData, List<Sun> newSunData, int newWeekMonthYear) {
    setState(() {
      weekMonthYear = newWeekMonthYear;
      moodData = newMoodData.where((element) => element.date.isAfter(startDateGraph) && element.date.isBefore(endDateGraph) ).toList();
      sunData = newSunData.where((element) => element.date.isAfter(startDateGraph) && element.date.isBefore(endDateGraph) ).toList();
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
    } catch (e) { 
      print(e.toString());
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
    // DUMMY DATA NOT USED
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
        domainLowerBoundFn: (s, _) => startDateGraph, 
        domainUpperBoundFn: (s, _) => endDateGraph, 
        //measureLowerBoundFn: (s, _) => 0, 
        //measureUpperBoundFn: (s, _) => 10, 
      ) // Configure our custom bar renderer for this series.
      //..setAttribute(charts.AxisSpec, new charts.AxisSpec())
      ..setAttribute(charts.measureAxisIdKey, 'secondaryMeasureAxisId'),
        
      new charts.Series<Sun, DateTime>(
        id: 'Sun',
        colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
        domainFn: (Sun sun, _) => sun.date, //sun.date
        measureFn: (Sun sun, _) => sun.sun,
        data: sunData,
        domainLowerBoundFn: (s, _) => startDateGraph, 
        domainUpperBoundFn: (s, _) => endDateGraph, 
        //measureLowerBoundFn: (s, _) => startDateGraph, 
        //measureUpperBoundFn: (s, _) => endDateGraph, 
      )
      ..setAttribute(charts.rendererIdKey, 'customBar'),
      //..setAttribute(charts.SeriesRenderer.defaultRendererId, '')
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
                  padding: EdgeInsetsDirectional.fromSTEB(30, 0, 30, 10),
                  child: NumericComboLineBarChart(
                    _createSampleData(),
                    
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
                padding: EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        IconButton(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          onPressed: () async {
                            _previousWeekMonthYear(endDateGraph, startDateGraph);
                            _updateData(await getMoods(), await getSuns(), weekMonthYear);
                          }, 
                          icon: Icon(
                            Icons.arrow_left,
                            color: Colors.black,
                            size: 25,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            _previousWeekMonthYear(endDateGraph, startDateGraph);
                            _updateData(await getMoods(), await getSuns(), weekMonthYear);
                          }, 
                          child: Text(
                            ' Previous',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              ),
                          ),
                        )
                      ]
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        TextButton(
                          onPressed: () async {
                            _nextWeekMonthYear(endDateGraph, startDateGraph);
                            _updateData(await getMoods(), await getSuns(), weekMonthYear);
                          }, 
                          child: Text(
                            'Next ',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              ),
                          ),
                        ), 
                        IconButton(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          onPressed: () async {
                            _nextWeekMonthYear(endDateGraph, startDateGraph);
                            _updateData(await getMoods(), await getSuns(), weekMonthYear);
                          }, 
                          icon: Icon(
                            Icons.arrow_right,
                            color: Colors.black,
                            size: 25,
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
              height: 10,
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
              ),
              child: Container()
            ),
            /*
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
                  _updateData(await getMoods(), await getSuns(), weekMonthYear);
                },
            ),
            */
            Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(25, 15, 25, 0),
                    child: ElevatedButton(
                      child: Text('Week', 
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
                        _updateWeekMonthYear(today, today.subtract(Duration(days:7)));
                        _updateData(await getMoods(), await getSuns(), 0);
                      },
                  ),
                ), 
                Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(25, 15, 25, 0),
                    child: ElevatedButton(
                      child: Text('Month', 
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
                        _updateWeekMonthYear(today, today.subtract(Duration(days:31)));
                        _updateData(await getMoods(), await getSuns(), 1);
                      },
                  ),
                ),
                Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(25, 15, 25, 0),
                    child: ElevatedButton(
                      child: Text('Year', 
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
                        _updateWeekMonthYear(today, today.subtract(Duration(days:365)));
                        _updateData(await getMoods(), await getSuns(), 2);
                      },
                  ),
                ),
              ]),   
          ]),
      ),
    ),));
  }
}

