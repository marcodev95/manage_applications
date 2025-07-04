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
  final String? notes;
  final String? answerTime;
  final String? followUpType;
  final DateTime? followUpDate;
  final String interviewPlace;
  final int? jobDataId;

  Interview({
    this.id,
    required this.date,
    required this.time,
    required this.type,
    required this.interviewFormat,
    required this.status,
    required this.interviewPlace,
    this.answerTime,
    this.notes,
    this.followUpType,
    this.followUpDate,
    this.jobDataId,
  });

  Interview.fromJson(Map<String, dynamic> json)
    : id = json[InterviewTableColumns.id],
      date = DateTime.parse(json[InterviewTableColumns.date]),
      time = fromStringToTimeOfDay(json[InterviewTableColumns.time]),
      type = getInterviewTypeFromString(json[InterviewTableColumns.type]),
      interviewFormat = getInterviewFormatFromString(
        json[InterviewTableColumns.interviewFormat],
      ),
      status = getInterviewStatusFromString(json[InterviewTableColumns.status]),
      notes = json[InterviewTableColumns.notes],
      answerTime = json[InterviewTableColumns.answerTime],
      followUpType = json[InterviewTableColumns.followUpType],
      interviewPlace = json[InterviewTableColumns.interviewPlace],
      followUpDate =
          json[InterviewTableColumns.followUpDate] != null
              ? DateTime.tryParse(json[InterviewTableColumns.followUpDate])
              : null,
      jobDataId = json[InterviewTableColumns.jobDataId];

  Interview copyWith({
    int? id,
    DateTime? date,
    TimeOfDay? time,
    InterviewTypes? type,
    InterviewsFormat? interviewFormat,
    InterviewStatus? status,
    String? answerTime,
    String? followUpType,
    String? notes,
    DateTime? followUpDate,
    String? interviewPlace,
    int? jobDataId,
  }) {
    return Interview(
      id: id ?? this.id,
      date: date ?? this.date,
      time: time ?? this.time,
      type: type ?? this.type,
      interviewFormat: interviewFormat ?? this.interviewFormat,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      answerTime: answerTime ?? this.answerTime,
      followUpType: followUpType ?? this.followUpType,
      followUpDate: followUpDate ?? this.followUpDate,
      interviewPlace: interviewPlace ?? this.interviewPlace,
      jobDataId: jobDataId ?? this.jobDataId,
    );
  }

  Map<String, dynamic> toJson() => {
    InterviewTableColumns.date: dbFormat.format(date),
    InterviewTableColumns.time: fromTimeOfDayToString(time),
    InterviewTableColumns.type: type.name,
    InterviewTableColumns.interviewFormat: interviewFormat.name,
    InterviewTableColumns.answerTime: answerTime,
    InterviewTableColumns.followUpType: followUpType,
    InterviewTableColumns.notes: notes,
    InterviewTableColumns.status: status.name,
    InterviewTableColumns.interviewPlace: interviewPlace,
    InterviewTableColumns.jobDataId: jobDataId,
  };

  static Interview defaultValue() {
    return Interview(
      date: DateTime.now(),
      time: TimeOfDay.now(),
      type: InterviewTypes.conoscitivo,
      interviewFormat: InterviewsFormat.online,
      status: InterviewStatus.toDo,
      interviewPlace: '',
      jobDataId: 0,
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
      interviewPlace: $interviewPlace
      notes: $notes
      jobDataId: $jobDataId
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
  static String notes = "notes";
  static String status = "status";
  static String answerTime = "answer_time";
  static String followUpType = "follow_up_type";
  static String followUpDate = "follow_up_date";
  static String interviewPlace = "interview_place";
  static String jobDataId = "fk_job_data_id";
}

class InterviewUi extends Equatable {
  final int? id;
  final DateTime date;
  final TimeOfDay time;
  final InterviewTypes type;
  final InterviewsFormat interviewFormat;
  final String? answerTime;
  final String? interviewPlace;
  final String? rescheduleDateTime;
  final DateTime? followUpDate;
  final InterviewStatus status;

  const InterviewUi({
    this.id,
    required this.date,
    required this.time,
    required this.type,
    required this.interviewFormat,
    required this.status,
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
      status = getInterviewStatusFromString(json[InterviewTableColumns.status]),
      answerTime = json[InterviewTableColumns.answerTime],
      interviewPlace = json[InterviewTableColumns.interviewPlace],

      rescheduleDateTime = json[InterviewTimelineTable.newDateTime],

      followUpDate =
          json[InterviewTableColumns.followUpDate] != null
              ? DateTime.tryParse(json[InterviewTableColumns.followUpDate])
              : null;

  InterviewUi copyWith({
    int? id,
    InterviewTypes? type,
    InterviewsFormat? interviewFormat,
    InterviewStatus? status,
    String? answerTime,
    String? interviewPlace,
    String? rescheduleDateTime,
  }) {
    return InterviewUi(
      id: id ?? this.id,
      date: date,
      time: time,
      type: type ?? this.type,
      interviewFormat: interviewFormat ?? this.interviewFormat,
      interviewPlace: interviewPlace ?? this.interviewPlace,
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
      answerTime: $answerTime
      RescheduleDate; $rescheduleDateTime
      status: $status
      followUpDate: ${followUpDate.toString()}
      interviewPlace: $interviewPlace
    ''';
  }

  @override
  List<Object?> get props => [id, type, interviewFormat, status, interviewPlace];
}
