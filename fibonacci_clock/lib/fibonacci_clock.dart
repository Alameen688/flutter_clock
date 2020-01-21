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
  String _weatherIconAsset = 'assets/streamline_icons/weather.png';
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
    final weatherIconAsset = getWeatherIconAsset(widget.model.weatherCondition);
    final condition = capitalizeFirstLetter(widget.model.weatherString);
    setState(() {
      _condition = condition;
      _weatherIconAsset = weatherIconAsset;
      _temperature = widget.model.temperatureString;
      _location = widget.model.location;
    });
  }

  @override
  Widget build(BuildContext context) {
    final baseFontSize = MediaQuery.of(context).size.width / 12.0;
    final subtitleFontSize =
        baseFontSize / 2.0 > 20.0 ? baseFontSize / 2.0 : 20.0;
    final bodyFontSize = baseFontSize / 3.5 > 16.0 ? baseFontSize / 3.5 : 16.0;
    final textColor = box5GradientColors != fibColors.emptyGradientColors
        ? Colors.white
        : Color(0xFF3C4043);

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
                color: textColor,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                fontSize: baseFontSize,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        color: textColor,
                      ),
                      Text(
                        _location,
                        style: TextStyle(
                            fontSize: bodyFontSize,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: ImageIcon(
                      AssetImage(_weatherIconAsset),
                      color: textColor,
                      size: 40,
                    ),
                  ),
                  Text(
                    _temperature,
                  ),
                  Text(
                    _condition,
                    style: TextStyle(fontSize: subtitleFontSize),
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

  String capitalizeFirstLetter(String s) =>
      (s?.isNotEmpty ?? false) ? s[0].toUpperCase() + s.substring(1) : s;

  String getWeatherIconAsset(WeatherCondition weatherCondition) {
    String iconAsset;
    switch (weatherCondition) {
      case WeatherCondition.cloudy:
        iconAsset = 'assets/streamline_icons/cloudy.png';
        break;
      case WeatherCondition.foggy:
        iconAsset = 'assets/streamline_icons/foggy.png';
        break;
      case WeatherCondition.rainy:
        iconAsset = 'assets/streamline_icons/rainy.png';
        break;
      case WeatherCondition.snowy:
        iconAsset = 'assets/streamline_icons/snowy.png';
        break;
      case WeatherCondition.sunny:
        iconAsset = 'assets/streamline_icons/sunny.png';
        break;
      case WeatherCondition.thunderstorm:
        iconAsset = 'assets/streamline_icons/thunderstorm.png';
        break;
      case WeatherCondition.windy:
        iconAsset = 'assets/streamline_icons/windy.png';
        break;
      default:
        iconAsset = 'assets/streamline_icons/weather.png';
    }
    return iconAsset;
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
          border: Border.all(width: 1.0, color: Colors.black.withOpacity(0.4)),
          gradient: gradientColors.length > 1
              ? LinearGradient(
                  begin: Alignment(-1.0, -1.0),
                  end: Alignment(1.0, 0.2),
                  colors: gradientColors,
                  stops: <double>[0.1, 1.0],
                )
              : null,
        ),
      ),
    );
  }
}
