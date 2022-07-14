//...Imports...//
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Api.dart';

//...Main App.............................//
void main() => runApp(MyApp());

//...State Controller....................//
class StateController {
  late void Function() stateCng;
}

//...Operational Variables..............//
String _val = '';
String _res = '0.0';
String _disp = '';
bool deg = false;


//...App.................................//
class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final StateController stController = StateController();

  @override
  Widget build(BuildContext context) {
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
          title: Appbar(set: _setMode),
          toolbarHeight: 40,
        ),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Calc(controller: stController,),
        ),
      ),
    );
  }

  void _setMode(bool x) {
    setCol(x);
    stController.stateCng();
  }
}

//...Clc: App body..........................//
class Calc extends StatefulWidget {
  final StateController controller;
  Calc({required this.controller, Key? key}) : super(key:key);

  @override
  _CalcState createState() => _CalcState(controller);
}

class _CalcState extends State<Calc> {
  _CalcState(StateController _controller) {
    _controller.stateCng = stateCng;
  }

  //change state...........................//
  void stateCng() => setState(() {});

  //display update.........................//
  void _update(String val) {
    setState(() {
      _val = val;
      _res = evaluate('('+_val+')');
      _disp = gen(_val);
    });
  }

  //...Key Preset.........................//
  Widget _key(String char, String value, Color color, {ck = false}) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        child: Container(
          height: double.infinity,
          padding: EdgeInsets.all(1.5),
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            child: Center(
              child: Text(
                char,
                style: themeformat,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        onTap: () {
          setState(() {
            if(_val=='') {
              _val += value;
            }
            else if("+-*/^".contains(value) && "+-*/^".contains(_val[_val.length-1])) {
              _val = _val.substring(0, _val.length-1) + value;
            }
            else {
              _val += value;
            }
            if(ck && deg) {_val += "(p/180)*";}
          });
          _update(_val);
        },
      ),
    );
  }

