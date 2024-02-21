import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'calculator_model.dart';

class CalculatorButton extends StatelessWidget {
  const CalculatorButton({super.key, required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        context.read<CalculatorModel>().setValue(value);
      },
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
      ),
      child: Text(
        value,
        style: const TextStyle(fontSize: 36.0),
      ),
    );
  }
}

class ButtonPanel extends StatelessWidget {
  const ButtonPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      childAspectRatio: 1.1,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      children: const [
        CalculatorButton(value: 'C'),
        CalculatorButton(value: '()'),
        CalculatorButton(value: '%'),
        CalculatorButton(value: '÷'),
        CalculatorButton(value: '7'),
        CalculatorButton(value: '8'),
        CalculatorButton(value: '9'),
        CalculatorButton(value: '×'),
        CalculatorButton(value: '4'),
        CalculatorButton(value: '5'),
        CalculatorButton(value: '6'),
        CalculatorButton(value: '−'),
        CalculatorButton(value: '1'),
        CalculatorButton(value: '2'),
        CalculatorButton(value: '3'),
        CalculatorButton(value: '+'),
        CalculatorButton(value: '0'),
        CalculatorButton(value: '00'),
        CalculatorButton(value: '.'),
        CalculatorButton(value: '='),
      ],
    );
  }
}
