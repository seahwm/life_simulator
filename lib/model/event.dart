import 'package:life_simulator/model/status.dart';

import 'option.dart';

class Event {
  final String text;
  final List<Option> option;
  late String Function(Status) defaultEvent;
  late String dsc;
  int? age;

  Event(this.text, this.option, {String Function(Status)? def,String? dsc}) {
    if (def == null) {
      this.defaultEvent = (status) => "";
    } else {
      this.defaultEvent = def;
    }
    if(dsc!=null){
      this.dsc=dsc;
    }else{
      this.dsc="";
    }
  }

  Event clone(){
    return Event(text, option,def: defaultEvent,dsc: dsc);
  }
}
