/// Example of a numeric combo chart with two series rendered as bars, and a
/// third rendered as a line.
// ignore_for_file: unnecessary_new
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class NumericComboLineBarChart extends StatelessWidget {
  static const secondaryMeasureAxisId = 'secondaryMeasureAxisId';
  final List<charts.Series<dynamic, DateTime>> seriesList;
  final bool animate = false;

  NumericComboLineBarChart(this.seriesList);

  /// Creates a [LineChart] with sample data and no transition.
  factory NumericComboLineBarChart.withSampleData() {
    return new NumericComboLineBarChart(
      _createSampleData(),
      // Disable animations for image tests.
      //animate: false,
    );
  }


  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(seriesList,
      // Use same number of ticks for both axis  
      primaryMeasureAxis: new charts.NumericAxisSpec(
        tickProviderSpec:
          new charts.BasicNumericTickProviderSpec(desiredTickCount: 5)),
      secondaryMeasureAxis: new charts.NumericAxisSpec(
        tickProviderSpec:
          new charts.BasicNumericTickProviderSpec(desiredTickCount: 5)),
        // Configure the default renderer as a line renderer. This will be used
        // for any series that does not define a rendererIdKey.
        defaultRenderer: new charts.LineRendererConfig(),
        // Custom renderer configuration for the bar series.
        customSeriesRenderers: [
          new charts.BarRendererConfig(
              // ID used to link series to this renderer.
              customRendererId: 'customBar')
        ]);
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<dynamic, DateTime>> _createSampleData() {
    final latest_mood = [
      new Mood(DateTime.now(), 5),
    ];

    final latest_sun = [
     new Sun(DateTime.now(), 2),
    ];

    return [
      // ignore: unnecessary_new
      new charts.Series<Mood, DateTime>(
        id: 'Mood',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Mood mood, _) => mood.date, //mode.date
        measureFn: (Mood mood, _) => mood.mood,
        data: latest_mood,
      )
        // Configure our custom bar renderer for this series.
        //
        ..setAttribute(charts.rendererIdKey, 'customBar'),
      new charts.Series<Sun, DateTime>(
        id: 'Sun',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (Sun sun, _) => sun.date, //sun.date
        measureFn: (Sun sun, _) => sun.sun,
        data: latest_sun
      )
      ..setAttribute(charts.measureAxisIdKey, secondaryMeasureAxisId),
    ];
  }
}

class Mood{
  final DateTime date;
  final num mood;

  Mood(this.date, this.mood);
}

class Sun{
  final DateTime date;
  final num sun;

  Sun(this.date, this.sun);
}



