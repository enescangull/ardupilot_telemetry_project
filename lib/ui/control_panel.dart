import 'package:flutter/material.dart';

class ControlPanel extends StatefulWidget {
  const new({super.key});

  @override
  State<ControlPanel> createState() => _ControlPanelState();
}

class _ControlPanelState extends State<ControlPanel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ElevatedButton(onPressed: () {}, child: Text('ARM')),
          ElevatedButton(onPressed: () {}, child: Text('DISARM')),
        ],
      ),
    );
  }
}
