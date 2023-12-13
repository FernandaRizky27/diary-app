import 'package:diary_app/pages/home_page.dart';
import 'package:diary_app/pages/note_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}
class _MainPageState extends State<MainPage> {
  DateTime? selectedDate;
  final List<Widget> _children = [HomePage(), NotePage()];
  int currentIndex = 0;

  void onTapTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }
    @override
  void initState() {
    setState(() {
      selectedDate = DateTime.now();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (currentIndex == 0)
          ? AppBar(
            title: Center(child: Text('MyDiary', style: GoogleFonts.whisper(fontSize: 30),)),
            backgroundColor: Colors.pinkAccent,
            elevation: 0,
            ): PreferredSize(
              child: Container(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Center(
                  child: Text(
                    'Catatan',
                    style: GoogleFonts.anton(fontSize: 30),
                  ),
                ),
              )),
              preferredSize: Size.fromHeight(100)),
      body: _children[currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
              onPressed: () {
                onTapTapped(0);
              },
              icon: Icon(Icons.home_rounded)),
          SizedBox(
            width: 20,
          ),
          IconButton(
              onPressed: () {
                onTapTapped(1);
              },
              icon: Icon(Icons.list_rounded))
        ],
      )),
    );
  }
}
