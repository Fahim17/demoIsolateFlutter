// import 'dart:async';
// import 'dart:convert';
// import 'dart:isolate';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'package:location/location.dart';
// import 'package:flutter_isolate/flutter_isolate.dart';

// double lat = 0.0;
// double long = 0.0;
// Future<void> main() async {
//   runApp(MyApp());
// }

// isolateFunction(String finalNum) {
//   Timer.periodic(const Duration(seconds: 5), sendActivity);
// }

// void sendActivity(timer) async {
//   Position? position = await Geolocator.getCurrentPosition();
//   if (position != null) {
//     lat = position.latitude;
//     long = position.longitude;
//   }

//   print('latlong: $lat, $long');

//   final response = await http.post(
//     Uri.parse('http://192.168.68.129:5000/myteams/updatememberactivity'),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(<String, String>{
//       "mobile": "8600",
//       "syncCode": "JOm2KmYy46AO",
//       "activityType": "ping",
//       "lat": lat.toString(),
//       "long": long.toString(),
//       "pedoCount": "${timer.tick}",
//       "batteryStatus": "554",
//       "date": "24-02-2022"
//     }),
//   );
//   print('response: ${response.statusCode}');
// }

// Future<void> locationPermission() async {
//   //----------- Location------------
//   Location location = new Location();
//   late bool _serviceEnabled;
//   late PermissionStatus _permissionGranted;

//   _serviceEnabled = await location.serviceEnabled();
//   if (!_serviceEnabled) {
//     _serviceEnabled = await location.requestService();
//     if (!_serviceEnabled) {
//       return;
//     }
//   }

//   _permissionGranted = await location.hasPermission();
//   if (_permissionGranted == PermissionStatus.denied) {
//     _permissionGranted = await location.requestPermission();
//     if (_permissionGranted != PermissionStatus.granted) {
//       return;
//     }
//   }
//   // Position? position = await Geolocator.getCurrentPosition();
//   // if (position != null) {
//   //   lat = position.latitude;
//   //   long = position.longitude;
//   // }
//   // print('latlong: $lat, $long');

// //------------------------------------------------------
// }

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key}) : super(key: key);

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int count = 0;

//   @override
//   void initState() {
//     super.initState();
//     locationPermission();
//   }

//   // Future<void> runCompute() async {
//   //   count = await compute(computeFunction, 2000);
//   //   setState(() {});
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Isolates Demo"),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(count.toString()),
//             ElevatedButton(
//               child: Text("Add"),
//               onPressed: () async {
//                 count++;
//                 final isolate =
//                     await FlutterIsolate.spawn(isolateFunction, "hello");
//                 setState(() {});
//               },
//             ),
//             // ElevatedButton(
//             //   child: Text("Add in Isolate"),
//             //   onPressed: runCompute,
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }
