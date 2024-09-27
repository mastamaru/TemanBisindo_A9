import 'package:flutter/material.dart';

class Translate extends StatelessWidget {
  const Translate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF5B8BDF),
      appBar: null,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  "Menerjemahkan..",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      fontSize: 27,
                      fontFamily: 'Ubuntu',
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  height: 404,
                  width: 384,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white),
                      color: Colors.white),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  "Hasil Terjemahan:",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      fontSize: 27,
                      fontFamily: 'Ubuntu',
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 164,
                  width: 384,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white),
                      color: Colors.white),
                ),
              ],
            ),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Kembali",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Ubuntu',
                    color: Colors.white,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
