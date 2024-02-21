import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'calculator_model.dart';
import 'button_pannel.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      ChangeNotifierProvider(
        create: (context) => CalculatorModel(),
        child: const MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyCaluclator(title: 'シンプルな計算機'),
    );
  }
}

class MyCaluclator extends StatefulWidget {
  const MyCaluclator({super.key, required this.title});

  final String title;

  @override
  State<MyCaluclator> createState() => _MyCaluclatorState();
}

class CalculatorButton extends StatelessWidget {
  const CalculatorButton({super.key, required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        // ボタンが押されたときの処理
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

class _MyCaluclatorState extends State<MyCaluclator> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black54, width: 1),
                borderRadius: BorderRadius.circular(6), // 角を丸くする
              ),
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.16,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        context.watch<CalculatorModel>().value,
                        style: const TextStyle(fontSize: 64.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'aaa',
                        style: TextStyle(fontSize: 30.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'aaa',
                        style: TextStyle(fontSize: 30.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Expanded(
            child: ButtonPanel(),
          ),
        ],
      ),
    );
  }
}
