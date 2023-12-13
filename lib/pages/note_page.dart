import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final CollectionReference _catatan =
      FirebaseFirestore.instance.collection('catatan');

  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _titleController.text = documentSnapshot['title'];
      _contentController.text = documentSnapshot['content'].toString();
    }
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            content: SingleChildScrollView(
                child: Center(
              child: Column(
                children: [
                  TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Catatan'),
                ),
                TextField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    labelText: 'Detail',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                  ),
                  child: Text(action == 'create' ? 'Create' : 'Update'),
                  onPressed: () async {
                    final String? title = _titleController.text;
                    final String? content = _contentController.text;
                    if (title != null && content != null) {
                      if (action == 'create') {
                        // Persist a new product to Firestore
                        await _catatan
                            .add({"title": title, "content": content});
                      }

                      if (action == 'update') {
                        // Update the product
                        await _catatan
                            .doc(documentSnapshot!.id)
                            .update({"title": title, "content": content});
                      }

                      // Clear the text fields
                      _titleController.text = '';
                      _contentController.text = '';

                      // Hide the bottom sheet
                      if (!context.mounted) return;
                      Navigator.of(context).pop();
                    }
                  },
                )
                ],
              ),
            )),
          );
        });
  }

  Future<void> _deleteProduct(String catatanId) async {
    await _catatan.doc(catatanId).delete();

    // Show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berhasil Menghapus catatan')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _catatan.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Card(
                  elevation: 10,
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(documentSnapshot['title']),
                    subtitle: Text(documentSnapshot['content']),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () =>
                                  _createOrUpdate(documentSnapshot)),
                          IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  _deleteProduct(documentSnapshot.id)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent,
        onPressed: () => _createOrUpdate(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
