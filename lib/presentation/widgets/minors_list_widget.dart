import 'package:dauco/domain/entities/minor.entity.dart';
import 'package:dauco/presentation/pages/minor_info_page.dart';
import 'package:flutter/material.dart';

class MinorsListWidget extends StatefulWidget {
  final List<Minor> minors;
  final double screenWidth;
  final int? selectedIndex;
  final Function(int) onItemSelected;
  final Function() onNextPage;
  final Function() onPreviousPage;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final String searchQuery;
  final String role;

  const MinorsListWidget({
    super.key,
    required this.minors,
    required this.screenWidth,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onNextPage,
    required this.onPreviousPage,
    required this.hasNextPage,
    required this.hasPreviousPage,
    required this.searchQuery,
    required this.role,
  });

  @override
  State<MinorsListWidget> createState() => _MinorsListWidgetState();
}

class _MinorsListWidgetState extends State<MinorsListWidget> {
  static const _cardColor = Color.fromARGB(255, 247, 238, 255);
  static const _buttonColor = Color.fromARGB(255, 104, 106, 195);
  static const _animationDuration = Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        children: [
          _buildMinorsList(),
          if (widget.minors.isNotEmpty) _buildPaginationControls(),
        ],
      ),
    );
  }

  Widget _buildMinorsList() {
    final query = widget.searchQuery.toLowerCase();

    final filteredMinors = query.isEmpty
        ? widget.minors
        : widget.minors.where((minor) {
            return minor.minorId.toString() == query;
          }).toList();

    return Expanded(
      child: filteredMinors.isEmpty
          ? const _EmptyState()
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: filteredMinors.length,
              itemBuilder: (context, index) =>
                  _buildMinorCard(filteredMinors[index]),
            ),
    );
  }

  Widget _buildMinorCard(Minor minor) {
    bool isHovered = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: GestureDetector(
            onTap: () => _handleMinorSelected(minor),
            child: AnimatedContainer(
              duration: _animationDuration,
              margin:
                  const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isHovered ? _cardColor.withOpacity(0.8) : _cardColor,
              ),
              padding: const EdgeInsets.all(10.0),
              child: _MinorItem(minor: minor, screenWidth: widget.screenWidth),
            ),
          ),
        );
      },
    );
  }

  void _handleMinorSelected(Minor minor) {
    final index = widget.minors.indexOf(minor);
    widget.onItemSelected(index);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MinorInfoPage(minor: minor, role: widget.role),
      ),
    );
  }

  Widget _buildPaginationControls() {
    return Container(
      padding: const EdgeInsets.only(bottom: 2.0, top: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Always show previous button
          _PaginationButton(
            icon: Icons.arrow_back_ios_rounded,
            onPressed: widget.hasPreviousPage ? widget.onPreviousPage : null,
            color: widget.hasPreviousPage
                ? _buttonColor
                : _buttonColor.withOpacity(0.5),
          ),
          const SizedBox(width: 20), // Consistent spacing between buttons
          // Always show next button
          _PaginationButton(
            icon: Icons.arrow_forward_ios_rounded,
            onPressed: widget.hasNextPage ? widget.onNextPage : null,
            color: widget.hasNextPage
                ? _buttonColor
                : _buttonColor.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'No hay menores que coincidan con la búsqueda',
        style: TextStyle(
          color: Color.fromARGB(255, 43, 45, 66),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _MinorItem extends StatelessWidget {
  final Minor minor;
  final double screenWidth;

  const _MinorItem({
    required this.minor,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Id del menor: ${minor.minorId}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Id del responsable: ${minor.managerId}',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              Text(
                'Fecha de nacimiento: ${minor.birthdate}',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.chevron_right),
      ],
    );
  }
}

class _PaginationButton extends StatelessWidget {
  final IconData icon;
  final Function()? onPressed; // Make nullable
  final Color color;

  const _PaginationButton({
    required this.icon,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.all(12),
        shape: const CircleBorder(),
        minimumSize: const Size.square(40),
        disabledBackgroundColor: color.withOpacity(0.3),
        disabledForegroundColor: Colors.white.withOpacity(0.5),
      ),
      child: Icon(icon, size: 16, color: Colors.white),
    );
  }
}
