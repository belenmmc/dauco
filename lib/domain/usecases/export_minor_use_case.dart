import 'package:dauco/data/services/export_service.dart';
import 'package:dauco/domain/entities/minor.entity.dart';
import 'package:dauco/domain/entities/test.entity.dart';

class ExportMinorUseCase {
  final ExportService _exportService = ExportService();

  /// Role-based export with automatic validation and tests inclusion
  Future<String> exportWithRoleValidation(List<Minor> minors,
      {ExportFormat format = ExportFormat.excel,
      String? filterType,
      String? filterValue}) async {
    final content = await _exportService.exportWithRoleValidation(
      minors,
      format: format,
      filterType: filterType,
      filterValue: filterValue,
      includeTests: true,
    );

    // For Excel, the export service already saves the file and returns the path
    if (format == ExportFormat.excel) {
      return content; // This is already the file path
    }

    // For CSV/JSON, we need to save the content to a file
    String filename;
    String extension = format.name;
    if (minors.length == 1) {
      filename = _exportService.generateFilename(
          'dauco_info_${minors.first.minorId}',
          extension: extension);
    } else if (filterType != null && filterValue != null) {
      filename =
          _exportService.generateFilename('dauco_info', extension: extension);
    } else {
      filename =
          _exportService.generateFilename('dauco_info', extension: extension);
    }

    return await _exportService.saveToFile(content, filename, format);
  }

  /// Export a single minor's complete information
  Future<String> exportSingleMinor(Minor minor,
      {List<Test>? tests, ExportFormat format = ExportFormat.excel}) async {
    final content = await _exportService.exportSingleMinor(minor,
        tests: tests, format: format);

    // For Excel, the export service already saves the file and returns the path
    if (format == ExportFormat.excel) {
      return content; // This is already the file path
    }

    // For CSV/JSON, we need to save the content to a file
    String extension = format.name;
    final filename = _exportService
        .generateFilename('dauco_info_${minor.minorId}', extension: extension);
    return await _exportService.saveToFile(content, filename, format);
  }

  /// Export multiple minors
  Future<String> exportMultipleMinors(List<Minor> minors,
      {ExportFormat format = ExportFormat.excel,
      String title = 'Reporte de Menores'}) async {
    final content = await _exportService.exportMultipleMinors(minors,
        format: format, title: title);

    // For Excel, the export service already saves the file and returns the path
    if (format == ExportFormat.excel) {
      return content; // This is already the file path
    }

    // For CSV/JSON, we need to save the content to a file
    String extension = format.name;
    final filename =
        _exportService.generateFilename('dauco_info', extension: extension);
    return await _exportService.saveToFile(content, filename, format);
  }

  /// Export filtered minors report
  Future<String> exportFilteredReport(
      List<Minor> minors, String filterType, String filterValue,
      {ExportFormat format = ExportFormat.excel}) async {
    final content = await _exportService
        .exportFilteredReport(minors, filterType, filterValue, format: format);

    // For Excel, the export service already saves the file and returns the path
    if (format == ExportFormat.excel) {
      return content; // This is already the file path
    }

    // For CSV/JSON, we need to save the content to a file
    String extension = format.name;
    final filename =
        _exportService.generateFilename('dauco_info', extension: extension);
    return await _exportService.saveToFile(content, filename, format);
  }

  /// Export content without saving to file (for preview)
  Future<String> generateExportContent(Minor minor,
      {List<Test>? tests, ExportFormat format = ExportFormat.excel}) async {
    return await _exportService.exportSingleMinor(minor,
        tests: tests, format: format);
  }
}
