# Fibonacci Clock

A Fibonacci clock made for the Lenovo Smart Clock as an entry for the Flutter Clock Challenge.

## Overview

The Fibonacci clock uses the first five (5) numbers of the Fibonacci sequence: 1, 1, 2, 3 and 5 to represent time.
You can read more about the [Fibonacci Sequence on Wikipedia](https://en.wikipedia.org/wiki/Fibonacci_number)


## How to tell time
To tell time, you need to do some maths :)

- The screen of the clock is made up of 5 squares which are sized with respect to the first 5 Fibonacci numbers.
- The clock uses 4 colors: Red, Green, Blue and White, to represent time in the square. (P.S The app uses a linear gradient to generate a shade of each color for beauty puporses.)
- The clock uses the 12-hour format.
- Hours are displayed using Red and/or Blue. Minutes are displayed using Green and/or Blue. This means Blue is used to display both hours and minutes in a square. White squares are then ignored!
- To read the number of hours, add up the corresponding values of all Red and Blue squares (PS: The Clock could also display Red only or Blue only depending on the time).
- To read the number of minutes, add up the corresponding values of all Green and Blue squares. (PS: The Clock could also display Green only or Blue only depending on the time). Go ahead and multiply the sum of those values by 5 to get the actual minute value.
- BONUS: Weather information is displayed on the largest square (The square of value: 5).

|   |   |   |
|---|---|---|
| ![Four Twenty 04:20](https://res.cloudinary.com/mentos/flutter-clock/4-20_sunny.png) 4:20 | ![Two Fifty-Five 02:55](https://res.cloudinary.com/mentos/flutter-clock/2-55_sunny.png) 2:55 | ![Three O' clock 03:00](https://res.cloudinary.com/mentos/flutter-clock/3-00_sunny.png) 3:00 |
|   |   |   |

NB: The clock uses a 12-hour format whose minutes are displayed in 5 minutes increment. Which means the 3:15 and 3:20 are displayable time but at a time in-between such as 3:16, 3:17, 3:18, 3:19 the clock would remain at 3:15.

## Author

Ogundiran Al-Ameen

## License

Under [MIT license](/fibonacci_clock/LICENSE).

## Credits

- Montserrat Font by Google Fonts (OFL license)
- Streamline icons by [Streamlineicons.com](https://app.streamlineicons.com/streamline-regular)

This clock is inspired by Philippe Chrétien who created [an open source arduino powered hardware Fibonacci clock in 2015](https://www.kickstarter.com/projects/basbrun/fibonacci-clock-an-open-source-clock-for-nerds-wit)

## Getting Started

For help getting started with Flutter, view the
[online documentation](https://flutter.dev/docs)
