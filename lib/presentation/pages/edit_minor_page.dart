import 'package:dauco/dependencyInjection/dependency_injection.dart';
import 'package:dauco/domain/entities/minor.entity.dart';
import 'package:dauco/domain/usecases/delete_minor_use_case.dart';
import 'package:dauco/domain/usecases/update_minor_use_case.dart';
import 'package:dauco/presentation/blocs/delete_minor_bloc.dart';
import 'package:dauco/presentation/blocs/update_minor_bloc.dart';
import 'package:dauco/presentation/widgets/edit_minor_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditMinorPage extends StatelessWidget {
  final Minor minor;

  const EditMinorPage({super.key, required this.minor});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => UpdateMinorBloc(
            updateMinorUseCase: appInjector.get<UpdateMinorUseCase>(),
          ),
        ),
        BlocProvider(
          create: (_) => DeleteMinorBloc(
            deleteMinorUseCase: appInjector.get<DeleteMinorUseCase>(),
          ),
        ),
      ],
      child: BlocListener<DeleteMinorBloc, DeleteMinorState>(
        listener: (context, state) {
          if (state is DeleteMinorError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error al eliminar: ${state.error}')),
            );
          }
        },
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 167, 168, 213),
          appBar: AppBar(
            title: const Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Editar Menor',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 20),
                ],
              ),
            ),
            automaticallyImplyLeading: true,
            backgroundColor: Color.fromARGB(255, 167, 168, 213),
          ),
          body: EditMinorWidget(
            minor: minor,
            onSave: (Minor updatedMinor) {
              Navigator.pop(context, updatedMinor);
            },
          ),
        ),
      ),
    );
  }
}