  //...Key Graphics........................//
  Widget _charkeydesign(String char, Color color) {
    return Container(
      height: double.infinity,
      padding: EdgeInsets.all(1.5),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Center(
          child: Text(
            char,
            style: themeformat,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _iconkeydesign(IconData icon, Color color) {
    return Container(
      height: double.infinity,
      padding: EdgeInsets.all(1.5),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Center(
          child: Icon(icon, color: txtcol,),
        ),
      ),
    );
  }

  //data for history.......................//
  List<String> _expList = [];
  List<String> _resList = [];

  //History display........................//
  Widget _tile(String _txt, String _sub, int id) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 1, color:textcolor),
          bottom: BorderSide(width: 1, color:textcolor),
        ),
      ),
      child: ListTile(
        title: Text(_txt, style:themeformat, overflow: TextOverflow.ellipsis,),
        subtitle: Text(_sub, style: TextStyle(fontSize: 20, color: themeformat.color), overflow: TextOverflow.ellipsis,),
        trailing: GestureDetector(
          child: Icon(Icons.add_circle_outline_sharp, color: bordercolor,),
          onTap: () {
            setState(() {
              _update(_val += _resList[id]);
            });
          },
        ),
        leading: GestureDetector(
            child: Icon(Icons.remove_circle, color: bordercolor,),
            onTap: () {
              setState(() {
                _resList.removeAt(id);
                _expList.removeAt(id);
              });
            }
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          //----DISPLAY---------------------------
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                color: textcolor,
                border: Border.all(
                  color: bordercolor,
                  width: 5.0,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                textDirection: TextDirection.ltr,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _disp,
                        style: themeformat,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        _res,
                        style: themeformat,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          //----HISTORY---------------------------
          Expanded(
            flex: 6,
            child: Container(
              decoration: BoxDecoration(
                color: boxcolor,
                border: Border.all(
                  color: bordercolor,
                  width: 5.0,
                ),
              ),
              alignment: Alignment.center,
              child: ListView.builder(
                reverse: true,
                itemBuilder:  (context, id) => _tile(_expList[id], _resList[id], id),
                itemCount: _expList.length,
              ),
            ),
          ),
          //----KEYBOARD--------------------------
          Expanded(
            flex: 9,
            child: Container(
              decoration: BoxDecoration(
                color: textcolor,
                border: Border.all(
                  color: bordercolor,
                  width: 5.0,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //~~~~ROW 1~~~~//
                  Expanded(
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            child: _iconkeydesign(Icons.backspace_rounded, boxcolor),
                            onTap: () {
                              setState(() {
                                if(_val.length!=0) {
                                  _val = _val.substring(0, _val.length-1);
                                  _update(_val);
                                }
                                else {
                                  _update("");
                                }
                              });
                            },
                            onLongPress: () {
                              setState(() {
                                _val = '';
                                _disp = '';
                                _res = '0.0';
                              });
                            },
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            child: _iconkeydesign(Icons.arrow_circle_left_outlined, boxcolor),
                            onTap: () {
                              setState(() {null;});
                            },
                            onLongPress: () {
                              setState(() {null;});
                            },
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            child: _iconkeydesign(Icons.arrow_circle_right_outlined, boxcolor),
                            onTap: () {
                              setState(() {null;});
                            },
                            onLongPress: () {
                              setState(() {null;});
                            },
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            child: _charkeydesign('(', keycolorbr),
                            onTap: () {
                              setState(() {
                                if(_val.length==0) {_val += '(';}
                                else {_val += !("+-*/^(".contains(_val[_val.length-1]))?"*(":"(";}
                                _update(_val);
                              });
                            },
                            onLongPress: () {
                              setState(() {null;});
                            },
                          ),
                        ),
                        _key(')', ')', keycolorbr),
                      ],
                    ),
                  ),
                  //~~~~ROW 2~~~~//
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _key("sin", (_val=='' || !"0123456789".contains(_val[_val.length-1]))?"s(":"*s(", keycolornum, ck: true),
                        _key("cos", (_val=='' || !"0123456789".contains(_val[_val.length-1]))?"c(":"*c(", keycolornum, ck: true),
                        _key("tan", (_val=='' || !"0123456789".contains(_val[_val.length-1]))?"t(":"*t(", keycolornum, ck: true),
                        _key("pi", "p", keycolorop),
                        _key("e", "e", keycolorop),
                      ],
                    ),
                  ),
                  //~~~~ROW 3~~~~//
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _key("1", "1", keycolornum),
                        _key("2", "2", keycolornum),
                        _key("3", "3", keycolornum),
                        _key("+", "+", keycolorop),
                        _key("^", "^", keycolorop),
                      ],
                    ),
                  ),
                  //~~~~ROW 4~~~~//
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _key("4", "4", keycolornum),
                        _key("5", "5", keycolornum),
                        _key("6", "6", keycolornum),
                        _key("-", "-", keycolorop),
                        _key("%", "%", keycolorop),
                      ],
                    ),
                  ),
                  //~~~~ROW 5~~~~//
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _key("7", "7", keycolornum),
                        _key("8", "8", keycolornum),
                        _key("9", "9", keycolornum),
                        _key("*", "*", keycolorop),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                              child: _charkeydesign("Ans", keycolorres),
                              onTap: () {
                                setState(() {
                                  _update(_val += _res);
                                });
                              }
                          ),
                        ),
                      ],
                    ),
                  ),
                  //~~~~ROW 6~~~~//
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                              child: _charkeydesign((deg)?"DEG":"RAD", (deg)?keycolorresasc:keycolorres),
                              onTap: () {
                                setState(() {
                                  deg = !deg;
                                });
                              }
                          ),
                        ),
                        _key("0", "0", keycolornum),
                        _key(".", (_val=='' || !"0123456789".contains(_val[_val.length-1]))?"0.":".", keycolorpt),
                        _key("/", "/", keycolorop),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            child: _charkeydesign("=", keycolorres),
                            onTap: () {
                              setState(() {
                                _update(_val);
                                _expList.add(_val);
                                _resList.add(_res);
                                _val='';_disp='';
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

//...Appbar...............................//
class Appbar extends StatefulWidget {
  final ValueChanged<bool> set;
  Appbar({required this.set, Key? key}) : super(key: key);

  @override
  _AppbarState createState() => _AppbarState(st: set);
}

class _AppbarState extends State<Appbar> {
  final ValueChanged<bool> st;
  _AppbarState({required this.st});
  bool light = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: IconButton(
            icon: Icon(Icons.more_vert, color: (light)?Colors.black:Colors.white,),
            tooltip: 'More',
            onPressed: () {
              print('Pressed More');
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
            icon: (light)?Icon(Icons.star, color: Colors.black,):Icon(Icons.star_border_outlined, color: Colors.white,),
            tooltip: 'Mode',
            onPressed: () {
              setState(() {
                print('Changed Mode');
                light = !light;
                st(light);
              });
            },
          ),
        ),
      ],
    );
  }
}