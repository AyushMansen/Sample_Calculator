//...Imports...//
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Api.dart';
import 'Calc.dart';
import 'Setting.dart';

//...Main App.............................//
void main() {
  runApp(CalcScreen());
}

//...State Controller....................//
class StateController {
  late void Function() stateCng;
  late void Function() stateAppCng;
}

String _route = "Calc";


//...App.................................//
class CalcScreen extends StatelessWidget {
  CalcScreen({Key? key}) : super(key: key);
  final StateController stController = StateController();

  @override
  Widget build(BuildContext context) {
    read().then((value) async {
      await value;
      setCol(light);
    });
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.grey,
        //accentColor: Colors.red[200],
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Appbar(stController, set: _setMode),
          toolbarHeight: 40,
        ),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Calc(stController),
        ),
      ),
    );
  }

  void _setMode(bool x) {
    setCol(x);
    stController.stateCng();
  }
}

class SetScreen extends StatelessWidget {
  SetScreen({Key? key}) : super(key: key);
  final StateController stController = StateController();

  @override
  Widget build(BuildContext context) {
    read().then((value) async {
      await value;
      setCol(light);
    });
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.grey,
        //accentColor: Colors.red[200],
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Appbar(stController, set: _setMode),
          toolbarHeight: 40,
        ),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Setting(stController, set: _setAppMode),
        ),
      ),
    );
  }

  void _setAppMode(bool x) {
    setCol(x);
    stController.stateAppCng();
  }

  void _setMode(bool x) {
    setCol(x);
    stController.stateCng();
  }
}

//...Appbar...............................//
class Appbar extends StatefulWidget {
  final ValueChanged<bool> set;
  final StateController AController;
  Appbar(this.AController, {required this.set, Key? key}) : super(key: key);

  @override
  _AppbarState createState() => _AppbarState(AController, st: set);
}

class _AppbarState extends State<Appbar> {
  final ValueChanged<bool> st;
  _AppbarState(StateController _controller, {required this.st}) {
    read().then((value) async {
      await value;
      setState(() {});
    });
    _controller.stateAppCng = stateAppCng;
  }

  void stateAppCng() {
    read().then((value) async {
      await value;
      setState(() {});
    });
  }


  Widget build(BuildContext context) {
    read().then((value) async {
      await value;
      setState(() {});
    });
    return Row (
      key: ValueKey<bool>(light),
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: IconButton(
            icon: Icon(Icons.settings, color: (light)?Colors.black:Colors.white,),
            tooltip: 'Settings',
            onPressed: () {
              //print('Go To Settings');
              if (_route == "Calc") {
                _route = "Setting";
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SetScreen()),
                );
              }
              else {
                _route = "Calc";
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CalcScreen()),
                );
              }
            },
          ),
        ),
        Expanded(
          flex: 5,
          child: Text(
            'CALCULATOR',
            style: themeformat,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 1,
          child: IconButton(
            icon: (light)?Icon(Icons.brightness_7_rounded, color: Colors.black,):Icon(Icons.brightness_3_rounded, color: Colors.white,),
            tooltip: 'Mode',
            onPressed: () {
              setState(() {
                //print('Changed Mode');
                light = !light;
                st(light);
                save();
              });
            },
          ),
        ),
      ],
    );
  }
}