import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GoogleMaps(),
    );
  }
}

class GoogleMaps extends StatefulWidget {
  @override
  _GoogleMapsState createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  int count = 1;
  String locationText = 'Bangalore';
  List locations = [
    ['Bangalore', LatLng(12.9716, 77.5946)],
    ['Bombay', LatLng(19.0760, 72.8777)],
    ['Delhi', LatLng(28.7041, 77.1025)],
    ['Chennai', LatLng(13.0827, 80.2707)],
    ['Kolkata', LatLng(22.5726, 88.3639)],
    ['Jaipur', LatLng(26.9124, 75.7873)]
  ];

  GoogleMapController myController;
  static LatLng _center = const LatLng(12.9716, 77.5946);
  Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    myController = controller;
  }

  LatLng _lastMapPosition = _center;

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId(_lastMapPosition.toString()),
          position: _lastMapPosition,
          infoWindow: InfoWindow(title: 'Location'),
          icon: BitmapDescriptor.defaultMarker));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF398D3C),
        centerTitle: true,
        title: Text('Sample Map App'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Stack(
              children: <Widget>[
                GoogleMap(
                  onCameraMove: _onCameraMove,
                  markers: _markers,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 11.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Column(
                      children: <Widget>[
                        FloatingActionButton(
                          onPressed: _onAddMarkerButtonPressed,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          backgroundColor: Color(0xFF398D3C),
                          child: Icon(
                            Icons.add_location,
                            size: 36,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        FloatingActionButton.extended(
                          backgroundColor: Color(0xFF398D3C),
                          onPressed: _locationOnPressed,
                          label: Text('Next'),
                          icon: Icon(Icons.navigate_next),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton.extended(
                      onPressed: () {},
                      label: Text(locationText),
                      icon: Icon(Icons.my_location),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 2,
            width: double.infinity,
            color: Color(0xFF398D3C),
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(color: Color(0xFF398D3C)),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: (){
                      _tileOnPressed(index);
                      setState(() {
                        count=index+1;
                        locationText = locations[index][0];
                      });
                    },
                    child: Card(
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            trailing: Icon(Icons.my_location),
                            title: Text('${locations[index][0]}'),
                          )
                        ],
                      ),
                    ),
                  );
                },
                itemCount: locations.length,
              ),
            ),
          )
        ],
      ),
    );
  }

  void _tileOnPressed(int index) {
    myController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: locations[index][1],
      zoom: 8,
    )));
  }

  void _locationOnPressed() {
    if (count < locations.length) {
      myController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: locations[count][1],
        zoom: 8,
      )));
      setState(() {
        locationText = locations[count][0];
        _center = locations[count][1];
        count++;
      });
    } else {
      count = 0;
      _locationOnPressed();
    }
  }
}
