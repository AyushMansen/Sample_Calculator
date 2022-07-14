import 'dart:math';
import 'package:flutter/material.dart';

//...Rounding............................//
String roundup(double d) {
  int i = 0;
  String _res = d.toString();
  while (_res[i]!='.') {i++;}
  i=_res.length-i;

  if(i>5) {
    d = (((d*pow(10, 5)).roundToDouble())/pow(10, 5));
  }
  _res = d.toString();

  return _res.substring(0, );

}

//...Calculation.........................//

String evaluate(String _eqn) {
  List _stack = [];
  List _op = [];
  Map _prelist = {
    's': 1,
    'c': 1,
    't': 1,
    '%': 2,
    '^': 3,
    '/': 4,
    '*': 4,
    '+': 5,
    '-': 5,
    '(': 6
  };
  String _temp = "";
  String _result = "";
  try {
    print(_eqn);

    void _push(String _x) {
      switch (_x) {
        case "":
          break;
        case "p":
          _stack.add(pi);
          break;
        case "e":
          _stack.add(e);
          break;
        default:
          _stack.add(double.parse(_x));
      }
      return;
    }

    void _evaluate(String _sym) {
      try {
        bool _u = true;
        double _res = 0;
        double _num1 = _stack.removeLast();
        double _num2 = (_stack.isEmpty) ? 0.0 : _stack.last;
        switch (_sym) {
          case '%':
            _res = (_num2 / _num1) * 100;
            break;
          case '^':
            _res = pow(_num2, _num1).toDouble();
            break;
          case '/':
            _res = _num2 / _num1;
            break;
          case '*':
            _res = _num2 * _num1;
            break;
          case '+':
            _res = _num2 + _num1;
            break;
          case '-':
            _res = _num2 - _num1;
            break;
          case 's':
            _res = sin(_num1);
            _u = false;
            break;
          case 'c':
            _res = cos(_num1);
            _u = false;
            break;
          case 't':
            _res = tan(_num1);
            _u = false;
            break;
        }
        if (_u) {
          _stack.removeLast();
        }
        _push(_res.toString());
      }
      catch (error) {
        _result = "!!MATH ERROR!!";
      }
    }

    void _pop(bool flag) {
      int _i = 1;
      if (flag && _op[_op.length - _i] == "(") {
        return;
      }
      else {
        while (_op[_op.length - _i] != "(") {
          _evaluate(_op[_op.length - _i]);
          _i += 1;
        }
        _op = _op.sublist(0, (_op.length - (_i - 1)));
      }
    }

    void _check(String x) {
      if (x == "(") {
        _op.add(x);
      }
      else if (_prelist[x] > _prelist[_op.last]) {
        _pop(false);
        _op.add(x);
      }
      else {
        _op.add(x);
      }
    }

    for (int i = 0; i < _eqn.length; i++) {
      if (!("1234567890pesct().+-*/^%".contains(_eqn[i]))) {
        _result = "NON NUMERIC";
        return _result;
      }
      else {
        if ("+*/^%sct".contains(_eqn[i])) {
          _push(_temp);
          _temp = "";
          _check(_eqn[i]);
        }
        else if (_eqn[i] == "-") {
          if (_temp == "") {
            _push("-1");
            _check("*");
          }
          else {
            _push(_temp);
            _temp = "";
            _check("+");
            _push("-1");
            _check("*");
          }
        }
        else if (_eqn[i] == "(") {
          if (i == 0) {
            _op.add("(");
          }
          else if (_temp != "") {
            _push(_temp);
            _temp = "";
            _check("*");
            _op.add("(");
          }
          else {
            _push(_temp);
            _temp = "";
            _check("(");
          }
        }
        else if (_eqn[i] == ")") {
          if (_temp == "" || _temp == "-") {
            if ("(".contains(_eqn[i - 1]) && i != (_eqn.length - 1)) {
              _result = "Avoid Empty Brackets";
              return _result;
            }
            else if ("+-".contains(_eqn[i - 1])) {
              _push("0.0");
            }
            else if ("*/^".contains(_eqn[i - 1])) {
              _push("1.0");
            }
          }
          else {
            _push(_temp);
          }
          _temp = "";
          _pop(true);
          _op = _op.sublist(0, (_op.length - 1));
        }
        else {
          _temp += _eqn[i];
        }
      }
    }
  }
  catch(e) {
    return "Invalid syntax";
  }



  _result = (_stack.isNotEmpty)?roundup(_stack.last):"0.0";

  return _result;
}

//...Display Generation..................//
String gen(String _eqn) {
  int i = 0;
  String _res = '';
  for(;i<_eqn.length;i++) {
    switch(_eqn[i]) {
      case 's': _res += "sin";
      break;
      case 'c': _res += "cos";
      break;
      case 't': _res += "tan";
      break;
      case 'p': _res += "pi";
      break;
      default: _res += _eqn[i];
    }
  }
  return _res;
}

//...Theme Variables.....................//
Color boxcolor = Colors.blueGrey.shade400;
Color bordercolor = Colors.black38;
Color textcolor = Colors.white70;
Color txtcol = Colors.green;
Color keycolornum = Colors.black;
Color keycolorop = Colors.orange;
Color keycolorbr = Colors.deepOrange;
Color keycolorpt = Colors.blueGrey;
Color keycolorresasc = Colors.blue.shade600;
Color keycolorres = Colors.blue.shade900;
var themeformat = const TextStyle(fontSize: 25.0, color: Colors.green,);

//...Change Mode.........................//
void setCol(bool x) {
  if(x) {
    boxcolor = Colors.blueGrey.shade400;
    bordercolor = Colors.black38;
    textcolor = Colors.white70;
    txtcol = Colors.green;
    keycolornum = Colors.black;
    keycolorop = Colors.orange;
    keycolorbr = Colors.deepOrange;
    keycolorpt = Colors.blueGrey;
    keycolorresasc = Colors.blue.shade600;
    keycolorres = Colors.blue.shade900;
  }
  else {
    boxcolor = Colors.grey.shade700;
    bordercolor = Colors.white24;
    textcolor = Colors.black26;
    txtcol = Colors.green.shade200;
    keycolornum = Colors.white12;
    keycolorop = Colors.orange.shade900;
    keycolorbr = Colors.red.shade900;
    keycolorpt = Colors.blueGrey.shade900;
    keycolorresasc = Colors.blueGrey.shade700;
    keycolorres = Colors.black;
  }
  themeformat = TextStyle(fontSize: 25.0, color: txtcol,);
}