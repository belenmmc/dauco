import 'package:dauco/domain/entities/minor.entity.dart';
import 'package:dauco/presentation/pages/minor_info_page.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';

class MinorsListWidget extends StatefulWidget {
  final Excel file;
  final List<Minor> children;
  final double screenWidth;
  final int? selectedIndex;
  final Function(int) onItemSelected;
  final Function() onNextPage;
  final Function() onPreviousPage;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const MinorsListWidget({
    super.key,
    required this.file,
    required this.children,
    required this.screenWidth,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onNextPage,
    required this.onPreviousPage,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  @override
  _MinorsListWidgetState createState() => _MinorsListWidgetState();
}

class _MinorsListWidgetState extends State<MinorsListWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: [
          Expanded(
            child: widget.children.isEmpty
                ? const Center(
                    child: Text(
                      'No hay menores registrados',
                      style: TextStyle(
                        color: Color(0xFF065591),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: widget.children.length,
                    itemBuilder: (context, index) {
                      final minor = widget.children[index];
                      return GestureDetector(
                        onTap: () {
                          widget.onItemSelected(index);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MinorInfoPage(
                                  file: widget.file, minor: minor),
                            ),
                          );
                        },
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 200),
                          scale: widget.selectedIndex == index ? 0.95 : 1.0,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 6.0, horizontal: 8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white.withOpacity(0.6),
                              boxShadow: widget.selectedIndex == index
                                  ? [
                                      const BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 8,
                                        spreadRadius: 0.5,
                                      )
                                    ]
                                  : null,
                            ),
                            padding: const EdgeInsets.all(12.0),
                            child: _buildMinorItem(minor),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Pagination buttons (only if there's data)
          if (widget.children.isNotEmpty)
            Container(
              padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.hasPreviousPage)
                    _buildPaginationButton(
                      text: 'Anterior',
                      onPressed: widget.onPreviousPage,
                    ),
                  if (widget.hasPreviousPage && widget.hasNextPage)
                    const SizedBox(width: 20),
                  if (widget.hasNextPage)
                    _buildPaginationButton(
                      text: 'Siguiente',
                      onPressed: widget.onNextPage,
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPaginationButton({
    required String text,
    required Function() onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4B8DAF),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 3,
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildMinorItem(Minor minor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Icons.child_care,
          color: Color(0xFF065591),
          size: 32,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ID: ${minor.minorId}',
                style: TextStyle(
                  color: const Color(0xFF065591),
                  fontSize: widget.screenWidth * 0.035,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Referencia: ${minor.reference}',
                style: TextStyle(
                  color: const Color(0xFF065591),
                  fontSize: widget.screenWidth * 0.03,
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.chevron_right, color: Color(0xFF065591)),
      ],
    );
  }
}
