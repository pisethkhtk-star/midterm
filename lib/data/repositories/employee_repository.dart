import 'package:demo_access_refresh_token_app/data/models/employee/employee_model.dart';
import 'package:demo_access_refresh_token_app/data/models/employee/employee_request.dart';
import 'package:demo_access_refresh_token_app/data/providers/employee_provider.dart';

abstract class IEmployeeRepository {
  Future<List<EmployeeModel>> getEmployees({String status = 'ALL'});
  Future<EmployeeModel?> getEmployeeById(int id);
  Future<bool> createEmployee(EmployeeRequest request);
  Future<bool> updateEmployee(EmployeeRequest request);
  Future<bool> deleteEmployee(int id);
}

class EmployeeRepositoryImpl implements IEmployeeRepository {
  final EmployeeProvider _provider;

  EmployeeRepositoryImpl({EmployeeProvider? provider})
      : _provider = provider ?? EmployeeProvider();

  @override
  Future<List<EmployeeModel>> getEmployees({String status = 'ALL'}) async {
    return await _provider.getEmployees(status: status);
  }

  @override
  Future<EmployeeModel?> getEmployeeById(int id) async {
    return await _provider.getEmployeeById(id);
  }

  @override
  Future<bool> createEmployee(EmployeeRequest request) async {
    return await _provider.createEmployee(request);
  }

  @override
  Future<bool> updateEmployee(EmployeeRequest request) async {
    return await _provider.updateEmployee(request);
  }

  @override
  Future<bool> deleteEmployee(int id) async {
    return await _provider.deleteEmployee(id);
  }
}

