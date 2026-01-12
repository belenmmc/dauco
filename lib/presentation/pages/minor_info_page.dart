import 'package:dauco/domain/entities/minor.entity.dart';
import 'package:dauco/presentation/pages/edit_minor_page.dart';
import 'package:dauco/presentation/widgets/app_background.dart';
import 'package:dauco/presentation/widgets/circular_button_widget.dart';
import 'package:dauco/presentation/widgets/minor_info_widget.dart';
import 'package:dauco/presentation/widgets/tests_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dauco/dependencyInjection/dependency_injection.dart';
import 'package:dauco/domain/usecases/get_all_tests_use_case.dart';
import 'package:dauco/presentation/blocs/get_all_tests_bloc.dart';
import 'package:dauco/presentation/widgets/export_dialog.dart';
import 'package:dauco/presentation/blocs/export_bloc.dart';
import 'package:dauco/domain/usecases/export_minor_use_case.dart';
import 'package:dauco/domain/usecases/get_all_minors_for_export_use_case.dart';

class MinorInfoPage extends StatefulWidget {
  final Minor minor;
  final String role;

  const MinorInfoPage({super.key, required this.minor, required this.role});

  @override
  _MinorInfoPageState createState() => _MinorInfoPageState();
}

class _MinorInfoPageState extends State<MinorInfoPage> {
  int _currentIndex = 0;
  late Minor currentMinor;

  @override
  void initState() {
    super.initState();
    currentMinor = widget.minor;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetTestsBloc(
        getAllTestsUseCase: appInjector.get<GetAllTestsUseCase>(),
      )..add(GetEvent(currentMinor.minorId)),
      child: AppScaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          toolbarHeight: 65,
          title: Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _currentIndex == 0
                      ? 'Información del Menor'
                      : 'Lista de Tests',
                  style: GoogleFonts.inter(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 55, 57, 82)),
                ),
                const SizedBox(width: 20),
                if (widget.role == 'admin' && _currentIndex == 0)
                  CircularButtonWidget(
                    iconData: Icons.edit_outlined,
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditMinorPage(minor: currentMinor),
                        ),
                      );

                      if (result != null && result is Minor) {
                        setState(() {
                          currentMinor = result;
                        });
                      }
                      Navigator.pop(context, true);
                    },
                  ),
                if (_currentIndex == 0) const SizedBox(width: 10),
                if (_currentIndex == 0)
                  CircularButtonWidget(
                    iconData: Icons.download_outlined,
                    onPressed: _showExportDialog,
                  )
              ],
            ),
          ),
          automaticallyImplyLeading: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: BlocListener<GetTestsBloc, GetTestsState>(
          listener: (context, state) {
            if (state is GetTestsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Error al cargar los tests'),
                  backgroundColor: Color.fromARGB(255, 55, 57, 82),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
          child: SafeArea(
            child: Column(
              children: [
                Expanded(child: _buildBody()),
                _buildPaginationControls(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return IndexedStack(
      index: _currentIndex,
      children: [
        MinorInfoWidget(minor: currentMinor),
        BlocBuilder<GetTestsBloc, GetTestsState>(
          builder: (context, state) {
            if (state is GetTestsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GetTestsSuccess) {
              if (state.tests.isEmpty) {
                return const Center(
                  child: Text('No hay tests disponibles',
                      style: TextStyle(fontSize: 20)),
                );
              }
              return TestsListWidget(tests: state.tests);
            } else if (state is GetTestsError) {
              return Center(child: Text('Error: ${state.error}'));
            }
            return const Center(child: Text('No tests available'));
          },
        ),
      ],
    );
  }

  Widget _buildPaginationControls(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _PaginationButton(
            icon: Icons.arrow_back_ios_rounded,
            onPressed: _currentIndex == 1
                ? () => setState(() => _currentIndex = 0)
                : null,
            color: _currentIndex == 1
                ? const Color.fromARGB(255, 97, 135, 174)
                : const Color.fromARGB(255, 97, 135, 174).withOpacity(0.5),
          ),
          const SizedBox(width: 20),
          _PaginationButton(
            icon: Icons.arrow_forward_ios_rounded,
            onPressed: _currentIndex == 0
                ? () => setState(() => _currentIndex = 1)
                : null,
            color: _currentIndex == 0
                ? const Color.fromARGB(255, 97, 135, 174)
                : const Color.fromARGB(255, 97, 135, 174).withOpacity(0.5),
          ),
        ],
      ),
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => BlocProvider(
        create: (context) => ExportBloc(
          exportMinorUseCase: appInjector.get<ExportMinorUseCase>(),
          getAllMinorsForExportUseCase:
              appInjector.get<GetAllMinorsForExportUseCase>(),
        ),
        child: ExportDialog(
          minor: currentMinor,
        ),
      ),
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
