//
// import 'package:sb_paints/data/response/status.dart';
//
// class ApiResponse<T> {
//   //! Data members with T as generics
//   Status? status;
//   String? message;
//   T? data;
//
// // ! Contructor
//   ApiResponse(this.status, this.message, this.data);
//
// // ! Named Constructors with initializer list
//   ApiResponse.loading() : status = Status.LOADING;
//   ApiResponse.completed(this.data) : status = Status.COMPLETED;
//   ApiResponse.error(this.message) : status = Status.ERROR;
//
//   @override
//   String toString() {
//     return "status : $status\n message : $message\n data : $data ";
//   }
// }
