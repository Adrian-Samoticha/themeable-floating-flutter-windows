import 'dart:math';

import 'package:flutter/material.dart';
import 'package:themeable_floating_windows/themeable_floating_windows.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Themeable Floating Windows - Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final WindowContainer _windowContainer = WindowContainer();

  void _openNewWindow() {
    setState(() {
      final properties = WindowProperties(
        childBuilder: (context, constraints, window) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12.0 * 2 + 14.0),
                child: GestureDetector(
                  onPanStart: (_) => print('onPanStart'),
                  onPanDown: (_) => print('onPanDown'),
                  child: Container(
                    color: Colors.grey
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    [Colors.red, () => setState(window.close)],
                    [Colors.green, () => setState(() {
                      window.properties.isMaximized ? window.restore(const Duration(milliseconds: 200), Curves.ease)
                                                    : window.maximize(const Duration(milliseconds: 200), Curves.ease);
                    })],
                  ].map((e) => Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: GestureDetector(
                      onTap: e[1] as void Function(),
                      child: SizedBox(
                        width: 14.0,
                        height: 14.0,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: e[0] as Color,
                            borderRadius: BorderRadius.circular(7.0)
                          )
                        )
                      ),
                    ),
                  )).toList(),
                )
              )
            ],
          );
        },
        backgroundBuilder: (context, constraints, window) {
          return Container(
            decoration: BoxDecoration(
              color: const Color.fromRGBO(250, 250, 250, 0.95),
              boxShadow: const [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.2), blurRadius: 12.0, spreadRadius: 4.0, offset: Offset(0.0, 2.0))],
              borderRadius: BorderRadius.circular(14.0),
            ),
          );
        },
        position: MutableRectangle(0.1, 0.1, 0.8, 0.8),
        enableGrabCursor: true,
        onDragBegin: (window) => print('onDragBegin'),
        onDragUpdate: (window) => print('onDragUpdate'),
        onDragEnd: (window) => print('onDragEnd'),
      );
      _windowContainer.openWindow(properties);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'You have this many windows open:',
                ),
                Text(
                  '${_windowContainer.windowList.length}',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            ),
          ),
          ThemeableFloatingWindowManager(windowContainer: _windowContainer)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openNewWindow,
        tooltip: 'Open New Window',
        child: const Icon(Icons.add),
      ),
    );
  }
}
