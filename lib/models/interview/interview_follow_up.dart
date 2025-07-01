import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:manage_applications/widgets/components/utility.dart';

class InterviewFollowUp extends Equatable {
  final int? id;
  final String followUpType;
  final DateTime followUpDate;
  final String? followUpNotes;
  final ResponseReceived responseReceived;
  final int? interviewId;

  const InterviewFollowUp({
    this.id,
    required this.followUpDate,
    required this.followUpType,
    this.followUpNotes,
    this.interviewId,
    this.responseReceived = ResponseReceived.no,
  });

  InterviewFollowUp.fromJson(Map<String, dynamic> json)
    : id = json[InterviewFollowUpColumns.id],
      followUpNotes = json[InterviewFollowUpColumns.followUpNotes],
      followUpType = json[InterviewFollowUpColumns.followUpType],
      interviewId = json[InterviewFollowUpColumns.interviewId],
      responseReceived = _fromStringToResponseReceived(
        json[InterviewFollowUpColumns.responseReceived],
      ),
      followUpDate = DateTime.parse(
        json[InterviewFollowUpColumns.followUpDate],
      );

  Map<String, dynamic> toJson() => {
    InterviewFollowUpColumns.followUpDate: dbFormat.format(followUpDate),
    InterviewFollowUpColumns.followUpType: followUpType,
    InterviewFollowUpColumns.followUpNotes: followUpNotes,
    InterviewFollowUpColumns.responseReceived: responseReceived.toDb,
    InterviewFollowUpColumns.interviewId: interviewId,
  };

  InterviewFollowUp copyWith({
    int? id,
    String? followUpNotes,
    String? followUpType,
    DateTime? followUpDate,
    DateTime? answerDate,
    ResponseReceived? responseReceived,
  }) {
    return InterviewFollowUp(
      id: id ?? this.id,
      followUpType: followUpType ?? this.followUpType,
      followUpDate: followUpDate ?? this.followUpDate,
      followUpNotes: followUpNotes ?? this.followUpNotes,
      responseReceived: responseReceived ?? this.responseReceived,
      interviewId: interviewId,
    );
  }

  static InterviewFollowUp defaultValue() {
    return InterviewFollowUp(followUpDate: DateTime.now(), followUpType: '');
  }

  @override
  String toString() {
    return ''' __INTERVIEW_FOLLOWUP__ 
      { 
        id => $id
        followUpType => $followUpType
        followUpDate => $followUpDate
        followUpNotes => $followUpNotes
        responseReceived => $responseReceived
        interviewId => $interviewId
      } ''';
  }

  @override
  List<Object?> get props => [id];
}

const String interviewFollowUpTable = "interview_follow_up_table";

class InterviewFollowUpColumns {
  static String id = "_id_interview_follow_up";
  static String followUpNotes = "follow_up_notes";
  static String followUpType = "follow_up_type";
  static String followUpDate = "follow_up_date";
  static String responseReceived = 'response_received';
  static String interviewId = "interview_id";
}

enum ResponseReceived { yes, no }

extension ResponseReceivedX on ResponseReceived {
  String get displayName {
    return switch (this) {
      ResponseReceived.yes => 'Risposta',
      ResponseReceived.no => 'In attesa',
    };
  }

  Icon get icon {
    return switch (this) {
      ResponseReceived.yes => Icon(Icons.check, color: Colors.green),
      ResponseReceived.no => Icon(Icons.hourglass_empty, color: Colors.grey),
    };
  }

  String get toDb {
    return switch (this) {
      ResponseReceived.yes => 'y',
      ResponseReceived.no => 'n',
    };
  }
}

ResponseReceived _fromStringToResponseReceived(String value) {
  switch (value) {
    case 'y':
      return ResponseReceived.yes;
    case 'n':
      return ResponseReceived.no;
    default:
      return ResponseReceived.no;
  }
}
