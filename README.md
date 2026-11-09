# Resistor Studio

A Material 3 resistor utility with a live four- and five-band decoder, Ohm's law calculator, component reference, and practical guide. Built with Flutter and the standard library only.

## Run

Requires Flutter 3.24 or newer and Dart 3.5 or newer. From the project directory:

```sh
flutter pub get
flutter run -d chrome
```

The web entry point is included. To generate the native runner scaffolding for your installed Flutter SDK, run `flutter create --platforms=android,ios .` before launching on a device with `flutter run`. Native iOS builds require macOS and Xcode.

Run checks with `flutter analyze` and `flutter test`.

The calculator uses volts, amperes and ohms. Results are nominal; verify component ratings and circuit safety against the manufacturer's datasheet.

The included tests cover decoding, tolerance, input validation, Ohm's law, and responsive navigation.
