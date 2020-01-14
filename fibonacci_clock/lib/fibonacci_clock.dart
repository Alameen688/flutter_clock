import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:intl/intl.dart';

class FibonacciClock extends StatefulWidget {
  final ClockModel model;

  const FibonacciClock(this.model);

  @override
  _FibonacciClockState createState() => _FibonacciClockState();
}

class _FibonacciClockState extends State<FibonacciClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;
  List<int> _fibonacciSequence = [1, 1, 2, 3, 5];
  Color box1AColor = Colors.white;
  Color box1BColor = Colors.white;
  Color box2Color = Colors.white;
  Color box3Color = Colors.white;
  Color box5Color = Colors.white;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(FibonacciClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(
          Duration(minutes: 1) -
              Duration(seconds: _dateTime.second) -
              Duration(milliseconds: _dateTime.millisecond),
          _updateTime);
    });
    final int hour = int.parse(DateFormat('hh').format(_dateTime));
    final int minute = int.parse(DateFormat('mm').format(_dateTime));
    generateLightBoxColors(hour, minute);
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Column(
            children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Row(
                    children: <Widget>[
                      LightBox(
                        flex: 2,
                        color: box2Color,
                      ),
                      Expanded(
                          flex: 1,
                          child: Column(
                            children: <Widget>[
                              LightBox(
                                color: box1AColor,
                              ),
                              LightBox(
                                color: box1BColor,
                              )
                            ],
                          ))
                    ],
                  )),
              LightBox(
                flex: 4,
                color: box3Color,
              )
            ],
          ),
        ),
        LightBox(
          flex: 3,
          color: box5Color,
        ),
      ],
    ));
  }

  void generateLightBoxColors(int hour, int minute) {
    final minRemainder = minute % 5;

    if (minRemainder == 0) {
      minute = minute ~/ 5;
    } else {
      minute = minute - minRemainder;
      minute ~/= 5;
    }

    final hrAddends = getAddends(hour);
    final minAddends = getAddends(minute);

    getColors(hrAddends, minAddends);

    if (hour == 00 || hour == 12) {
      box1BColor = Colors.red;
      hour = 12;
    } else {
      box1BColor = Colors.white;
    }
  }

  List<int> getAddends(int timeSum) {
    List<int> addends = [];
    int index = _fibonacciSequence.length - 1;

    while (timeSum > 0) {
      final currentPossibleAddend = _fibonacciSequence[index];

      if (timeSum >= currentPossibleAddend) {
        addends.add(currentPossibleAddend);
        timeSum -= currentPossibleAddend;
      }

      index--;
    }

    return addends;
  }

  getColors(List<int> hrAddends, List<int> minAddends) {
    if (hrAddends.contains(5) && minAddends.contains(5)) {
      box5Color = Colors.blue;
    } else if (hrAddends.contains(5)) {
      box5Color = Colors.red;
    } else if (minAddends.contains(5)) {
      box5Color = Colors.green;
    } else {
      box5Color = Colors.white;
    }

    if (hrAddends.contains(3) && minAddends.contains(3)) {
      box3Color = Colors.blue;
    } else if (hrAddends.contains(3)) {
      box3Color = Colors.red;
    } else if (minAddends.contains(3)) {
      box3Color = Colors.green;
    } else {
      box3Color = Colors.white;
    }

    if (hrAddends.contains(2) && minAddends.contains(2)) {
      box2Color = Colors.blue;
    } else if (hrAddends.contains(2)) {
      box2Color = Colors.red;
    } else if (minAddends.contains(2)) {
      box2Color = Colors.green;
    } else {
      box2Color = Colors.white;
    }

    if (hrAddends.contains(1) && minAddends.contains(1)) {
      box1AColor = Colors.blue;
    } else if (hrAddends.contains(1)) {
      box1AColor = Colors.red;
    } else if (minAddends.contains(1)) {
      box1AColor = Colors.green;
    } else {
      box1AColor = Colors.white;
    }
  }
}

class LightBox extends StatelessWidget {
  final Color color;
  final Widget child;
  final int flex;

  const LightBox(
      {Key key, this.color = Colors.white, this.flex = 1, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: child ??
          Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1.0),
              color: color,
            ),
          ),
    );
  }
}
