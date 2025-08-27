import 'package:equatable/equatable.dart';
import 'package:manage_applications/models/interview/interview_timeline.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_data_section/interview_form_utility.dart';
import 'package:manage_applications/widgets/components/utility.dart';
import 'package:flutter/material.dart';

class Interview {
  final int? id;
  final DateTime date;
  final TimeOfDay time;
  final InterviewTypes type;
  final InterviewsFormat interviewFormat;
  final InterviewStatus status;
  final bool placeUpdated;
  final String? previousInterviewPlace;
  final String? notes;
  final String? answerTime;
  final String? followUpType;
  final DateTime? followUpDate;
  final String interviewPlace;
  final int? jobApplicationId;

  Interview({
    this.id,
    required this.date,
    required this.time,
    required this.type,
    required this.interviewFormat,
    required this.status,
    required this.interviewPlace,
    this.placeUpdated = false,
    this.previousInterviewPlace,
    this.answerTime,
    this.notes,
    this.followUpType,
    this.followUpDate,
    this.jobApplicationId,
  });

  Interview.fromJson(Map<String, dynamic> json)
    : id = json[InterviewTableColumns.id],
      date = DateTime.parse(json[InterviewTableColumns.date]),
      time = fromStringToTimeOfDay(json[InterviewTableColumns.time]),
      type = getInterviewTypeFromString(json[InterviewTableColumns.type]),
      interviewFormat = getInterviewFormatFromString(
        json[InterviewTableColumns.interviewFormat],
      ),
      previousInterviewPlace =
          json[InterviewTableColumns.previousInterviewPlace],
      placeUpdated = fromIntToBool(json[InterviewTableColumns.placeUpdated]),
      status = getInterviewStatusFromString(json[InterviewTableColumns.status]),
      notes = json[InterviewTableColumns.notes],
      answerTime = json[InterviewTableColumns.answerTime],
      followUpType = json[InterviewTableColumns.followUpType],
      interviewPlace = json[InterviewTableColumns.interviewPlace],
      followUpDate =
          json[InterviewTableColumns.followUpDate] != null
              ? DateTime.tryParse(json[InterviewTableColumns.followUpDate])
              : null,
      jobApplicationId = json[InterviewTableColumns.jobApplicationId];

  Interview copyWith({
    int? id,
    DateTime? date,
    TimeOfDay? time,
    InterviewTypes? type,
    InterviewsFormat? interviewFormat,
    InterviewStatus? status,
    bool? placeUpdated,
    String? answerTime,
    String? previousInterviewPlace,
    String? followUpType,
    String? notes,
    DateTime? followUpDate,
    String? interviewPlace,
    int? jobApplicationId,
  }) {
    return Interview(
      id: id ?? this.id,
      date: date ?? this.date,
      time: time ?? this.time,
      type: type ?? this.type,
      interviewFormat: interviewFormat ?? this.interviewFormat,
      placeUpdated: placeUpdated ?? this.placeUpdated,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      previousInterviewPlace:
          previousInterviewPlace ?? this.previousInterviewPlace,
      answerTime: answerTime ?? this.answerTime,
      followUpType: followUpType ?? this.followUpType,
      followUpDate: followUpDate ?? this.followUpDate,
      interviewPlace: interviewPlace ?? this.interviewPlace,
      jobApplicationId: jobApplicationId ?? this.jobApplicationId,
    );
  }

  Map<String, dynamic> toJson() => {
    InterviewTableColumns.date: dbFormat.format(date),
    InterviewTableColumns.time: fromTimeOfDayToString(time),
    InterviewTableColumns.type: type.name,
    InterviewTableColumns.interviewFormat: interviewFormat.name,
    InterviewTableColumns.answerTime: answerTime,
    InterviewTableColumns.placeUpdated: fromBoolToInt(placeUpdated),
    InterviewTableColumns.followUpType: followUpType,
    InterviewTableColumns.notes: notes,
    InterviewTableColumns.previousInterviewPlace: previousInterviewPlace,
    InterviewTableColumns.status: status.name,
    InterviewTableColumns.interviewPlace: interviewPlace,
    InterviewTableColumns.jobApplicationId: jobApplicationId,
  };

  static Interview defaultValue() {
    return Interview(
      date: DateTime.now(),
      time: TimeOfDay.now(),
      type: InterviewTypes.conoscitivo,
      interviewFormat: InterviewsFormat.online,
      status: InterviewStatus.toDo,
      interviewPlace: '',
    );
  }

