import 'package:dauco/dependencyInjection/dependency_injection.dart';
import 'package:dauco/domain/entities/test.entity.dart';
import 'package:dauco/domain/usecases/get_items_use_case.dart';
import 'package:dauco/presentation/blocs/get_items_bloc.dart';
import 'package:dauco/presentation/widgets/test_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        getItemsUseCase: appInjector.get<GetItemsUseCase>(),
      ),
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 167, 168, 213),
        appBar: AppBar(
          title: Text('Información del Test',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          automaticallyImplyLeading: true,
          backgroundColor: Color.fromARGB(255, 167, 168, 213),
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
          child: TestInfoWidget(test: widget.test),
        ),
      ),
    );
  }
}
