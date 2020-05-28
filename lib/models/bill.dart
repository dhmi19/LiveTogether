
import 'billItem.dart';

class Bill {

  List<BillItem> items;
  String title;
  bool isSettled;
  String timeStamp;

  Bill({this.items, this.title, this.isSettled, this.timeStamp});

}