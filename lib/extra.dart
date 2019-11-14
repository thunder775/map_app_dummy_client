///// expanded tiles
//
//Expanded(
//flex: 1,
//child: Container(
//width: double.infinity,
//height: 40,
//decoration: BoxDecoration(color: Color(0xFF398D3C)),
//child: ListView.builder(
//itemBuilder: (context, index) {
//return GestureDetector(
//onTap: () {
//_tileOnPressed(index);
//setState(() {
//count = index + 1;
//locationText = locations[index][0];
//});
//},
//child: Card(
//child: Column(
//children: <Widget>[
//ListTile(
//trailing: Icon(Icons.my_location),
//title: Text('${locations[index][0]}'),
//)
//],
//),
//),
//);
//},
//itemCount: locations.length,
//),
//),
//)
///// just a finction
//void _tileOnPressed(int index) {
//  myController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//    target: locations[index][1],
//    zoom: 8,
//  )));
//}void _locationOnPressed() {
//    if (count < locations.length) {
//      myController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//        target: locations[count][1],
//        zoom: 8,
//      )));
//      setState(() {
//        locationText = locations[count][0];
//        _center = locations[count][1];
//        count++;
//      });
//    } else {
//      count = 0;
//      _locationOnPressed();
//    }
//  }
