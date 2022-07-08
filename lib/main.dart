//Package import------------------------------------------------------------------------------------------------
//import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Api.dart';

void main() => runApp(MyApp());

//Controller-----------------------------------------------------------------------------------------------------
class StateController {
  late void Function() stateCng;
}


//Variables required for functioning-----------------------------------------------------------------------------
String _val = '';
String _res = '0.0';
//~~~~ThemeColours~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Color? _boxcolor = Colors.blueGrey[200];
Color _bordercolor = Colors.black38;
Color _textcolor = Colors.white70;
Color _keycolornum = Colors.black;
Color _keycolorop = Colors.orange;
Color _keycolorbr = Colors.deepOrange;
Color _keycolorpt = Colors.blueGrey;
Color? _keycolorresasc = Colors.blue[800];
Color? _keycolorres = Colors.blue[900];

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//String _exp = '';

//Preset text theme----------------------------------------------------------------------------------------------
var _themeformat = TextStyle(fontSize: 25.0, color: Colors.green,);

//Starting of App root-------------------------------------------------------------------------------------------
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
      title: 'Sample Calculator',
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
    if(x) {
      _boxcolor = Colors.blueGrey[200];
      _bordercolor = Colors.black38;
      _textcolor = Colors.white54;
      _keycolornum = Colors.black;
      _keycolorop = Colors.orange;
      _keycolorbr = Colors.deepOrange;
      _keycolorpt = Colors.blueGrey;
      _keycolorresasc = Colors.blue[800];
      _keycolorres = Colors.blue[900];
      _themeformat = TextStyle(fontSize: 25.0, color: Colors.green,);
    }
    else {
      _boxcolor = Colors.grey[800];
      _bordercolor = Colors.white24;
      _textcolor = Colors.black26;
      _keycolornum = Colors.white12;
      _keycolorop = Colors.orange.shade900;
      _keycolorbr = Colors.red.shade900;
      _keycolorpt = Colors.blueGrey.shade900;
      _keycolorresasc = Colors.black54;
      _keycolorres = Colors.black;
      _themeformat = TextStyle(fontSize: 25.0, color: Colors.lightGreenAccent,);
    }

    stController.stateCng();
  }
}

//Calc: Main body of the application-----------------------------------------------------------------------------
class Calc extends StatefulWidget {
  final StateController controller;
  Calc({required this.controller, Key? key}) : super(key: key);

  @override
  _CalcState createState() => _CalcState(controller);
}

class _CalcState extends State<Calc> {
  _CalcState(StateController _controller) {
    _controller.stateCng = stateCng;
  }

  void stateCng() {setState(() {});}

  //State update function----------------------------------------------------------------------------------------
  void _update(String val) {
    setState(() {
      _val = val;
      _res = evaluate('('+_val+')');
    });
  }

  List<String> _expList = [];
  List<String> _resList = [];

