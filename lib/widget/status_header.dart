import 'package:flutter/cupertino.dart';

import '../model/status.dart';

class StatusHeader extends StatelessWidget {
  final Status status;

  const StatusHeader(this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("IQ=${status.iq}"),
          Text("GOLD=${status.gold}"),
          Text("LUCK=${status.luck}"),
          Text("HEALTH=${status.health}"),
        ],
      ),
    );
  }
}
