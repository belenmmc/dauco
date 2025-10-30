import 'package:dauco/presentation/widgets/register_user_button_widget.dart';
import 'package:flutter/material.dart';

enum UserSearchField {
  all('Todos los campos'),
  name('Nombre'),
  email('Email'),
  role('Rol'),
  managerId('ID Responsable');

  const UserSearchField(this.displayName);
  final String displayName;
}

class AdminSearchBarWidget extends StatefulWidget
    implements PreferredSizeWidget {
  final Function(String query, UserSearchField field) onChanged;
  final String role;

  const AdminSearchBarWidget({
    super.key,
    required this.onChanged,
    required this.role,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 20.0);

  @override
  State<AdminSearchBarWidget> createState() => _AdminSearchBarWidgetState();
}

class _AdminSearchBarWidgetState extends State<AdminSearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  UserSearchField _selectedField = UserSearchField.all;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: kToolbarHeight + 20.0,
      flexibleSpace: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 16,
              top: 0,
              bottom: 0,
              child: IconButton(
                icon: const Icon(Icons.arrow_back,
                    color: Color.fromARGB(255, 43, 45, 66)),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: screenWidth * 0.5,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 248, 251, 255),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        const Icon(Icons.search,
                            color: Color.fromARGB(255, 43, 45, 66)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            onChanged: (value) =>
                                widget.onChanged(value, _selectedField),
                            style: const TextStyle(fontSize: 16),
                            decoration: InputDecoration(
                              isCollapsed: true,
                              hintText:
                                  'Buscar en ${_selectedField.displayName.toLowerCase()}... (ej: admin juan)',
                              border: InputBorder.none,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              suffixIcon: _controller.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear,
                                          color:
                                              Color.fromARGB(255, 43, 45, 66)),
                                      padding: const EdgeInsets.only(right: 8),
                                      onPressed: () {
                                        _controller.clear();
                                        widget.onChanged('', _selectedField);
                                        setState(() {});
                                      },
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        // Dropdown para seleccionar campo de búsqueda
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: PopupMenuButton<UserSearchField>(
                            icon: const Icon(
                              Icons.filter_list,
                              color: Color.fromARGB(255, 43, 45, 66),
                            ),
                            tooltip: 'Filtros de búsqueda',
                            onSelected: (UserSearchField field) {
                              setState(() {
                                _selectedField = field;
                              });
                              // Volver a ejecutar la búsqueda con el nuevo campo
                              widget.onChanged(_controller.text, field);
                            },
                            itemBuilder: (BuildContext context) {
                              return UserSearchField.values
                                  .map((UserSearchField field) {
                                return PopupMenuItem<UserSearchField>(
                                  value: field,
                                  child: Row(
                                    children: [
                                      Icon(
                                        field == _selectedField
                                            ? Icons.radio_button_checked
                                            : Icons.radio_button_unchecked,
                                        color: field == _selectedField
                                            ? Colors.blue
                                            : Colors.grey,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(field.displayName),
                                    ],
                                  ),
                                );
                              }).toList();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12),
                RegisterUserButtonWidget(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
