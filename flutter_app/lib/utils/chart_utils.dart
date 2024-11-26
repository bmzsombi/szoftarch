class ChartData {
  final DateTime date;
  final double value;

  ChartData(this.date, this.value);
}
List<ChartData> convertToChartData(List<Map<String, dynamic>> inputList) {
  return inputList.map((element) {
    return ChartData(
      DateTime.parse(element['timestamp']),
      (element['value'] as num).toDouble(),
    );
  }).toList();
}
