import 'package:dauco/presentation/widgets/register_user_button_widget.dart';
import 'package:flutter/material.dart';

enum UserSearchField {
  name('Nombre'),
  email('Email'),
  role('Rol'),
  managerId('ID Responsable');

  const UserSearchField(this.displayName);
  final String displayName;
}

class UserSearchFilters {
  final Map<UserSearchField, String> filters;

  UserSearchFilters({Map<UserSearchField, String>? filters})
      : filters = filters ?? {};

  bool get isEmpty => filters.values.every((value) => value.isEmpty);

  UserSearchFilters copyWith({Map<UserSearchField, String>? filters}) {
    return UserSearchFilters(filters: filters ?? this.filters);
  }
}

class AdminSearchBarWidget extends StatefulWidget {
  final Function(UserSearchFilters filters) onChanged;
  final String role;
  final VoidCallback? onUserCreated;

  const AdminSearchBarWidget({
    super.key,
    required this.onChanged,
    required this.role,
    this.onUserCreated,
  });

  @override
  State<AdminSearchBarWidget> createState() => _AdminSearchBarWidgetState();
}

class _AdminSearchBarWidgetState extends State<AdminSearchBarWidget> {
  final TextEditingController _mainController = TextEditingController();
  final Map<UserSearchField, TextEditingController> _controllers = {};
  UserSearchFilters _currentFilters = UserSearchFilters();
  bool _showAdvancedFilters = false;

  String? _selectedRole;

  @override
  void initState() {
    super.initState();
    // Inicializar controladores para cada campo excepto role
    for (UserSearchField field in UserSearchField.values) {
      if (field != UserSearchField.role) {
        _controllers[field] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _updateFilters() {
    Map<UserSearchField, String> filters = {};

    // Campo principal (nombre por defecto)
    if (_mainController.text.isNotEmpty) {
      filters[UserSearchField.name] = _mainController.text;
    }

    // Campos adicionales
    for (var entry in _controllers.entries) {
      if (entry.key != UserSearchField.name && entry.value.text.isNotEmpty) {
        filters[entry.key] = entry.value.text;
      }
    }

    // Campo role (dropdown)
    if (_selectedRole != null && _selectedRole!.isNotEmpty) {
      String roleValue;
      switch (_selectedRole) {
        case 'Admin':
          roleValue = 'admin';
          break;
        case 'Responsable':
          roleValue = 'manager';
          break;
        default:
          roleValue = _selectedRole!.toLowerCase();
      }
      filters[UserSearchField.role] = roleValue;
    }

    _currentFilters = UserSearchFilters(filters: filters);
    widget.onChanged(_currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      constraints: BoxConstraints(
        minHeight: 70.0,
        maxHeight: _showAdvancedFilters ? 200.0 : 70.0,
      ),
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Positioned(
                    left: 16,
                    top: 0,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Color.fromARGB(255, 43, 45, 66)),
                      onPressed: () {
                        print("Back button pressed!"); // Debug line
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: screenWidth * 0.5,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 248, 251, 255),
                            borderRadius: BorderRadius.circular(30.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 12),
                              const Icon(Icons.search,
                                  color: Color.fromARGB(255, 43, 45, 66)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _mainController,
                                  onChanged: (value) => _updateFilters(),
                                  style: const TextStyle(fontSize: 16),
                                  decoration: InputDecoration(
                                    isCollapsed: true,
                                    hintText:
                                        'Buscar por ${UserSearchField.name.displayName.toLowerCase()}',
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    suffixIcon: _mainController.text.isNotEmpty
                                        ? IconButton(
                                            icon: const Icon(Icons.clear,
                                                color: Color.fromARGB(
                                                    255, 43, 45, 66)),
                                            padding:
                                                const EdgeInsets.only(right: 8),
                                            onPressed: () {
                                              _mainController.clear();
                                              _updateFilters();
                                              setState(() {});
                                            },
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: IconButton(
                                  icon: Icon(
                                    _showAdvancedFilters
                                        ? Icons.expand_less
                                        : Icons.expand_more,
                                    color:
                                        const Color.fromARGB(255, 43, 45, 66),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _showAdvancedFilters =
                                          !_showAdvancedFilters;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      RegisterUserButtonWidget(
                        onUserCreated: widget.onUserCreated,
                      ),
                    ],
                  ),
                ],
              ),
              if (_showAdvancedFilters) _buildAdvancedFilters(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdvancedFilters() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width * 0.7,
      constraints: BoxConstraints(maxHeight: 160),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 248, 251, 255),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Flexible(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: UserSearchField.values
                      .where((field) => field != UserSearchField.name)
                      .map((field) => _buildFilterField(field))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  for (var controller in _controllers.values) {
                    controller.clear();
                  }
                  setState(() {
                    _selectedRole = null;
                  });
                  _updateFilters();
                },
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: Colors.grey.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.clear_all,
                      size: 12,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Limpiar Filtros',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterField(UserSearchField field) {
    if (field == UserSearchField.role) {
      return _buildRoleDropdownField();
    }

    return Container(
      width: 200,
      height: 40,
      child: TextFormField(
        controller: _controllers[field],
        onChanged: (value) => _updateFilters(),
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          labelText: field.displayName,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildRoleDropdownField() {
    return Container(
      width: 200,
      height: 40,
      child: DropdownButtonFormField<String>(
        value: _selectedRole,
        style: const TextStyle(fontSize: 14, color: Colors.black),
        decoration: InputDecoration(
          labelText: 'Rol',
          border: const OutlineInputBorder(),
        ),
        items: ['Admin', 'Responsable']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: const TextStyle(fontSize: 14)),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedRole = newValue;
          });
          _updateFilters();
        },
      ),
    );
  }
}
