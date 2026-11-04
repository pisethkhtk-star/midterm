import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_access_refresh_token_app/core/constants/app_colors.dart';
import 'package:demo_access_refresh_token_app/core/utils/validators.dart';
import 'package:demo_access_refresh_token_app/data/models/employee/employee_model.dart';
import 'package:demo_access_refresh_token_app/data/models/employee/employee_request.dart';
import 'package:demo_access_refresh_token_app/modules/employees/employee_controller.dart';
import 'package:demo_access_refresh_token_app/widgets/custom_button.dart';
import 'package:demo_access_refresh_token_app/widgets/custom_text_field.dart';

class EmployeeFormView extends StatefulWidget {
  const EmployeeFormView({super.key});

  @override
  State<EmployeeFormView> createState() => _EmployeeFormViewState();
}

class _EmployeeFormViewState extends State<EmployeeFormView> {
  final EmployeeController controller = Get.find<EmployeeController>();

  final _formKey = GlobalKey<FormState>();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  EmployeeModel? _editingEmployee;
  bool get isEdit => _editingEmployee != null;

  String _selectedRole = 'USER';
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _editingEmployee = Get.arguments is EmployeeModel ? Get.arguments as EmployeeModel : null;

    _firstNameController = TextEditingController(text: _editingEmployee?.firstName ?? '');
    _lastNameController = TextEditingController(text: _editingEmployee?.lastName ?? '');
    _usernameController = TextEditingController(text: _editingEmployee?.username ?? '');
    _emailController = TextEditingController(text: _editingEmployee?.email ?? '');
    _phoneController = TextEditingController(text: _editingEmployee?.phoneNumber ?? '');
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    if (_editingEmployee != null) {
      final role = _editingEmployee!.role.replaceAll('ROLE_', '').toUpperCase();
      _selectedRole = (role == 'ADMIN') ? 'ADMIN' : 'USER';
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final request = EmployeeRequest(
      id: _editingEmployee?.id,
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      password: _passwordController.text.isNotEmpty ? _passwordController.text : null,
      confirmPassword: _confirmPasswordController.text.isNotEmpty
          ? _confirmPasswordController.text
          : null,
      role: _selectedRole,
      status: _editingEmployee?.status ?? 'ACT',
    );

    final success = await controller.saveEmployee(
      request: request,
      isEdit: isEdit,
    );

    if (success) {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          isEdit ? 'Update Employee' : 'Add New Employee',
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.divider),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Info Badge
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.infoBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.badge_outlined, color: AppColors.primaryLight, size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          isEdit
                              ? 'Editing employee details for ${_editingEmployee?.username}.'
                              : 'Fill in the information below to register a new employee record.',
                          style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Name Fields
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _firstNameController,
                        label: 'First Name',
                        hint: 'John',
                        prefixIcon: Icons.person_outline,
                        validator: (v) => Validators.required(v, 'First Name'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomTextField(
                        controller: _lastNameController,
                        label: 'Last Name',
                        hint: 'Doe',
                        validator: (v) => Validators.required(v, 'Last Name'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Username
                CustomTextField(
                  controller: _usernameController,
                  label: 'Username',
                  hint: 'johndoe',
                  prefixIcon: Icons.alternate_email_rounded,
                  validator: Validators.username,
                ),
                const SizedBox(height: 16),

                // Email
                CustomTextField(
                  controller: _emailController,
                  label: 'Email Address',
                  hint: 'john.doe@example.com',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),
                const SizedBox(height: 16),

                // Phone
                CustomTextField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  hint: '012345678',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: Validators.phone,
                ),
                const SizedBox(height: 16),

                // Role Dropdown
                const Text(
                  'Employee Role',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border, width: 1.2),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedRole,
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down_rounded),
                      items: const [
                        DropdownMenuItem(
                          value: 'USER',
                          child: Text('USER (Standard Employee)'),
                        ),
                        DropdownMenuItem(
                          value: 'ADMIN',
                          child: Text('ADMIN (Administrator)'),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedRole = val);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Password Fields (required if Add, optional if Edit)
                CustomTextField(
                  controller: _passwordController,
                  label: isEdit ? 'New Password (leave blank to keep current)' : 'Password',
                  hint: 'Enter password (min 6 chars)',
                  prefixIcon: Icons.lock_outline_rounded,
                  obscureText: _obscurePassword,
                  validator: (val) {
                    if (!isEdit) {
                      return Validators.password(val, minLength: 6);
                    }
                    if (val != null && val.isNotEmpty && val.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  controller: _confirmPasswordController,
                  label: isEdit ? 'Confirm New Password' : 'Confirm Password',
                  hint: 'Repeat password',
                  prefixIcon: Icons.lock_outline_rounded,
                  obscureText: _obscurePassword,
                  validator: (val) {
                    if (!isEdit || (_passwordController.text.isNotEmpty)) {
                      return Validators.confirmPassword(val, _passwordController.text);
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Save Button
                Obx(() => CustomButton(
                      title: isEdit ? 'Update Employee' : 'Create Employee',
                      icon: isEdit ? Icons.check_circle_outline : Icons.person_add_rounded,
                      isLoading: controller.isActionLoading.value,
                      onPressed: _submit,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

