class ProfileModel {
  bool? success;
  int? code;
  String? type;
  String? message;
  Data? data;

  ProfileModel({this.success, this.code, this.type, this.message, this.data});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    type = json['type'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['code'] = this.code;
    data['type'] = this.type;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? adminID;
  String? name;
  String? email;
  String? dateOfBirth;
  String? userName;
  String? whatsappNo;
  String? timeZone;
  int? roleID;
  String? roleName;
  String? roleSlug;
  String? companyId;
  String? companyName;
  String? isApprover;
  String? googleLocation;
  String? status;
  String? address;
  String? contactNo;
  String? createdDate;
  Null? lastLogin;

  Data(
      {this.adminID,
        this.name,
        this.email,
        this.dateOfBirth,
        this.userName,
        this.whatsappNo,
        this.timeZone,
        this.roleID,
        this.roleName,
        this.roleSlug,
        this.companyId,
        this.companyName,
        this.isApprover,
        this.googleLocation,
        this.status,
        this.address,
        this.contactNo,
        this.createdDate,
        this.lastLogin});

  Data.fromJson(Map<String, dynamic> json) {
    adminID = json['adminID'];
    name = json['name'];
    email = json['email'];
    dateOfBirth = json['dateOfBirth'];
    userName = json['userName'];
    whatsappNo = json['whatsappNo'];
    timeZone = json['time_zone'];
    roleID = json['roleID'];
    roleName = json['roleName'];
    roleSlug = json['role_slug'];
    companyId = json['company_id'];
    companyName = json['company_name'];
    isApprover = json['is_approver'];
    googleLocation = json['google_location'];
    status = json['status'];
    address = json['address'];
    contactNo = json['contactNo'];
    createdDate = json['created_date'];
    lastLogin = json['lastLogin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['adminID'] = this.adminID;
    data['name'] = this.name;
    data['email'] = this.email;
    data['dateOfBirth'] = this.dateOfBirth;
    data['userName'] = this.userName;
    data['whatsappNo'] = this.whatsappNo;
    data['time_zone'] = this.timeZone;
    data['roleID'] = this.roleID;
    data['roleName'] = this.roleName;
    data['role_slug'] = this.roleSlug;
    data['company_id'] = this.companyId;
    data['company_name'] = this.companyName;
    data['is_approver'] = this.isApprover;
    data['google_location'] = this.googleLocation;
    data['status'] = this.status;
    data['address'] = this.address;
    data['contactNo'] = this.contactNo;
    data['created_date'] = this.createdDate;
    data['lastLogin'] = this.lastLogin;
    return data;
  }
}
