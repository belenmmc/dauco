import 'package:dauco/domain/entities/minor.entity.dart';
import 'package:dauco/presentation/widgets/search_bar_widget.dart';
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
  final SearchFilters searchFilters;
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
    required this.searchFilters,
    required this.role,
  });

  @override
  State<MinorsListWidget> createState() => _MinorsListWidgetState();
}

class _MinorsListWidgetState extends State<MinorsListWidget> {
  static const _cardColor = Color.fromARGB(255, 252, 254, 255);
  static const _buttonColor = Color.fromARGB(255, 97, 135, 174);
  static const _animationDuration = Duration(milliseconds: 200);

  bool _matchesAllFilters(Minor minor, SearchFilters filters) {
    if (filters.isEmpty) return true;

    return filters.filters.entries.every((entry) {
      final field = entry.key;
      final value = entry.value;

      switch (field) {
        case SearchField.name:
          return minor.minorId
              .toString()
              .toLowerCase()
              .contains(value.toString().toLowerCase());
        case SearchField.birthdate:
          if (value is Map<String, DateTime>) {
            final minorDate = DateTime(minor.birthdate.year,
                minor.birthdate.month, minor.birthdate.day);

            final dateFrom = value['from'];
            final dateTo = value['to'];

            // Check if the minor's birthdate is within the range
            bool isAfterFrom = dateFrom == null ||
                minorDate.isAfter(dateFrom) ||
                minorDate.isAtSameMomentAs(dateFrom);

            bool isBeforeTo = dateTo == null ||
                minorDate.isBefore(dateTo) ||
                minorDate.isAtSameMomentAs(dateTo);

            return isAfterFrom && isBeforeTo;
          } else if (value is DateTime) {
            // Fallback for single date (backward compatibility)
            final filterDate = DateTime(value.year, value.month, value.day);
            final minorDate = DateTime(minor.birthdate.year,
                minor.birthdate.month, minor.birthdate.day);
            return minorDate.isAtSameMomentAs(filterDate);
          }
          return false;
        case SearchField.sex:
          String filterValue = value.toString().toUpperCase();
          String minorSex = minor.sex.toUpperCase();

          // Handle different sex value formats in the database
          if (minorSex == 'MASCULINO' || minorSex == 'MALE') {
            minorSex = 'M';
          } else if (minorSex == 'FEMENINO' || minorSex == 'FEMALE') {
            minorSex = 'F';
          }

          return minorSex == filterValue;

        case SearchField.zipCode:
          return minor.zipCode
              .toString()
              .toLowerCase()
              .contains(value.toString().toLowerCase());
      }
    });
  }

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
    final filteredMinors = widget.minors.where((minor) {
      return _matchesAllFilters(minor, widget.searchFilters);
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
                  const EdgeInsets.symmetric(vertical: 6.0, horizontal: 150.0),
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
  }

  Widget _buildPaginationControls() {
    return Container(
      padding: const EdgeInsets.only(bottom: 2.0, top: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _PaginationButton(
            icon: Icons.arrow_back_ios_rounded,
            onPressed: widget.hasPreviousPage ? widget.onPreviousPage : null,
            color: widget.hasPreviousPage
                ? _buttonColor
                : _buttonColor.withOpacity(0.5),
          ),
          const SizedBox(width: 20),
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
                'Fecha de nacimiento: ${minor.birthdate.day.toString().padLeft(2, '0')}/${minor.birthdate.month.toString().padLeft(2, '0')}/${minor.birthdate.year}',
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
  final Function()? onPressed;
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
