import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:intl/intl.dart';

class Calculation {
  final String expression;
  final String result;

  Calculation({required this.expression, required this.result});
}

// 計算機のモデルを表すクラス
class CalculatorModel extends ChangeNotifier {
  // 計算履歴を保持するリスト
  final List<Calculation> _history = [];

  // 入力値を保持する変数
  String _lastInputValue = '';

  // 操作を保持するリスト
  final List<String> _operations = [];

  // 計算結果を保持する変数
  double _calcResult = 0;

  // 計算結果を取得するgetter
  // 整数の場合は小数点以下を切り捨て、小数の場合はそのまま文字列に変換する
  String get calcResult {
    // 数字をカンマ区切りにするためのフォーマッタ
    NumberFormat formatter = NumberFormat('#,###');

    if (_calcResult == _calcResult.floor()) {
      return formatter.format(_calcResult.toInt());
    } else {
      return formatter.format(_calcResult);
    }
  }

  // 計算結果を取得するgetter（内部的な計算用）
  String get calcResultForCalculation {
    if (_calcResult == _calcResult.floor()) {
      return _calcResult.toInt().toString();
    } else {
      return _calcResult.toString();
    }
  }

  // 操作を取得するgetter
  String get operations {
    // '*' と '/' をそれぞれ '×' と '÷' に変換するためのマップ
    Map<String, String> operationMap = {
      '*': '×',
      '/': '÷',
    };

    // 数字をカンマ区切りにするためのフォーマッタ
    NumberFormat formatter = NumberFormat('#,###');

    String result = '';
    for (int i = 0; i < _operations.length; i++) {
      // 数字と小数点が続く場合以外はスペースを挿入
      if (i > 0 && _operations[i - 1] != '.' && _operations[i] != '.') {
        result += ' ';
      }
      // 演算子を表示用に変換
      String operation = operationMap[_operations[i]] ?? _operations[i];
      // 数字の場合はカンマ区切りにする
      result += operation.contains(RegExp(r'^\d+$')) ? formatter.format(int.parse(operation)) : operation;
    }
    return result;
  }

  // 計算履歴を取得するメソッド
  List<Calculation> get history {
    return _history;
  }

  // 新しい値を設定するメソッド
  String _lastOperation = '';
  String _lastNumber = '';

  void setValue(String newValue) {
    // 新しい値が '×' または '÷' の場合、それぞれ '*' または '/' に変換する
    if (newValue == '×') {
      newValue = '*';
    } else if (newValue == '÷') {
      newValue = '/';
    }

    // 新しい値が 'C' の場合、全ての操作をクリアする
    if (newValue == 'C') {
      _operations.clear();
      _lastInputValue = '';
      _lastOperation = '';
      _lastNumber = '';
      _calcResult = 0;
      notifyListeners();
      return;
    }

    // 新しい値が '=' の場合、_operationsをクリアし、_calcResultの値で差し替える
    if (newValue == '=') {
      if (_lastInputValue == '=') {
        // 前回も '=' が押されていた場合、最後の計算を再度行う
        _operations.clear();
        _operations.add(calcResultForCalculation);

        _operations.add(_lastOperation);
        _operations.add(_lastNumber);
        _calcResult = _calculateResult(newValue);
        _history.add(
          Calculation(
            expression: "$operations = $calcResult",
            result: calcResult,
          ),
        );
        _operations.clear();
        _operations.add(calcResultForCalculation);
      } else {
        _calcResult = _calculateResult(newValue);
        if (_operations.length > 1) {
          _lastOperation = _operations[_operations.length - 2];
          _lastNumber = _operations[_operations.length - 1];
        }
        _history.add(
          Calculation(
            expression: "$operations = $calcResult",
            result: calcResult,
          ),
        );
        _operations.clear();
        _operations.add(calcResultForCalculation);
      }
      _lastInputValue = '=';
      notifyListeners();
      return;
    }

    // 新しい値が数値であるかをチェックする
    if (double.tryParse(newValue) != null) {
      // リストの最後の要素が数値であるかをチェックする
      if (_operations.isNotEmpty && double.tryParse(_operations.last) != null) {
        if (_lastInputValue == "=") {
          // "="の後に数値が入力された場合、新たな計算としてリストを空にする
          _operations.clear();
          _operations.add(newValue);
          _lastOperation = '';
        } else {
          // 数値である場合、新しい値を最後の要素に追加する
          _operations[_operations.length - 1] += newValue;
        }
      } else {
        // 数値でない場合、新しい値をリストに追加する
        _operations.add(newValue);
      }
    } else {
      // 新しい値が数値でない場合（計算記号の場合）
      if (_operations.isNotEmpty && double.tryParse(_operations.last) == null) {
        // リストの最後の要素が数値でない場合（計算記号の場合）、新しい値で最後の要素を置き換える
        _operations[_operations.length - 1] = newValue;
      } else {
        // リストの最後の要素が数値の場合、新しい値をリストに追加する
        _operations.add(newValue);
      }
    }
    // 計算を実行し、_calcResult を更新する
    _calcResult = _calculateResult(newValue);

    // _lastInputValue を新しい値に更新する
    _lastInputValue = newValue;

    // リスナーに通知する
    notifyListeners();
  }

  // _operations リストに基づいて結果を計算するメソッド
  double _calculateResult(newValue) {
    // _operations リストを一つの文字列に結合する
    String expression = _operations.join();

    try {
      // 式を解析する
      Parser p = Parser();
      Expression exp = p.parse(expression);

      // 変数をバインドする（もし存在すれば）
      ContextModel cm = ContextModel();

      // 式を評価する
      double result = exp.evaluate(EvaluationType.REAL, cm);

      // 結果を返す
      return result;
    } catch (e) {
      // エラーが発生した場合、_lastInputValueが=の場合は、_operationsの最後の値を削除し、前回の計算結果を返す
      if (newValue == '=') {
        _operations.removeLast();
      }
      return _calcResult;
    }
  }
}
