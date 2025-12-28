import 'package:flutter/material.dart';
import 'package:proyecto_moviles/models/communication_item.dart';
import 'package:proyecto_moviles/services/tts_services.dart';
import 'package:proyecto_moviles/services/preferences.dart';
import 'package:proyecto_moviles/data/communication_data.dart';
import 'widgets/communication_card.dart';
import 'package:proyecto_moviles/views/text_input_view.dart'; 

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // CONFIGURACIÓN Y ESTADO
  // Definimos los servicios y las variables que controlan la navegación.
  final TTSService _ttsService = TTSService();
  final PreferencesService _prefsService = PreferencesService();

  int _currentIndex = 0; // Controla qué pestaña está activa visualmente
  late PageController _pageController; // Controla el movimiento de deslizamiento (swipe)
  
  List<String> _favoriteIds = []; 

  // Lista maestra de categorías que define el orden de las pestañas
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
    _loadFavorites();
    _pageController = PageController(initialPage: _currentIndex); 
  }

  @override
  void dispose() {
    _ttsService.stop();
    _pageController.dispose(); // Limpiamos el controlador para liberar memoria
    super.dispose();
  }

  // LÓGICA DE DATOS
  // Métodos para cargar favoritos y filtrar qué items mostrar según la categoría.
  Future<void> _loadFavorites() async {
    final favorites = await _prefsService.loadFavorites();
    setState(() {
      _favoriteIds = favorites;
    });
  }

  // Lógica principal para decidir qué lista de tarjetas mostrar.
  // Si es 'favoritos', filtramos la lista completa buscando los IDs guardados.
  // Si es cualquier otra, sacamos la lista directa del archivo de datos.
  List<CommunicationItem> _getCurrentItems(String categoryKey) {
    if (categoryKey == 'favoritos') {
      final allItems = CommunicationData.categories.values
          .expand((items) => items)
          .toList();
      
      // Mapeamos los IDs a objetos reales, manejando errores si un ID ya no existe
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
    return CommunicationData.categories[categoryKey] ?? [];
  }


  // VISTAS AUXILIARES Y ACCIONES
  // Constructores de widgets reutilizables y manejo de eventos.    
  void _onItemTap(CommunicationItem item) {
    _ttsService.speak(item.text);
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

  // Generador de la cuadrícula (Grid) de tarjetas para las categorías estándar
  Widget _buildCategoryView(String categoryKey) {
    final items = _getCurrentItems(categoryKey);
    
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        key: PageStorageKey(categoryKey), // Mantiene la posición del scroll al cambiar de pestaña
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.1,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return CommunicationCard(
            item: item,
            onTap: () => _onItemTap(item),
          );
        },
      ),
    );
  }

  // ESTRUCTURA PRINCIPAL 
  // Armado de la pantalla con AppBar, PageView (Cuerpo) y BottomNavigationBar.
  @override
  Widget build(BuildContext context) {
    final currentCategoryKey = _categories[_currentIndex]; 
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_getCategoryTitle(currentCategoryKey)),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      
      // Usamos PageView para permitir la navegación deslizando (Swipe)
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        // Generamos las páginas dinámicamente. Si es 'teclado', mostramos el input,
        // si no, construimos la cuadrícula correspondiente.
        children: _categories.map<Widget>((key) {
          if (key == 'teclado') {
            return TextInputPage(); 
          }
          return _buildCategoryView(key);
        }).toList(),
      ),
      
      // Barra de navegación inferior sincronizada con el PageView
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, 
        onTap: (index) {
          // Al tocar un botón, animamos el PageView hacia esa página
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favoritos'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Comida'),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_emotions), label: 'Emociones'),
          BottomNavigationBarItem(icon: Icon(Icons.health_and_safety), label: 'Necesidades'),
          BottomNavigationBarItem(icon: Icon(Icons.keyboard), label: 'Teclado'),
        ],
      ),
    );
  }
}