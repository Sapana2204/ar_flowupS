class getMenus_model {
  bool? success;
  int? code;
  String? type;
  String? message;
  List<Data>? data;
  Pagination? pagination;

  getMenus_model(
      {this.success,
        this.code,
        this.type,
        this.message,
        this.data,
        this.pagination});

  getMenus_model.fromJson(Map<String, dynamic> json) {
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
  int? menuId;
  String? menuName;
  String? moduleName;
  Null? moduleDescription;
  String? menuLink;
  String? tableName;
  String? iconName;
  String? pluralLabel;
  String? label;
  int? menuIndex;
  Null? companyId;
  String? createdBy;
  String? createdDate;
  String? modifiedBy;
  String? modifiedDate;
  String? status;

  Data(
      {this.menuId,
        this.menuName,
        this.moduleName,
        this.moduleDescription,
        this.menuLink,
        this.tableName,
        this.iconName,
        this.pluralLabel,
        this.label,
        this.menuIndex,
        this.companyId,
        this.createdBy,
        this.createdDate,
        this.modifiedBy,
        this.modifiedDate,
        this.status});

  Data.fromJson(Map<String, dynamic> json) {
    menuId = json['menu_id'];
    menuName = json['menu_name'];
    moduleName = json['module_name'];
    moduleDescription = json['module_description'];
    menuLink = json['menu_link'];
    tableName = json['table_name'];
    iconName = json['icon_name'];
    pluralLabel = json['plural_label'];
    label = json['label'];
    menuIndex = json['menu_index'];
    companyId = json['company_id'];
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    modifiedBy = json['modified_by'];
    modifiedDate = json['modified_date'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['menu_id'] = this.menuId;
    data['menu_name'] = this.menuName;
    data['module_name'] = this.moduleName;
    data['module_description'] = this.moduleDescription;
    data['menu_link'] = this.menuLink;
    data['table_name'] = this.tableName;
    data['icon_name'] = this.iconName;
    data['plural_label'] = this.pluralLabel;
    data['label'] = this.label;
    data['menu_index'] = this.menuIndex;
    data['company_id'] = this.companyId;
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
  String? limit;
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

