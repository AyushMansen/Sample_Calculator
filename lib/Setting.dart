import 'package:flutter/material.dart';
import 'Api.dart';
import 'main.dart';

class Setting extends StatefulWidget {
  final ValueChanged<bool> set;
  final StateController Scontroller;
  const Setting(this.Scontroller, {required this.set, Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState(Scontroller, st: set);
}

class _SettingState extends State<Setting> {
  final ValueChanged<bool> st;
  _SettingState(StateController _controller, {required this.st}) {
    _controller.stateCng = stateCng;
  }

  void stateCng() => setState(() {});

  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          width: 5.0,
          color: bordercolor,
        ),
        color: textcolor,
      ),
      child: ListView(
        children: [
          ListTile(
            title: Text("Change Mode", style: themeformat,),
            subtitle: Text((light)?"Light mode":"Dark mode", style: TextStyle(fontSize: 15, color: themeformat.color,),),
            trailing: GestureDetector(
                child: Icon((light)?Icons.brightness_7_rounded:Icons.brightness_3_rounded, color: (light)?Colors.grey.shade800:Colors.white,),
                onTap: () {
                  setState(() {
                    light = !light;
                    st(light);
                  });
                }
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}