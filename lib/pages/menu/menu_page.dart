import 'package:cafeteria_instituto/components/navbar/custom_navbar.dart';
import 'package:cafeteria_instituto/widgets/menu/menu_item.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MenuPage extends StatefulWidget {
  final String? category;
  final User user = FirebaseAuth.instance.currentUser!;
  MenuPage({super.key, this.category});

  @override
  State createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String? selectedCategory;
  final List<String> categories = ['Cafe', 'Bebidas', 'Bocadillos', 'Snacks', 'Bolleria'];
  final List<String> imgList = [
    'assets/images/img1.png',
    'assets/images/img2.png',
    'assets/images/img3.png',
  ];
  TextEditingController searchController = TextEditingController();
  late Future<List<String>> categoriesFuture;

  @override
  void initState() {
    super.initState();

    selectedCategory = widget.category ?? categories.first;
  }

  Future<List<DocumentSnapshot>> getItems(String category) async {
    var snapshot = await FirebaseFirestore.instance.collection('Productos').doc('tipos').collection(category).get();
    return snapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 67, 77, 69),
        title: const Text(
          'Menú Cafetería',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sección de búsqueda
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Buscar productos',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  // Manejar la lógica de búsqueda aquí
                },
              ),
            ),
          ),
          // Sección del carrusel
          Container(
            height: 200,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFF434D45),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 200.0,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  viewportFraction: 1.0,
                  enableInfiniteScroll: true,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                  pageSnapping: true,
                  reverse: false,
                  scrollPhysics: const BouncingScrollPhysics(),
                ),
                items: imgList.map((img) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Image.asset(
                        img,
                        fit: BoxFit.cover,
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ),
          // Sección del menú de categorías
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedCategory == categories[index] ? const Color.fromRGBO(4, 94, 59, 0.733) : Colors.grey,
                      shape: RoundedRectangleBorder(
                        // Agregar bordes redondeados aquí
                        borderRadius: BorderRadius.circular(10), // Ajustar el valor del radio según tus necesidades
                      ),
                      elevation: 1, // Agregar sombra aquí
                    ),
                    onPressed: () {
                      setState(() {
                        selectedCategory = categories[index];
                      });
                    },
                    child: Text(
                      categories[index],
                      style: TextStyle(
                        color: selectedCategory == categories[index] ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Sección del grid de ítems
          Expanded(
            child: FutureBuilder<List<DocumentSnapshot>>(
              future: getItems(selectedCategory!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Padding(
                    // Agregar Padding aquí
                    padding: const EdgeInsets.all(16.0), // Ajustar el valor del padding según tus necesidades
                    child: GridView.builder(
                      physics: const ScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 4 / 6,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        final itemData = snapshot.data![index].data() as Map<String, dynamic>;
                        return MenuItem(
                          name: itemData['nombre'] ?? 'Nombre no disponible',
                          price: (itemData['precio'] as num?)?.toDouble(),
                          imageUrl: itemData['image'] as String?,
                          isFavorite: itemData['isFavorite'] as bool? ?? false, // Si es null, se asigna false
                          toggleFavorite: () {
                            final user = FirebaseAuth.instance.currentUser;
                            if (user != null) {
                              FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(user.uid)
                                  .collection('favoritos')
                                  .add({
                                    'nombre': itemData['nombre'],
                                    'precio': itemData['precio'],
                                    'image': itemData['image'],
                                    'isFavorite': true, // Asume que el producto es un favorito cuando se añade
                                    // Añade cualquier otro campo que necesites
                                  })
                                  .then((value) => Fluttertoast.showToast(msg: 'Producto añadido a favoritos'))
                                  .catchError((error) => Fluttertoast.showToast(msg: 'Error al añadir el producto a favoritos: $error'));
                            } else {
                              Fluttertoast.showToast(msg: 'Necesitas iniciar sesión para añadir productos a favoritos');
                            }
                          },

                          addToCart: () {
                            // Lógica para añadir al carrito
                            final user = FirebaseAuth.instance.currentUser;
                            if (user != null) {
                              FirebaseFirestore.instance
                                  .collection('Carrito')
                                  .doc(user.uid)
                                  .collection('Productos')
                                  .add({
                                    'nombre': itemData['nombre'],
                                    'precio': itemData['precio'],
                                    'image': itemData['image'],
                                    'isFavorite': itemData['isFavorite'],
                                    // Añade cualquier otro campo que necesites
                                  })
                                  .then((value) => Fluttertoast.showToast(msg: 'Producto añadido al carrito'))
                                  .catchError((error) => Fluttertoast.showToast(msg: 'Error al añadir el producto: $error'));
                            } else {
                              Fluttertoast.showToast(msg: 'Necesitas iniciar sesión para añadir productos al carrito');
                            }
                          },
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomNavBar(currentIndex: 0),
    );
  }
}
