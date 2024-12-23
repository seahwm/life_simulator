import 'package:life_simulator/model/option.dart';
import 'package:life_simulator/model/status.dart';
import 'package:life_simulator/model/event.dart';

class _Idc {
  static String DEFAULT = "default";
  static String CHILD = "child";
  static String SCHOOL = "school";
  static String COLLEGE = "college";
  static String FACTORY = "factory";
}

class SimpleEventManager {
  Status status = Status();
  final List<Event> _childRandomEvent = [
    Event('你第一次吃大便，发现蛮好吃的', [], def: (status) {
      status.iq -= 5;
      status.health -= 5;
      return StatusChanges(iq: -5, health: -5).toString();
    }),
    Event('你父母生了个2胎，从此你的宠爱就被分走了', [], def: (status) {
      status.health -= 5;
      return StatusChanges(health: -5).toString();
    }),
    Event('你父母中彩票，你成为富二代了', [], def: (status) {
      status.gold += 10000;
      return StatusChanges(gold: 10000).toString();
    }),
    Event('你父母买了很多书给你读', [], def: (status) {
      status.iq += 10;
      return StatusChanges(iq: 10).toString();
    }),
    Event('你对世界万物都很好奇', [], def: (status) {
      status.iq += 10;
      return StatusChanges(iq: 10).toString();
    }),
    Event('路过的算命大师说你骨骼惊奇，将来必成大事', [], def: (status) {
      status.iq += 10;
      status.health += 10;
      status.luck += 10;
      status.atk += 10;
      return StatusChanges(iq: 10, health: 10, luck: 10, atk: 10).toString();
    }),
    Event('你偷看到父母做爱，对你造成了极大的心理阴影', [], def: (status) {
      status.health -= 10;
      return StatusChanges(health: -10).toString();
    }),
  ];

  final List<Event> _schoolRandomEvent = [
    Event('你考试考到第一名', [], def: (status) {
      status.iq += 3;
      return StatusChanges(iq: 3).toString();
    }),
    Event('你因为讲太多干话，被校园霸凌了', [], def: (status) {
      status.conditions.add(Condition.BULLY);
      return StatusChanges(conditions: [Condition.BULLY]).toString();
    }),
    Event(
      '你WM哥要做大事，他问你要不要一起',
      [
        Option("一起", (evManager) {
          evManager.status.iq += 100;
          return "你选了\"一起\" ${StatusChanges(iq: 100).toString()}";
        }),
        Option("滚", (evManager) {
          evManager.status.iq -= 100;
          evManager.status.gold -= 1000;
          return "你选了\"滚\" ${StatusChanges(iq: -100, gold: -1000).toString()}";
        })
      ],
    ),
  ];

  final List<Event> _factoryRandomEvent = [
    Event('你考试考到第一名', [], def: (status) {
      status.iq += 3;
      return StatusChanges(iq: 3).toString();
    }),
    Event('你因为讲太多干话，被职场霸凌了', [], def: (status) {
      status.conditions.add(Condition.BULLY);
      return StatusChanges(conditions: [Condition.BULLY]).toString();
    }),
  ];

  late Map<String, List<Event>> _allEvent;

  Event defEvent = Event("你出生了", []);

  String idc = _Idc.DEFAULT;

  bool end = false;
  int idx = 0;

  SimpleEventManager() {
    _allEvent = {
      _Idc.DEFAULT: [defEvent],
      _Idc.CHILD: _childRandomEvent,
      _Idc.SCHOOL: _schoolRandomEvent,
      _Idc.COLLEGE: _schoolRandomEvent,
      _Idc.FACTORY: _factoryRandomEvent,
    };
  }

  bool get endIdc {
    return end;
  }

  List<Event> CurrentEvent() {
    return _allEvent[idc]!;
  }

  String preGetNextEvent() {
    String dsc = "";
    if (status.conditions.isNotEmpty) {
      for (Condition con in status.conditions) {
        dsc += conditionEvent[con]!(status) + "\n";
      }
    }
    if (status.age > 0 && status.age <= 7) {
      setIdc(_Idc.CHILD);
      _childRandomEvent.shuffle();
    }
    if (status.age > 7 && status.age < 18) {
      setIdc(_Idc.SCHOOL);
      _schoolRandomEvent.shuffle();
    }
    return dsc;
  }

  Event getNextEvent() {
    String dsc = preGetNextEvent();
    List<Event> evList = CurrentEvent();
    if (evList.length == idx) {
      end = true;
      Event endEv = Event("End", []);
      endEv.age = status.age;
      return endEv;
    }
    Event ev = evList[idx].clone();
    if (dsc.isNotEmpty) {
      dsc += "\n";
    }
    dsc += ev.defaultEvent(status);
    ev.dsc = dsc;
    ev.age = status.age;
    idx++;
    status.age++;
    return ev;
  }

  void setIdc(String idc) {
    this.idc = idc;
    idx = 0;
  }

  List<Option> getOption() {
    Event ev = _childRandomEvent[idx];
    return ev.option;
  }
}
