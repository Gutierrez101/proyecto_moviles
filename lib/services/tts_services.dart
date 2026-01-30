import 'package:flutter_tts/flutter_tts.dart';
//Maneja la funcionalidad de Text-to-Speech
class TTSService {
  final FlutterTts _tts = FlutterTts();
  
  TTSService() {
    _initTTS();
  }

  Future<void> _initTTS() async {
    await _tts.setLanguage("es-ES");
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
  }

  //COnvierte texto en audio
  Future<void> speak(String text) async {
    await _tts.speak(text);
  }

  //Detener la reproduccion de voz
  Future<void> stop() async {
    await _tts.stop();
  }
}
