import 'package:dauco/dependencyInjection/dependency_injection.dart';
import 'package:dauco/domain/entities/test.entity.dart';
import 'package:dauco/domain/usecases/get_all_items_use_case.dart';
import 'package:dauco/presentation/blocs/get_items_bloc.dart';
import 'package:dauco/presentation/widgets/app_background.dart';
import 'package:dauco/presentation/widgets/test_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class TestInfoPage extends StatefulWidget {
  final Test test;

  const TestInfoPage({super.key, required this.test});

  @override
  _TestInfoPageState createState() => _TestInfoPageState();
}

class _TestInfoPageState extends State<TestInfoPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetItemsBloc(
        getItemsUseCase: appInjector.get<GetAllItemsUseCase>(),
      )..add(GetEvent(widget.test.testId)),
      child: AppScaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Información del Test',
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
        body: BlocListener<GetItemsBloc, GetItemsState>(
          listener: (context, state) {
            if (state is GetItemsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${state.error}'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
          child: BlocBuilder<GetItemsBloc, GetItemsState>(
            builder: (context, state) {
              if (state is GetItemsLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is GetItemsSuccess) {
                return TestInfoWidget(test: widget.test, items: state.items);
              } else {
                return Center(child: Text('No items available'));
              }
            },
          ),
        ),
      ),
    );
  }
}
