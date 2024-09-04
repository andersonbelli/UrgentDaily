extension DateTimeFormatter on DateTime {
  // Format DateTime to dd/mm/yyyy
  String formatDate() => '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year';
}