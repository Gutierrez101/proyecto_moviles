import 'package:flutter/material.dart';
// Importamos el servicio encargado de la síntesis de voz
import 'package:proyecto_moviles/services/tts_services.dart'; 

class TextInputPage extends StatefulWidget {
  const TextInputPage({super.key});

  @override
  State<TextInputPage> createState() => _TextInputPageState();
}

class _TextInputPageState extends State<TextInputPage> {
  // CONTROLADORES Y SERVICIOS
  // Inicializamos las herramientas para capturar el texto y producir el audio.
  // _textController: Nos permite leer y manipular lo que el usuario escribe.
  final TextEditingController _textController = TextEditingController();
  // _ttsService: La instancia que conecta con el motor de voz del dispositivo.
  final TTSService _ttsService = TTSService();


  // Funciones que manejan los eventos del usuario (hablar, borrar, limpiar memoria).
  void _speakText() {
    final text = _textController.text.trim(); // Quitamos espacios vacíos al inicio/final
    if (text.isNotEmpty) {
      _ttsService.speak(text);
      _textController.clear(); 
    }
  }
  
  void _clearText() {
    _textController.clear(); // Limpia manualmente el campo de texto
  }

  // Método vital para el rendimiento: libera la memoria del controlador cuando
  // el usuario cambia de pestaña o cierra esta vista.
  @override
  void dispose() {
    _textController.dispose(); 
    super.dispose();
  }


  // Estructura adaptativa que incluye el campo de entrada y el botón de acción.
  @override
  Widget build(BuildContext context) {
    // Usamos SingleChildScrollView para evitar errores de "pixel overflow"
    // cuando el teclado virtual sube y ocupa espacio en la pantalla.
    return SingleChildScrollView( 
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, // Estira los elementos a lo ancho
        children: <Widget>[
          
          // Campo de Texto Multilínea
          TextField(
            controller: _textController,
            decoration: InputDecoration(
              hintText: 'Escribe aquí la frase que quieres decir...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              // Botón "X" integrado para borrado rápido
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: _clearText,
              ),
            ),
            keyboardType: TextInputType.text,
            maxLines: 6, // Permitimos varias líneas para frases complejas
            minLines: 4,
          ),
          
          const SizedBox(height: 20), // Espacio separador
          
          // Botón Principal "DECIR"
          ElevatedButton.icon(
            icon: const Icon(Icons.volume_up, size: 28),
            label: const Text(
              'DECIR',
              style: TextStyle(fontSize: 20),
            ),
            // Estilo personalizado para que sea un botón grande y accesible
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 60), 
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onPressed: _speakText,
          ),
        ],
      ),
    );
  }
}