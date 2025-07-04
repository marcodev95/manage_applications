import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/company/company.dart';
import 'package:manage_applications/models/company/company_referent.dart';
import 'package:manage_applications/models/contract/contract.dart';
import 'package:manage_applications/models/db/db_helper.dart';
import 'package:manage_applications/models/interview/interview.dart';
import 'package:manage_applications/models/interview/interview_timeline.dart';
import 'package:manage_applications/models/job_application_details.dart';
import 'package:manage_applications/models/job_data/job_data.dart';
import 'package:manage_applications/models/requirement.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_timeline_section/interview_timeline_utility.dart';

final jobApplicationDetailsRepositoryProvider = Provider(
  (_) => JobApplicationDetailsRepository(DbHelper.instance),
);

class JobApplicationDetailsRepository {
  final DbHelper _db;

  JobApplicationDetailsRepository(final DbHelper db) : _db = db;

  Future<Map<String, Object?>> _getJobData(int jobDataId) async =>
      await _db.readSingleItem(
        table: jobDataTable,
        where: "${JobDataTableColumns.id} = ?",
        whereArgs: [jobDataId],
      );

  Future<Map<String, Object?>> _getCompany(int jobDataId) async =>
      await _db.readSingleItem(
        table: companyTable,
        columns: [
          CompanyTableColumns.id,
          CompanyTableColumns.name,
          CompanyTableColumns.address,
          CompanyTableColumns.city,
          CompanyTableColumns.email,
          CompanyTableColumns.website,
          CompanyTableColumns.phoneNumber,
        ],
        where: "${CompanyTableColumns.id} = ?",
        whereArgs: [jobDataId],
      );

  Future<Map<String, Object?>?> _getClientCompany(int id) async {
    return await _db.readSingleItem(
      table: companyTable,
      columns: [
        CompanyTableColumns.id,
        CompanyTableColumns.name,
        CompanyTableColumns.address,
        CompanyTableColumns.city,
        CompanyTableColumns.email,
        CompanyTableColumns.website,
        CompanyTableColumns.phoneNumber,
        CompanyTableColumns.workingHours,
      ],
      where: "${CompanyTableColumns.id} = ?",
      whereArgs: [id],
    );
  }

  Future<List<Map<String, Object?>>> _getCompanyReferents(int jobDataId) async {
    final sql = '''
    SELECT 
      ${CompanyReferentTableColumns.id},
      ${CompanyReferentTableColumns.name},
      ${CompanyReferentTableColumns.role},
      ${CompanyReferentTableColumns.companyType},
      ${CompanyReferentTableColumns.email}

    FROM $companyReferentTableName

    WHERE ${CompanyReferentTableColumns.jobDataId} = $jobDataId
  ''';

    return await _db.rawQuery(sql: sql);
  }

  Future<List<Map<String, Object?>>> _getInterviewList(int jobDataId) async {
    final interviewDataSQL = '''   
  SELECT 
    ${InterviewTableColumns.id}, 
    ${InterviewTableColumns.type}, 
    ${InterviewTableColumns.date}, 
    ${InterviewTableColumns.interviewFormat},
    ${InterviewTableColumns.answerTime},
    ${InterviewTableColumns.interviewPlace},
    ${InterviewTableColumns.status},
    ${InterviewTableColumns.time},
    ${InterviewTableColumns.followUpDate}

  FROM $interviewTable 
  WHERE ${InterviewTableColumns.jobDataId} = $jobDataId
  ''';

    final interviewMap = await _db.rawQuery(
      sql: interviewDataSQL,
    );

    if (interviewMap.isEmpty) return [];

    final postponedResultsQuery = '''
    SELECT 
      ${InterviewTimelineTable.interviewId}, 
      MAX(${InterviewTimelineTable.eventDateTime}) AS ${InterviewTimelineTable.eventDateTime},
      ${InterviewTimelineTable.newDateTime}
    FROM ${InterviewTimelineTable.tableName}
    WHERE ${InterviewTimelineTable.eventType} = '${InterviewTimelineEvent.postponed.name}'
    GROUP BY ${InterviewTimelineTable.interviewId}
''';

    final postponedMap = await _db.rawQuery(
      sql: postponedResultsQuery,
    );

    final Map<int, dynamic> postponedMapById = {};
    for (final item in postponedMap) {
      final interviewId = item[InterviewTimelineTable.interviewId] as int;
      postponedMapById[interviewId] = item[InterviewTimelineTable.newDateTime];
    }

    final enrichedInterviews =
        interviewMap.map((row) {
          final interviewId = row[InterviewTableColumns.id] as int;
          final postponeDate = postponedMapById[interviewId];
          return {...row, InterviewTimelineTable.newDateTime: postponeDate};
        }).toList();

    return enrichedInterviews;
  }

  Future _getRequirementsList(int jobDataId) async {
    final sql = ''' 
      SELECT  
        ${RequirementTableColumns.id},
        ${RequirementTableColumns.requirement} 
      FROM $requirementTable
      WHERE ${RequirementTableColumns.jobDataId} = $jobDataId      
    ''';
    return await _db.rawQuery(sql: sql);
  }

  Future _getContratcsList(int jobDataId) async {
    final sql = ''' 
    SELECT 
        ${ContractTableColumns.id}, 
        ${ContractTableColumns.type},
        ${ContractTableColumns.contractDuration},
        ${ContractTableColumns.workPlaceAddress},
        ${ContractTableColumns.ral},
        ${ContractTableColumns.isTrialContract},
        ${ContractTableColumns.jobDataId}
      FROM $contractTable
      WHERE ${ContractTableColumns.jobDataId} = $jobDataId      
  ''';
    return await _db.rawQuery(sql: sql);
  }

  Future<JobApplicationDetails> getJobApplicationDetails({
    required int jobDataId,
  }) async {
    Map<String, dynamic> jobDataDetailsMap = {};

    jobDataDetailsMap["job_data"] = await _getJobData(jobDataId);

    final companyId =
        jobDataDetailsMap["job_data"][JobDataTableColumns.companyId] as int;
    jobDataDetailsMap["company"] = await _getCompany(companyId);

    final clientCompanyId =
        jobDataDetailsMap["job_data"][JobDataTableColumns.clientCompanyId];
    if (clientCompanyId != null) {
      jobDataDetailsMap["final_company"] = await _getClientCompany(
        clientCompanyId as int,
      );
    }

    jobDataDetailsMap["company_referents"] = await _getCompanyReferents(
      jobDataId,
    );

    jobDataDetailsMap["requirements"] = await _getRequirementsList(jobDataId);

    jobDataDetailsMap["interviews"] = await _getInterviewList(jobDataId);

    jobDataDetailsMap["contracts"] = await _getContratcsList(jobDataId);

    debugPrint("JobDataDetailsAPI => $jobDataDetailsMap");
    debugPrint(
      "FromJson => ${JobApplicationDetails.fromJson(jobDataDetailsMap)}",
    );

    return JobApplicationDetails.fromJson(jobDataDetailsMap);
  }
}
