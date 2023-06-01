import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:at_viz/at_viz.dart';
import 'package:neumorphic_button/neumorphic_button.dart';

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
                width: MediaQuery.of(context).size.width * .9,
                height: MediaQuery.of(context).size.width * .9,
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
                child: SimpleRadialGauge(
                  actualValue: double.parse(_waterLevel),
                  maxValue: 595,
                  minValue: 0,
                  title: const Text(
                    'WaterLevel Indicator',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  titlePosition: TitlePosition.top,
                  unit: 'Liter',
                  icon: const Icon(
                    Icons.water_drop_outlined,
                    color: Colors.blue,
                  ),
                  pointerColor: Colors.blue,
                  decimalPlaces: 2,
                  isAnimate: true,
                  animationDuration: 1000,
                  size: MediaQuery.of(context).size.width * .9,
                ),
              ),
      ),
    );
  }
}
