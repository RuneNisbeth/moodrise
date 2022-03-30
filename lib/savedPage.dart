import 'package:flutter/material.dart';
import 'homePage.dart';

/*
TODO: 
1. Routing 
2. SliderValue
3. Edit button to go back to mood logger "HomePage"
4. 
*/


class SavedPage extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
            Text(
              'Good evening  😌',
              textAlign: TextAlign.center,
              style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Color(0xFF151E55),
                    fontSize: 20,
                  ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(25, 25, 25, 25),
              child: Text(
                'Your mood has already been logged today',
                textAlign: TextAlign.center,
                style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xFF151E55),
                      fontSize: 30,
                ),
              ),
            ),

            
            
            // TODO: Slider value



            ElevatedButton.icon(
              icon: Icon(
                Icons.edit,
                //color: Colors.white),
              ),
              label: Text('Edit', 
                textAlign: TextAlign.center,
                style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white,),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFF28C17)),
              ),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage(),),
                );
                print('Pressed Edit mood from saved page');
              },
              
              /*
              child: Row(
                children: const <Widget>[
                  Icon(
                    Icons.edit
                  ),
                  Text('Edit', 
                    textAlign: TextAlign.center,
                    style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,),
                  ),
                ]
              ),
              */

            ),
          ]
        ),
      ),
    );
  }
}