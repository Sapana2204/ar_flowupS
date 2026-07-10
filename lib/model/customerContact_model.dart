class CustomerContact {
  String? name;
  String? mobileNo;
  String? email;
  String? department;
  String? designation;
  String? isPrimary;

  CustomerContact({
    this.name,
    this.mobileNo,
    this.email,
    this.department,
    this.designation,
    this.isPrimary,
  });

  CustomerContact.fromJson(Map<String, dynamic> json) {
    name = json['name']?.toString();
    mobileNo = json['mobile_no']?.toString();
    email = json['email']?.toString();
    department = json['department']?.toString();
    designation = json['designation']?.toString();
    isPrimary = json['is_primary']?.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'mobile_no': mobileNo,
      'email': email,
      'department': department,
      'designation': designation,
      'is_primary': isPrimary,
    };
  }
}