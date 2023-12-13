import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime? selectedDate;
  final TextEditingController _titleDiaryController = TextEditingController();
  final TextEditingController _contentDiaryController = TextEditingController();
  final CollectionReference _catatan =
      FirebaseFirestore.instance.collection('diary');

  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _titleDiaryController.text = documentSnapshot['title'];
      _contentDiaryController.text = documentSnapshot['content'];
    }
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                // prevent the soft keyboard from covering text fields
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _titleDiaryController,
                  decoration: const InputDecoration(labelText: 'Kamu Kenapa?'),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(selectedDate.toString()),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _contentDiaryController,
                  decoration: const InputDecoration(
                    labelText: 'Cerita Sini Yuk',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text(action == 'create' ? 'Create' : 'Update'),
                  onPressed: () async {
                    final String? title = _titleDiaryController.text;
                    final String? content = _contentDiaryController.text;
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
                      _titleDiaryController.text = '';
                      _contentDiaryController.text = '';

                      // Hide the bottom sheet
                      if (!context.mounted) return;
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
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
      appBar: CalendarAppBar(
        onDateChanged: (value) => setState(() => selectedDate = value),
        firstDate: DateTime.now().subtract(Duration(days: 1000)),
        lastDate: DateTime.now(),
        backButton: false,
        locale: 'id',
        accent: Colors.pinkAccent,
      ),
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
                          // Tombol untuk edit product
                          IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () =>
                                  _createOrUpdate(documentSnapshot)),
                          // Tombol untuk menghapus product
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
