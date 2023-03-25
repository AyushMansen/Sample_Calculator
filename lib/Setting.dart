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
    read().then((value) async {
      await value;
      setState(() {});
    });
    _controller.stateCng = stateCng;
  }

  void stateCng() {
    read().then((value) async {
      await value;
      setState(() {});
    });
  }

  @override
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
                    save();
                    st(light);
                  });
                }
            ),
          ),
          const Divider(),
          ListTile(
            title: Text("Angle Representation", style: themeformat,),
            subtitle: Text((rad)?"Radian":"Degree", style: TextStyle(fontSize: 15, color: themeformat.color,),),
            trailing: GestureDetector(
                child: Icon((rad)?Icons.toggle_on:Icons.toggle_off_outlined, color: (light)?Colors.grey.shade800:Colors.white,),
                onTap: () {
                  setState(() {
                    rad = !rad;
                    save();
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
