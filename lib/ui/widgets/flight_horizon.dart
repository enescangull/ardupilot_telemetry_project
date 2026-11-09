import 'package:flutter/material.dart';

class FlightHorizon extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        children: [
          Icon(Icons.circle, size: 50),
          GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            children: [
              Column(children: [Text('Yatış')]),
              Column(children: [Text('Dikey Hız')]),
              Column(children: [Text('Yunuslama')]),
              Column(children: [Text('Uçuş Süresi')]),
            ],
          ),
        ],
      ),
    );
  }
}
