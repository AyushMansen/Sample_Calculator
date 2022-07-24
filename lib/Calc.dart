import 'package:flutter/material.dart';
import 'Api.dart';
import 'main.dart';

//...Clc: App body..........................//
class Calc extends StatefulWidget {
  final StateController Ccontroller;
  Calc(this.Ccontroller, {Key? key}) : super(key:key);

  @override
  _CalcState createState() => _CalcState(Ccontroller);
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
      val = val;
      res = evaluate('('+val+')', deg);
      disp = gen(val);
    });
  }

  //...Key Preset.........................//
  Widget _key(String char, String value, Color color) {
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
            if(val=='') {
              val += value;
            }
            else if("+-*/^".contains(value) && "+-*/^".contains(val[val.length-1])) {
              val = val.substring(0, val.length-1) + value;
            }
            else {
              val += value;
            }
          });
          _update(val);
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

  //History display........................//
  Widget _tile(String _txt, String _sub, int id, bool d) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 1, color:textcolor),
          bottom: BorderSide(width: 1, color:textcolor),
        ),
      ),
      child: ListTile(
        title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 5,
                child: Text(_txt, style:themeformat, overflow: TextOverflow.ellipsis,),
              ),
              Expanded(
                flex:1,
                child: Text(d?'DEG':'RAD', style: TextStyle(fontSize: 10, color: themeformat.color)),
              ),
            ]
        ),
        subtitle: Text(_sub, style: TextStyle(fontSize: 20, color: themeformat.color), overflow: TextOverflow.ellipsis,),
        trailing: GestureDetector(
          child: Icon(Icons.add_circle_outline_sharp, color: bordercolor,),
          onTap: () {
            setState(() {
              _update(val += resList[id]);
            });
          },
        ),
        leading: GestureDetector(
            child: Icon(Icons.remove_circle, color: bordercolor,),
            onTap: () {
              setState(() {
                resList.removeAt(id);
                expList.removeAt(id);
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
                        disp,
                        style: themeformat,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        res,
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
            key: ValueKey<int>(expList.length),
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
                itemBuilder:  (context, id) => _tile(expList[id][0], resList[id], id, expList[id][1]),
                itemCount: expList.length,
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
                                if(val.length!=0) {
                                  val = val.substring(0, val.length-1);
                                  _update(val);
                                }
                                else {
                                  _update("");
                                }
                              });
                            },
                            onLongPress: () {
                              setState(() {
                                val = '';
                                disp = '';
                                res = '0.0';
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
                                if(val.length==0) {val += '(';}
                                else {val += !("+-*/^(".contains(val[val.length-1]))?"*(":"(";}
                                _update(val);
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
                        _key("sin", (val=='' || !"0123456789".contains(val[val.length-1]))?"s(":"*s(", keycolornum),
                        _key("cos", (val=='' || !"0123456789".contains(val[val.length-1]))?"c(":"*c(", keycolornum),
                        _key("tan", (val=='' || !"0123456789".contains(val[val.length-1]))?"t(":"*t(", keycolornum),
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
                                  _update(val += res);
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
                                  _update(val);
                                });
                              }
                          ),
                        ),
                        _key("0", "0", keycolornum),
                        _key(".", (val=='' || !"0123456789".contains(val[val.length-1]))?"0.":".", keycolorpt),
                        _key("/", "/", keycolorop),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            child: _charkeydesign("=", keycolorres),
                            onTap: () {
                              if(val=="") {return;}
                              setState(() {
                                _update(val);
                                expList.add([disp,deg]);
                                resList.add(res);
                                val='';disp='';
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
