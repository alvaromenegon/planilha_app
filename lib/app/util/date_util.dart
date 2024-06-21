class DateUtil {
  static final List<String> months = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro'
  ];

  static String getMonth(String month) {
    return months[int.parse(month) - 1];
  }

  static List<String> generateYears({int min = 2024, int max = 2025}) {
    return List.generate(max - min + 1, (i) => (min + i).toString());
  }

  static String getMonthNumberAsString(String month) {
    return '${months.indexOf(month) + 1}';
  }
}
