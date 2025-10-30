import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manage_applications/widgets/components/snack_bar_widget.dart';
import 'package:url_launcher/url_launcher.dart';

final DateFormat uiFormat = DateFormat("dd-MM-yyyy");
final DateFormat dbFormat = DateFormat("yyyy-MM-dd");
final DateFormat dateTimeFormatUI = DateFormat("dd-MM-yyyy 'alle' HH:mm");

final NumberFormat getRalFormatter = NumberFormat('#,###', 'it_IT');

String fromTimeOfDayToString(TimeOfDay time) {
  return '${time.hour}:${time.minute}';
}

String formatDateTimeForDb(DateTime date, TimeOfDay time) {
  return '${uiFormat.format(date)} : ${fromTimeOfDayToString(time)}';
}

DateTime buildDateTime(DateTime date, TimeOfDay time) {
  return DateTime(
    date.year,
    date.month,
    date.day,
    time.hour,
    time.minute,
    DateTime.now().second,
    DateTime.now().millisecond,
  );
}

DateTime? parseDateTimeOrNull(String? dateTime) {
  if (dateTime == null) return null;
  return DateTime.tryParse(dateTime);
}

String? convertToIsoString(DateTime? dateTime) {
  return dateTime?.toIso8601String();
}

String convertDateTimeToUI(DateTime dateTime) {
  return dateTimeFormatUI.format(dateTime);
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

List<String> buildMissingFieldsMessage(Map<String, dynamic> fields) {
  final missing =
      fields.entries
          .where((entry) => entry.value == null)
          .map((entry) => entry.key)
          .toList();

  return missing;
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
