import '../data/network/network_api_services.dart';
import '../constants/appUrls.dart';
import '../model/customerTicketReport_model.dart';

class CustomerRepository {
  final NetworkApiServices _api = NetworkApiServices();

  Future<CustomerTicketReportModel> getCustomerTicketReport({
    required int customerId,
    required String fromDate,
    required String toDate,
  }) async {

    final payload = {
      "customer_id": customerId.toString(),
      "from_date": fromDate,
      "to_date": toDate,
    };

    print("📤 Report Payload: $payload");

    final response = await _api.getPostApiResponse(
      AppUrls.customerTicketReport,
      payload,
    );

    return CustomerTicketReportModel.fromJson(response);
  }
}