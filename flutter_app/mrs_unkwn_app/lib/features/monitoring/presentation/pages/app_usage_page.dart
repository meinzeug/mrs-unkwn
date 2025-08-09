import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Displays various charts summarizing app usage statistics.
class AppUsagePage extends StatelessWidget {
  const AppUsagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final barGroups = _dailyUsageData();
    final pieSections = _categoryData();
    final lineSpots = _weeklyUsageSpots();

    return Scaffold(
      appBar: AppBar(title: const Text('App Usage Statistics')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Heutige Nutzung',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                barGroups: barGroups,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) =>
                          Text(value.toInt().toString()),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Kategorien',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(sections: pieSections),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Wochenverlauf',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(spots: lineSpots),
                ],
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) => Text('T${value.toInt()}'),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _export(context),
            icon: const Icon(Icons.share),
            label: const Text('Exportieren'),
          ),
        ],
      ),
    );
  }

  static List<BarChartGroupData> _dailyUsageData() {
    final hours = [2.0, 1.5, 3.0, 4.0, 1.0, 0.5, 2.5];
    return [
      for (var i = 0; i < hours.length; i++)
        BarChartGroupData(x: i, barRods: [
          BarChartRodData(toY: hours[i], width: 12, color: Colors.blue),
        ])
    ];
  }

  static List<PieChartSectionData> _categoryData() {
    const categories = {
      'Lernen': 40.0,
      'Spiele': 30.0,
      'Sozial': 20.0,
      'Sonstiges': 10.0,
    };
    return [
      for (final entry in categories.entries)
        PieChartSectionData(
          value: entry.value,
          title: entry.key,
          color: Colors.primaries[categories.keys.toList().indexOf(entry.key)],
          radius: 50,
        )
    ];
  }

  static List<FlSpot> _weeklyUsageSpots() {
    final hours = [3, 2, 4, 5, 2, 1, 3];
    return [
      for (var i = 0; i < hours.length; i++)
        FlSpot(i.toDouble(), hours[i].toDouble())
    ];
  }

  static void _export(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export gestartet')),
    );
  }
}
