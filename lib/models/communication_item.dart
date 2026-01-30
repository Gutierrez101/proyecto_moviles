import 'package:flutter/material.dart';

class CommunicationItem {
  final String id;
  final String text;
  final IconData? icon;
  final Color color;
  final String? imagePath; // imagen local
  final bool isImage; // verificar si es imagen o icono

  CommunicationItem({
    required this.id,
    required this.text,
    this.icon,
    required this.color,
    this.imagePath,
    this.isImage = false,
  });
}
