import 'package:flutter/material.dart';
import 'package:temanbisindoa9/utils/routes/routes.dart';

void main() {
  runApp(myApp());
}

class myApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Routes.generateRoute,
      initialRoute: Routes.home,
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF5B8BDF),
        appBar: null,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                ButtonMain(
                  text: 'TERJEMAHKAN BISINDO',
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.translate);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                ButtonMain(
                    text: 'BUKA KAMUS BISINDO',
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.dictionary);
                    }),
              ],
            )
          ],
        ));
  }
}

class ButtonMain extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  ButtonMain({
    super.key,
    required this.text,
    required this.onPressed,
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
        onPressed: onPressed,
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
