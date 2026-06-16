import '../data/network/network_api_services.dart';
import '../constants/appUrls.dart';
import '../model/customerTicketReport_model.dart';

class CustomerRepository {
  final NetworkApiServices _api = NetworkApiServices();

  Future<CustomerTicketReportModel> getCustomerTicketReport({
    required int customerId,
    required String fromDate,
  }) async {

    print({
      "customer_id": customerId.toString(),
      "from_date": fromDate,
    });

    final response = await _api.getPostApiResponse(
      AppUrls.customerTicketReport,
      {
        "customer_id": customerId.toString(),
        "from_date": fromDate,
      },
    );

    print(response);

    return CustomerTicketReportModel.fromJson(response);
  }
}