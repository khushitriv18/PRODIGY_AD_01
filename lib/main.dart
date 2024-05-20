import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData.dark().copyWith(
        colorScheme: ThemeData.dark().colorScheme.copyWith(
          surface: Colors.grey[900],
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[900],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.0),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
          ),
        ),
      ),
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = '';
  String _display = '';

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        // Clear button pressed
        _output = '';
        _display = '';
      } else if (buttonText == 'D') {
        // Delete button pressed
        if (_display.isNotEmpty) {
          _display = _display.substring(0, _display.length - 1);
        }
      } else if (buttonText == '=') {
        // Equals button pressed
        try {
          // Evaluate the full expression
          final expression = Expression.parse(_display.replaceAll('x', '*'));
          final evaluator = const ExpressionEvaluator();
          final result = evaluator.eval(expression, {});
          _output = result.toString();
        } catch (e) {
          _output = 'Error';
        }
      } else if (buttonText == '+-') {
        // Toggle sign button pressed
        if (_display.isNotEmpty && _display != '0') {
          if (_display.startsWith('-')) {
            _display = _display.substring(1);
          } else {
            _display = '-$_display';
          }
        }
      } else {
        // Number or operator button pressed
        _display += buttonText;
      }
    });
  }

  Widget _buildButton(
      String buttonText,
      Color buttonColor,
      Color textColor,
      ) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            foregroundColor: textColor,
          ),
          onPressed: () {
            _buttonPressed(buttonText);
          },
          child: Text(
            buttonText,
            style: TextStyle(fontSize: 24.0),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonRow(List<String> buttons) {
    return Row(
      children: buttons
          .map((button) => _buildButton(
        button,
        button == 'C' || button == 'D'
            ? Colors.grey[700]!
            : Colors.grey[900]!,
        button == '=' || button == '/' || button == 'x' || button == '-' || button == '+' || button == '%'
            ? Colors.white
            : Colors.pink[100]!,
      ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator App'),
        centerTitle: true,
        backgroundColor: Colors.pink[200],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _display,
                    style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[500]),
                  ),
                  Text(
                    _output,
                    style: TextStyle(
                        fontSize: 48.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 0.0),
          Column(
            children: [
              // Rows of buttons
              _buildButtonRow(['C', 'D', '%', '/']),
              _buildButtonRow(['9', '8', '7', 'x']),
              _buildButtonRow(['6', '5', '4', '-']),
              _buildButtonRow(['3', '2', '1', '+']),
              _buildButtonRow(['+-', '0', '.', '=']),
            ],
          ),
        ],
      ),
    );
  }
}
