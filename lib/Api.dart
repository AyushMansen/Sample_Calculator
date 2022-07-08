import 'dart:math';

String evaluate(String _eqn) {
  List _stack = [];
  List _op = [];
  Map _prelist = {'s':1, 'c':1, 't':1, '%':2, '^':3, '/':4, '*':4, '+':5, '-':5, '(':6};
  String _temp = "";
  String _result = "";

  //_eqn = '('+_eqn+')';
  print(_eqn);

  void _push(String _x) {
    switch(_x) {
      case "": break;
      case "p": _stack.add(pi);
      break;
      case "e": _stack.add(e);
      break;
      default: _stack.add(double.parse(_x));
    }
    return;
  }

  void _evaluate(String _sym) {
    try {
      bool _u = true;
      double _res = 0;
      double _num1 = _stack.removeLast();
      double _num2 = (_stack.isEmpty)?0.0:_stack.last;
      switch(_sym) {
        case '%': _res = (_num2/_num1)*100;
        break;
        case '^': _res = pow(_num2, _num1).toDouble();
        break;
        case '/': _res = _num2/_num1;
        break;
        case '*': _res = _num2*_num1;
        break;
        case '+': _res = _num2+_num1;
        break;
        case '-': _res = _num2-_num1;
        break;
        case 's': _res = sin(_num1); _u = false;
        break;
        case 'c': _res = cos(_num1); _u = false;
        break;
        case 't': _res = tan(_num1); _u = false;
        break;
      }
      if(_u) {_stack.removeLast();}
      _push(_res.toString());
    }
    catch(error) {
      _result = "!!MATH ERROR!!";
    }
  }

  void _pop(bool flag) {
    int _i=1;
    if(flag && _op[_op.length-_i]=="(") {
      return;
    }
    else {
      while(_op[_op.length-_i]!="(") {
        _evaluate(_op[_op.length-_i]);
        _i += 1;
      }
      _op = _op.sublist(0, (_op.length-(_i-1)));
    }
  }

  void _check(String x) {
    if(x=="(") {
      _op.add(x);
    }
    else if(_prelist[x]>_prelist[_op.last]) {
      _pop(false);
      _op.add(x);
    }
    else {
      _op.add(x);
    }
  }

  for(int i=0;i<_eqn.length;i++) {
    if(!("1234567890pesct().+-*/^%".contains(_eqn[i]))) {
      _result = "NON NUMERIC";
      return _result;
    }
    else{
      if("+*/^%sct".contains(_eqn[i])){
        _push(_temp);
        _temp = "";
        _check(_eqn[i]);
      }
      else if(_eqn[i]=="-"){
        if(_temp=="") {
          _push("-1");
          _check("*");
        }
        else {
          _push(_temp);
          _temp="";
          _check("+");
          _push("-1");
          _check("*");
        }
      }
      else if(_eqn[i]=="("){
        if(i==0) {_op.add("(");}
        else if(_temp!="") {
          _push(_temp);
          _temp="";
          _check("*");
          _op.add("(");
        }
        else {
          _push(_temp);
          _temp="";
          _check("(");
        }
      }
      else if(_eqn[i]==")"){
        if(_temp=="" || _temp=="-"){
          if("(".contains(_eqn[i-1]) && i!=(_eqn.length-1)){_result="Avoid Empty Brackets"; return _result;}
          else if("+-".contains(_eqn[i-1])){_push("0.0");}
          else if("*/^".contains(_eqn[i-1])){_push("1.0");}
        }
        else{_push(_temp);}
        _temp="";
        _pop(true);
        _op = _op.sublist(0, (_op.length-1));
      }
      else{
        _temp += _eqn[i];
      }
    }
  }


  _result = (_stack.isNotEmpty)?_stack.last.toStringAsFixed(5):"0.0";

  return _result;
}