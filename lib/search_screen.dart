import 'package:flutter/material.dart';

class SearchSCreen extends StatefulWidget {
  @override
  _SearchSCreenState createState() => _SearchSCreenState();
}

class _SearchSCreenState extends State<SearchSCreen> {
  TextEditingController controller = TextEditingController();
  bool initialLoad = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          cursorColor: Colors.white,
          controller: controller,
          autofocus: initialLoad,
          style: TextStyle(color: Colors.white, fontSize: 22),
          decoration: InputDecoration(
              border: InputBorder.none,
              suffixIcon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              hintText: 'Search location...',
              hintStyle: TextStyle(color: Colors.white30, fontSize: 20)),
        ),
        backgroundColor: Color(0xFF398D3C),
      ),
      backgroundColor: Color(0xFFFAF4E9),
    );
  }
}
