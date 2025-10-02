import 'package:dauco/presentation/pages/admin_page.dart';
import 'package:dauco/presentation/widgets/circular_button_widget.dart';
import 'package:dauco/presentation/widgets/profile_button_widget.dart';
import 'package:dauco/presentation/widgets/select_file_widget.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget implements PreferredSizeWidget {
  final ValueChanged<String> onChanged;
  final String role;

  const SearchBarWidget(
      {super.key, required this.onChanged, required this.role});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 20.0);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2.0),
        child: Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.role == 'admin')
                CircularButtonWidget(
                  iconData: Icons.manage_accounts,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminPage(),
                    ),
                  ),
                ),
              if (widget.role == 'admin') SizedBox(width: 12),
              SizedBox(
                width: screenWidth * 0.5,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(237, 247, 238, 255),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 12),
                      const Icon(Icons.search,
                          color: Color.fromARGB(255, 43, 45, 66)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          onChanged: widget.onChanged,
                          style: const TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                            isCollapsed: true,
                            hintText: 'Buscar...',
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 14),
                            suffixIcon: _controller.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear,
                                        color: Color.fromARGB(255, 43, 45, 66)),
                                    padding: const EdgeInsets.only(right: 8),
                                    onPressed: () {
                                      _controller.clear();
                                      widget.onChanged('');
                                      setState(() {});
                                    },
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 24),
              SelectFileWidget(),
              SizedBox(width: 12),
              ProfileButtonWidget()
            ],
          ),
        ),
      ),
    );
  }
}
