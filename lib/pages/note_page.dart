import 'package:diary_app/data/database.dart';
import 'package:flutter/material.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final AppDatabase database = AppDatabase();
  TextEditingController noteContent = TextEditingController();
  Future insert(String title) async {
    DateTime now = DateTime.now();
    await database.into(database.note).insertReturning(
        NoteCompanion.insert(title: title, createdAt: now, updatedAt: now));
  }

  Future<List<NoteData>> getAll() {
    return database.select(database.note).get();
  }

  void noteDialog() {
    showDialog(
        context: context,
        builder: (BuildContext) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Text("Masukkan Catatanmu"),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: noteContent,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Ketik Catatan'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          insert(noteContent.text);
                          Navigator.of(context, rootNavigator: true)
                              .pop('dialog');
                          setState(() {});
                        },
                        child: Text('Simpan'))
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              elevation: 10,
              child: ListTile(
                  leading: Icon(Icons.donut_large),
                  title: Text('Perasaanku Hari Ini'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
                      IconButton(onPressed: () {}, icon: Icon(Icons.edit))
                    ],
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: IconButton(
                onPressed: () {
                  noteDialog();
                },
                icon: Icon(Icons.add),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
