import 'package:hive/hive.dart';
import 'hiveObjectModal.dart';

class HiveDB {
  static put() async {
    var box = await Hive.openBox('myBox');

    box.put(0, {'naam': 'abul', 'phone': '0174'});

    print('putting data success');
  }
}
