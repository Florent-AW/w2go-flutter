// lib\core\common\utils\date_formatter.dart

class DateFormatter {
  static String formatTripDates(DateTime startDate, DateTime endDate) {
    // Noms des mois en français
    const months = [
      'jan.', 'fév.', 'mars', 'avr.', 'mai', 'juin',
      'juil.', 'août', 'sept.', 'oct.', 'nov.', 'déc.'
    ];

    // Si même mois et année
    if (startDate.month == endDate.month && startDate.year == endDate.year) {
      return '${startDate.day} - ${endDate.day} ${months[startDate.month - 1]}';
    }

    // Si même année
    if (startDate.year == endDate.year) {
      return '${startDate.day} ${months[startDate.month - 1]} - ${endDate.day} ${months[endDate.month - 1]}';
    }

    // Différentes années
    return '${startDate.day} ${months[startDate.month - 1]} ${startDate.year} - ${endDate.day} ${months[endDate.month - 1]} ${endDate.year}';
  }

  static String formatShortDate(DateTime date) {
    const months = [
      'jan.', 'fév.', 'mars', 'avr.', 'mai', 'juin',
      'juil.', 'août', 'sept.', 'oct.', 'nov.', 'déc.'
    ];
    return '${date.day} ${months[date.month - 1]}';
  }
}