  @override
  String toString() {
    return '''
      Id_Interview: $id
      Date: ${date.toString()}
      Time: ${time.toString()}
      Type: $type
      Place: $interviewFormat
      answerTime: $answerTime
      status: $status
      followUpType: $followUpType
      followUpDate: ${followUpDate.toString()}
      previousInterviewPlace: $previousInterviewPlace
      interviewPlace: $interviewPlace
      notes: $notes
      jobApplicationId: $jobApplicationId
    ''';
  }
}

const String interviewTable = "interview_table";

class InterviewTableColumns {
  static String id = "_id_interview";
  static String date = "date";
  static String time = "time";
  static String type = "type";
  static String interviewFormat = "interview_format";
  static String placeUpdated = "place_updated";
  static String notes = "notes";
  static String previousInterviewPlace = 'previous_interview_place';
  static String status = "status";
  static String answerTime = "answer_time";
  static String followUpType = "follow_up_type";
  static String followUpDate = "follow_up_date";
  static String interviewPlace = "interview_place";
  static String jobApplicationId = "fk_job_application_id";
}

class InterviewUi extends Equatable {
  final int? id;
  final DateTime date;
  final TimeOfDay time;
  final InterviewTypes type;
  final InterviewsFormat interviewFormat;
  final String? previousInterviewPlace;
  final String? answerTime;
  final bool placeUpdated;
  final String? interviewPlace;
  final DateTime? rescheduleDateTime;
  final DateTime? followUpDate;
  final InterviewStatus status;

  const InterviewUi({
    this.id,
    required this.date,
    required this.time,
    required this.type,
    required this.interviewFormat,
    required this.status,
    this.placeUpdated = false,
    this.previousInterviewPlace,
    this.answerTime,
    this.interviewPlace,
    this.rescheduleDateTime,
    this.followUpDate,
  });

  InterviewUi.fromJson(Map<String, dynamic> json)
    : id = json[InterviewTableColumns.id],
      date = DateTime.parse(json[InterviewTableColumns.date]),
      time = fromStringToTimeOfDay(json[InterviewTableColumns.time]),
      type = getInterviewTypeFromString(json[InterviewTableColumns.type]),
      interviewFormat = getInterviewFormatFromString(
        json[InterviewTableColumns.interviewFormat],
      ),
      previousInterviewPlace =
          json[InterviewTableColumns.previousInterviewPlace],
      placeUpdated = fromIntToBool(json[InterviewTableColumns.placeUpdated]),
      status = getInterviewStatusFromString(json[InterviewTableColumns.status]),
      answerTime = json[InterviewTableColumns.answerTime],
      interviewPlace = json[InterviewTableColumns.interviewPlace],

      rescheduleDateTime = parseDateTimeOrNull(
        json[InterviewTimelineTable.newDateTime],
      ),

      followUpDate =
          json[InterviewTableColumns.followUpDate] != null
              ? DateTime.tryParse(json[InterviewTableColumns.followUpDate])
              : null;

  InterviewUi copyWith({
    int? id,
    InterviewTypes? type,
    InterviewsFormat? interviewFormat,
    InterviewStatus? status,
    bool? placeUpdated,
    String? previousInterviewPlace,
    String? answerTime,
    String? interviewPlace,
    DateTime? rescheduleDateTime,
  }) {
    return InterviewUi(
      id: id ?? this.id,
      date: date,
      time: time,
      type: type ?? this.type,
      placeUpdated: placeUpdated ?? this.placeUpdated,
      interviewFormat: interviewFormat ?? this.interviewFormat,
      interviewPlace: interviewPlace ?? this.interviewPlace,
      previousInterviewPlace: previousInterviewPlace ?? this.previousInterviewPlace,
      status: status ?? this.status,
      answerTime: answerTime ?? this.answerTime,
      rescheduleDateTime: rescheduleDateTime ?? this.rescheduleDateTime,
    );
  }

  @override
  String toString() {
    return '''
      Id_Interview: $id
      Date: ${date.toString()}
      Time: ${time.toString()}
      Type: $type
      Place: $interviewFormat
      placeUpdated: $placeUpdated
      answerTime: $answerTime
      previousInterviewPlace: $previousInterviewPlace
      RescheduleDate; $rescheduleDateTime
      status: $status
      followUpDate: ${followUpDate.toString()}
      interviewPlace: $interviewPlace
    ''';
  }

  @override
  List<Object?> get props => [
    id,
    type,
    interviewFormat,
    status,
    interviewPlace,
  ];
}
