import 'package:manage_applications/widgets/components/snack_bar_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final DateFormat uiFormat = DateFormat("dd-MM-yyyy");
final DateFormat dbFormat = DateFormat("yyyy-MM-dd");

/* String formatTimeOfDay(
  BuildContext context,
  TimeOfDay time, {
  bool alwaysUse24HourFormat = true,
}) {
  return MaterialLocalizations.of(context)
      .formatTimeOfDay(time, alwaysUse24HourFormat: alwaysUse24HourFormat);
} */

String fromTimeOfDayToString(TimeOfDay time) {
  return '${time.hour}:${time.minute}';
}

String formatDateTimeForDb(DateTime date, TimeOfDay time) {
  return '${uiFormat.format(date)} : ${fromTimeOfDayToString(time)}';
}

String padTwoDigits(int n) => n.toString().padLeft(2, '0');

String convertToIsoDateTime(String oldDateStr) {
  final parts = oldDateStr.split(' : ');
  if (parts.length != 2) throw FormatException("Formato data non valido");
  
  final datePart = parts[0];  // "DATE"
  final timePart = parts[1];  // "TIME"
  
  final dateParts = datePart.split('-');
  if (dateParts.length != 3) throw FormatException("Formato data non valido");
  
  final day = padTwoDigits(int.parse(dateParts[0]));
  final month = padTwoDigits(int.parse(dateParts[1]));
  final year = dateParts[2];
  
  final timeParts = timePart.split(':');
  if (timeParts.length != 2) throw FormatException("Formato orario non valido");
  
  final hour = padTwoDigits(int.parse(timeParts[0]));
  final minute = padTwoDigits(int.parse(timeParts[1]));
  
  return "$year-$month-$day $hour:$minute:00";
}


bool fromIntToBool(int? value) => (value ?? 0) != 0;
int fromBoolToInt(bool val) => val ? 1 : 0;

TimeOfDay fromStringToTimeOfDay(String time) {
  final splitString = time.split(":");
  final int h = int.parse(splitString[0]);
  final int m = int.parse(splitString[1]);

  return TimeOfDay(hour: h, minute: m);
}

Future<void> tryToLaunchUrl({
  required BuildContext context,
  required String link,
  LaunchMode mode = LaunchMode.externalApplication,
}) async {
  if (!await launchUrl(Uri.parse(link), mode: mode)) {
    if (context.mounted) {
      showErrorSnackBar(message: "l'apertura del link", context: context);
    }
  }
}

/// DebugPrint List

void debugPrintList<T>(List<T> list) {
  for (var element in list) {
    debugPrint(element.toString());
  }
}

void debugPrintErrorUtility(Object? error, StackTrace? stackTrace) {
  debugPrint("Error => $error");
  debugPrint("Stack => $stackTrace");
}

void navigatorPush(
  BuildContext context,
  Widget pageToGo, [
  RouteSettings? settings,
]) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => pageToGo, settings: settings),
  );
}

T? getRouteArg<T>(BuildContext context) {
  final args = ModalRoute.of(context)?.settings.arguments;
  if (args is T) return args;
  return null;
}

enum ViewModel { list, form }

//Utile per tipi più complessi.

class PageArgs {
  final int id;

  PageArgs({required this.id});

  factory PageArgs.fromRoute(dynamic args) {
    if (args is PageArgs) return args;
    return PageArgs(id: 0);
  }
}
