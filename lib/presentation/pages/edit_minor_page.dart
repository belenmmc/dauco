import 'package:dauco/dependencyInjection/dependency_injection.dart';
import 'package:dauco/domain/entities/minor.entity.dart';
import 'package:dauco/domain/usecases/delete_minor_use_case.dart';
import 'package:dauco/domain/usecases/get_all_users_use_case.dart';
import 'package:dauco/domain/usecases/update_minor_use_case.dart';
import 'package:dauco/presentation/blocs/delete_minor_bloc.dart';
import 'package:dauco/presentation/blocs/get_all_users_bloc.dart' as users_bloc;
import 'package:dauco/presentation/blocs/update_minor_bloc.dart';
import 'package:dauco/presentation/widgets/app_background.dart';
import 'package:dauco/presentation/widgets/edit_minor_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

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
        BlocProvider(
          create: (_) => users_bloc.GetAllUsersBloc(
            getAllUsersUseCase: appInjector.get<GetAllUsersUseCase>(),
          )..add(users_bloc.GetEvent()),
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
        child: AppScaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Editar Menor',
                style: GoogleFonts.inter(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 55, 57, 82)),
              ),
            ),
            automaticallyImplyLeading: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
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
