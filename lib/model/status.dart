enum Condition {
  BULLY,
}

Map<Condition, String Function(Status)> conditionEvent = {
  Condition.BULLY: (status) {
    status.health -= 5;
    return StatusChanges(health: -5,conditionEvent: Condition.BULLY).toString();
  },
};

class Status {
  int iq = 100;
  int health = 100;
  int atk = 0;
  int gold = 0;
  int age = 0;
  int luck = 0;
  List<Condition> conditions = [];
}

class StatusChanges {
  int iq = 0;
  int health = 0;
  int atk = 0;
  int gold = 0;
  int luck = 0;
  List<Condition> conditions=[];
  Condition? conditionEvent =null;

  StatusChanges({int? iq, int? health, int? atk, int? gold, int? luck,List<Condition>? conditions, Condition? conditionEvent}) {
    if (iq != null) {
      this.iq = iq;
    }
    if (health != null) {
      this.health = health;
    }
    if (atk != null) {
      this.atk = atk;
    }
    if (gold != null) {
      this.gold = gold;
    }
    if (luck != null) {
      this.luck = luck;
    }
    if(conditions!=null){
      this.conditions =conditions;
    }
    if(conditionEvent!=null){
      this.conditionEvent=conditionEvent;
    }
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    if(conditionEvent!=null){
      buffer.write("因为 ");
      buffer.write(conditionEvent!.name);
      buffer.write(":\n");
    }
    if (iq != 0) {
      buffer.write("IQ: ");
      buffer.write(iq > 0 ? "+" : "");
      buffer.write(iq.toString()+" ");
    }
    if (health != 0) {
      buffer.write("Health: ");
      buffer.write(health > 0 ? "+" : "");
      buffer.write(health.toString()+" ");
    }
    if (atk != 0) {
      buffer.write("ATK: ");
      buffer.write(atk > 0 ? "+" : "");
      buffer.write(atk.toString()+" ");
    }
    if (gold != 0) {
      buffer.write("GOLD: ");
      buffer.write(gold > 0 ? "+" : "");
      buffer.write(gold.toString()+" ");
    }
    if (luck != 0) {
      buffer.write("LUCK: ");
      buffer.write(luck > 0 ? "+" : "");
      buffer.write(luck.toString()+" ");
    }
    if(conditions.isNotEmpty){
      buffer.write("你被上了 ");
      for(final c in conditions){
        buffer.write(c.name+" ");
      }
      buffer.write("状态 ");
    }

    return buffer.toString();
  }
}
