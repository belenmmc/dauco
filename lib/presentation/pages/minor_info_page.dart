import 'package:dauco/domain/entities/minor.entity.dart';
import 'package:dauco/presentation/widgets/minor_info_widget.dart';
import 'package:dauco/presentation/widgets/tests_list_widget.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dauco/dependencyInjection/dependency_injection.dart';
import 'package:dauco/domain/usecases/get_tests_use_case.dart';
import 'package:dauco/presentation/blocs/get_tests_bloc.dart';

class MinorInfoPage extends StatefulWidget {
  final Excel file;
  final Minor minor;

  const MinorInfoPage({super.key, required this.file, required this.minor});

  @override
  _MinorInfoPageState createState() => _MinorInfoPageState();
}

class _MinorInfoPageState extends State<MinorInfoPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetTestsBloc(
        getTestsUseCase: appInjector.get<GetTestsUseCase>(),
      ),
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 167, 168, 213),
        appBar: AppBar(
          title: Text(
              _currentIndex == 0 ? 'Información del Menor' : 'Lista de Tests',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          automaticallyImplyLeading: true,
          backgroundColor: Color.fromARGB(255, 167, 168, 213),
        ),
        body: BlocListener<GetTestsBloc, GetTestsState>(
          listener: (context, state) {
            if (state is GetTestsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${state.error}'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
          child: _buildBody(),
        ),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              backgroundColor: Color.fromARGB(255, 167, 168, 213),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              tooltip: _currentIndex == 0
                  ? 'Ver lista de tests'
                  : 'Volver a información del menor',
              child: Icon(
                  _currentIndex == 0 ? Icons.arrow_forward : Icons.arrow_back),
              onPressed: () {
                setState(() {
                  _currentIndex = (_currentIndex + 1) % 2;
                });

                if (_currentIndex == 1) {
                  context
                      .read<GetTestsBloc>()
                      .add(GetEvent(widget.file, widget.minor.minorId));
                }
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody() {
    return IndexedStack(
      index: _currentIndex,
      children: [
        MinorInfoWidget(minor: widget.minor),
        BlocBuilder<GetTestsBloc, GetTestsState>(
          builder: (context, state) {
            if (state is GetTestsLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is GetTestsSuccess) {
              if (state.tests.isEmpty) {
                return Center(
                    child: Text('No hay tests disponibles',
                        style: TextStyle(fontSize: 20)));
              }
              return TestsListWidget(tests: state.tests);
            } else if (state is GetTestsError) {
              return Center(child: Text('Error: ${state.error}'));
            }
            return Center(child: Text('No tests available'));
          },
        ),
      ],
    );
  }
}
