import 'package:manage_applications/models/company/company.dart';
import 'package:manage_applications/models/referent/referent.dart';
import 'package:manage_applications/models/contract/benefit.dart';
import 'package:manage_applications/models/contract/contract.dart';
import 'package:manage_applications/models/interview/interview.dart';
import 'package:manage_applications/models/interview/interview_follow_up.dart';
import 'package:manage_applications/models/interview/interview_timeline.dart';
import 'package:manage_applications/models/interview/referents_interview.dart';
import 'package:manage_applications/models/job_application/job_application.dart';
import 'package:manage_applications/models/job_application/job_application_referent.dart';
import 'package:manage_applications/models/requirement.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static final DbHelper instance = DbHelper._init();

  static Database? _database;
  final _dbName = 'db_job_application.db';
  final _idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  final _textType = 'TEXT';
  final _intType = 'INTEGER';
  final _floatType = 'REAL';

  DbHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB(_dbName);
    return _database!;
  }

  Future _onConfigure(Database db) async {
    return await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        final batch = db.batch();

        _createCompanyTable(batch);
        _createJobDataTable(batch);
        _createCompanyReferentTable(batch);
        _createInterviewTable(batch);
        _createInterviewFollowUpTable(batch);
        _createContractTable(batch);
        _createRequirementTable(batch);
        _createBenefitsTable(batch);
        _createReferentsInterviewTable(batch);
        _createInterviewTimelineTable(batch);
        _createJobApplicationReferents(batch);

        await batch.commit();
      },
      onConfigure: _onConfigure,
    );
  }

  Future<String> dbPath() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return path;
  }

  /* Table */

  void _createCompanyTable(Batch batch) {
    batch.execute('''CREATE TABLE $companyTable ( 
        ${CompanyTableColumns.id} $_idType, 
        ${CompanyTableColumns.name} $_textType,
        ${CompanyTableColumns.city} $_textType,
        ${CompanyTableColumns.address} $_textType,
        ${CompanyTableColumns.workingHours} $_textType,
        ${CompanyTableColumns.phoneNumber} $_textType,
        ${CompanyTableColumns.website} $_textType,
        ${CompanyTableColumns.email} $_textType
      )''');

    batch.execute('''INSERT INTO $companyTable (
        ${CompanyTableColumns.name},
        ${CompanyTableColumns.city},
        ${CompanyTableColumns.address},
        ${CompanyTableColumns.phoneNumber},
        ${CompanyTableColumns.website},
        ${CompanyTableColumns.workingHours},
        ${CompanyTableColumns.email}
      ) VALUES 
        ('Azienda Demo 1', 'Città Demo', 'Via Finta 10', '', 'https://www.google.com/', '9-18', 'demo1@example.com'),
        ('Azienda Demo 2', 'Città Demo 2', 'Via Finta 20', '', 'https://www.google.com/', '8.30-12.30/14-18', 'demo2@example.com')
      ''');
  }

  void _createCompanyReferentTable(Batch batch) {
    batch.execute('''CREATE TABLE $referentTableName ( 
        ${ReferentTableColumns.id} $_idType, 
        ${ReferentTableColumns.name} $_textType,
        ${ReferentTableColumns.email} $_textType,
        ${ReferentTableColumns.phoneNumber} $_textType,
        ${ReferentTableColumns.role} $_textType,
        ${ReferentTableColumns.companyId} $_intType,

        FOREIGN KEY (${ReferentTableColumns.companyId}) 
          REFERENCES $companyTable (${CompanyTableColumns.id}) 
            ON DELETE CASCADE

      )''');

    batch.execute('''INSERT INTO $referentTableName (
          ${ReferentTableColumns.name},
          ${ReferentTableColumns.email},
          ${ReferentTableColumns.phoneNumber},
          ${ReferentTableColumns.role},
          ${ReferentTableColumns.companyId}
        ) VALUES 
          ('Referente Demo 1', 'referente1@example.com', '1234556', 'hr', 1),
          ('Referente Demo 2', 'referente2@example.com', '1234556', 'dev', 2)
        ''');
  }

  void _createJobDataTable(Batch batch) {
    batch.execute('''CREATE TABLE $jobApplicationsTable ( 
        ${JobApplicationsTableColumns.id} $_idType, 
        ${JobApplicationsTableColumns.applyDate} $_textType,
        ${JobApplicationsTableColumns.position} $_textType,
        ${JobApplicationsTableColumns.applicationStatus} $_textType,
        ${JobApplicationsTableColumns.websiteUrl} $_textType,
        ${JobApplicationsTableColumns.dayInOffice} $_textType,
        ${JobApplicationsTableColumns.workType} $_textType,
        ${JobApplicationsTableColumns.experience} $_textType,
        ${JobApplicationsTableColumns.companyId} $_intType,
        ${JobApplicationsTableColumns.clientCompanyId} $_intType DEFAULT NULL,

        FOREIGN KEY (${JobApplicationsTableColumns.companyId}) 
          REFERENCES $companyTable (${CompanyTableColumns.id}) 
            ON DELETE CASCADE
      )''');

    batch.execute('''INSERT INTO $jobApplicationsTable (
          ${JobApplicationsTableColumns.applyDate},
          ${JobApplicationsTableColumns.position},
          ${JobApplicationsTableColumns.applicationStatus},
          ${JobApplicationsTableColumns.websiteUrl},
          ${JobApplicationsTableColumns.workType},
          ${JobApplicationsTableColumns.dayInOffice},
          ${JobApplicationsTableColumns.experience},
          ${JobApplicationsTableColumns.companyId},
          ${JobApplicationsTableColumns.clientCompanyId}
        ) VALUES ('2023-10-11', 'Posizione Demo 1', 'apply', 'www.indeed.com', 'hybrid', '3', '', 1, 2), 
                ('2023-11-10', 'Posizione Demo 2', 'interview', 'www.indeed.com', 'onSite', '5', '', 2, NULL)
      ''');
  }

  void _createInterviewTable(Batch batch) {
    batch.execute('''CREATE TABLE $interviewTable ( 
        ${InterviewTableColumns.id} $_idType, 
        ${InterviewTableColumns.date} $_textType,
        ${InterviewTableColumns.time} $_textType,
        ${InterviewTableColumns.type} $_textType,
        ${InterviewTableColumns.interviewFormat} $_textType,
        ${InterviewTableColumns.answerTime} $_textType,
        ${InterviewTableColumns.placeUpdated} $_intType,
        ${InterviewTableColumns.previousInterviewPlace} $_textType,
        ${InterviewTableColumns.notes} $_textType,
        ${InterviewTableColumns.status} $_textType,
        ${InterviewTableColumns.interviewPlace} $_textType,
        ${InterviewTableColumns.followUpType} $_textType,
        ${InterviewTableColumns.followUpDate} $_textType,
        ${InterviewTableColumns.jobApplicationId} $_intType,

        FOREIGN KEY (${InterviewTableColumns.jobApplicationId}) 
          REFERENCES $jobApplicationsTable (${JobApplicationsTableColumns.id}) 
            ON DELETE CASCADE
    )''');
  }

  void _createContractTable(Batch batch) {
    batch.execute('''CREATE TABLE $contractTable( 
        ${ContractTableColumns.id} $_idType, 
        ${ContractTableColumns.type} $_textType,
        ${ContractTableColumns.ccnl} $_textType,
        ${ContractTableColumns.contractDuration} $_textType,
        ${ContractTableColumns.isTrialContract} $_intType,
        ${ContractTableColumns.ral} $_textType,
        ${ContractTableColumns.salary} $_floatType,
        ${ContractTableColumns.monthlyPayments} $_intType,
        ${ContractTableColumns.isOvertimePresent} $_intType,
        ${ContractTableColumns.isProductionBonusPresent} $_intType,
        ${ContractTableColumns.notes} $_textType,
        ${ContractTableColumns.workPlaceAddress} $_textType,
        ${ContractTableColumns.workPlace} $_textType,
        ${ContractTableColumns.workingHour} $_textType,
        ${ContractTableColumns.jobApplicationId} $_intType,

        FOREIGN KEY (${ContractTableColumns.jobApplicationId}) 
          REFERENCES $jobApplicationsTable (${JobApplicationsTableColumns.id}) 
            ON DELETE CASCADE
    )''');
  }

  void _createBenefitsTable(Batch batch) {
    batch.execute('''CREATE TABLE ${BenefitsTable.tableName} ( 
      ${BenefitsTable.id} $_idType, 
      ${BenefitsTable.benefit} $_textType,
      ${BenefitsTable.contractId} $_intType,

      FOREIGN KEY (${BenefitsTable.contractId}) 
        REFERENCES $contractTable (${ContractTableColumns.id}) 
          ON DELETE CASCADE
    )''');
  }

  void _createRequirementTable(Batch batch) {
    batch.execute('''CREATE TABLE $requirementsTable ( 
      ${RequirementTableColumns.id} $_idType, 
      ${RequirementTableColumns.requirement} $_textType,
      ${RequirementTableColumns.jobApplicationId} $_intType,

      FOREIGN KEY (${RequirementTableColumns.jobApplicationId}) 
        REFERENCES $jobApplicationsTable (${JobApplicationsTableColumns.id}) 
          ON DELETE CASCADE
    )''');
  }

  void _createReferentsInterviewTable(Batch batch) {
    batch.execute('''CREATE TABLE $referentsInterviewTable( 
        ${ReferentsInterviewTableColumns.id} $_idType, 
        ${ReferentsInterviewTableColumns.interviewId} $_intType,
        ${ReferentsInterviewTableColumns.referentId} $_intType,

        FOREIGN KEY (${ReferentsInterviewTableColumns.interviewId}) 
          REFERENCES $interviewTable (${InterviewTableColumns.id}) 
            ON DELETE CASCADE,
        
        FOREIGN KEY (${ReferentsInterviewTableColumns.referentId}) 
          REFERENCES $referentTableName (${ReferentTableColumns.id}) 
            ON DELETE CASCADE
    )''');
  }

  void _createInterviewFollowUpTable(Batch batch) {
    batch.execute('''CREATE TABLE $interviewFollowUpTable( 
        ${InterviewFollowUpColumns.id} $_idType, 
        ${InterviewFollowUpColumns.followUpDate} $_textType,
        ${InterviewFollowUpColumns.followUpType} $_textType,
        ${InterviewFollowUpColumns.followUpNotes} $_textType,
        ${InterviewFollowUpColumns.responseReceived} $_textType,
        ${InterviewFollowUpColumns.interviewId} $_intType,

        FOREIGN KEY (${InterviewFollowUpColumns.interviewId}) 
          REFERENCES $interviewTable (${InterviewTableColumns.id}) 
            ON DELETE CASCADE
    )''');
  }

  void _createInterviewTimelineTable(Batch batch) {
    batch.execute('''CREATE TABLE ${InterviewTimelineTable.tableName}( 
        ${InterviewTimelineTable.id} $_idType, 
        ${InterviewTimelineTable.eventType} $_textType,
        ${InterviewTimelineTable.eventDateTime} $_textType,
        ${InterviewTimelineTable.originalDateTime} $_textType,
        ${InterviewTimelineTable.newDateTime} $_textType,
        ${InterviewTimelineTable.requester} $_textType,
        ${InterviewTimelineTable.reason} $_textType,
        ${InterviewTimelineTable.note} $_textType,
        ${InterviewTimelineTable.followUpSentAt} $_textType,
        ${InterviewTimelineTable.followUpSentTo} $_textType,
        ${InterviewTimelineTable.relocatedAddress} $_textType,
        ${InterviewTimelineTable.interviewId} $_intType,

        FOREIGN KEY (${InterviewTimelineTable.interviewId}) 
          REFERENCES $interviewTable (${InterviewTableColumns.id}) 
            ON DELETE CASCADE
    )''');
  }

  void _createJobApplicationReferents(Batch batch) {
    batch.execute('''CREATE TABLE ${JobApplicationReferentsColumns.tableName}( 
        ${JobApplicationReferentsColumns.jobApplicationId} $_intType, 
        ${JobApplicationReferentsColumns.referentId} $_intType,
        ${JobApplicationReferentsColumns.involvedInInterview} $_intType,
        ${JobApplicationReferentsColumns.referentAffiliation} $_textType,


        PRIMARY KEY (
          ${JobApplicationReferentsColumns.jobApplicationId}, 
          ${JobApplicationReferentsColumns.referentId}
        ),

        FOREIGN KEY (${JobApplicationReferentsColumns.jobApplicationId}) 
          REFERENCES $jobApplicationsTable (${JobApplicationsTableColumns.id}) 
            ON DELETE CASCADE,
        
        FOREIGN KEY (${JobApplicationReferentsColumns.referentId}) 
          REFERENCES $referentTableName(${ReferentTableColumns.id})
            ON DELETE CASCADE
    )''');

    batch.execute('''INSERT INTO ${JobApplicationReferentsColumns.tableName} (
        ${JobApplicationReferentsColumns.jobApplicationId}, 
        ${JobApplicationReferentsColumns.referentId},
        ${JobApplicationReferentsColumns.involvedInInterview},
        ${JobApplicationReferentsColumns.referentAffiliation}

        ) VALUES 
          (1, 1, 1, 'main'), (1, 2, 0, 'client')
        ''');
  }

  /* Query */

  Future<int> create({
    required String table,
    required Map<String, Object?> json,
  }) async {
    final db = await instance.database;
    return await db.insert(table, json);
  }

  Future<Map<String, Object?>> readSingleItem({
    required String table,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final db = await instance.database;

    final maps = await db.query(
      table,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
    );

    return maps.first;
  }

  Future<List<Map<String, Object?>>> readAllItems({
    required String table,
    String? where,
    String? orderBy,
    List<Object?>? whereArgs,
    List<String>? columns,
  }) async {
    final db = await instance.database;

    final result = await db.query(
      table,
      orderBy: orderBy,
      columns: columns,
      whereArgs: whereArgs,
    );

    return result;
  }

  Future<int> update({
    required String table,
    required Map<String, dynamic> json,
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final db = await instance.database;

    return db.update(table, json, where: where, whereArgs: whereArgs);
  }

  Future<int> delete({
    required String table,
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final db = await instance.database;

    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }

  /* RawQuery */

  Future<List<Map<String, Object?>>> rawQuery({
    required String sql,
    List<Object?>? arguments,
  }) async {
    final db = await instance.database;
    final maps = await db.rawQuery(sql, arguments);

    return maps;
  }

  Future<Map<String, Object?>?> rawQueryReadSingleItem({
    required String sql,
  }) async {
    final db = await instance.database;
    final maps = await db.rawQuery(sql);

    return maps.isNotEmpty ? maps.first : null;
  }

  Future<int> rawUpdate({required String sql, List<Object?>? arguments}) async {
    final db = await instance.database;
    return await db.rawUpdate(sql, arguments);
  }

  Future<int> rawDelete({required String sql, List<Object?>? arguments}) async {
    final db = await instance.database;
    return await db.rawDelete(sql, arguments);
  }
}
