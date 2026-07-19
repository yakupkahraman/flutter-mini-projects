import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StudyChart extends StatelessWidget {
  final Map<String, double> studyData;
  final int currentWeekIndex;
  final VoidCallback onPreviousWeek;
  final VoidCallback? onNextWeek;

  const StudyChart({
    super.key,
    required this.studyData,
    required this.currentWeekIndex,
    required this.onPreviousWeek,
    this.onNextWeek,
  });

  List<DateTime> _getWeekDates(int weekOffset) {
    final now = DateTime.now();
    final monday = now.subtract(
      Duration(days: now.weekday - 1 + (weekOffset * 7)),
    );
    return List.generate(7, (index) => monday.add(Duration(days: index)));
  }

  List<FlSpot> _getWeeklyChartData() {
    final weekDates = _getWeekDates(currentWeekIndex);
    return weekDates.asMap().entries.map((entry) {
      final index = entry.key;
      final date = entry.value;
      final dateKey =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final hours = studyData[dateKey] ?? 0.0;

      return FlSpot(index.toDouble(), hours);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final weekDates = _getWeekDates(currentWeekIndex);
    final weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final weeklyData = _getWeeklyChartData();
    final maxWeeklyHours = weeklyData
        .map((spot) => spot.y)
        .fold(0.0, (max, hours) => hours > max ? hours : max);

    return Container(
      height: 300,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey.shade900,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: onPreviousWeek,
                icon: const Icon(Icons.chevron_left, color: Colors.white),
              ),
              Text(
                '${weekDates.first.day}/${weekDates.first.month} - ${weekDates.last.day}/${weekDates.last.month}',
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
              IconButton(
                onPressed: onNextWeek,
                icon: const Icon(Icons.chevron_right, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 8, right: 16, top: 12),
              child: LineChart(
                LineChartData(
                  maxY: maxWeeklyHours == 0 ? 8.0 : maxWeeklyHours + 1,
                  minY: 0,
                  lineBarsData: [
                    LineChartBarData(
                      spots: weeklyData,
                      color: Colors.green,
                      barWidth: 3,
                      isCurved: false,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < weekDays.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                weekDays[index],
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        reservedSize: 35,
                        getTitlesWidget: (value, meta) {
                          return Container(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              '${value.toInt()}h',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.white70,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 1,
                    getDrawingVerticalLine: (value) {
                      return FlLine(color: Colors.white10, strokeWidth: 1);
                    },
                    getDrawingHorizontalLine: (value) {
                      return FlLine(color: Colors.white10, strokeWidth: 1);
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
