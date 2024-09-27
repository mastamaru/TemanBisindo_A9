import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final List<String> items;
  final String defaultValue;
  final Function(String) onChanged;

  const CustomDropdown({
    Key? key,
    required this.items,
    required this.defaultValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  late String _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButton<String>(
        value: _currentValue,
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: Colors.black, fontSize: 16),
        underline: SizedBox(),
        isExpanded: true,
        onChanged: (String? newValue) {
          if (newValue != null && newValue != widget.defaultValue) {
            setState(() {
              _currentValue = newValue;
            });
            widget.onChanged(newValue);
          }
        },
        items: widget.items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(
                  color: value == widget.defaultValue
                      ? Colors.grey
                      : Colors.black),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class Dictionary extends StatefulWidget {
  const Dictionary({super.key});

  @override
  State<Dictionary> createState() => _DictionaryState();
}

class _DictionaryState extends State<Dictionary> {
  final List<String> _dropdownItems = [
    'Pilihan: ',
    'Huruf',
    'Angka',
    'Kata',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF5B8BDF),
      appBar: null,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  "Kamus",
                  style: TextStyle(
                    fontSize: 43,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Ubuntu',
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 35),
                Text(
                  "Kata apa yang lagi kamu pelajari \nsekarang?",
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Ubuntu',
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 35),
                CustomDropdown(
                  items: _dropdownItems,
                  defaultValue: 'Pilihan: ',
                  onChanged: (value) {
                    print('Selected: $value');
                  },
                ),
                SizedBox(height: 35),
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
