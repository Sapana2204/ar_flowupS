class CommonCategoryModel {
  bool? success;
  int? code;
  String? type;
  String? message;
  List<CategoryData>? data;

  CommonCategoryModel({
    this.success,
    this.code,
    this.type,
    this.message,
    this.data,
  });

  CommonCategoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    type = json['type'];
    message = json['message'];

    if (json['data'] != null) {
      data = (json['data'] as List)
          .map((v) => CategoryData.fromJson(v))
          .toList();
    }
  }
}

class CategoryData {
  int? categoryId;
  String? slug;
  String? categoryName;
  int? parentId;
  String? isParent;
  int? categoriesIndex;
  List<Sublist>? sublist;

  CategoryData.fromJson(Map<String, dynamic> json) {
    categoryId = _toInt(json['category_id']);
    slug = json['slug']?.toString();
    categoryName = json['categoryName']?.toString();
    parentId = _toInt(json['parent_id']);
    isParent = json['is_parent']?.toString();
    categoriesIndex = _toInt(json['categories_index']);

    if (json['sublist'] != null) {
      sublist = (json['sublist'] as List)
          .map((v) => Sublist.fromJson(v))
          .toList();
    }
  }
}

class Sublist {
  int? categoryId;
  String? slug;
  String? categoryName;
  int? parentId;
  String? isParent;
  int? categoriesIndex;
  String? catColor;

  Sublist.fromJson(Map<String, dynamic> json) {
    categoryId = _toInt(json['category_id']);
    slug = json['slug']?.toString();
    categoryName = json['categoryName']?.toString();
    parentId = _toInt(json['parent_id']);
    isParent = json['is_parent']?.toString();
    categoriesIndex = _toInt(json['categories_index']);
    catColor = json['cat_color']?.toString(); // ✅ FIX
  }
}

/// ✅ SAFE INT PARSER
int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}