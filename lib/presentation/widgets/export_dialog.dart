import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dauco/presentation/blocs/export_bloc.dart';
import 'package:dauco/domain/entities/minor.entity.dart';
import 'package:dauco/domain/entities/test.entity.dart';
import 'package:dauco/data/services/export_service.dart';

class ExportDialog extends StatefulWidget {
  final Minor? minor;
  final List<Minor>? minors;
  final List<Test>? tests;
  final String? title;
  final String? filterType;
  final String? filterValue;

  const ExportDialog({
    super.key,
    this.minor,
    this.minors,
    this.tests,
    this.title,
    this.filterType,
    this.filterValue,
  });

  @override
  State<ExportDialog> createState() => _ExportDialogState();
}

class _ExportDialogState extends State<ExportDialog> {
  ExportFormat _selectedFormat = ExportFormat.excel;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildFormatSelection(),
            const SizedBox(height: 32),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    String title = widget.title ?? 'Exportar Datos';

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 97, 135, 174),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.download,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: const Color.fromARGB(255, 43, 45, 66),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Selecciona el formato de exportación',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: const Color.fromARGB(255, 107, 114, 128),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _buildFormatSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Formato de Exportación',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(255, 43, 45, 66),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildFormatOption(
                ExportFormat.json,
                'JSON',
                'Formato de intercambio de datos JavaScript',
                Icons.code,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildFormatOption(
                ExportFormat.excel,
                'Excel',
                'Hojas de cálculo con múltiples pestañas',
                Icons.table_view,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFormatOption(
    ExportFormat format,
    String title,
    String description,
    IconData icon,
  ) {
    final isSelected = _selectedFormat == format;

    return GestureDetector(
      onTap: () => setState(() => _selectedFormat = format),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? const Color.fromARGB(255, 97, 135, 174)
                : const Color.fromARGB(255, 229, 231, 235),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? const Color.fromARGB(255, 97, 135, 174).withOpacity(0.05)
              : Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? const Color.fromARGB(255, 97, 135, 174)
                      : const Color.fromARGB(255, 107, 114, 128),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? const Color.fromARGB(255, 97, 135, 174)
                        : const Color.fromARGB(255, 43, 45, 66),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color.fromARGB(255, 107, 114, 128),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions() {
    return BlocConsumer<ExportBloc, ExportState>(
      listener: (context, state) {
        if (state is ExportSuccess) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(state.message),
                  const SizedBox(height: 4),
                  Text(
                    'Archivo guardado en: \${state.filePath}',
                    style: const TextStyle(
                        fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
              backgroundColor: Colors.green,
              action: SnackBarAction(
                label: 'Copiar ruta',
                textColor: Colors.white,
                onPressed: () {
                  // Copy file path to clipboard
                },
              ),
            ),
          );
        } else if (state is ExportError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is ExportLoading;

        return Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : _exportAction,
                icon: isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(
                        Icons.download,
                        color: Colors.white,
                      ),
                label: Text(
                  isLoading ? 'Exportando...' : 'Exportar',
                  style: const TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 97, 135, 174),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _exportAction() {
    List<Minor> minorsToExport = widget.minors ?? [];

    print('🔍 EXPORT DIALOG: Exporting ${minorsToExport.length} minors');
    print(
        '🔍 MINOR IDS TO EXPORT: ${minorsToExport.map((m) => m.minorId).toList()}');

    // Use role-based export for multiple minors or filtered exports
    if (minorsToExport.isNotEmpty) {
      context.read<ExportBloc>().add(
            ExportWithRoleValidationEvent(
              minors: minorsToExport,
              format: _selectedFormat,
              filterType: widget.filterType,
              filterValue: widget.filterValue,
            ),
          );
    } else if (widget.minor != null) {
      // Single minor export still uses the individual method
      context.read<ExportBloc>().add(
            ExportSingleMinorEvent(
              minor: widget.minor!,
              tests: widget.tests,
              format: _selectedFormat,
            ),
          );
    }
  }
}
