import 'package:flutter/material.dart';
import 'package:proyecto_moviles/models/communication_item.dart';
import 'package:proyecto_moviles/services/tts_services.dart';
import 'package:proyecto_moviles/services/preferences.dart';
import 'package:proyecto_moviles/services/database_helper.dart';
import 'widgets/communication_card.dart';
import 'package:proyecto_moviles/views/text_input_view.dart';
import 'package:proyecto_moviles/views/add_card_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TTSService _ttsService = TTSService();
  final PreferencesService _prefsService = PreferencesService();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  int _currentIndex = 0;
  late PageController _pageController;
  
  List<String> _favoriteIds = [];
  Map<String, List<CommunicationItem>> _categoriesData = {};
  bool _isLoading = true;

  final List<String> _categories = [
    'favoritos', 
    'comida', 
    'emociones', 
    'necesidades',
    'teclado',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadFavorites();
    await _loadAllCategories();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _ttsService.stop();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadFavorites() async {
    final favorites = await _prefsService.loadFavorites();
    setState(() {
      _favoriteIds = favorites;
    });
  }

  Future<void> _loadAllCategories() async {
    final comida = await _dbHelper.getItemsByCategory('comida');
    final emociones = await _dbHelper.getItemsByCategory('emociones');
    final necesidades = await _dbHelper.getItemsByCategory('necesidades');
    
    setState(() {
      _categoriesData = {
        'comida': comida,
        'emociones': emociones,
        'necesidades': necesidades,
      };
    });
  }

  List<CommunicationItem> _getCurrentItems(String categoryKey) {
    if (categoryKey == 'favoritos') {
      final allItems = _categoriesData.values
          .expand((items) => items)
          .toList();
      
      return _favoriteIds
          .map((id) {
            try {
              return allItems.firstWhere((item) => item.id == id);
            } catch (e) {
              return null;
            }
          })
          .where((item) => item != null)
          .cast<CommunicationItem>()
          .toList();
    }
    return _categoriesData[categoryKey] ?? [];
  }

  void _onItemTap(CommunicationItem item) {
    _ttsService.speak(item.text);
  }

  void _onItemLongPress(CommunicationItem item, String category) async {
    if (category == 'favoritos') {
      // Opción para eliminar de favoritos
      final shouldRemove = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Quitar de favoritos'),
          content: Text('¿Deseas quitar "${item.text}" de tus favoritos?'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Quitar'),
            ),
          ],
        ),
      );

      if (shouldRemove == true) {
        setState(() {
          _favoriteIds.remove(item.id);
        });
        await _prefsService.saveFavorites(_favoriteIds);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Eliminado de favoritos'),
              backgroundColor: Colors.orange.shade700,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      }
    } else {
      // Opción para agregar a favoritos o eliminar si es custom
      final isCustom = await _dbHelper.isCustomItem(item.id);
      final isFavorite = _favoriteIds.contains(item.id);

      if (mounted) {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) => Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: Icon(
                    isFavorite ? Icons.star : Icons.star_border,
                    color: Colors.amber.shade700,
                  ),
                  title: Text(
                    isFavorite ? 'Quitar de favoritos' : 'Agregar a favoritos',
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    if (isFavorite) {
                      setState(() {
                        _favoriteIds.remove(item.id);
                      });
                    } else {
                      setState(() {
                        _favoriteIds.add(item.id);
                      });
                    }
                    await _prefsService.saveFavorites(_favoriteIds);
                    
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isFavorite ? 'Eliminado de favoritos' : 'Agregado a favoritos',
                          ),
                          backgroundColor: isFavorite 
                            ? Colors.orange.shade700 
                            : Colors.green.shade700,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    }
                  },
                ),
                if (isCustom)
                  ListTile(
                    leading: const Icon(Icons.delete, color: Colors.red),
                    title: const Text('Eliminar tarjeta'),
                    onTap: () async {
                      Navigator.pop(context);
                      final shouldDelete = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Eliminar tarjeta'),
                          content: Text(
                            '¿Estás seguro de eliminar "${item.text}"? Esta acción no se puede deshacer.',
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              child: const Text('Eliminar'),
                            ),
                          ],
                        ),
                      );

                      if (shouldDelete == true) {
                        await _dbHelper.deleteItem(item.id);
                        await _loadAllCategories();
                        
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Tarjeta eliminada'),
                              backgroundColor: Colors.red.shade700,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        }
                      }
                    },
                  ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      }
    }
  }

  String _getCategoryTitle(String categoryKey) {
    switch (categoryKey) {
      case 'favoritos': return 'Favoritos';
      case 'comida': return 'Comida y Bebida';
      case 'emociones': return 'Emociones';
      case 'necesidades': return 'Necesidades';
      case 'teclado': return 'Texto Libre';
      default: return 'Comunicación';
    }
  }

  Widget _buildCategoryView(String categoryKey) {
    final items = _getCurrentItems(categoryKey);
    
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No hay tarjetas en esta categoría',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Mantén presionada una tarjeta de otra categoría\npara agregarla a favoritos',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GridView.builder(
        key: PageStorageKey(categoryKey),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.1,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return CommunicationCard(
            item: item,
            onTap: () => _onItemTap(item),
            onLongPress: () => _onItemLongPress(item, categoryKey),
          );
        },
      ),
    );
  }

  void _navigateToAddCard() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddCardView(),
      ),
    );

    if (result == true) {
      await _loadAllCategories();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final currentCategoryKey = _categories[_currentIndex];
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_getCategoryTitle(currentCategoryKey)),
        centerTitle: true,
        backgroundColor: const Color(0xFF6A5AE0),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (currentCategoryKey != 'favoritos' && currentCategoryKey != 'teclado')
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: _navigateToAddCard,
              tooltip: 'Agregar tarjeta',
            ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _categories.map<Widget>((key) {
          if (key == 'teclado') {
            return const TextInputPage();
          }
          return _buildCategoryView(key);
        }).toList(),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF6A5AE0),
          unselectedItemColor: Colors.grey.shade500,
          selectedFontSize: 12,
          unselectedFontSize: 11,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: 'Favoritos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu),
              label: 'Comida',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_emotions),
              label: 'Emociones',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.health_and_safety),
              label: 'Necesidades',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.keyboard),
              label: 'Teclado',
            ),
          ],
        ),
      ),
    );
  }
}