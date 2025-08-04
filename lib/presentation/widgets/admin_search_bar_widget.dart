import 'package:dauco/presentation/widgets/register_user_button_widget.dart';
import 'package:flutter/material.dart';

class AdminSearchBarWidget extends StatefulWidget
    implements PreferredSizeWidget {
  final ValueChanged<String> onChanged;
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
                      color: const Color.fromARGB(237, 247, 238, 255),
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
                                          color:
                                              Color.fromARGB(255, 43, 45, 66)),
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
