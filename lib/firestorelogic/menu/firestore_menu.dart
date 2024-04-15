import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreMenu extends StatefulWidget {
  final String category;

  const FirestoreMenu({super.key, required this.category});

  @override
  _FirestoreMenuState createState() => _FirestoreMenuState();
}

class _FirestoreMenuState extends State<FirestoreMenu> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('Productos').doc('tipos').collection(widget.category).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No hay elementos disponibles'));
        }

        final menuItems = snapshot.data!.docs;
        return ListView.builder(
          itemCount: menuItems.length,
          itemBuilder: (context, index) => _buildMenuItem(menuItems[index]),
        );
      },
    );
  }

  Widget _buildMenuItem(QueryDocumentSnapshot item) {
    final itemData = item.data() as Map<String, dynamic>;
    final name = itemData['nombre'] ?? 'Nombre no disponible';
    final price = (itemData['precio'] as num?)?.toDouble();
    //final imageUrl = itemData['image'] as String?;

    return GestureDetector(
      onTap: () {
        // Aquí puedes manejar la acción de seleccionar un producto
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: ListTile(
          // leading: imageUrl != null ? Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover) : null,
          title: Text(name),
          subtitle: price != null ? Text('€${price.toStringAsFixed(2)}') : null,
          trailing: IconButton(
            icon: const Icon(Icons.add_shopping_cart),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
