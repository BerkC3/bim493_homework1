const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

String _twoDigits(int n) => n.toString().padLeft(2, '0');

String formatEventDate(DateTime d) =>
    '${_weekdays[d.weekday - 1]}, ${d.day} ${_months[d.month - 1]} ${d.year}';

String formatEventTime(DateTime d) =>
    '${_twoDigits(d.hour)}:${_twoDigits(d.minute)}';

String formatEventDateTime(DateTime d) =>
    '${formatEventDate(d)} • ${formatEventTime(d)}';
