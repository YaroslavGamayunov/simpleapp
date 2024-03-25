import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simpleapp/criteria_screen.dart';

import 'option_button.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _mainColor = 'pink';
  String _alertType = 'dialog';
  String _transitionType = 'topToBottom';
  bool _isOptionSelected = false;

  final Map<String, Color> _colorOptions = {
    'pink': Colors.pink,
    'yellow': Colors.yellow,
    'green': Colors.green,
  };

  final List<String> _alertOptions = ['dialog', 'snackbar'];
  final List<String> _transitionOptions = [
    'bottomToTop',
    'topToBottom',
    'rightToLeft'
  ];

  void _selectRandomOptions() {
    setState(() {
      _mainColor =
          _colorOptions.keys.elementAt(Random().nextInt(_colorOptions.length));
      _alertType = _alertOptions[Random().nextInt(_alertOptions.length)];
      _transitionType =
          _transitionOptions[Random().nextInt(_transitionOptions.length)];
      _isOptionSelected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Подбор варианта на экзамен'),
        backgroundColor: _colorOptions[_mainColor],
      ),
      body: ListView(children: [
        Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Основной цвет',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Row(
                  children: _colorOptions.keys.map((String color) {
                    return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: OptionButton(
                          optionName: color,
                          isSelected: _mainColor == color,
                          onSelect: () {
                            setState(() {
                              _mainColor = color;
                            });
                          },
                        ));
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Text(
                  'Показ результата',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Row(
                  children: _alertOptions.map((String type) {
                    return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: OptionButton(
                          optionName: type,
                          isSelected: _alertType == type,
                          onSelect: () {
                            setState(() {
                              _alertType = type;
                            });
                          },
                        ));
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Text(
                  'Переход между экранами',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Wrap(
                  children: _transitionOptions.map((String type) {
                    return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: OptionButton(
                          optionName: type,
                          isSelected: _transitionType == type,
                          onSelect: () {
                            setState(() {
                              _transitionType = type;
                            });
                          },
                        ));
                  }).toList(),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _selectRandomOptions,
                  child: const Text('Подобрать вариант'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          var begin = const Offset(0.0, 1.0);
                          var end = Offset.zero;

                          switch (_transitionType) {
                            case 'bottomToTop':
                              begin = const Offset(0.0, 1.0);
                              end = Offset.zero;
                              break;

                            case 'topToBottom':
                              begin = const Offset(0.0, -1.0);
                              end = Offset.zero;
                              break;
                            case 'rightToLeft':
                              begin = const Offset(1.0, 0.0);
                              end = Offset.zero;
                              break;

                          }

                          final tween = Tween(begin: begin, end: end);
                          final offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            CriteriaScreen(),
                      ),
                    );
                  },
                  child: const Text('Открыть критерии'),
                ),
                if (_isOptionSelected)
                  ElevatedButton(
                    onPressed: () {
                      if (_alertType == 'dialog') {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Ваш выбор'),
                              content: Text(
                                  'Цвет: $_mainColor, Переход: $_transitionType'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            );
                          },
                        );
                      } else if (_alertType == 'snackbar') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Цвет: $_mainColor, Переход: $_transitionType'),
                          ),
                        );
                      }
                    },
                    child: const Text('Открыть Dialog/SnackBar'),
                  ),
              ],
            ))
      ]),
    );
  }
}
