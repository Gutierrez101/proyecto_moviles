import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyecto_moviles/models/communication_item.dart';
import 'package:proyecto_moviles/services/database_helper.dart';

class AddCardView extends StatefulWidget {
  final CommunicationItem? item;
  final String? category;

  const AddCardView({super.key, this.item, this.category});

  @override
  State<AddCardView> createState() => _AddCardViewState();
}

class _AddCardViewState extends State<AddCardView> {
  final TextEditingController _textController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  
  String _selectedCategory = 'comida';
  IconData _selectedIcon = Icons.chat_bubble;
  Color _selectedColor = const Color(0xFF6A5AE0);
  bool _useImage = false;
  String? _imagePath;

  final List<Map<String, dynamic>> _categories = [
    {'value': 'comida', 'label': 'Comida y Bebida'},
    {'value': 'emociones', 'label': 'Emociones'},
    {'value': 'necesidades', 'label': 'Necesidades'},
  ];

  final List<IconData> _availableIcons = [
    // Iconos estándar de Flutter
    Icons.chat_bubble,
    Icons.favorite,
    Icons.thumb_up,
    Icons.celebration,
    Icons.music_note,
    Icons.sports_soccer,
    Icons.book,
    Icons.videogame_asset,
    Icons.directions_car,
    Icons.pets,
    Icons.local_florist,
    Icons.beach_access,
    Icons.nightlight,
    Icons.wb_sunny,
    Icons.child_care,
    Icons.school,
    Icons.shopping_cart,
    Icons.camera_alt,
    Icons.headphones,
    Icons.palette,
    // Más iconos útiles
    Icons.restaurant,
    Icons.fastfood,
    Icons.local_pizza,
    Icons.icecream,
    Icons.local_bar,
    Icons.sentiment_very_satisfied,
    Icons.sentiment_satisfied,
    Icons.sentiment_dissatisfied,
    Icons.waving_hand,
    Icons.handshake,
    Icons.sports_gymnastics,
    Icons.fitness_center,
    Icons.sports_basketball,
    Icons.sports_baseball,
    Icons.flight,
    Icons.train,
    Icons.directions_boat,
    Icons.rocket_launch,
    Icons.car_rental,
  ];

  final List<Color> _availableColors = [
    const Color(0xFF6A5AE0), // Morado
    const Color(0xFFFF6B9D), // Rosa
    const Color(0xFF4CAF50), // Verde
    const Color(0xFFFF9800), // Naranja
    const Color(0xFF2196F3), // Azul
    const Color(0xFFF44336), // Rojo
    const Color(0xFF9C27B0), // Morado oscuro
    const Color(0xFF00BCD4), // Cyan
    const Color(0xFFFFEB3B), // Amarillo
    const Color(0xFF795548), // Café
    const Color(0xFF607D8B), // Gris azulado
    const Color(0xFFE91E63), // Pink
  ];

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      final it = widget.item!;
      _textController.text = it.text;
      _selectedIcon = it.icon ?? _selectedIcon;
      _selectedColor = it.color;
      _selectedCategory = widget.category ?? _selectedCategory;
      _useImage = it.isImage;
      _imagePath = it.imagePath;
    } else if (widget.category != null) {
      _selectedCategory = widget.category!;
    }
  }

  Future<void> _saveCard() async {
    final text = _textController.text.trim();
    
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Por favor escribe un texto para la tarjeta'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    final isEditing = widget.item != null;
    final id = isEditing ? widget.item!.id : 'custom_${DateTime.now().millisecondsSinceEpoch}';

    final newItem = CommunicationItem(
      id: id,
      text: text,
      icon: _useImage ? null : _selectedIcon,
      color: _selectedColor,
      imagePath: _useImage ? _imagePath : null,
      isImage: _useImage,
    );

    try {
      if (isEditing) {
        await _dbHelper.updateItem(newItem);
      } else {
        await _dbHelper.insertItem(newItem, _selectedCategory);
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.item != null ? '¡Tarjeta editada exitosamente!' : '¡Tarjeta creada exitosamente!'),
            backgroundColor: Colors.green.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar: $e'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      setState(() {
        _imagePath = picked.path;
        _useImage = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Tarjeta'),
        backgroundColor: const Color(0xFF6A5AE0),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Vista previa de la tarjeta
            Card(
              elevation: 6,
              color: _selectedColor.withOpacity(0.15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: _selectedColor, width: 3),
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                height: 180,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _useImage && _imagePath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            width: 70,
                            height: 70,
                            child: Image.file(
                              File(_imagePath!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Icon(
                          _selectedIcon,
                          size: 70,
                          color: _selectedColor,
                        ),
                    const SizedBox(height: 16),
                    Text(
                      _textController.text.isEmpty 
                        ? 'Vista previa' 
                        : _textController.text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _selectedColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Campo de texto
            Text(
              'Texto de la tarjeta',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Ej: Quiero jugar',
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF6A5AE0), width: 2),
                ),
              ),
              onChanged: (value) => setState(() {}),
            ),
            
            const SizedBox(height: 24),
            
            // Selector de categoría
            Text(
              'Categoría',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down),
                  items: _categories.map((cat) {
                    return DropdownMenuItem<String>(
                      value: cat['value'],
                      child: Text(cat['label']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    }
                  },
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Selector tipo: icono o imagen
            Text(
              'Tipo',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ChoiceChip(
                  label: const Text('Icono'),
                  selected: !_useImage,
                  onSelected: (v) {
                    setState(() {
                      _useImage = !v ? true : false;
                      if (!_useImage) _imagePath = null;
                    });
                  },
                ),
                const SizedBox(width: 12),
                ChoiceChip(
                  label: const Text('Imagen'),
                  selected: _useImage,
                  onSelected: (v) async {
                    if (v) {
                      await _pickImage();
                    } else {
                      setState(() {
                        _useImage = false;
                        _imagePath = null;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (!_useImage)
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: _availableIcons.length,
                  itemBuilder: (context, index) {
                    final icon = _availableIcons[index];
                    final isSelected = icon == _selectedIcon;
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIcon = icon;
                        });
                      },
                      child: Container(
                        width: 64,
                        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected 
                            ? _selectedColor.withOpacity(0.2) 
                            : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? _selectedColor : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Icon(
                          icon,
                          size: 32,
                          color: isSelected ? _selectedColor : Colors.grey.shade600,
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Seleccionar de galería'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A5AE0),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_imagePath != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(_imagePath!),
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                      ),
                    ),
                ],
              ),
            
            const SizedBox(height: 24),
            
            // Selector de color
            Text(
              'Color',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _availableColors.map((color) {
                final isSelected = color == _selectedColor;
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = color;
                    });
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.transparent,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 28)
                      : null,
                  ),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 40),
            
            // Botón guardar
            ElevatedButton(
              onPressed: _saveCard,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A5AE0),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
              child: const Text(
                'CREAR TARJETA',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}