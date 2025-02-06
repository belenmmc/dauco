import 'package:flutter/material.dart';

class DataPage extends StatelessWidget {
  const DataPage({super.key});

  // Simulación de los productos obtenidos de la base de datos
  List<Product> getProducts() {
    return [
      Product(
          name: 'Product 1',
          price: 29.99,
          description: 'This is a description for product 1.'),
      Product(
          name: 'Product 2',
          price: 49.99,
          description: 'This is a description for product 2.'),
      Product(
          name: 'Product 3',
          price: 19.99,
          description: 'This is a description for product 3.'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<Product> products = getProducts(); // Obtenemos los productos

    return Scaffold(
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
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Centra los elementos horizontalmente
                        children: [
                          Icon(Icons.menu,
                              color: Colors.grey), // Icono del lado izquierdo
                          SizedBox(
                              width:
                                  8), // Espacio entre el icono y el campo de texto
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
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16), // Ajuste del padding
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 40),
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
        itemCount: products.length,
        itemBuilder: (context, index) {
          Product product = products[index];
          return InkWell(
            onTap: () {
              print('Tapped on ${product.name}');
            },
            child: Card(
              margin: const EdgeInsets.all(8.0),
              elevation: 5,
              child: Container(
                padding: EdgeInsets.all(16.0), // Espacio dentro de la tarjeta
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
                    SizedBox(width: 16), // Espacio entre el ícono y el texto
                    Expanded(
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center, // Centra verticalmente
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: TextStyle(
                              fontSize: 16, // Tamaño de texto más grande
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            product.description,
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
    );
  }
}

class Product {
  final String name;
  final double price;
  final String description;

  Product({
    required this.name,
    required this.price,
    required this.description,
  });
}
