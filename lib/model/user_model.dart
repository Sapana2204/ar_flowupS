class UsersModel {
  bool? success;
  int? code;
  String? type;
  String? message;
  List<Data>? data;
  Pagination? pagination;

  UsersModel(
      {this.success,
        this.code,
        this.type,
        this.message,
        this.data,
        this.pagination});

  UsersModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    type = json['type'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['code'] = this.code;
    data['type'] = this.type;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class Data {
  int? adminID;
  String? name;
  String? defaultCompany;
  String? timeZone;
  String? companyId;
  String? isApprover;
  String? userName;
  String? email;
  String? isEmailSend;
  String? password;
  String? isSysUser;
  String? roleID;
  String? userSetting;
  String? photo;
  String? address;
  String? googleLocation;
  Null? latitude;
  Null? longitude;
  String? contactNo;
  Null? countryCode;
  String? whatsappNo;
  String? dateOfBirth;
  int? otp;
  String? isVerified;
  String? lastLogin;
  String? gfcmToken;
  String? isGoogleSync;
  String? isOneDriveSync;
  Null? gCalToken;
  Null? oneDriveAccessToken;
  String? otpExpTime;
  String? createdBy;
  String? createdDate;
  String? modifiedBy;
  String? modifiedDate;
  String? status;

  Data(
      {this.adminID,
        this.name,
        this.defaultCompany,
        this.timeZone,
        this.companyId,
        this.isApprover,
        this.userName,
        this.email,
        this.isEmailSend,
        this.password,
        this.isSysUser,
        this.roleID,
        this.userSetting,
        this.photo,
        this.address,
        this.googleLocation,
        this.latitude,
        this.longitude,
        this.contactNo,
        this.countryCode,
        this.whatsappNo,
        this.dateOfBirth,
        this.otp,
        this.isVerified,
        this.lastLogin,
        this.gfcmToken,
        this.isGoogleSync,
        this.isOneDriveSync,
        this.gCalToken,
        this.oneDriveAccessToken,
        this.otpExpTime,
        this.createdBy,
        this.createdDate,
        this.modifiedBy,
        this.modifiedDate,
        this.status});

  Data.fromJson(Map<String, dynamic> json) {
    adminID = json['adminID'];
    name = json['name'];
    defaultCompany = json['default_company'];
    timeZone = json['time_zone'];
    companyId = json['company_id'];
    isApprover = json['is_approver'];
    userName = json['userName'];
    email = json['email'];
    isEmailSend = json['isEmailSend'];
    password = json['password'];
    isSysUser = json['is_sys_user'];
    roleID = json['roleID'];
    userSetting = json['user_setting'];
    photo = json['photo'];
    address = json['address'];
    googleLocation = json['google_location'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    contactNo = json['contactNo'];
    countryCode = json['country_code'];
    whatsappNo = json['whatsappNo'];
    dateOfBirth = json['dateOfBirth'];
    otp = json['otp'];
    isVerified = json['isVerified'];
    lastLogin = json['lastLogin'];
    gfcmToken = json['gfcmToken'];
    isGoogleSync = json['is_google_sync'];
    isOneDriveSync = json['is_one_drive_sync'];
    gCalToken = json['g_cal_token'];
    oneDriveAccessToken = json['one_drive_access_token'];
    otpExpTime = json['otp_exp_time'];
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    modifiedBy = json['modified_by'];
    modifiedDate = json['modified_date'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['adminID'] = this.adminID;
    data['name'] = this.name;
    data['default_company'] = this.defaultCompany;
    data['time_zone'] = this.timeZone;
    data['company_id'] = this.companyId;
    data['is_approver'] = this.isApprover;
    data['userName'] = this.userName;
    data['email'] = this.email;
    data['isEmailSend'] = this.isEmailSend;
    data['password'] = this.password;
    data['is_sys_user'] = this.isSysUser;
    data['roleID'] = this.roleID;
    data['user_setting'] = this.userSetting;
    data['photo'] = this.photo;
    data['address'] = this.address;
    data['google_location'] = this.googleLocation;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['contactNo'] = this.contactNo;
    data['country_code'] = this.countryCode;
    data['whatsappNo'] = this.whatsappNo;
    data['dateOfBirth'] = this.dateOfBirth;
    data['otp'] = this.otp;
    data['isVerified'] = this.isVerified;
    data['lastLogin'] = this.lastLogin;
    data['gfcmToken'] = this.gfcmToken;
    data['is_google_sync'] = this.isGoogleSync;
    data['is_one_drive_sync'] = this.isOneDriveSync;
    data['g_cal_token'] = this.gCalToken;
    data['one_drive_access_token'] = this.oneDriveAccessToken;
    data['otp_exp_time'] = this.otpExpTime;
    data['created_by'] = this.createdBy;
    data['created_date'] = this.createdDate;
    data['modified_by'] = this.modifiedBy;
    data['modified_date'] = this.modifiedDate;
    data['status'] = this.status;
    return data;
  }
}

class Pagination {
  int? total;
  int? page;
  int? limit;
  int? totalPages;
  int? start;
  int? end;

  Pagination(
      {this.total,
        this.page,
        this.limit,
        this.totalPages,
        this.start,
        this.end});

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
    start = json['start'];
    end = json['end'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['page'] = this.page;
    data['limit'] = this.limit;
    data['totalPages'] = this.totalPages;
    data['start'] = this.start;
    data['end'] = this.end;
    return data;
  }
}
