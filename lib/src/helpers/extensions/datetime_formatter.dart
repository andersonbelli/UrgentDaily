extension DateTimeFormatter on DateTime {
  // Format DateTime to dd/mm/yyyy
  String formatDate() =>
      '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year';
}

extension StringDateTime on String {
  // Format String of format dd/mm/yyyy to DateTime
  // 01/34/6789
  DateTime convertStringToDateTime() => DateTime(
        int.parse(
          substring(6, 10),
        ),
        int.parse(
          substring(3, 5),
        ),
        int.parse(
          substring(0, 2),
        ),
      );
}
