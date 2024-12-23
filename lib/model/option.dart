import '../Manager/simple_event_manager.dart';

class Option {
  String optionNm;
  String Function(SimpleEventManager) onChoose;
  Option(this.optionNm, this.onChoose);
}
