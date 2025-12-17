import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dauco/domain/usecases/export_minor_use_case.dart';
import 'package:dauco/domain/usecases/get_all_minors_for_export_use_case.dart';
import 'package:dauco/domain/entities/minor.entity.dart';
import 'package:dauco/domain/entities/test.entity.dart';
import 'package:dauco/data/services/export_service.dart';

// Events
abstract class ExportEvent {}

class ExportSingleMinorEvent extends ExportEvent {
  final Minor minor;
  final List<Test>? tests;
  final ExportFormat format;

  ExportSingleMinorEvent({
    required this.minor,
    this.tests,
    this.format = ExportFormat.excel,
  });
}

class ExportMultipleMinorsEvent extends ExportEvent {
  final List<Minor> minors;
  final ExportFormat format;
  final String title;

  ExportMultipleMinorsEvent({
    required this.minors,
    this.format = ExportFormat.excel,
    this.title = 'Reporte de Menores',
  });
}

class ExportFilteredReportEvent extends ExportEvent {
  final List<Minor> minors;
  final String filterType;
  final String filterValue;
  final ExportFormat format;

  ExportFilteredReportEvent({
    required this.minors,
    required this.filterType,
    required this.filterValue,
    this.format = ExportFormat.excel,
  });
}

class ExportWithRoleValidationEvent extends ExportEvent {
  final List<Minor> minors;
  final ExportFormat format;
  final String? filterType;
  final String? filterValue;

  ExportWithRoleValidationEvent({
    required this.minors,
    this.format = ExportFormat.excel,
    this.filterType,
    this.filterValue,
  });
}

// States
abstract class ExportState {}

class ExportInitial extends ExportState {}

class ExportLoading extends ExportState {}

class ExportSuccess extends ExportState {
  final String filePath;
  final String message;

  ExportSuccess({required this.filePath, required this.message});
}

class ExportError extends ExportState {
  final String error;

  ExportError({required this.error});
}

class ExportRoleError extends ExportState {
  final String roleMessage;

  ExportRoleError({required this.roleMessage});
}

// BLoC
class ExportBloc extends Bloc<ExportEvent, ExportState> {
  final ExportMinorUseCase exportMinorUseCase;
  final GetAllMinorsForExportUseCase getAllMinorsForExportUseCase;

  ExportBloc({
    required this.exportMinorUseCase,
    required this.getAllMinorsForExportUseCase,
  }) : super(ExportInitial()) {
    on<ExportSingleMinorEvent>(_onExportSingleMinor);
    on<ExportMultipleMinorsEvent>(_onExportMultipleMinors);
    on<ExportFilteredReportEvent>(_onExportFilteredReport);
    on<ExportWithRoleValidationEvent>(_onExportWithRoleValidation);
  }

  Future<void> _onExportSingleMinor(
    ExportSingleMinorEvent event,
    Emitter<ExportState> emit,
  ) async {
    emit(ExportLoading());
    try {
      final filePath = await exportMinorUseCase.exportSingleMinor(
        event.minor,
        tests: event.tests,
        format: event.format,
      );

      emit(ExportSuccess(
        filePath: filePath,
        message: 'Archivo guardado exitosamente',
      ));
    } catch (e) {
      emit(ExportError(error: 'Error al exportar: $e'));
    }
  }

  Future<void> _onExportMultipleMinors(
    ExportMultipleMinorsEvent event,
    Emitter<ExportState> emit,
  ) async {
    emit(ExportLoading());
    try {
      final filePath = await exportMinorUseCase.exportMultipleMinors(
        event.minors,
        format: event.format,
        title: event.title,
      );

      emit(ExportSuccess(
        filePath: filePath,
        message:
            'Reporte de ${event.minors.length} menores guardado exitosamente',
      ));
    } catch (e) {
      emit(ExportError(error: 'Error al exportar: $e'));
    }
  }

  Future<void> _onExportFilteredReport(
    ExportFilteredReportEvent event,
    Emitter<ExportState> emit,
  ) async {
    emit(ExportLoading());
    try {
      final filePath = await exportMinorUseCase.exportFilteredReport(
        event.minors,
        event.filterType,
        event.filterValue,
        format: event.format,
      );

      emit(ExportSuccess(
        filePath: filePath,
        message: 'Reporte filtrado guardado exitosamente',
      ));
    } catch (e) {
      emit(ExportError(error: 'Error al exportar: $e'));
    }
  }

  Future<void> _onExportWithRoleValidation(
    ExportWithRoleValidationEvent event,
    Emitter<ExportState> emit,
  ) async {
    emit(ExportLoading());
    try {
      List<Minor> minorsToExport;

      // If no filter is applied, get ALL minors for export (not just the paginated ones)
      if (event.filterType == null || event.filterValue == null) {
        minorsToExport = await getAllMinorsForExportUseCase.execute();
      } else {
        // For filtered exports, use the provided filtered list
        minorsToExport = event.minors;
      }

      final filePath = await exportMinorUseCase.exportWithRoleValidation(
        minorsToExport,
        format: event.format,
        filterType: event.filterType,
        filterValue: event.filterValue,
      );

      String message;
      if (event.filterType != null && event.filterValue != null) {
        message = 'Reporte filtrado con tests guardado exitosamente';
      } else {
        message = 'Reporte completo con tests guardado exitosamente';
      }

      emit(ExportSuccess(
        filePath: filePath,
        message: message,
      ));
    } catch (e) {
      // Check if it's a role validation error
      if (e.toString().contains('Como administrador debe aplicar filtros') ||
          e.toString().contains('Sin permisos')) {
        emit(ExportRoleError(roleMessage: e.toString()));
      } else {
        emit(ExportError(error: 'Error al exportar: $e'));
      }
    }
  }
}
