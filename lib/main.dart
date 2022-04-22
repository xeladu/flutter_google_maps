import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BitmapDescriptor? _customIcon;
  GoogleMapController? _controller;
  Location? _location;

  @override
  void initState() {
    super.initState();

    _initLocationService();
  }

  // check if service enabled
  // ask to enable service
  // check if permission granted
  // ask for permission
  Future _initLocationService() async {
    _location = Location();

    if (!await _location!.serviceEnabled()) {
      if (!await _location!.requestService()) {
        return;
      }
    }

    var permission = await _location!.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await _location!.requestPermission();
      if (permission != PermissionStatus.granted) {
        return;
      }
    }

    var loc = await _location!.getLocation();
    print("${loc.latitude} ${loc.longitude}");
  }

  Future _setCustomMarkerImage() async {
    if (_customIcon != null) return;

    // replaces the default marker with an asset image "icon.png"
    final ImageConfiguration imageConfiguration =
        createLocalImageConfiguration(context, size: const Size.square(24));
    var bmp = await BitmapDescriptor.fromAssetImage(
        imageConfiguration, "icon.png",
        mipmaps: false);
    setState(() {
      _customIcon = bmp;
    });
  }

  Future _moveToBerlin() async {
    _controller!.moveCamera(CameraUpdate.newLatLng(
        const LatLng(52.52309894124325, 13.413122125924026)));
  }

  Future _animateToBerlin() async {
    _controller!.animateCamera(CameraUpdate.newLatLng(
        const LatLng(52.52309894124325, 13.413122125924026)));
  }

  Future _moveToCurrentLocation() async {
    var loc = await _location!.getLocation();

    if (loc.latitude == null || loc.longitude == null) return;

    _controller!.moveCamera(
        CameraUpdate.newLatLng(LatLng(loc.latitude!, loc.longitude!)));
  }

  Future _animateToCurrentLocation() async {
    var loc = await _location!.getLocation();

    if (loc.latitude == null || loc.longitude == null) return;

    _controller!.animateCamera(
        CameraUpdate.newLatLng(LatLng(loc.latitude!, loc.longitude!)));
  }

  @override
  Widget build(BuildContext context) {
    _setCustomMarkerImage();
    return Scaffold(
        bottomNavigationBar: BottomAppBar(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
              IconButton(
                  icon: const Icon(
                    Icons.forward,
                    color: Colors.blue,
                  ),
                  onPressed: () async => await _animateToBerlin()),
              IconButton(
                  icon: const Icon(
                    Icons.pin_drop,
                    color: Colors.blue,
                  ),
                  onPressed: () async => await _animateToCurrentLocation()),
              IconButton(
                  icon: const Icon(Icons.fast_forward),
                  color: Colors.blue,
                  onPressed: () async => await _moveToBerlin()),
            ])),
        body: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: GoogleMap(
                onMapCreated: (controller) async {
                  _controller = controller;
                  await _moveToCurrentLocation();
                },
                onTap: (latlng) =>
                    print("onTap: ${latlng.latitude} ${latlng.longitude}"),
                onLongPress: (latlng) => print(
                    "onLongPress: ${latlng.latitude} ${latlng.longitude}"),
                onCameraMove: (cp) => print(
                    "onCameraMove: ${cp.target.latitude} ${cp.target.longitude}"),
                compassEnabled: true,
                myLocationButtonEnabled: true,
                rotateGesturesEnabled: true,
                zoomControlsEnabled: true,
                zoomGesturesEnabled: true,
                myLocationEnabled: true,
                markers: <Marker>{
                  Marker(
                      markerId: const MarkerId("BerlinMarker"),
                      rotation: 180,
                      consumeTapEvents: true,
                      onTap: () => print(
                          "infoWindow is ignored, if consumeTapEvents is true!"),
                      infoWindow: const InfoWindow(
                          title: "Berlin",
                          snippet:
                              "Location is 52.52309894124325, 13.413122125924026"),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueAzure),
                      position:
                          const LatLng(52.52309894124325, 13.413122125924026)),
                  Marker(
                      markerId: const MarkerId("StuttgartMarker"),
                      rotation: 270,
                      infoWindow: const InfoWindow(
                          title: "Stuttgart",
                          snippet:
                              "Location is 48.77538798756846, 9.18178996130423"),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueGreen),
                      position:
                          const LatLng(48.77538798756846, 9.18178996130423)),
                  Marker(
                      markerId: const MarkerId("FrankfurtMarker"),
                      rotation: 0,
                      infoWindow: const InfoWindow(
                          title: "Frankfurt",
                          snippet:
                              "Location is 50.11655301417056, 8.681184968800679"),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueViolet),
                      position:
                          const LatLng(50.11655301417056, 8.681184968800679)),
                  Marker(
                      markerId: const MarkerId("DüsseldorfMarker"),
                      rotation: 90,
                      infoWindow: const InfoWindow(
                          title: "Düsseldorf",
                          snippet:
                              "Location is 51.22837532659796, 6.78887549590447"),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueRose),
                      position:
                          const LatLng(51.22837532659796, 6.78887549590447)),
                  Marker(
                      markerId: const MarkerId("HamburgMarker"),
                      rotation: 135,
                      infoWindow: const InfoWindow(
                          title: "Hamburg",
                          snippet:
                              "Location is 53.556060743806164, 9.96687243215407"),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueMagenta),
                      position:
                          const LatLng(53.556060743806164, 9.96687243215407)),
                  (_customIcon == null)
                      ? const Marker(
                          markerId: MarkerId("MünchenMarker"),
                          rotation: 315,
                          infoWindow: InfoWindow(
                              title: "München",
                              snippet:
                                  "Location is 48.1272193947633, 11.555870900278869"),
                          position:
                              LatLng(48.1272193947633, 11.555870900278869))
                      : Marker(
                          markerId: const MarkerId("MünchenMarker"),
                          rotation: 315,
                          infoWindow: const InfoWindow(
                              title: "München",
                              snippet:
                                  "Location is 48.1272193947633, 11.555870900278869"),
                          icon: _customIcon!,
                          position: const LatLng(
                              48.1272193947633, 11.555870900278869))
                },
                circles: <Circle>{
                  Circle(
                      circleId: const CircleId("BerlinCircle"),
                      consumeTapEvents: true,
                      onTap: () => print("onTap: Berlin circle tapped"),
                      center:
                          const LatLng(52.52309894124325, 13.413122125924026),
                      radius: 25000,
                      fillColor: Colors.grey.shade300,
                      strokeWidth: 1,
                      strokeColor: Colors.black),
                  Circle(
                      circleId: const CircleId("StuttgartCircle"),
                      consumeTapEvents: true,
                      onTap: () => print("onTap: Stuttgart circle tapped"),
                      center: const LatLng(48.77538798756846, 9.18178996130423),
                      radius: 25000,
                      fillColor: Colors.grey.shade300,
                      strokeWidth: 1,
                      strokeColor: Colors.black),
                  Circle(
                      circleId: const CircleId("FrankfurtCircle"),
                      consumeTapEvents: true,
                      onTap: () => print("onTap: Frankfurt circle tapped"),
                      center:
                          const LatLng(50.11655301417056, 8.681184968800679),
                      radius: 25000,
                      fillColor: Colors.grey.shade300,
                      strokeWidth: 1,
                      strokeColor: Colors.black),
                  Circle(
                      circleId: const CircleId("DüsseldorfCircle"),
                      consumeTapEvents: true,
                      onTap: () => print("onTap: Düsseldorf circle tapped"),
                      center:
                          const LatLng(51.22837532659796, 6.788875495904476),
                      radius: 25000,
                      fillColor: Colors.grey.shade300,
                      strokeWidth: 1,
                      strokeColor: Colors.black),
                  Circle(
                      circleId: const CircleId("HamburgCircle"),
                      consumeTapEvents: true,
                      onTap: () => print("onTap: Hamburg circle tapped"),
                      center:
                          const LatLng(53.556060743806164, 9.96687243215407),
                      radius: 25000,
                      fillColor: Colors.grey.shade300,
                      strokeWidth: 1,
                      strokeColor: Colors.black),
                  Circle(
                      circleId: const CircleId("MünchenCircle"),
                      consumeTapEvents: true,
                      onTap: () => print("onTap: München circle tapped"),
                      center:
                          const LatLng(48.1272193947633, 11.555870900278869),
                      radius: 25000,
                      fillColor: Colors.grey.shade300,
                      strokeWidth: 1,
                      strokeColor: Colors.black)
                },
                initialCameraPosition: const CameraPosition(
                    zoom: 15,
                    target: LatLng(52.52309894124325, 13.413122125924026)))));
  }
}
