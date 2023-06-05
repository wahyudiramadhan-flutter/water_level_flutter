// ignore_for_file: use_key_in_widget_constructors

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:neumorphic_button/neumorphic_button.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RealtimeDataScreen(),
      theme: ThemeData.dark(),
    ),
  );
}

class RealtimeDataScreen extends StatefulWidget {
  @override
  _RealtimeDataScreenState createState() => _RealtimeDataScreenState();
}

class _RealtimeDataScreenState extends State<RealtimeDataScreen> {
  late DatabaseReference _databaseReference;
  late StreamSubscription _dataSubscription;
  var isLoading = true;
  String _waterLevel = '';
  @override
  void initState() {
    super.initState();
    _databaseReference = FirebaseDatabase.instance.ref().child('waterlevel');
    _dataSubscription = _databaseReference.onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          _waterLevel = event.snapshot.value.toString();
          isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _dataSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: const Text(
          'WaterLevel Apps',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
      body: Center(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : NeumorphicButton(
                width: MediaQuery.of(context).size.width * .95,
                height: MediaQuery.of(context).size.height * 9,
                onTap: () {},
                borderRadius: 12,
                bottomRightShadowBlurRadius: 15,
                bottomRightShadowSpreadRadius: 1,
                borderWidth: 5,
                backgroundColor: Colors.grey.shade900,
                topLeftShadowBlurRadius: 15,
                topLeftShadowSpreadRadius: 1,
                topLeftShadowColor: Colors.grey.shade800,
                bottomRightShadowColor: Colors.black,
                padding: const EdgeInsets.all(50),
                bottomRightOffset: const Offset(4, 4),
                topLeftOffset: const Offset(-4, -4),
                child: LiquidLinearProgressIndicator(
                  value: double.parse(_waterLevel), // Defaults to 0.5.
                  valueColor: AlwaysStoppedAnimation(Colors
                      .blue), // Defaults to the current Theme's accentColor.
                  backgroundColor: Colors.grey
                      .shade900, // Defaults to the current Theme's backgroundColor.
                  borderColor: Colors.blue,
                  borderWidth: 5.0,
                  borderRadius: 12.0,
                  direction: Axis
                      .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
                  center: Text("${double.parse(_waterLevel) * 100} %"),
                ),
              ),
      ),
    );
  }
}
