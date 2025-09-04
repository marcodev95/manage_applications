import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/models/company/company.dart';
import 'package:manage_applications/models/contract/contract.dart';
import 'package:manage_applications/models/db/db_helper.dart';
import 'package:manage_applications/models/interview/interview.dart';
import 'package:manage_applications/models/job_application/job_application.dart';
import 'package:manage_applications/models/job_application/job_application_referent.dart';
import 'package:manage_applications/models/job_application_details.dart';
import 'package:manage_applications/models/referent/referent.dart';
import 'package:manage_applications/models/requirement.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/models/timeline/interview_timeline.dart';
import 'package:manage_applications/pages/job_application_details_page/interview_section/interview_details/interview_data_section/interview_form_utility.dart';

final jobApplicationDetailsRepositoryProvider = Provider(
  (_) => JobApplicationDetailsRepository(DbHelper.instance),
);

class JobApplicationDetailsRepository {
  final DbHelper _db;

  JobApplicationDetailsRepository(DbHelper db) : _db = db;

  Future _getJobDetailsWithCompanies(int applicationId) async {
    final sql = '''
    SELECT 
      ja.${JobApplicationsTableColumns.id},
      ja.${JobApplicationsTableColumns.position},
      ja.${JobApplicationsTableColumns.applyDate},
      ja.${JobApplicationsTableColumns.applicationStatus},
      ja.${JobApplicationsTableColumns.websiteUrl},
      ja.${JobApplicationsTableColumns.workType},
      ja.${JobApplicationsTableColumns.dayInOffice},

      c.${CompanyTableColumns.id} AS c_id,
      c.${CompanyTableColumns.name} AS c_name,
      c.${CompanyTableColumns.address} AS c_address,
      c.${CompanyTableColumns.city} AS c_city,
      c.${CompanyTableColumns.email} AS c_email,
      c.${CompanyTableColumns.website} AS c_website,
      c.${CompanyTableColumns.phoneNumber} AS c_phoneNumber,

      cc.${CompanyTableColumns.id} AS cc_id,
      cc.${CompanyTableColumns.name} AS cc_name,
      cc.${CompanyTableColumns.address} AS cc_address,
      cc.${CompanyTableColumns.city} AS cc_city,
      cc.${CompanyTableColumns.email} AS cc_email,
      cc.${CompanyTableColumns.website} AS cc_website,
      cc.${CompanyTableColumns.phoneNumber} AS cc_phoneNumber

    FROM $jobApplicationsTable AS ja
      INNER JOIN $companyTable AS c  
        ON c.${CompanyTableColumns.id} = ja.${JobApplicationsTableColumns.companyId}

      LEFT JOIN $companyTable AS cc
        ON cc.${CompanyTableColumns.id} = ja.${JobApplicationsTableColumns.clientCompanyId}


    WHERE ja.${JobApplicationsTableColumns.id} = $applicationId

    ''';

    final result = await _db.rawQuery(sql: sql);

    print(result);

    final row = result.first;

    return {
      'job_application': {
        JobApplicationsTableColumns.id: row[JobApplicationsTableColumns.id],
        JobApplicationsTableColumns.position: row[JobApplicationsTableColumns.position],
        JobApplicationsTableColumns.applyDate: row[JobApplicationsTableColumns.applyDate],
        JobApplicationsTableColumns.applicationStatus:
            row[JobApplicationsTableColumns.applicationStatus],
        JobApplicationsTableColumns.websiteUrl: row[JobApplicationsTableColumns.websiteUrl],
        JobApplicationsTableColumns.workType: row[JobApplicationsTableColumns.workType],
        JobApplicationsTableColumns.dayInOffice: row[JobApplicationsTableColumns.dayInOffice],
      },
      'company': {
        CompanyTableColumns.id: row['c_id'],
        CompanyTableColumns.name: row['c_name'],
        CompanyTableColumns.address: row['c_address'],
        CompanyTableColumns.city: row['c_city'],
        CompanyTableColumns.email: row['c_email'],
        CompanyTableColumns.website: row['c_website'],
        CompanyTableColumns.phoneNumber: row['c_phoneNumber'],
      },
      'client_company':
          row['cc_id'] == null
              ? null
              : {
                CompanyTableColumns.id: row['cc_id'],
                CompanyTableColumns.name: row['cc_name'],
                CompanyTableColumns.address: row['cc_address'],
                CompanyTableColumns.city: row['cc_city'],
                CompanyTableColumns.email: row['cc_email'],
                CompanyTableColumns.website: row['cc_website'],
                CompanyTableColumns.phoneNumber: row['cc_phoneNumber'],
              },
    };
  }