  Widget _tile(String _txt, String _sub, int id) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 1, color:_textcolor),
          bottom: BorderSide(width: 1, color:_textcolor),
        ),
      ),
      child: ListTile(
        title: Text(_txt, style:_themeformat, overflow: TextOverflow.ellipsis,),
        subtitle: Text(_sub, style: TextStyle(fontSize: 20, color: _themeformat.color), overflow: TextOverflow.ellipsis,),
        trailing: GestureDetector(
          child: Icon(Icons.add_circle_outline_sharp, color: _bordercolor,),
          onTap: () {
            setState(() {
              _update(_val += _resList[id]);
            });
          },
        ),
        leading: GestureDetector(
            child: Icon(Icons.remove_circle, color: _bordercolor,),
            onTap: () {
              setState(() {
                _resList.removeAt(id);
                _expList.removeAt(id);
              });
            }
        ),
        /*trailing: Wrap(
          children: <Widget>[
            Expanded(child: GestureDetector(
              child: Icon(Icons.remove_circle, color: _bordercolor,),
              onTap: () {
                setState(() {
                  _resList.removeAt(id);
                  _expList.removeAt(id);
                });
              }
            ),),
            Expanded(child: GestureDetector(
              child: Icon(Icons.add_circle_outline_sharp, color: _bordercolor,),
              onTap: () {
                setState(() {
                  _update(_val += _resList[id]);
                });
              },
            ),),
          ]
        ),*/
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          //##  Display Area  ##################################################################################
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                color: _textcolor,
                border: Border.all(
                  color: Colors.black87,
                  width: 10.0,
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
                        '$_val',
                        style: _themeformat,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '$_res',
                        style: _themeformat,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          //##  History  ########################################################################################
          Expanded(
            flex: 6,
            child: Container(
              decoration: BoxDecoration(
                color: _boxcolor,
                border: Border.all(
                  color: Colors.black87,
                  width: 10.0,
                ),
              ),
              alignment: Alignment.center,
              child: ListView.builder(
                reverse: true,
                itemBuilder: (context, id) => _tile(_expList[id], _resList[id], id),
                itemCount: _expList.length,
              ),
            ),
          ),

          //##  Keyboard Area  ##################################################################################
          Expanded(
            flex: 9,
            child: Container(
              decoration: BoxDecoration(
                color: _boxcolor,
                border: Border.all(
                  color: Colors.black87,
                  width: 10.0,
                ),
              ),
              alignment: Alignment.center,
              //##  Keys  #######################################################################################
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //Row 1~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                  Expanded( child:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //  bkspc  ________________________________________________________________________________
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: double.infinity,
                          child: Container(
                            decoration: BoxDecoration(
                              color: _boxcolor,
                              border: Border.all(color: _bordercolor, width: 5.0),
                            ),
                            child: Container(
                            decoration: BoxDecoration(
                              color: _boxcolor,
                              border: Border.all(color: Colors.lightGreen, width: 2),
                            ),
                            child: FittedBox(child: ElevatedButton(
                              child: Icon(Icons.backspace, color: _themeformat.color,),
                              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color?>(_boxcolor)),
                              onPressed: () {
                                print('Backspace');
                                setState(() {
                                  if(_val.length!=0) {
                                    _val = _val.substring(0, _val.length-1);
                                    _update(_val);
                                  }
                                });
                              },
                              onLongPress: () {
                                print('Reset');
                                setState(() {
                                  _val = '';
                                  _res = '0.0';
                                });
                              },
                            ),),
                          ),
                        ),),
                      ),
                      //  left  _________________________________________________________________________________
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: double.infinity,
                          child: Container(
                            decoration: BoxDecoration(
                                color: _boxcolor,
                                border: Border.all(color: _bordercolor, width: 5.0),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: _boxcolor,
                                border: Border.all(color: Colors.lightGreen, width: 2),
                              ),
                              child: FittedBox(child: ElevatedButton(
                                child: Text("<-", style: _themeformat,),
                                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color?>(_boxcolor)),
                                onPressed: () {
                                  print("Left");
                                },
                                onLongPress: () {},
                              ),),
                            ),
                        ),),
                      ),
                      //  right  ________________________________________________________________________________
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: double.infinity,
                          child:Container(
                          decoration: BoxDecoration(
                            color: _boxcolor,
                            border: Border.all(color: _bordercolor, width: 5.0),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: _boxcolor,
                              border: Border.all(color: Colors.lightGreen, width: 2),
                              ),
                            child: FittedBox(child: ElevatedButton(
                              child: Text("->", style: _themeformat,),
                              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color?>(_boxcolor)),
                              onPressed: () {
                                print("Right");
                              },
                              onLongPress: () {},
                            ),),
                          ),
                        ),),
                      ),
                      //_________________________________________________________________________________________
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: double.infinity,
                          child: Container(
                          decoration: BoxDecoration(
                            color: _boxcolor,
                            border: Border.all(color: _bordercolor, width: 5.0),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                               color: _keycolorbr,
                               border: Border.all(color: Colors.lightGreen, width: 2),
                            ),
                            child: FittedBox(child: ElevatedButton(
                              child: FittedBox(child: Text('(', style: _themeformat,),),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(_keycolorbr),
                              ),
                              onPressed: () {
                                print("Input (");
                                if (_val.length==0) {_val += "(";}
                                else {_val += !("+-*/^(".contains(_val[_val.length-1]))?"*(":"(";}
                                _update(_val);
                                },
                              onLongPress: null,
                            ),
                            ),
                          ),
                        ),),
                      ),
                      //_________________________________________________________________________________________
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: double.infinity,
                          child: Container(
                          decoration: BoxDecoration(
                            color: _boxcolor,
                            border: Border.all(color: _bordercolor, width: 5.0,)
                          ),
                          child: Container(
                          decoration: BoxDecoration(
                            color: _keycolorbr,
                            border: Border.all(color: Colors.lightGreen, width: 2),
                          ),
                          child: FittedBox(child: ElevatedButton(
                            child: FittedBox(child: Text(')', style: _themeformat,),),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(_keycolorbr),
                            ),
                            onPressed: () {
                              print("Input )");
                              _val += ")";
                              _update(_val);
                            },
                            onLongPress: null,
                          ),),
                        ),
                      ),),
                      ),
                    ],
                  ),),
                  //Row 2~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                  Expanded( child:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //_________________________________________________________________________________________
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: double.infinity,
                          child: Container(
                          decoration: BoxDecoration(
                            color: _boxcolor,
                            border: Border.all(color: _bordercolor, width: 5.0),
                          ),
                          child: FittedBox(child: Keys(key: ValueKey<Color>(_keycolornum), disp: 'sin', txt: 's(', col: _keycolornum, update: _update),),
                        ),),
                      ),
                      //_________________________________________________________________________________________
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: double.infinity,
                          child: Container(
                          decoration: BoxDecoration(
                            color: _boxcolor,
                            border: Border.all(color: _bordercolor, width: 5.0),
                          ),
                          child: FittedBox(child: Keys(key: ValueKey<Color>(_keycolornum), disp: 'cos', txt: 'c(', col: _keycolornum, update: _update),),
                        ),),
                      ),
                      //_________________________________________________________________________________________
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: double.infinity,
                          child: Container(
                          decoration: BoxDecoration(
                            color: _boxcolor,
                            border: Border.all(color: _bordercolor, width: 5.0),
                          ),
                          child: FittedBox(child: Keys(key: ValueKey<Color>(_keycolornum), disp: 'tan', txt: 't(', col: _keycolornum, update: _update),),
                        ),),
                      ),
                      //_________________________________________________________________________________________
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: double.infinity,
                          child: Container(
                          decoration: BoxDecoration(
                            color: _boxcolor,
                            border: Border.all(color: _bordercolor, width: 5.0),
                          ),
                          child: FittedBox(child: Keys(key: ValueKey<Color>(_keycolornum), disp: 'pi', txt: 'p', col: _keycolorop, update: _update),),
                        ),),
                      ),
                      //_________________________________________________________________________________________
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: double.infinity,
                          child: Container(
                          decoration: BoxDecoration(
                            color: _boxcolor,
                            border: Border.all(color: _bordercolor, width: 5.0),
                          ),
                          child: FittedBox(child: Keys(key: ValueKey<Color>(_keycolornum), disp: 'e', txt: 'e', col: _keycolorop, update: _update),),
                        ),),
                      ),
                      //_________________________________________________________________________________________
                    ],
                  ),),
                  //Row 3~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                  Expanded( child:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //_________________________________________________________________________________________
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: double.infinity,
                          child: Container(
                          decoration: BoxDecoration(
                            color: _boxcolor,
                            border: Border.all(color: _bordercolor, width: 5.0),
                          ),
                          child: FittedBox(child: Keys(key: ValueKey<Color>(_keycolornum), disp: '1', txt: '1', col: _keycolornum, update: _update),),
                        ),),
                      ),
                      //_________________________________________________________________________________________
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: double.infinity,
                          child: Container(
                          decoration: BoxDecoration(
                            color: _boxcolor,
                            border: Border.all(color: _bordercolor, width: 5.0),
                          ),
                          child: FittedBox(child: Keys(key: ValueKey<Color>(_keycolornum), disp: '2', txt: '2', col: _keycolornum, update: _update),),
                        ),),
                      ),
                      //_________________________________________________________________________________________
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: double.infinity,
                          child: Container(
                          decoration: BoxDecoration(
                            color: _boxcolor,
                            border: Border.all(color: _bordercolor, width: 5.0),
                          ),
                          child: FittedBox(child: Keys(key: ValueKey<Color>(_keycolornum), disp: '3', txt: '3', col: _keycolornum, update: _update),),
                        ),),
                      ),
                      //_________________________________________________________________________________________
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: double.infinity,
                          child: Container(
                          decoration: BoxDecoration(
                            color: _boxcolor,
                            border: Border.all(color: _bordercolor, width: 5.0),
                          ),
                          child: FittedBox(child: Keys(key: ValueKey<Color>(_keycolornum), disp: '+', txt: '+', col: _keycolorop, update: _update),),
                        ),),
                      ),
                      //_________________________________________________________________________________________
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: double.infinity,
                          child: Container(
                          decoration: BoxDecoration(
                            color: _boxcolor,
                            border: Border.all(color: _bordercolor, width: 5.0),
                          ),
                          child: FittedBox(child: Keys(key: ValueKey<Color>(_keycolornum), disp: '^', txt: '^', col: _keycolorop, update: _update),),
                        ),),
                      ),
                      //_________________________________________________________________________________________
                    ],
                  ),),
                  //Row 4~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                  Expanded(child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //_________________________________________________________________________________________
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: double.infinity,
                          child: Container(
                          decoration: BoxDecoration(
                            color: _boxcolor,
                            border: Border.all(color: _bordercolor, width: 5.0),
                          ),
                          child: FittedBox(child: Keys(key: ValueKey<Color>(_keycolornum), disp: '4', txt: '4', col: _keycolornum, update: _update),),
                        ),),
                      ),
                      //_________________________________________________________________________________________
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: double.infinity,
                          child: Container(
                          decoration: BoxDecoration(
                            color: _boxcolor,
                            border: Border.all(color: _bordercolor, width: 5.0),
                          ),
                          child: FittedBox(child: Keys(key: ValueKey<Color>(_keycolornum), disp: '5', txt: '5', col: _keycolornum, update: _update),),
                        ),),
                      ),
                      //_________________________________________________________________________________________
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: double.infinity,
                          child: Container(
                          decoration: BoxDecoration(
                            color: _boxcolor,
                            border: Border.all(color: _bordercolor, width: 5.0),
                          ),
                          child: FittedBox(child: Keys(key: ValueKey<Color>(_keycolornum), disp: '6', txt: '6', col: _keycolornum, update: _update),),
                        ),),
                      ),
                      //_________________________________________________________________________________________
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: double.infinity,
                          child: Container(
                          decoration: BoxDecoration(
                            color: _boxcolor,
                            border: Border.all(color: _bordercolor, width: 5.0),
                          ),
                          child: FittedBox(child: Keys(key: ValueKey<Color>(_keycolornum), disp: '-', txt: '-', col: _keycolorop, update: _update),),
                        ),),
                      ),
                      //_________________________________________________________________________________________
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: double.infinity,
                          child: Container(
                          decoration: BoxDecoration(
                            color: _boxcolor,
                            border: Border.all(color: _bordercolor, width: 5.0),
                          ),
                          child: FittedBox(child: Keys(key: ValueKey<Color>(_keycolornum), disp: '%', txt: '%', col: _keycolorop, update: _update),),
                        ),),
                      ),
                      //_________________________________________________________________________________________
                    ],
                  ),),
                  //Row 5~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                  Expanded(child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //_________________________________________________________________________________________
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: double.infinity,
                          child: Container(
                          decoration: BoxDecoration(
                            color: _boxcolor,
                            border: Border.all(color: _bordercolor, width: 5.0),
                          ),
                          child: FittedBox(child: Keys(key: ValueKey<Color>(_keycolornum), disp: '7', txt: '7', col: _keycolornum, update: _update),),
                        ),),
                      ),
                      //_________________________________________________________________________________________
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: double.infinity,
                          child: Container(
                          decoration: BoxDecoration(
                            color: _boxcolor,
                            border: Border.all(color: _bordercolor, width: 5.0),
                          ),
                          child: FittedBox(child: Keys(key: ValueKey<Color>(_keycolornum), disp: '8', txt: '8', col: _keycolornum, update: _update),),
                        ),),
                      ),
                      //_________________________________________________________________________________________
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: double.infinity,
                          child: Container(
                          decoration: BoxDecoration(
                            color: _boxcolor,
                            border: Border.all(color: _bordercolor, width: 5.0),
                          ),
                          child: FittedBox(child: Keys(key: ValueKey<Color>(_keycolornum), disp: '9', txt: '9', col: _keycolornum, update: _update),),
                        ),),
                      ),
                      //_________________________________________________________________________________________
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: double.infinity,
                          child: Container(
                          decoration: BoxDecoration(
                            color: _boxcolor,
                            border: Border.all(color: _bordercolor, width: 5.0),
                          ),
                          child: FittedBox(child: Keys(key: ValueKey<Color>(_keycolornum), disp: '*', txt: '*', col: _keycolorop, update: _update),),
                        ),),
                      ),
                      //_________________________________________________________________________________________
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: double.infinity,
                          child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: _boxcolor,
                            border: Border.all(color: _bordercolor, width: 5.0),
                          ),
                          //child: FittedBox(
                            child: Container(
                              height: 60,
                            decoration: BoxDecoration(
                            color: _keycolorresasc,
                            border: Border.all(color: Colors.lightGreen, width: 2),
                          ),
                          child: FittedBox(child: ElevatedButton(
                            child: FittedBox(child: Text("Ans", style: _themeformat,),),
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color?>(_keycolorres)),
                            onPressed: () {
                              print('Ans');
                              setState(() {
                                //_val += _res;
                                _update(_val += _res);
                              });
                            },
                          ),
                        ),
                          ),
                        ),),
                      ),
                      //_________________________________________________________________________________________
                    ],
                  ),),
                  //Row 6~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                  Expanded(child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //_________________________________________________________________________________________
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: double.infinity,
                          child: Container(
                          decoration: BoxDecoration(
                            color: _boxcolor,
                            border: Border.all(color: _bordercolor, width: 5.0),
                          ),
                          child: FittedBox(child: Keys(key: ValueKey<Color>(_keycolornum), disp: '#', txt: '#', col: _keycolorpt, update: _update),),
                        ),),
                      ),
                      //_________________________________________________________________________________________
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: double.infinity,
                          child: Container(
                          decoration: BoxDecoration(
                            color: _boxcolor,
                            border: Border.all(color: _bordercolor, width: 5.0),
                          ),
                          child: FittedBox(child: Keys(key: ValueKey<Color>(_keycolornum), disp: '0', txt: '0', col: _keycolornum, update: _update),),
                        ),),
                      ),
                      //_________________________________________________________________________________________
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: double.infinity,
                          child: Container(
                          decoration: BoxDecoration(
                            color: _boxcolor,
                            border: Border.all(color: _bordercolor, width: 5.0),
                          ),
                          child: FittedBox(child: Keys(key: ValueKey<Color>(_keycolornum), disp: '.', txt: '.', col: _keycolorpt, update: _update),),
                        ),),
                      ),
                      //_________________________________________________________________________________________
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: double.infinity,
                          child: Container(
                          decoration: BoxDecoration(
                            color: _boxcolor,
                            border: Border.all(color: _bordercolor, width: 5.0),
                          ),
                          child: FittedBox(child: Keys(key: ValueKey<Color>(_keycolornum), disp: '/', txt: '/', col: _keycolorop, update: _update),),
                        ),),
                      ),
                      //_________________________________________________________________________________________
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: double.infinity,
                          child: Container(
                            decoration: BoxDecoration(
                              color: _boxcolor,
                              border: Border.all(color: _bordercolor, width: 5.0,),
                            ),
                            child: FittedBox(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _keycolorresasc,
                                  border: Border.all(color: Colors.lightGreen, width: 2),
                                ),
                                child: FittedBox(child: ElevatedButton(
                                  child: FittedBox(child: Text('=', style: _themeformat,),),
                                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color?>(_keycolorres)),
                                  onPressed: () {
                                    print('Equal To');
                                    setState(() {
                                      _update(_val);
                                      _expList.add(_val);
                                      _resList.add(_res);
                                      _val='';
                                    });
                                  },
                                ),),
                              ),
                            ),
                          ),
                        ),
                      ),
                      //_________________________________________________________________________________________
                    ],
                  ),),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//Class to define keys-------------------------------------------------------------------------------------------
