import 'package:dauco/presentation/pages/admin_page.dart';
import 'package:dauco/presentation/pages/analytics_page.dart';
import 'package:dauco/presentation/widgets/circular_button_widget.dart';
import 'package:dauco/presentation/widgets/profile_button_widget.dart';
import 'package:dauco/presentation/widgets/select_file_widget.dart';
import 'package:flutter/material.dart';

enum SearchField {
  name('Nombre'),
  birthdate('Fecha de Nacimiento'),
  sex('Sexo'),
  zipCode('Código postal'),
  managerId('ID Responsable');

  const SearchField(this.displayName);
  final String displayName;
}

class SearchFilters {
  final Map<SearchField, dynamic> filters;

  SearchFilters({Map<SearchField, dynamic>? filters}) : filters = filters ?? {};

  bool get isEmpty => filters.values.every((value) =>
      value == null ||
      value == '' ||
      (value is DateTime && value.toString().isEmpty));

  SearchFilters copyWith({Map<SearchField, dynamic>? filters}) {
    return SearchFilters(filters: filters ?? this.filters);
  }
}

class SearchBarWidget extends StatefulWidget {
  final Function(SearchFilters filters) onChanged;
  final Function(bool isExpanded)? onAdvancedFiltersToggle;
  final String role;
  final bool showBackButton;

