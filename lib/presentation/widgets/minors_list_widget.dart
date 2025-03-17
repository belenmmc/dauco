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
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: ListView.builder(
            itemCount: widget.children.length,
            itemBuilder: (context, index) {
              final minor = widget.children[index];
              return GestureDetector(
                onTap: () {
                  widget.onItemSelected(index);
                },
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 200),
                  scale: widget.selectedIndex == index ? 0.9 : 1,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white.withOpacity(0.53),
                      boxShadow: widget.selectedIndex == index
                          ? [
                              const BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ]
                          : [],
                    ),
                    padding: const EdgeInsets.all(12.0),
                    child: _buildMinorContainer(
                        minor, widget.screenWidth, context),
                  ),
                ),
              );
            },
          ),
        ),
        // Pagination buttons at the bottom
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Previous Page button
              if (widget.hasPreviousPage)
                ElevatedButton(
                  onPressed: widget.onPreviousPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4B8DAF),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Previous Page',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(width: 16), // Spacing between buttons
              // Next Page button
              if (widget.hasNextPage)
                ElevatedButton(
                  onPressed: widget.onNextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4B8DAF),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Next Page',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMinorContainer(
      Minor minor, double screenWidth, BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Icon(Icons.child_care, color: Color(0xFF065591), size: 30),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Id: ${minor.minorId}',
                  style: TextStyle(
                    color: const Color(0xFF065591),
                    fontSize: screenWidth * 0.02,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Referencia: ${minor.reference}',
                  style: TextStyle(
                    color: const Color(0xFF065591),
                    fontSize: screenWidth * 0.02,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MinorInfoPage(file: widget.file, minor: minor),
          ),
        );
      },
    );
  }
}
