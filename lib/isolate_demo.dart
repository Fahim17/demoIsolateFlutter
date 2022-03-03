// import 'dart:async';
// import 'dart:convert';
// import 'dart:isolate';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// void main() {
//   runApp(MyApp());
// }

// void showConsole(timer) async {
//   //print('finalNum: ${timer.tick}');
//   final response = await http.post(
//     Uri.parse('http://192.168.68.129:5000/myteams/updatememberactivity'),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(<String, String>{
//       "mobile": "8600",
//       "syncCode": "JOm2KmYy46AO",
//       "activityType": "ping",
//       "lat": "22",
//       "long": "91",
//       "pedoCount": "${timer.tick}",
//       "batteryStatus": "554",
//       "date": "24-02-2022"
//     }),
//   );
//   print('response: ${response.body}');
// }

// isolateFunction(int finalNum) {
//   Timer.periodic(const Duration(seconds: 3), showConsole);
// }

// // int computeFunction(int finalNum) {
// //   int _count = 0;

// //   for (int i = 0; i < finalNum; i++) {
// //     _count++;
// //     if ((_count % 100) == 0) {
// //       print("compute: " + _count.toString());
// //     }
// //   }
// //   return _count;
// // }

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
//     Isolate.spawn(isolateFunction, 1000);
//     super.initState();
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
