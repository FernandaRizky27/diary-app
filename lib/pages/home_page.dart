import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    decoration: InputDecoration(
                        hintText: 'Apa yang ada di pikiranmu?',
                        border: OutlineInputBorder()),
                  ),
                ],
              ),
            ), // inputan text
            Padding(
              padding: EdgeInsets.all(20),
              child: Card(
                elevation: 19,
                child: Expanded(
                    child: Container(
                  child: Center(
                    child: Text(style: TextStyle(fontSize: 25), 'hello'),
                  ),
                )),
              ),
            ) //output dari input text
          ],
        ),
      ),
    );
  }
}