class Keys extends StatefulWidget {
  final String disp;
  final String txt;
  final ValueChanged<String> update;
  Color col;
  Keys({required this.disp, required this.txt, required this.col, required this.update, Key?key}) : super(key: key);

  @override
  _KeysState createState() => _KeysState(d: disp, t: txt, c: col, updt: update);
}

class _KeysState extends State<Keys> {
  final String d;
  final String t;
  final ValueChanged<String> updt;
  Color c;
  _KeysState({required this.d, required this.t, required this.c, required this.updt});

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: c,
        border: Border.all(width: 2, color: Colors.lightGreen,),
      ),
      child: FittedBox(child: ElevatedButton(
        child: Text('$d', style: _themeformat,),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(c)
        ),
        onPressed: () {
          print('Input $d');
          setState(() {
            if(_val=='') {_val += '$t';}
            else if("+-*/^".contains(t) && "+-*/^".contains(_val[_val.length-1])) {
              _val = _val.substring(0, _val.length-1) + "$t";
            }
            else {
              _val += '$t';
            }
          });
          updt(_val);
        },
        onLongPress: null,
      ),),
    );
  }
}

//AppBar---------------------------------------------------------------------------------------------------------
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
            style: TextStyle(fontWeight: FontWeight.w500, color: (light)?Colors.yellow:Colors.white),
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

//==================================================END==========================================================