  Future<List<Map<String, Object?>>> _getCompanyReferents(
    int applicationId,
  ) async {
    final sql = '''
    SELECT 
      ${ReferentTableColumns.id},
      ${ReferentTableColumns.name},
      ${ReferentTableColumns.role},
      ${ReferentTableColumns.email},

      ${JobApplicationReferentsColumns.referentAffiliation}

    FROM $referentTableName
      INNER JOIN ${JobApplicationReferentsColumns.tableName}
        ON ${JobApplicationReferentsColumns.referentId} = ${ReferentTableColumns.id}

    WHERE ${JobApplicationReferentsColumns.jobApplicationId} = $applicationId
  ''';

    return await _db.rawQuery(sql: sql);
  }

  Future<List<Map<String, Object?>>> _getInterviewList(
    int applicationId,
  ) async {
    final sql = '''
      SELECT 
      i.${InterviewTableColumns.id}, 
      i.${InterviewTableColumns.type}, 
      i.${InterviewTableColumns.date}, 
      i.${InterviewTableColumns.interviewFormat},
      i.${InterviewTableColumns.answerTime},
      i.${InterviewTableColumns.placeUpdated},
      i.${InterviewTableColumns.interviewPlace},
      i.${InterviewTableColumns.previousInterviewPlace},
      i.${InterviewTableColumns.status},
      i.${InterviewTableColumns.time},
      i.${InterviewTableColumns.followUpDate},

      MAX(it.${InterviewTimelineTable.eventDateTime}) AS ${InterviewTimelineTable.eventDateTime},
      it.${InterviewTimelineTable.newDateTime}

    FROM $interviewTable i
    LEFT JOIN ${InterviewTimelineTable.tableName} it
      ON it.${InterviewTimelineTable.interviewId} = i.${InterviewTableColumns.id}
      AND it.${InterviewTimelineTable.eventType} = '${InterviewStatus.postponed.name}'
    WHERE i.${InterviewTableColumns.jobApplicationId} = $applicationId
    GROUP BY i.${InterviewTableColumns.id}
    ''';

    return await _db.rawQuery(sql: sql);
  }

  Future<List<Map<String, Object?>>> _getContractsList(
    int applicationId,
  ) async {
    final sql = ''' 
    SELECT 
        ${ContractTableColumns.id}, 
        ${ContractTableColumns.type},
        ${ContractTableColumns.contractDuration},
        ${ContractTableColumns.workPlaceAddress},
        ${ContractTableColumns.ral},
        ${ContractTableColumns.isTrialContract}
      FROM $contractTable
      WHERE ${ContractTableColumns.jobApplicationId} = $applicationId      
  ''';
    return await _db.rawQuery(sql: sql);
  }

  Future<List<Map<String, Object?>>> _getRequirementsList(
    int applicationId,
  ) async {
    final sql = ''' 
      SELECT  
        ${RequirementTableColumns.id},
        ${RequirementTableColumns.requirement} 
      FROM $requirementsTable
      WHERE ${RequirementTableColumns.jobApplicationId} = $applicationId      
    ''';
    return await _db.rawQuery(sql: sql);
  }

  Future<JobApplicationDetails> getJobApplicationDetails(applicationId) async {
    try {
      final jobDetails = await _getJobDetailsWithCompanies(applicationId);
      final Map<String, dynamic> applicationDetailsMap = {
        'job_application': jobDetails['job_application'],
        'company': jobDetails['company'],
        'client_company': jobDetails['client_company'],
        'company_referents': await _getCompanyReferents(applicationId),
        'interviews': await _getInterviewList(applicationId),
        'contracts': await _getContractsList(applicationId),
        'requirements': await _getRequirementsList(applicationId),
      };

      debugPrint("JobDataDetailsAPI => $applicationDetailsMap");
      debugPrint(
        "FromJson => ${JobApplicationDetails.fromJson(applicationDetailsMap)}",
      );

      return JobApplicationDetails.fromJson(applicationDetailsMap);
    } catch (e, stackTrace) {
      throw DataLoadingError(error: e, stackTrace: stackTrace);
    }
  }
}
