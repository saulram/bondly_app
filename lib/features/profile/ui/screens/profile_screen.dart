import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  static String route = "/profileScreen";

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber
    );
  }

}