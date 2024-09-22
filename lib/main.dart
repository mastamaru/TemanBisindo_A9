import 'package:flutter/material.dart';

void main() {
  runApp(myApp());
}

class myApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Color(0xFF5B8BDF),
            appBar: AppBar(
              backgroundColor: Color(0xFF5B8BDF),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 40,
                    ),
                    child: Text(
                      'TEMAN BISINDO',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 43,
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )),
                Column(
                  children: [
                    ButtonMain(text: 'TERJEMAHKAN BISINDO'),
                    SizedBox(
                      height: 20,
                    ),
                    ButtonMain(text: 'BUKA KAMUS BISINDO'),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                )
              ],
            )));
  }
}

class ButtonMain extends StatelessWidget {
  final String text;
  ButtonMain({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 330,
      height: 120.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        onPressed: () {},
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Ubuntu',
            fontWeight: FontWeight.normal,
            // apply this into hex #2c64c6
            color: Color(0xFF2C64C6),
          ),
        ),
      ),
    );
  }
}
