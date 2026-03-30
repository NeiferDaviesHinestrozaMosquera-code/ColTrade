import 'package:flutter/material.dart';

/// Subscription plan tier identifiers.
enum PlanTier { free, pro, pymes, empresarial }

/// Pure domain entity – no Flutter dependencies except Color/IconData
/// because these are purely presentational constants tightly coupled to data.
class SubscriptionPlan {
  final PlanTier tier;
  final String id;
  final String name;
  final String tagline;
  final String price;
  final String period;
  final IconData icon;
  final List<Color> gradientColors;
  final Color accentColor;
  final List<String> features;
  final bool isPopular;
  final bool isEnterprise;

  const SubscriptionPlan({
    required this.tier,
    required this.id,
    required this.name,
    required this.tagline,
    required this.price,
    required this.period,
    required this.icon,
    required this.gradientColors,
    required this.accentColor,
    required this.features,
    this.isPopular = false,
    this.isEnterprise = false,
  });
}
