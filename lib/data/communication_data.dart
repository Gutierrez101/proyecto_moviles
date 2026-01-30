import 'package:flutter/material.dart';
import 'package:proyecto_moviles/models/communication_item.dart';

class CommunicationData {
  // Mapa principal que contiene todo el vocabulario de la aplicación.
  // Organiza los 'CommunicationItems' dentro de listas categorizadas 
  // (favoritos, comida, emociones, etc.) para fácil acceso desde la UI.
  static final Map<String, List<CommunicationItem>> categories = {
    'favoritos': [
      CommunicationItem(
        id: 'si',
        text: 'Sí',
        icon: Icons.check_circle,
        color: Colors.green,
      ),
      CommunicationItem(
        id: 'no',
        text: 'No',
        icon: Icons.cancel,
        color: Colors.red,
      ),
      CommunicationItem(
        id: 'duele',
        text: 'Me duele',
        icon: Icons.healing,
        color: Colors.orange,
      ),
      CommunicationItem(
        id: 'ayuda',
        text: 'Necesito ayuda',
        icon: Icons.pan_tool,
        color: Colors.purple,
      ),
    ],

    // Categoria Alimentacion
    'comida': [
      CommunicationItem(
        id: 'tengo_hambre',
        text: 'Tengo hambre',
        icon: Icons.restaurant,
        color: Colors.brown,
      ),
      CommunicationItem(
        id: 'tengo_sed',
        text: 'Tengo sed',
        icon: Icons.local_drink,
        color: Colors.blue,
      ),
      CommunicationItem(
        id: 'agua',
        text: 'Quiero agua',
        icon: Icons.water_drop,
        color: Colors.lightBlue,
      ),
      CommunicationItem(
        id: 'fruta',
        text: 'Quiero fruta',
        icon: Icons.apple,
        color: Colors.red,
      ),
      CommunicationItem(
        id: 'leche',
        text: 'Quiero leche',
        icon: Icons.coffee,
        color: Colors.brown.shade300,
      ),
      CommunicationItem(
        id: 'terminé',
        text: 'Ya terminé',
        icon: Icons.done_all,
        color: Colors.green,
      ),
    ],

    // Categoria Emociones
    'emociones': [
      CommunicationItem(
        id: 'feliz',
        text: 'Estoy feliz',
        icon: Icons.sentiment_very_satisfied,
        color: Colors.yellow.shade700,
      ),
      CommunicationItem(
        id: 'triste',
        text: 'Estoy triste',
        icon: Icons.sentiment_dissatisfied,
        color: Colors.blue,
      ),
      CommunicationItem(
        id: 'enojado',
        text: 'Estoy enojado',
        icon: Icons.sentiment_very_dissatisfied,
        color: Colors.red,
      ),
      CommunicationItem(
        id: 'asustado',
        text: 'Tengo miedo',
        icon: Icons.sentiment_neutral,
        color: Colors.purple,
      ),
      CommunicationItem(
        id: 'cansado',
        text: 'Estoy cansado',
        icon: Icons.bedtime,
        color: Colors.indigo,
      ),
      CommunicationItem(
        id: 'aburrido',
        text: 'Estoy aburrido',
        icon: Icons.access_time,
        color: Colors.grey,
      ),
    ],

    //Categoria Necesidades basicas
    'necesidades': [
      CommunicationItem(
        id: 'baño',
        text: 'Quiero ir al baño',
        icon: Icons.wc,
        color: Colors.teal,
      ),
      CommunicationItem(
        id: 'dolor',
        text: 'Tengo dolor',
        icon: Icons.medical_services,
        color: Colors.red,
      ),
      CommunicationItem(
        id: 'calor',
        text: 'Tengo calor',
        icon: Icons.thermostat,
        color: Colors.orange,
      ),
      CommunicationItem(
        id: 'frio',
        text: 'Tengo frío',
        icon: Icons.ac_unit,
        color: Colors.lightBlue,
      ),
      CommunicationItem(
        id: 'sueño',
        text: 'Tengo sueño',
        icon: Icons.bed,
        color: Colors.indigo,
      ),
      CommunicationItem(
        id: 'descanso',
        text: 'Quiero descansar',
        icon: Icons.weekend,
        color: Colors.green,
      ),
    ],
  };
}