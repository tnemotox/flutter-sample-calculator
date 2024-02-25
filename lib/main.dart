import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'calculator_model.dart';
import 'button_pannel.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
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
        title: Text(
          widget.title,
          textAlign: TextAlign.left, // タイトルを左寄せにする
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 12.0), // 右側の余白を増やすことで、ボタンを左に寄せる
            child: IconButton(
              icon: const Icon(Icons.more_vert, size: 30.0), // 三点リーダーアイコンを追加
              onPressed: () {
                // 三点リーダーボタンが押されたときの処理
              },
            ),
          ),
        ],
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
                        context.watch<CalculatorModel>().operations,
                        style: const TextStyle(fontSize: 32.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        context.watch<CalculatorModel>().calcResult,
                        style: const TextStyle(
                          fontSize: 24.0,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: Align(
                      alignment: Alignment.centerLeft, // アイコンを左寄せにする
                      child: Row(
                        // Rowウィジェットを使用してアイコンを並べる
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, // アイコンを左右に寄せる
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0), // 左側のアイコンの余白を設定
                            child: IconButton(
                              icon: const Icon(
                                Icons.history,
                                size: 30.0,
                              ),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(5.0),
                                    ), // 上部の角を少し丸くする
                                  ),
                                  builder: (BuildContext context) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 50.0),
                                      child: FractionallySizedBox(
                                        heightFactor: 0.8,
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).colorScheme.inversePrimary,
                                              ),
                                              child: const Align(
                                                alignment: Alignment.topLeft,
                                                child: Padding(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Text(
                                                    '計算履歴',
                                                    style: TextStyle(
                                                      fontSize: 20.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: ListView.separated(
                                                itemCount: context.watch<CalculatorModel>().history.length,
                                                separatorBuilder: (context, index) => const Divider(),
                                                itemBuilder: (context, index) {
                                                  Calculation calculation = context.watch<CalculatorModel>().history[index];
                                                  return ListTile(
                                                    title: Text(
                                                      calculation.expression,
                                                      style: const TextStyle(
                                                        fontSize: 18.0,
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      context.read<CalculatorModel>().setValue(
                                                            calculation.result,
                                                          );
                                                      Navigator.pop(
                                                        context,
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 10.0,
                                                ),
                                                child: ElevatedButton(
                                                  style: ButtonStyle(
                                                    minimumSize: MaterialStateProperty.all(
                                                      const Size(
                                                        double.infinity,
                                                        50,
                                                      ),
                                                    ),
                                                    side: MaterialStateProperty.all(
                                                      BorderSide(
                                                        color: Theme.of(context).primaryColor,
                                                        width: 2,
                                                      ),
                                                    ),
                                                  ),
                                                  child: const Text('キャンセル'),
                                                  onPressed: () {
                                                    Navigator.pop(
                                                      context,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 12.0), // 右側のアイコンの余白を設定
                            child: Icon(Icons.backspace, size: 30.0), // バックスペースボタン
                          ),
                        ],
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
