import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class EngineeringCalcu extends StatefulWidget {
  const EngineeringCalcu({super.key});

  @override
  State<EngineeringCalcu> createState() => _EngineeringCalcuState();
}

class _EngineeringCalcuState extends State<EngineeringCalcu> {
  String _input = '';
  String _output = '';
  bool _isDegreesMode = true; // Initially set it to degrees mode

  final ExpressionParser expressionParser = ExpressionParser();

  void _addToInput(String value) {
    setState(() {
      _input += value;
    });
  }



  void _clearInput() {
    setState(() {
      _input = '';
      _output = '';
    });
  }

  void _toggleDegreesMode() {
    setState(() {
      _isDegreesMode = !_isDegreesMode;
    });
  }

  void _calculate() {
    if (_input.isNotEmpty) {
      try {
        final parsedExpression = Parser().parse(_input);
        final contextModel = ContextModel();
        final result = parsedExpression.evaluate(EvaluationType.REAL, contextModel);

        setState(() {
          _output = result.toString();
        });
      } catch (e) {
        setState(() {
          _output = 'Error';
        });
      }
    } else {
      setState(() {
        _output = 'Error';
      });
    }
  }


  Widget _buildButton(String label, Function() onPressed, {Color? color}) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: color ?? Colors.deepOrange,
        textStyle: TextStyle(fontSize: 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Engineering Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                child: Text(
                  _input,
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                child: Text(
                  _output,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Buttons for digits and operators
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildButton('7', () => _addToInput('7')),
                _buildButton('8', () => _addToInput('8')),
                _buildButton('9', () => _addToInput('9')),
                _buildButton('/', () => _addToInput('/')),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildButton('4', () => _addToInput('4')),
                _buildButton('5', () => _addToInput('5')),
                _buildButton('6', () => _addToInput('6')),
                _buildButton('x', () => _addToInput('x')),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildButton('1', () => _addToInput('1')),
                _buildButton('2', () => _addToInput('2')),
                _buildButton('3', () => _addToInput('3')),
                _buildButton('-', () => _addToInput('-')),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildButton('0', () => _addToInput('0')),
                _buildButton('.', () => _addToInput('.')),
                _buildButton('π', () => _addToInput('π')),
                _buildButton('+', () => _addToInput('+')),
              ],
            ),
            // Other functions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildButton('(', () => _addToInput('(')),
                _buildButton(')', () => _addToInput(')')),
                _buildButton('^', () => _addToInput('^')),
                _buildButton('√', () => _addToInput('√')),
              ],
            ),
            // Trigonometric functions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildButton('sin', () => _addToInput('sin(')),
                _buildButton('cos', () => _addToInput('cos(')),
                _buildButton('tan', () => _addToInput('tan(')),
                _buildButton(_isDegreesMode ? 'Deg' : 'Rad', () => _toggleDegreesMode()),
              ],
            ),
            // Logarithmic function and clear
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildButton('log', () => _addToInput('log(')),
                _buildButton('C', () => _clearInput(), color: Colors.red),
                _buildButton('=', () => _calculate(), color: Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ExpressionParser {
  final Parser parser = Parser();
  final ContextModel contextModel = ContextModel();

  double evaluate(String expression, bool isDegreesMode) {
    try {
      // Replace 'x' with '*' and '÷' with '/'
      expression = expression.replaceAll('x', '*').replaceAll('÷', '/');

      // Handle parentheses for multiplication
      expression = expression.replaceAllMapped(
        RegExp(r'\(([^)]+)\)(\d+(\.\d+)?)'),
            (match) {
          final base = match.group(1);
          final factor = match.group(2);
          if (base != null && factor != null) {
            return '$base*$factor';
          } else {
            throw Exception('Invalid multiplication expression');
          }
        },
      );

      // Modify trigonometric functions based on degrees/radians mode
      if (isDegreesMode) {
        expression = expression.replaceAllMapped(
          RegExp(r'sin\(([^)]+)\)'),
              (match) {
            final group1 = match.group(1);
            if (group1 != null) {
              return 'sin(${(double.parse(group1) * (pi / 180)).toString()})';
            } else {
              throw Exception('Invalid argument for sin');
            }
          },
        );

        expression = expression.replaceAllMapped(
          RegExp(r'cos\(([^)]+)\)'),
              (match) {
            final group1 = match.group(1);
            if (group1 != null) {
              return 'cos(${(double.parse(group1) * (pi / 180)).toString()})';
            } else {
              throw Exception('Invalid argument for cos');
            }
          },
        );

        expression = expression.replaceAllMapped(
          RegExp(r'tan\(([^)]+)\)'),
              (match) {
            final group1 = match.group(1);
            if (group1 != null) {
              return 'tan(${(double.parse(group1) * (pi / 180)).toString()})';
            } else {
              throw Exception('Invalid argument for tan');
            }
          },
        );
      }

      // Add support for the addition operation
      expression = expression.replaceAllMapped(
        RegExp(r'(\d+(\.\d+)?)\s*\+\s*(\d+(\.\d+)?)'),
            (match) {
          final num1 = match.group(1);
          final num2 = match.group(3);
          if (num1 != null && num2 != null) {
            return (double.parse(num1) + double.parse(num2)).toString();
          } else {
            throw Exception('Invalid addition expression');
          }
        },
      );

      // Add support for square root
      // Replace '√number' with the square root operation
      expression = expression.replaceAllMapped(
        RegExp(r'√(\d+(\.\d+)?)'),
            (match) {
          final number = match.group(1);
          if (number != null) {
            return sqrt(double.parse(number)).toString();
          } else {
            throw Exception('Invalid square root expression');
          }
        },
      );

      // Add support for pi (π)
      expression = expression.replaceAll('π', pi.toString());

      // Parse and evaluate the expression using the math_expressions package
      final parsedExpression = parser.parse(expression);
      final evaluated = parsedExpression.evaluate(EvaluationType.REAL, contextModel);

      return evaluated;
    } catch (e) {
      throw Exception('Error evaluating expression: $e');
    }
  }
}

