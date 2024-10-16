import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        ),
      
      body: Container(
        
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.all(25),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //dark mode
            const Text("Dark Mode", style: TextStyle(fontWeight: FontWeight.bold),),


            //switch
            CupertinoSwitch(value: false, 
            onChanged: (value) {})
          ],
          ),
      ),
    );
  }
}