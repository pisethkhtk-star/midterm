import 'package:demo_access_refresh_token_app/core/constants/api_endpoints.dart';
import 'package:demo_access_refresh_token_app/core/network/api_client.dart';
import 'package:demo_access_refresh_token_app/data/models/employee/employee_model.dart';
import 'package:demo_access_refresh_token_app/data/models/employee/employee_request.dart';

class EmployeeProvider {
  final ApiClient _apiClient;

  EmployeeProvider({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<List<EmployeeModel>> getEmployees({String status = 'ALL'}) async {
    final response = await _apiClient.post(
      ApiEndpoints.employeeList,
      body: {'status': status},
      requireAuth: true,
    );

    List items = [];
    if (response is Map && response['data'] != null) {
      if (response['data'] is List) {
        items = response['data'];
      }
    } else if (response is List) {
      items = response;
    }

    return items.map((item) => EmployeeModel.fromJson(item)).toList();
  }

  Future<EmployeeModel?> getEmployeeById(int id) async {
    final response = await _apiClient.post(
      ApiEndpoints.employeeById(id),
      body: {'status': 'ACT'},
      requireAuth: true,
    );

    if (response is Map && response['data'] != null) {
      return EmployeeModel.fromJson(response['data']);
    }
    return null;
  }

  Future<bool> createEmployee(EmployeeRequest request) async {
    final response = await _apiClient.post(
      ApiEndpoints.employeeCreate,
      body: request.toCreateJson(),
      requireAuth: true,
    );
    return response != null;
  }

  Future<bool> updateEmployee(EmployeeRequest request) async {
    final response = await _apiClient.post(
      ApiEndpoints.employeeUpdate,
      body: request.toUpdateJson(),
      requireAuth: true,
    );
    return response != null;
  }

  Future<bool> deleteEmployee(int id) async {
    final response = await _apiClient.post(
      ApiEndpoints.employeeDelete,
      body: {'id': id},
      requireAuth: true,
    );
    return response != null;
  }
}

