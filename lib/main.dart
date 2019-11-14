
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_app_dummy_client/cities_helper.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
  CitiesHelper helper = CitiesHelper();

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

  String jsonData;
  bool loading = false;
  List citiesList;
  List<City> cityObjects = [];

  void getJsonCitiesList() async {
    loading = true;
    setState(() {});
    citiesList = await helper.loadJson();
    print('start');
    for (int i = 0; i < citiesList.length; i++) {
      cityObjects.add(City(
          country: citiesList[i]['country'],
          lat: double.parse(citiesList[i]['lat']),
          lng: double.parse(citiesList[i]['lng']),
          name: citiesList[i]['name']));
    }
    print('stop');
    loading = false;
    setState(() {});
  }

  @override
  void initState() {
//    SystemChrome.setEnabledSystemUIOverlays([]);
    getJsonCitiesList();
    // TODO: implement initState
    super.initState();
  }

  City cityFromSearchScreen;
  City currentCity = City(name: 'New Delhi',country: "IN",lat: 28.6139,lng: 77.2090 );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: loading,
        child: SafeArea(
          child: Column(
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
                        target: LatLng(28.6139, 77.2090),
                        zoom: 11.0,
                      ),
                    ),
                    Positioned(
                      top: 10,
                      child: GestureDetector(
                        onTap: () async {
                          cityFromSearchScreen = await showSearch(
                              context: context,
                              delegate: SearchCities(cities: cityObjects));
                          print('==================');
                          myController.animateCamera(
                              CameraUpdate.newCameraPosition(CameraPosition(
                            target: LatLng(cityFromSearchScreen.lat,
                                cityFromSearchScreen.lng),
                            zoom: 11,
                          )));
                          currentCity = cityFromSearchScreen;
                          setState(() {});
                        },
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.9),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 28.0),
                                child: Text('Search'),
                              ),
                              Spacer(),
                              IconButton(
                                icon: Icon(Icons.search),
                                onPressed: () {
                                  showSearch(
                                      context: context,
                                      delegate: SearchCities());

                                  print('hey');
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: Column(
                        children: <Widget>[
                          FloatingActionButton(
                            heroTag: 'marker',
                            onPressed: _onAddMarkerButtonPressed,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.add_location,
                              size: 36,color: Color(0xFF398D3C),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton.extended(
                          heroTag: currentCity,
                          onPressed: () {
                            myController.animateCamera(
                                CameraUpdate.newCameraPosition(CameraPosition(
                                  target: LatLng(currentCity.lat,
                                      currentCity.lng),
                                  zoom: 11,
                                )));
                          },
                          label: Text('${currentCity.country},${currentCity.name}'),
                          icon: Icon(Icons.my_location),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchCities extends SearchDelegate<City> {
  SearchCities({this.cities});

  List<City> cities;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          close(context, null);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.search),
      onPressed: () {},
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    var suggestion = cities.where((city)=> city.name.toLowerCase().contains(query.toLowerCase())).toList();
    return  ListView.builder(
      itemCount: suggestion.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            close(context, suggestion[index]);
          },
          title: Text('${suggestion[index].country},${suggestion[index].name}'),
          leading: Icon(Icons.location_searching),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions

    var suggestion = cities
        .where((city) => city.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return query == ''
        ? Container()
        : ListView.builder(
            itemCount: suggestion.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  close(context, suggestion[index]);
                },
                title: Text('${suggestion[index].country},${suggestion[index].name}'),
                leading: Icon(Icons.location_searching),
              );
            },
          );
  }
}
