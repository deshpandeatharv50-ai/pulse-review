import 'package:flutter/material.dart';

/// ELEV8 demo healthcare organizations.
class HealthcareOrganization {
  final String id;
  final String name;
  final String type; // e.g. "Hospital Network", "Teaching Hospital", "Clinic"
  final String description;
  final Color accentColor;
  final IconData icon;
  final List<HealthcarePersona> personas;

  const HealthcareOrganization({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.accentColor,
    required this.icon,
    required this.personas,
  });

  static const List<HealthcareOrganization> all = [
    HealthcareOrganization(
      id: 'central-medical',
      name: 'Central Medical Group',
      type: 'Hospital Network',
      description: 'Multi-specialty network with integrated HR',
      accentColor: Color(0xFF0E7C7B), // Medical teal
      icon: Icons.account_balance_rounded,
      personas: [
        HealthcarePersona(employeeId: '7234', password: 'elevate123', name: 'James Peterson', role: 'Admin', dept: 'Operations'),
        HealthcarePersona(employeeId: '4891', password: 'elevate123', name: 'Dr. Mehta', role: 'Doctor', dept: 'Clinical'),
        HealthcarePersona(employeeId: '3056', password: 'elevate123', name: 'Sarah Chen', role: 'Nurse', dept: 'Nursing'),
        HealthcarePersona(employeeId: '8127', password: 'elevate123', name: 'Priya Sharma', role: 'HR Director', dept: 'HR'),
      ],
    ),
    HealthcareOrganization(
      id: 'st-grace-hospital',
      name: 'St. Grace Hospital',
      type: 'Teaching Hospital',
      description: 'Specialty care & research institution',
      accentColor: Color(0xFF1A5F7A), // Deep blue
      icon: Icons.school_rounded,
      personas: [
        HealthcarePersona(employeeId: '2945', password: 'elevate123',  name: 'Hon Williams', role: 'Admin', dept: 'Operations'),
        HealthcarePersona(employeeId: '6738', password: 'elevate123',  name: 'Dr. Kapoor', role: 'Doctor', dept: 'Clinical'),
        HealthcarePersona(employeeId: '5421', password: 'elevate123',  name: 'Aisha Khan', role: 'Nurse', dept: 'Nursing'),
      ],
    ),
    HealthcareOrganization(
      id: 'sunrise-healthcare',
      name: 'Sunrise Healthcare Network',
      type: 'Clinic Network',
      description: 'Primary care & ambulatory services',
      accentColor: Color(0xFFE97C3D), // Sunrise orange
      icon: Icons.apartment_rounded,
      personas: [
        HealthcarePersona(employeeId: '9183', password: 'elevate123',  name: 'Amit Kumar', role: 'Admin', dept: 'Operations'),
        HealthcarePersona(employeeId: '1672', password: 'elevate123', name: 'Dr. Patel', role: 'Doctor', dept: 'Clinical'),
        HealthcarePersona(employeeId: '4509', password: 'elevate123',  name: 'Maria Jose', role: 'Nurse', dept: 'Nursing'),
      ],
    ),
  ];
}

/// Healthcare staff persona for login demo.
class HealthcarePersona {
  final String employeeId;
  final String password;
  final String name;
  final String role; // Admin, Doctor, Nurse, HR Director, HR Specialist
  final String dept; // Operations, Clinical, Nursing, HR

  const HealthcarePersona({
    required this.employeeId,
    required this.password,
    required this.name,
    required this.role,
    required this.dept,
  });

  String get displayName => '$name ($role)';
}
