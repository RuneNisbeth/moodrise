import 'package:flutter/material.dart';

class AdvicePage extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xD9FFCB30),
        automaticallyImplyLeading: false,
        title: Text(
          'Tips & Advice',
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(35, 35, 35, 35),
                  child: Container(
                    width: double.infinity,
                    height: 170,
                    constraints: BoxConstraints(
                      maxWidth: double.infinity,
                    ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(30, 15, 0, 0),
                          child: Text(
                            'Today\'s weather',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Color(0xFF151E55),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(30, 15, 0, 0),
                          child: Text(
                            'It should be sunny today from ',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Color(0xFF151E55),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(30, 5, 0, 5),
                          child: Text(
                            ' ☀️   3 pm -5 pm ',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Color(0xFF151E55),
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(30, 0, 0, 0),
                          child: Text(
                            'Try to get out in this time slot to soak in some sushine.',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Color(0xFF151E55),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton.icon(
                                icon: Icon(
                                  Icons.notifications
                                ),
                                label: Text('Set a reminder', 
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFF28C17)),
                                ),
                                onPressed: () async {
                                  
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(35, 0, 35, 35),
                  child: Container(
                    width: double.infinity,
                    height: 400,
                    constraints: BoxConstraints(
                      maxWidth: double.infinity,
                    ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(25, 25, 25, 25),
                    child: Container(
                      width: double.infinity,
                      height: 400,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(10, 0, 10, 10),
                            child: Text(
                              'Find out how to cope with  Seasonal  Depression',
                              style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Color(0xFF151E55),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                            child: Text(
                              '#LetsTalkAboutIt  made a YouTube video with great advise on how to cope with \"SAD\". Watch it down below.',
                              style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w300,
                                  ),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
                            child: Image.asset('assets/images/youtube_advice.png'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
