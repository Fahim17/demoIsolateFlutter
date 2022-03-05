import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:battery_plus/battery_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'package:location/location.dart';
import 'package:intl/intl.dart';

String androidId = '';
double? lat = 0.0;
double? long = 0.0;
String formattedDate = '';
String mobileNo = '';
String syncCode = '';
String batteryStatus = '10';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
//----------- Battery------------
  // final Battery _battery = Battery();

  // BatteryState? _batteryState;
  // StreamSubscription<BatteryState>? _batteryStateSubscription;

  // _battery.batteryState.then(_updateBatteryState);
  // _batteryStateSubscription =
  //     _battery.onBatteryStateChanged.listen(_updateBatteryState);

//----------- Location------------
  Location location = new Location();
  location.enableBackgroundMode();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }
  }

//------------------------------------------------------
  //await initializeService();
  print('THIS IS MAIN FUNCTION');
  runApp(MyApp());
}
// void _updateBatteryState(BatteryState state) {
//   if (_batteryState == state) return;
//   _batteryState = state;
// }

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
}

void onIosBackground() {
  WidgetsFlutterBinding.ensureInitialized();
  print('FLUTTER BACKGROUND FETCH');
}

void onStart() {
  WidgetsFlutterBinding.ensureInitialized();

  final service = FlutterBackgroundService();
  service.onDataReceived.listen((event) {
    if (event!["action"] == "setAsForeground") {
      service.setForegroundMode(true);
      return;
    }

    if (event["action"] == "setAsBackground") {
      service.setForegroundMode(false);
    }

    if (event["action"] == "stopService") {
      service.stopBackgroundService();
    }
  });
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Location;
  // bring to foreground
  service.setForegroundMode(true);
  Timer.periodic(const Duration(seconds: 5), (timer) async {
    //if (!(await service.isServiceRunning())) timer.cancel();
    service.setNotificationInfo(
      title: "Background Service testing",
      content: "Updated at ${DateTime.now()}",
    );
//----------------------------------

    final info = await deviceInfoPlugin.androidInfo;
    androidId = info.androidId.toString();
    //print('android Id :' + androidId);

    // var battery = Battery();
    // batteryStatus = await battery.batteryLevel.toString();
    //print('Battery: $batteryStatus');

    Position? position = await Geolocator.getCurrentPosition();
    if (position != null) {
      lat = position.latitude;
      long = position.longitude;
    }
    print('latlong: $lat, $long');

    var now = DateTime.now();
    var formatter = DateFormat('dd-MM-yyyy');
    formattedDate = formatter.format(now);
    //print('date: $formattedDate');
//----------------------------------

    if (mobileNo == '' && syncCode == '') {
      getMobileAndSync();
    } else {
      sendActivity(timer);
    }

    service.sendData(
      {
        //"current_date": DateTime.now().toIso8601String(),
      },
    );
  });
}

// void getOtherData() {}
void getMobileAndSync() async {
  try {
    print('asdhoasgno: ${androidId.toString()}');
    final response = await http.post(
      Uri.parse('http://192.168.68.129:5000/myteams/validmember'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{"deviceSerial": androidId}),
    );
    var json = jsonDecode(response.body);
    //print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      mobileNo = json['mobile'].toString();
      syncCode = json['syncCode'].toString();
      print('Find Member success');
    } else {
      print('Member Not Found');
    }
  } catch (e) {
    print('getMobileAndSync Exception:$e');
  }
}

void sendActivity(Timer timer) async {
  try {
    final response = await http.post(
      Uri.parse('http://192.168.68.129:5000/myteams/updatememberactivity'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "mobile": mobileNo,
        "syncCode": syncCode,
        "activityType": "ping",
        "lat": lat.toString(),
        "long": long.toString(),
        "pedoCount": "${timer.tick}",
        "batteryStatus": batteryStatus,
        "date": formattedDate
      }),
    );
  } catch (e) {
    print('sendActivity Exception:$e');
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int count = 0;

  @override
  void initState() {
    super.initState();
  }

  // Future<void> runCompute() async {
  //   count = await compute(computeFunction, 2000);
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Isolates Demo"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(count.toString()),
            ElevatedButton(
              child: Text("Add"),
              onPressed: () async {
                count++;
                await initializeService();
                setState(() {});
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: Text("Stop"),
              onPressed: () async {
                count--;
                final service = FlutterBackgroundService();
                var isRunning = await service.isServiceRunning();
                if (isRunning) {
                  service.sendData(
                    {"action": "stopService"},
                  );
                }
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