  const SearchBarWidget({
    super.key,
    required this.onChanged,
    this.onAdvancedFiltersToggle,
    required this.role,
    this.showBackButton = true,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _mainController = TextEditingController();
  final Map<SearchField, TextEditingController> _controllers = {};
  SearchFilters _currentFilters = SearchFilters();
  bool _showAdvancedFilters = false;

  String? _selectedSex;
  DateTime? _birthdateFrom;
  DateTime? _birthdateTo;

  @override
  void initState() {
    super.initState();
    for (SearchField field in SearchField.values) {
      if (field != SearchField.birthdate && field != SearchField.sex) {
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
    Map<SearchField, dynamic> filters = {};

    if (_mainController.text.isNotEmpty) {
      filters[SearchField.name] = _mainController.text;
    }

    for (var entry in _controllers.entries) {
      if (entry.key != SearchField.name && entry.value.text.isNotEmpty) {
        filters[entry.key] = entry.value.text;
      }
    }

    if (_birthdateFrom != null || _birthdateTo != null) {
      Map<String, DateTime> dateRange = {};
      if (_birthdateFrom != null) {
        dateRange['from'] = _birthdateFrom!;
      }
      if (_birthdateTo != null) {
        dateRange['to'] = _birthdateTo!;
      }
      filters[SearchField.birthdate] = dateRange;
    }

    if (_selectedSex != null && _selectedSex!.isNotEmpty) {
      String sexValue;
      switch (_selectedSex) {
        case 'Masculino':
          sexValue = 'M';
          break;
        case 'Femenino':
          sexValue = 'F';
          break;
        default:
          sexValue = _selectedSex!;
      }
      filters[SearchField.sex] = sexValue;
    }

    _currentFilters = SearchFilters(filters: filters);
    widget.onChanged(_currentFilters);
  }

  Future<DateTimeRange?> _showCustomDateRangePicker() async {
    DateTime? startDate = _birthdateFrom;
    DateTime? endDate = _birthdateTo;

    return showDialog<DateTimeRange>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: Color.fromARGB(255, 248, 251, 255),
              child: Container(
                width: 400,
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Seleccionar rango de fechas',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 43, 45, 66),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                          style: IconButton.styleFrom(
                            foregroundColor:
                                const Color.fromARGB(255, 55, 57, 82),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // From Date
                    const Text(
                      'Fecha desde:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 43, 45, 66),
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: startDate ?? DateTime(2015),
                          firstDate: DateTime(1900),
                          lastDate: endDate ?? DateTime.now(),
                          locale: const Locale('es', 'ES'),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary:
                                      const Color.fromARGB(255, 97, 135, 174),
                                  onPrimary: Colors.white,
                                  surface:
                                      const Color.fromARGB(255, 248, 251, 255),
                                  onSurface:
                                      const Color.fromARGB(255, 43, 45, 66),
                                ),
                                dialogBackgroundColor:
                                    const Color.fromARGB(255, 248, 251, 255),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setDialogState(() {
                            startDate = picked;
                            if (endDate != null && picked.isAfter(endDate!)) {
                              endDate = null;
                            }
                          });
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 16),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(255, 213, 222, 233)),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white.withOpacity(0.8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today,
                                color: const Color.fromARGB(255, 55, 57, 82),
                                size: 20),
                            const SizedBox(width: 12),
                            Text(
                              startDate != null
                                  ? '${startDate!.day}/${startDate!.month}/${startDate!.year}'
                                  : 'Seleccionar fecha',
                              style: TextStyle(
                                fontSize: 16,
                                color: startDate != null
                                    ? const Color.fromARGB(255, 43, 45, 66)
                                    : const Color.fromARGB(255, 55, 57, 82),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // To Date
                    const Text(
                      'Fecha hasta:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 43, 45, 66),
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: endDate ?? startDate ?? DateTime(2015),
                          firstDate: startDate ?? DateTime(1900),
                          lastDate: DateTime.now(),
                          locale: const Locale('es', 'ES'),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary:
                                      const Color.fromARGB(255, 97, 135, 174),
                                  onPrimary: Colors.white,
                                  surface:
                                      const Color.fromARGB(255, 248, 251, 255),
                                  onSurface:
                                      const Color.fromARGB(255, 43, 45, 66),
                                ),
                                dialogBackgroundColor:
                                    const Color.fromARGB(255, 248, 251, 255),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setDialogState(() {
                            endDate = picked;
                          });
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 16),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(255, 213, 222, 233)),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white.withOpacity(0.8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today,
                                color: const Color.fromARGB(255, 55, 57, 82),
                                size: 20),
                            const SizedBox(width: 12),
                            Text(
                              endDate != null
                                  ? '${endDate!.day}/${endDate!.month}/${endDate!.year}'
                                  : 'Seleccionar fecha',
                              style: TextStyle(
                                fontSize: 16,
                                color: endDate != null
                                    ? const Color.fromARGB(255, 43, 45, 66)
                                    : const Color.fromARGB(255, 55, 57, 82),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              foregroundColor:
                                  const Color.fromARGB(255, 43, 45, 66),
                              backgroundColor:
                                  const Color.fromARGB(255, 213, 222, 233),
                            ),
                            child: const Text(
                              'Cancelar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 55, 57, 82),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: startDate != null && endDate != null
                                ? () {
                                    Navigator.of(context).pop(
                                      DateTimeRange(
                                          start: startDate!, end: endDate!),
                                    );
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 97, 135, 174),
                              foregroundColor: Colors.white,
                              disabledBackgroundColor:
                                  const Color.fromARGB(255, 97, 135, 174),
                              disabledForegroundColor:
                                  Colors.white.withOpacity(0.7),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Aplicar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      constraints: BoxConstraints(
        minHeight: 70.0,
        maxHeight: _showAdvancedFilters ? 300.0 : 70.0,
      ),
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (widget.showBackButton)
              Positioned(
                left: 16,
                top: 0,
                bottom: 0,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back,
                      color: Color.fromARGB(255, 43, 45, 66)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.role == 'admin')
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: CircularButtonWidget(
                              iconData: Icons.manage_accounts,
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AdminPage(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (widget.role == 'admin' || widget.role == 'manager')
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: CircularButtonWidget(
                              iconData: Icons.analytics,
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AnalyticsPage(role: widget.role),
                                ),
                              ),
                            ),
                          ),
                        ),
                      Expanded(
                        flex: 3,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: 450,
                            minWidth: 300,
                          ),
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
                                      hintText: 'Buscar por ID',
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 14),
                                      suffixIcon: _mainController
                                              .text.isNotEmpty
                                          ? IconButton(
                                              icon: const Icon(Icons.clear,
                                                  color: Color.fromARGB(
                                                      255, 43, 45, 66)),
                                              padding: const EdgeInsets.only(
                                                  right: 8),
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
                                      widget.onAdvancedFiltersToggle
                                          ?.call(_showAdvancedFilters);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SelectFileWidget(),
                      const SizedBox(width: 8),
                      ProfileButtonWidget(),
                    ],
                  ),
                  if (_showAdvancedFilters) _buildAdvancedFilters(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedFilters() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width * 0.7,
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: SearchField.values
                .where((field) => field != SearchField.name)
                .where((field) =>
                    widget.role == 'admin' || field != SearchField.managerId)
                .map((field) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: _buildFilterField(field),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                for (var controller in _controllers.values) {
                  controller.clear();
                }
                setState(() {
                  _selectedSex = null;
                  _birthdateFrom = null;
                  _birthdateTo = null;
                });
                _updateFilters();
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
    );
  }

  Widget _buildFilterField(SearchField field) {
    switch (field) {
      case SearchField.birthdate:
        return _buildDatePickerField();
      case SearchField.sex:
        return _buildSexDropdownField();
      default:
        return _buildTextFilterField(field);
    }
  }

  Widget _buildTextFilterField(SearchField field) {
    return Container(
      height: 40,
      child: TextFormField(
        controller: _controllers[field],
        onChanged: (value) => _updateFilters(),
        style: const TextStyle(fontSize: 12),
        keyboardType: _getKeyboardType(field),
        decoration: InputDecoration(
          labelText: field.displayName,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  TextInputType _getKeyboardType(SearchField field) {
    switch (field) {
      case SearchField.zipCode:
      case SearchField.managerId:
        return TextInputType.number;
      default:
        return TextInputType.text;
    }
  }

  Widget _buildDatePickerField() {
    final TextEditingController dateController = TextEditingController(
      text: _birthdateFrom != null && _birthdateTo != null
          ? '${_birthdateFrom!.day}/${_birthdateFrom!.month}/${_birthdateFrom!.year} - ${_birthdateTo!.day}/${_birthdateTo!.month}/${_birthdateTo!.year}'
          : '',
    );

    return Container(
      height: 40,
      child: TextFormField(
        controller: dateController,
        readOnly: true,
        style: const TextStyle(fontSize: 12),
        decoration: InputDecoration(
          labelText: SearchField.birthdate.displayName,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today, size: 16),
        ),
        onTap: () async {
          final DateTimeRange? picked = await _showCustomDateRangePicker();
          if (picked != null) {
            setState(() {
              _birthdateFrom = picked.start;
              _birthdateTo = picked.end;
            });
            _updateFilters();
          }
        },
      ),
    );
  }

  Widget _buildSexDropdownField() {
    return Container(
      height: 40,
      child: DropdownButtonFormField<String>(
        value: _selectedSex,
        style: const TextStyle(fontSize: 12, color: Colors.black),
        decoration: InputDecoration(
          labelText: 'Sexo',
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        dropdownColor: const Color.fromARGB(255, 248, 251, 255),
        items: ['Masculino', 'Femenino']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: const TextStyle(fontSize: 12)),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedSex = newValue;
          });
          _updateFilters();
        },
      ),
    );
  }
}
