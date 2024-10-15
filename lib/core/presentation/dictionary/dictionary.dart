import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temanbisindoa9/core/controllers/gestur_controllers.dart';

import '../../widget/gesturCard.dart';

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
    'Semua',
    'Huruf',
    'Angka',
    'Kata',
  ];

  final GesturController _gesturController = Get.put(GesturController());
  String selectedItem = 'Semua'; // saving selected item

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
                  defaultValue: selectedItem,
                  onChanged: (value) {
                    setState(() {
                      selectedItem = value; // Update status dropdown
                    });
                    // Panggil fungsi filter di controller
                    _gesturController.filterGestur(value);
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
                  child: Obx(() {
                    if (_gesturController.isLoading.value) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return GridView.builder(
                        padding: EdgeInsets.all(8),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: _gesturController.filteredGesturList.length,
                        itemBuilder: (context, index) {
                          return GesturCard(
                            gestur: _gesturController.filteredGesturList[index],
                          );
                        },
                      );
                    }
                  }),
                ),
              ],
            ),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  selectedItem = 'Semua';
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
