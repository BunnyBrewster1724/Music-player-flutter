// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music_player/playlist_page.dart';
import 'dart:ui' as ui; 


class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  WidgetStateProperty<Color> getColor(Color color, Color colorOnPressed) {
    getColor(Set<WidgetState> states) {
      if (states.contains(WidgetState.pressed)) {
        return colorOnPressed;
      }
      return color;
    }
    return WidgetStateProperty.resolveWith(getColor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Positioned.fill(
          //   child: Image.asset(
          //     'assets/Archive_6_copy.jpg',
          //     fit: BoxFit.cover,
          //   ),
          // ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xE539597E), Color(0xE539597E)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/logo.svg',
                  height: 150,
                ),
                const SizedBox(height: 20),
                const Text(
                  'WELCOME',
                  style: TextStyle(
                    fontFamily: 'Alegreya',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Enhance Your Day with\nSpiritual Reflection',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'EBGaramond',
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                Transform.translate(
                  offset: const ui.Offset(0.0, 90),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePage()),
                      );
                    },
                    style: ButtonStyle(
                      overlayColor: getColor(Colors.transparent, Colors.teal.withOpacity(0.3)),
                      padding: WidgetStateProperty.all(
                        const EdgeInsets.symmetric(horizontal: 40.0, vertical: 12.0),
                      ),
                      backgroundColor: WidgetStateProperty.all(const Color(0xFF597EA9)),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Start Chanting',
                      style: TextStyle(
                        fontFamily: 'Alegreya',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}