import 'package:flutter/material.dart';

class FitraItemModel {
  final String id;
  final String nameKey;
  final double pricePerPerson;
  final IconData icon;

  const FitraItemModel({
    required this.id,
    required this.nameKey,
    required this.pricePerPerson,
    required this.icon,
  });
}

// Current rates in Bangladesh (approximate for 2024/2025)
const List<FitraItemModel> defaultFitraItems = [
  FitraItemModel(
    id: 'wheat',
    nameKey: 'zakatFitraWheat',
    pricePerPerson: 115.0, // Standard minimum
    icon: Icons.grass_rounded,
  ),
  FitraItemModel(
    id: 'barley',
    nameKey: 'zakatFitraBarley',
    pricePerPerson: 400.0,
    icon: Icons.grain_rounded,
  ),
  FitraItemModel(
    id: 'dates',
    nameKey: 'zakatFitraDates',
    pricePerPerson: 2100.0,
    icon: Icons.spa_rounded,
  ),
  FitraItemModel(
    id: 'raisins',
    nameKey: 'zakatFitraRaisins',
    pricePerPerson: 2700.0,
    icon: Icons.auto_awesome_mosaic_rounded,
  ),
  FitraItemModel(
    id: 'cheese',
    nameKey: 'zakatFitraCheese',
    pricePerPerson: 3000.0,
    icon: Icons.bakery_dining_rounded,
  ),
];
