import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';

class FibonacciClock extends StatefulWidget {
  final ClockModel model;

  const FibonacciClock(this.model);

  @override
  _FibonacciClockState createState() => _FibonacciClockState();
}

class _FibonacciClockState extends State<FibonacciClock> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: <Widget>[
        LightBox(
          flex: 2,
          child: Column(
            children: <Widget>[
              LightBox(
                  flex: 2,
                  child: Row(
                    children: <Widget>[
                      LightBox(
                        flex: 2,
                        color: Colors.blue,
                      ),
                      LightBox(
                          flex: 1,
                          child: Column(
                            children: <Widget>[
                              LightBox(
                                color: Colors.red,
                              ),
                              LightBox(
                                color: Colors.white,
                              )
                            ],
                          ))
                    ],
                  )),
              LightBox(
                flex: 4,
                color: Colors.green,
              )
            ],
          ),
        ),
        LightBox(
          flex: 3,
          color: Colors.blue,
        ),
      ],
    ));
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
