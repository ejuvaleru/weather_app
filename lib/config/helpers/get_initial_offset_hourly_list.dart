double getInitialOffsetHourlyList(String lastUpdateHour) {
  if (lastUpdateHour == '00:00') return 0; // If last update is midnight then return 0 cause its the begin of the day

  int hour = int.parse(lastUpdateHour.split(':').first);
  final minutes = int.parse(lastUpdateHour.split(':').last);

  if (minutes >= 30 && (hour + 1) <= 23) {
    hour += 1;
  }

  return (80 * hour).toDouble();
}
