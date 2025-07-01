import 'package:manage_applications/models/contract/benefit.dart';
import 'package:manage_applications/models/contract/contract.dart';
import 'package:manage_applications/models/company/company_referent.dart';
import 'package:manage_applications/models/company/company.dart';
import 'package:manage_applications/models/interview/interview.dart';
import 'package:manage_applications/models/interview/interview_timeline.dart';
import 'package:manage_applications/models/interview/interview_follow_up.dart';
import 'package:manage_applications/models/job_data/job_data.dart';
import 'package:manage_applications/models/interview/referents_interview.dart';
import 'package:manage_applications/models/requirement.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
        ('Company', 'Gallarate', 'Via della Company', '123456789', 'https://www.google.com/', '9-18', 'email@email1'),
        ('Company2', 'Varese', 'Via della Company2', '3456789', 'https://www.google.com/', '8.30-12.30/14-18', 'email@email2')
      ''');
  }

  void _createCompanyReferentTable(Batch batch) {
    batch.execute('''CREATE TABLE $companyReferentTableName ( 
        ${CompanyReferentTableColumns.id} $_idType, 
        ${CompanyReferentTableColumns.name} $_textType,
        ${CompanyReferentTableColumns.email} $_textType,
        ${CompanyReferentTableColumns.phoneNumber} $_textType,
        ${CompanyReferentTableColumns.companyType} $_textType,
        ${CompanyReferentTableColumns.role} $_textType,
        ${CompanyReferentTableColumns.jobDataId} $_intType,
        ${CompanyReferentTableColumns.companyId} $_intType,

        FOREIGN KEY (${CompanyReferentTableColumns.companyId}) 
          REFERENCES $companyTable (${CompanyTableColumns.id}) 
            ON DELETE CASCADE,

        FOREIGN KEY (${CompanyReferentTableColumns.jobDataId}) 
          REFERENCES $jobDataTable (${JobDataTableColumns.id}) 
            ON DELETE CASCADE
      )''');

    batch.execute('''INSERT INTO $companyReferentTableName (
          ${CompanyReferentTableColumns.name},
          ${CompanyReferentTableColumns.email},
          ${CompanyReferentTableColumns.phoneNumber},
          ${CompanyReferentTableColumns.role},
          ${CompanyReferentTableColumns.companyType},
          ${CompanyReferentTableColumns.jobDataId},
          ${CompanyReferentTableColumns.companyId}
        ) VALUES 
          ('Referent1', 'email1', '1234556', 'HR', 'M', 1, 1),
          ('Referent2', 'email2', '1234556', 'DEV', 'C',  1, 2)
        ''');
  }

  void _createJobDataTable(Batch batch) {
    batch.execute('''CREATE TABLE $jobDataTable ( 
        ${JobDataTableColumns.id} $_idType, 
        ${JobDataTableColumns.applyDate} $_textType,
        ${JobDataTableColumns.position} $_textType,
        ${JobDataTableColumns.applicationStatus} $_textType,
        ${JobDataTableColumns.websiteUrl} $_textType,
        ${JobDataTableColumns.dayInOffice} $_textType,
        ${JobDataTableColumns.workType} $_textType,
        ${JobDataTableColumns.experience} $_textType,
        ${JobDataTableColumns.companyId} $_intType,
        ${JobDataTableColumns.clientCompanyId} $_intType DEFAULT NULL,

        FOREIGN KEY (${JobDataTableColumns.companyId}) 
          REFERENCES $companyTable (${CompanyTableColumns.id}) 
            ON DELETE CASCADE
      )''');

    batch.execute('''INSERT INTO $jobDataTable (
          ${JobDataTableColumns.applyDate},
          ${JobDataTableColumns.position},
          ${JobDataTableColumns.applicationStatus},
          ${JobDataTableColumns.websiteUrl},
          ${JobDataTableColumns.workType},
          ${JobDataTableColumns.dayInOffice},
          ${JobDataTableColumns.experience},
          ${JobDataTableColumns.companyId},
          ${JobDataTableColumns.clientCompanyId}
        ) VALUES ('2023-10-11', 'Junior Developer', 'Candidato', 'www.indeed.com', 'hybrid', '3', 'Da 1 a 5 anni', 1, 2), 
                ('2023-11-10', 'Junior Developer2', 'Colloquio', 'www.indeed.com', 'presence', '5', '', 2, NULL)
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
        ${InterviewTableColumns.notes} $_textType,
        ${InterviewTableColumns.status} $_textType,
        ${InterviewTableColumns.interviewPlace} $_textType,
        ${InterviewTableColumns.followUpType} $_textType,
        ${InterviewTableColumns.followUpDate} $_textType,
        ${InterviewTableColumns.jobDataId} $_intType,

        FOREIGN KEY (${InterviewTableColumns.jobDataId}) 
          REFERENCES $jobDataTable (${JobDataTableColumns.id}) 
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
        ${ContractTableColumns.jobDataId} $_intType,

        FOREIGN KEY (${ContractTableColumns.jobDataId}) 
          REFERENCES $jobDataTable (${JobDataTableColumns.id}) 
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
    batch.execute('''CREATE TABLE $requirementTable ( 
      ${RequirementTableColumns.id} $_idType, 
      ${RequirementTableColumns.requirement} $_textType,
      ${RequirementTableColumns.jobDataId} $_intType,

      FOREIGN KEY (${RequirementTableColumns.jobDataId}) 
        REFERENCES $jobDataTable (${JobDataTableColumns.id}) 
          ON DELETE CASCADE
    )''');
  }

  /*   void _createClientCompanyTable(Batch batch) {
    batch.execute('''
      CREATE TABLE $clientCompanyTable( 
        ${FinalCompanyTableColumns.id} $_idType, 
        ${FinalCompanyTableColumns.clientCompanyId} $_intType,
        ${FinalCompanyTableColumns.companyId} $_intType,
        ${FinalCompanyTableColumns.jobAppId} $_intType,

        FOREIGN KEY (${FinalCompanyTableColumns.companyId}) 
          REFERENCES $companyTable (${CompanyTableColumns.id}) 
            ON DELETE CASCADE,
        
        FOREIGN KEY (${FinalCompanyTableColumns.jobAppId}) 
          REFERENCES $jobDataTable (${JobDataTableColumns.id}) 
            ON DELETE CASCADE
  )''');

    batch.execute('''INSERT INTO $clientCompanyTable (    
        ${FinalCompanyTableColumns.id}, 
        ${FinalCompanyTableColumns.clientCompanyId},
        ${FinalCompanyTableColumns.companyId},
        ${FinalCompanyTableColumns.jobAppId}

      ) VALUES (1, 2, 1, 1) ''');
  } */

  void _createReferentsInterviewTable(Batch batch) {
    batch.execute('''CREATE TABLE $referentsInterviewTable( 
        ${ReferentsInterviewTableColumns.id} $_idType, 
        ${ReferentsInterviewTableColumns.interviewId} $_intType,
        ${ReferentsInterviewTableColumns.referentId} $_intType,

        FOREIGN KEY (${ReferentsInterviewTableColumns.interviewId}) 
          REFERENCES $interviewTable (${InterviewTableColumns.id}) 
            ON DELETE CASCADE,
        
        FOREIGN KEY (${ReferentsInterviewTableColumns.referentId}) 
          REFERENCES $companyReferentTableName (${CompanyReferentTableColumns.id}) 
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
        ${InterviewTimelineTable.eventDateTimeDB} $_textType,
        ${InterviewTimelineTable.originalDateTime} $_textType,
        ${InterviewTimelineTable.newDateTime} $_textType,
        ${InterviewTimelineTable.requester} $_textType,
        ${InterviewTimelineTable.reason} $_textType,
        ${InterviewTimelineTable.note} $_textType,
        ${InterviewTimelineTable.interviewId} $_intType,

        FOREIGN KEY (${InterviewTimelineTable.interviewId}) 
          REFERENCES $interviewTable (${InterviewTableColumns.id}) 
            ON DELETE CASCADE
    )''');
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

  Future<List<Map<String, Object?>>> rawQuery({required String sql}) async {
    final db = await instance.database;
    final maps = await db.rawQuery(sql);

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
}


/* Old _onCreate

Future _createDB(Database db, int version) async {
    final batch = db.batch();

    _createCompanyTable(batch);
    _createJobDataTable(batch);
    _createCompanyReferentTable(batch);
    _createInterviewTable(batch);
    _createContractTable(batch);
    _createRequirementTable(batch);
    _createClientCompanyTable(batch);

    await batch.commit();

    /* await db.execute('''
CREATE TABLE $companyReferentTableName ( 
  ${CompanyReferentTableColumns.id} $idType, 
  ${CompanyReferentTableColumns.name} $textType,
  ${CompanyReferentTableColumns.email} $textType,
  ${CompanyReferentTableColumns.phoneNumber} $textType,
  ${CompanyReferentTableColumns.role} $textType,
  ${CompanyReferentTableColumns.jobDataId} $intType,
  ${CompanyReferentTableColumns.companyId} $intType,

  FOREIGN KEY (${CompanyReferentTableColumns.companyId}) REFERENCES $companyTable (${CompanyTableColumns.id}) ON DELETE CASCADE,

  FOREIGN KEY (${CompanyReferentTableColumns.jobDataId}) REFERENCES $jobDataTable (${JobDataTableColumns.id}) ON DELETE CASCADE
  )'''); */
//https://www.sqlitetutorial.net/sqlite-foreign-key/ Vedere x SQFLITE

/*     await db.execute('''
CREATE TABLE $jobDataTable ( 
  ${JobDataTableColumns.id} $idType, 
  ${JobDataTableColumns.applyDate} $textType,
  ${JobDataTableColumns.position} $textType,
  ${JobDataTableColumns.applicationStatus} $textType,
  ${JobDataTableColumns.websiteUrl} $textType,
  ${JobDataTableColumns.dayInOffice} $textType,
  ${JobDataTableColumns.workType} $textType,
  ${JobDataTableColumns.experience} $textType,
  ${JobDataTableColumns.companyId} $intType,

  FOREIGN KEY (${JobDataTableColumns.companyId}) REFERENCES $companyTable (${CompanyTableColumns.id}) ON DELETE CASCADE
  )'''); */

    /*    await db.execute('''
CREATE TABLE $interviewTable ( 
  ${InterviewTableColumns.id} $idType, 
  ${InterviewTableColumns.date} $textType,
  ${InterviewTableColumns.time} $textType,
  ${InterviewTableColumns.type} $textType,
  ${InterviewTableColumns.place} $textType,
  ${InterviewTableColumns.answerTime} $textType,
  ${InterviewTableColumns.followUpType} $textType,
  ${InterviewTableColumns.followUpDate} $textType,
  ${InterviewTableColumns.jobDataId} $intType,

  FOREIGN KEY (${InterviewTableColumns.jobDataId}) REFERENCES $jobDataTable (${JobDataTableColumns.id}) ON DELETE CASCADE
  )'''); */

    /*    await db.execute('''
CREATE TABLE $requirementTable ( 
  ${RequirementTableColumns.id} $idType, 
  ${RequirementTableColumns.requirement} $textType,
  ${RequirementTableColumns.jobDataId} $intType,

  FOREIGN KEY (${RequirementTableColumns.jobDataId}) REFERENCES $jobDataTable (${JobDataTableColumns.id}) ON DELETE CASCADE
  )'''); */

/*     await db.execute('''
CREATE TABLE $contractTable( 
  ${ContractTableColumns.id} $idType, 
  ${ContractTableColumns.type} $textType,
  ${ContractTableColumns.ral} $intType,
  ${ContractTableColumns.salary} $intType,
  ${ContractTableColumns.contractDuration} $textType,
  ${ContractTableColumns.jobDataId} $intType,

  FOREIGN KEY (${ContractTableColumns.jobDataId}) REFERENCES $jobDataTable (${JobDataTableColumns.id}) ON DELETE CASCADE
  )'''); */

    /*    await db.execute('''
CREATE TABLE $clientCompanyTable( 
  ${FinalCompanyTableColumns.id} $idType, 
  ${FinalCompanyTableColumns.clientCompanyId} $intType,
  ${FinalCompanyTableColumns.companyId} $intType,
  ${FinalCompanyTableColumns.jobAppId} $intType,

  FOREIGN KEY (${FinalCompanyTableColumns.companyId}) REFERENCES $companyTable (${CompanyTableColumns.id}) ON DELETE CASCADE,
  
  FOREIGN KEY (${FinalCompanyTableColumns.jobAppId}) REFERENCES $jobDataTable (${JobDataTableColumns.id}) ON DELETE CASCADE
  )'''); */

    /// INSERT
    /*    await db.execute('''INSERT INTO $companyTable (
    ${CompanyTableColumns.name},
    ${CompanyTableColumns.city},
    ${CompanyTableColumns.address},
    ${CompanyTableColumns.phoneNumber},
    ${CompanyTableColumns.website},
    ${CompanyTableColumns.workingHours},
    ${CompanyTableColumns.email}
  ) VALUES ('Company', 'Gallarate', 'Via della Company', 123456789, 'https://www.google.com/', '9-18', 'email@email1'),
           ('Company2', 'Varese', 'Via della Company2', 3456789, 'https://www.google.com/', '8.30-12.30/14-18', 'email@email2')
  '''); */

/*     await db.execute('''
  INSERT INTO $jobDataTable (
    ${JobDataTableColumns.applyDate},
    ${JobDataTableColumns.position},
    ${JobDataTableColumns.applicationStatus},
    ${JobDataTableColumns.websiteUrl},
    ${JobDataTableColumns.workType},
    ${JobDataTableColumns.dayInOffice},
    ${JobDataTableColumns.experience},
    ${JobDataTableColumns.companyId}
  ) VALUES ('2023-10-11', 'Junior Developer', 'apply', 'www.indeed.com', 'hybrid', '3', 'Da 1 a 5 anni', 1), 
           ('2023-11-10', 'Junior Developer2', 'interview', 'www.indeed.com', 'presence', '5', '', 2)
  '''); */

    /*  await db.execute( '''INSERT INTO $clientCompanyTable (    
    ${FinalCompanyTableColumns.id}, 
    ${FinalCompanyTableColumns.clientCompanyId},
    ${FinalCompanyTableColumns.companyId},
    ${FinalCompanyTableColumns.jobAppId}

  ) VALUES (1, 2, 1, 1) ''' ); */

    /*  await db.execute('''INSERT INTO $companyReferentTableName (
    ${CompanyReferentTableColumns.name},
    ${CompanyReferentTableColumns.email},
    ${CompanyReferentTableColumns.phoneNumber},
    ${CompanyReferentTableColumns.role},
    ${CompanyReferentTableColumns.jobDataId},
    ${CompanyReferentTableColumns.companyId}
  ) VALUES ('Referent1', 'email', '1234556', 'HR', 1, 1),
    ('Referent1', 'email', '1234556', 'DEV', 1, 1),
    ('Referent1', 'email', '1234556', 'AD', 1, 1)
    '''); */
  }
 */