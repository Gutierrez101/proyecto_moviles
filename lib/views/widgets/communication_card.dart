import 'package:flutter/material.dart';
import 'package:proyecto_moviles/models/communication_item.dart';
import 'dart:io';

class CommunicationCard extends StatelessWidget {
  final CommunicationItem item;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const CommunicationCard({
    super.key,
    required this.item,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: item.color.withOpacity(0.15),
      shadowColor: item.color.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: item.color, width: 2.5),
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(20),
        splashColor: item.color.withOpacity(0.3),
        highlightColor: item.color.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Preguntamos: ¿Es una imagen Y tiene una ruta válida?
              if (item.isImage && item.imagePath != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(item.imagePath!), // Cargamos la imagen desde el archivo
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    // Si falla cargar la imagen, mostramos un ícono roto
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.broken_image,
                          size: 64, color: item.color);
                    },
                  ),
                )
              else
                // Si no es imagen, mostramos el ícono normal
                Icon(
                  item.icon ?? Icons.help_outline, // Usamos un ícono por defecto si fuera null
                  size: 64,
                  color: item.color,
                ),

              const SizedBox(height: 12),
              Text(
                item.text,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: item.color,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}