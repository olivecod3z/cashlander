import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DoughnutChart extends StatefulWidget {
  const DoughnutChart({super.key});

  @override
  State<DoughnutChart> createState() => _DoughnutChartState();
}

class _DoughnutChartState extends State<DoughnutChart> {
  late List<_ChartData> chartData;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();

    // Calculate total for percentages
    final rawData = [
      _ChartData('Transport', 30, Colors.blue),
      _ChartData('Food', 34, Colors.orange),
      _ChartData('Healthcare', 25, Colors.green),
      _ChartData('Misc', 15, Colors.purple),
    ];

    final total = rawData.fold<double>(0, (sum, item) => sum + item.value);

    // Add percentages to category names
    chartData =
        rawData.map((item) {
          final percentage = (item.value / total * 100).round();
          return _ChartData(
            '${item.category} ($percentage%)',
            item.value,
            item.color,
          );
        }).toList();

    // Trigger animation after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 220,
          child: SfCircularChart(
            legend: Legend(
              isVisible: true,
              position: LegendPosition.right,
              alignment: ChartAlignment.center,
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                letterSpacing: 0,
                color: Colors.black87,
              ),
              iconHeight: 15,
              iconWidth: 15,
              itemPadding: 17,
            ),
            series: <DoughnutSeries<_ChartData, String>>[
              DoughnutSeries<_ChartData, String>(
                dataSource: _isLoaded ? chartData : [],
                xValueMapper: (data, _) => data.category,
                yValueMapper: (data, _) => data.value,
                pointColorMapper: (data, _) => data.color,
                innerRadius: '65%',
                radius: '80%',
                // Animation properties
                animationDuration: 2000,
                animationDelay: 100,

                // Visual properties
                cornerStyle: CornerStyle.bothFlat,
                explode: true,
                explodeAll: true,
                explodeOffset: '8%',
                // Data labels
                // dataLabelSettings: DataLabelSettings(
                //   isVisible: true,
                //   labelPosition: ChartDataLabelPosition.outside,
                //   useSeriesColor: true,
                // ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChartData {
  final String category;
  final double value;
  final Color color;
  _ChartData(this.category, this.value, this.color);
}
