import 'dart:async';

import 'package:fibonacci_clock/colors.dart' as fibColors;
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
  WeatherCondition _weatherCondition; //TODO Change from string
  String _temperature = '';
  String _condition = '';
  String _location = '';
  Timer _timer;
  List<int> _fibonacciSequence = [1, 1, 2, 3, 5];

  List<Color> box1AGradientColors = fibColors.emptyGradientColors,
      box1BGradientColors = fibColors.emptyGradientColors,
      box2GradientColors = fibColors.emptyGradientColors,
      box3GradientColors = fibColors.emptyGradientColors,
      box5GradientColors = fibColors.emptyGradientColors;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);

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
      _temperature = widget.model.temperatureString;
      _condition = widget.model.weatherString;
      _weatherCondition = widget.model.weatherCondition;
      _location = widget.model.location;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.model.is24HourFormat) {
      debugPrint('Hey Sorry! This clock only supports a 12 hour format');
    }
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
                        gradientColors: box2GradientColors,
                      ),
                      Expanded(
                          flex: 1,
                          child: Column(
                            children: <Widget>[
                              LightBox(
                                gradientColors: box1AGradientColors,
                              ),
                              LightBox(
                                gradientColors: box1BGradientColors,
                              )
                            ],
                          ))
                    ],
                  )),
              LightBox(
                flex: 4,
                gradientColors: box3GradientColors,
              )
            ],
          ),
        ),
        LightBox(
          flex: 3,
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: DefaultTextStyle(
              style: TextStyle(
                // TODO: USE RESPONSIVE COLORS (White on white background won't display)
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                // TODO: Use SCALABLE FONT SIZE BY WIDTH
                fontSize: 25,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                      Text(
                        _location,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Spacer(),
                  Icon(
                    getWeatherIconData(_weatherCondition),
                    color: Colors.white,
                    size: 40,
                  ),
                  Text(
                    _temperature,
                    style: TextStyle(fontSize: 60),
                  ),
                  Text(
                    _condition,
                  )
                ],
              ),
            ),
          ),
          gradientColors: box5GradientColors,
        ),
      ],
    ));
  }

  IconData getWeatherIconData(WeatherCondition weatherCondition) {
    IconData icon;
    switch (weatherCondition) {
      case WeatherCondition.cloudy:
        icon = Icons.wb_cloudy;
        break;
      case WeatherCondition.foggy:
        icon = Icons.wb_cloudy;
        break;
      case WeatherCondition.rainy:
        icon = Icons.wb_iridescent;
        break;
      case WeatherCondition.snowy:
        icon = Icons.wb_cloudy;
        break;
      case WeatherCondition.sunny:
        icon = Icons.wb_sunny;
        break;
      case WeatherCondition.thunderstorm:
        icon = Icons.wb_cloudy;
        break;
      case WeatherCondition.windy:
        icon = Icons.wb_cloudy;
        break;
      default:
        icon = null;
    }
    return icon;
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
      box1BGradientColors = fibColors.redGradientColors;

      hour = 12;
    } else {
      box1BGradientColors = fibColors.emptyGradientColors;
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
      box5GradientColors = fibColors.blueGradientColors;
    } else if (hrAddends.contains(5)) {
      box5GradientColors = fibColors.redGradientColors;
    } else if (minAddends.contains(5)) {
      box5GradientColors = fibColors.greenGradientColors;
    } else {
      box5GradientColors = fibColors.emptyGradientColors;
    }

    if (hrAddends.contains(3) && minAddends.contains(3)) {
      box3GradientColors = fibColors.blueGradientColors;
    } else if (hrAddends.contains(3)) {
      box3GradientColors = fibColors.redGradientColors;
    } else if (minAddends.contains(3)) {
      box3GradientColors = fibColors.greenGradientColors;
    } else {
      box3GradientColors = fibColors.emptyGradientColors;
    }

    if (hrAddends.contains(2) && minAddends.contains(2)) {
      box2GradientColors = fibColors.blueGradientColors;
    } else if (hrAddends.contains(2)) {
      box2GradientColors = fibColors.redGradientColors;
    } else if (minAddends.contains(2)) {
      box2GradientColors = fibColors.greenGradientColors;
    } else {
      box2GradientColors = fibColors.emptyGradientColors;
    }

    if (hrAddends.contains(1) && minAddends.contains(1)) {
      box1AGradientColors = fibColors.blueGradientColors;
    } else if (hrAddends.contains(1)) {
      box1AGradientColors = fibColors.redGradientColors;
    } else if (minAddends.contains(1)) {
      box1AGradientColors = fibColors.greenGradientColors;
    } else {
      box1AGradientColors = fibColors.emptyGradientColors;
    }
  }
}

class LightBox extends StatelessWidget {
  final Color color;
  final Widget child;
  final int flex;
  final List<Color> gradientColors;

  const LightBox(
      {Key key,
      this.color = Colors.white,
      this.flex = 1,
      this.child,
      this.gradientColors = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        child: child,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(width: 1.0, color: Colors.black.withOpacity(0.3)),
          gradient: gradientColors.length > 1
              ? LinearGradient(
                  begin: Alignment(-1.0, -1.0),
                  end: Alignment(1.0, 1.0),
                  colors: gradientColors,
                  stops: <double>[0.1, 1.0],
                )
              : null,
        ),
      ),
    );
  }
}
