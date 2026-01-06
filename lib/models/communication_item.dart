import 'package:flutter/material.dart';

class CommunicationItem {
  final String id;
  final String text;
  final IconData? icon; // nullable: may be null when using image
  final Color color;
  final String? imagePath; // local path to gallery image
  final bool isImage; // whether this item uses an image instead of an icon

  CommunicationItem({
    required this.id,
    required this.text,
    this.icon,
    required this.color,
    this.imagePath,
    this.isImage = false,
  });
}
