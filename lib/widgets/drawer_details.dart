import 'package:flutter/material.dart';
import 'package:music_player/settings_page.dart';

class DrawerDetails extends StatefulWidget {
  const DrawerDetails({super.key});

  @override
  _DrawerDetailsState createState() => _DrawerDetailsState();
}

class _DrawerDetailsState extends State<DrawerDetails> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(227, 158, 183, 212),
      child: Column(
        children: [
          const DrawerHeader(
            child: Center(
              child: Icon(
                Icons.music_note,
                size: 40,
                color: Color.fromARGB(226, 238, 238, 239),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 25),
            child: ListTile(
              title: const Text("Home"),
              leading: const Icon(Icons.home),
              onTap: () => Navigator.pop(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 0),
            child: ListTile(
              title: const Text("Settings"),
              leading: const Icon(Icons.settings),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage(),
                ),
                );
                
              },
            ),
          ),
        ],
      ),
    );
  }
}
