import 'package:dauco/data/services/import_service.dart';
import 'package:dauco/dependencyInjection/dependency_injection.dart';
import 'package:dauco/domain/entities/imported_user.entity.dart';
import 'package:dauco/domain/usecases/import_users_use_case.dart';
import 'package:dauco/presentation/blocs/import_users_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImportedUsersPage extends StatefulWidget {
  const ImportedUsersPage({super.key});

  @override
  ImportedUsersPageState createState() => ImportedUsersPageState();
}

class ImportedUsersPageState extends State<ImportedUsersPage> {
  List<ImportedUser> users = []; // Define the users variable

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ImportUsersBloc(
            importUsersUseCase: appInjector.get<ImportUsersUseCase>()),
        child: Scaffold(
          appBar: AppBar(
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(120.0),
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 720,
                        child: Container(
                          height: 74,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.menu, color: Colors.grey),
                              SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Search',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(28),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[100],
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.search),
                                onPressed: () {
                                  print('Search button pressed');
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 58),
                      IconButton(
                        icon: Icon(
                          Icons.filter_alt_outlined,
                          size: 60,
                        ),
                        onPressed: () {
                          print('Share button pressed');
                        },
                      ),
                      const SizedBox(width: 438),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 40),
                          elevation: 15,
                        ),
                        onPressed: () {
                          print('Export button pressed');
                        },
                        child: Text('Export'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              ImportedUser user = users[index];
              return InkWell(
                onTap: () {
                  print('Tapped on ${user.name}');
                },
                child: Card(
                  margin: const EdgeInsets.all(8.0),
                  elevation: 5,
                  child: Container(
                    padding:
                        EdgeInsets.all(16.0), // Espacio dentro de la tarjeta
                    height:
                        125, // Altura personalizada para hacer la tarjeta más grande
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Centra horizontalmente
                      children: [
                        Icon(
                          Icons.abc,
                          color: Colors.blue,
                          size: 100, // Tamaño del ícono
                        ),
                        SizedBox(
                            width: 16), // Espacio entre el ícono y el texto
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment
                                .center, // Centra verticalmente
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name,
                                style: TextStyle(
                                  fontSize: 16, // Tamaño de texto más grande
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                user.name,
                                style: TextStyle(fontSize: 16),
                                maxLines: 2,
                                overflow: TextOverflow
                                    .ellipsis, // Para que el texto largo se corte
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ));
  }
}
