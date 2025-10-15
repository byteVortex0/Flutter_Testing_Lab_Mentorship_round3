import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/weather_display.dart';
import 'package:mocktail/mocktail.dart';

class MockWeatherRepo extends Mock implements WeatherRepo {}

void main() {
  group('Test weather Repo', () {
    late WeatherRepo weatherRepo;
    setUp(() {
      weatherRepo = WeatherRepo();
    });
    test('Convert celsius to fahrenheit', () {
      final fahrenheit = weatherRepo.celsiusToFahrenheit(25.0);
      expect(fahrenheit, 77.0);
    });

    test('Convert fahrenheit to celsius', () {
      final celsius = weatherRepo.fahrenheitToCelsius(77.0);
      expect(celsius, 25.0);
    });
  });

  group('Test weather display', () {
    late MockWeatherRepo mockRepo;

    setUp(() {
      mockRepo = MockWeatherRepo();
    });

    testWidgets('Test loading', (WidgetTester tester) async {
      when(() => mockRepo.fetchWeatherData(any())).thenAnswer((_) async {
        return null;
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: WeatherDisplay(weatherRepo: mockRepo)),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Test success', (WidgetTester tester) async {
      when(() => mockRepo.fetchWeatherData(any())).thenAnswer(
        (_) async => {
          'city': 'Egypt',
          'temperature': 15.0,
          'description': 'Rainy',
          'humidity': 85,
          'windSpeed': 8.5,
          'icon': '🌧️',
        },
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: WeatherDisplay(weatherRepo: mockRepo)),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Card), findsOneWidget);
      expect(find.text('Egypt'), findsOneWidget);
      expect(find.text('Rainy'), findsOneWidget);
    });

    testWidgets('Test error', (WidgetTester tester) async {
      when(
        () => mockRepo.fetchWeatherData(any()),
      ).thenAnswer((_) async => null);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: WeatherDisplay(weatherRepo: mockRepo)),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Failed to fetch weather data'), findsOneWidget);
    });
  });
}
