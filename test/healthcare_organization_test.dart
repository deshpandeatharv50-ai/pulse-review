import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pulsereview_mobile/models/healthcare_organization.dart';

void main() {
  group('HealthcareOrganization', () {
    test('has 3 organizations configured', () {
      expect(HealthcareOrganization.all.length, equals(3));
    });

    test('Central Medical Group has HR personas', () {
      final central =
          HealthcareOrganization.all.firstWhere((o) => o.id == 'central-medical');
      final hrPersonas =
          central.personas.where((p) => p.dept == 'HR').toList();
      expect(hrPersonas.length, equals(2)); // HR Director + Specialist
    });

    test('all organizations have at least 3 personas', () {
      for (final org in HealthcareOrganization.all) {
        expect(org.personas.length, greaterThanOrEqualTo(3));
      }
    });

    test('all personas have valid roles', () {
      final validRoles = ['Admin', 'Doctor', 'Nurse', 'HR Director', 'HR Specialist'];
      for (final org in HealthcareOrganization.all) {
        for (final persona in org.personas) {
          expect(validRoles, contains(persona.role));
        }
      }
    });

    test('all organizations have unique IDs', () {
      final ids = HealthcareOrganization.all.map((o) => o.id).toList();
      expect(ids.length, equals(ids.toSet().length)); // No duplicates
    });

    test('St. Grace Hospital is teaching hospital', () {
      final stGrace =
          HealthcareOrganization.all.firstWhere((o) => o.id == 'st-grace-hospital');
      expect(stGrace.type, equals('Teaching Hospital'));
    });

    test('Sunrise Healthcare has clinic focus', () {
      final sunrise = HealthcareOrganization.all
          .firstWhere((o) => o.id == 'sunrise-healthcare');
      expect(sunrise.type, equals('Clinic Network'));
    });

    test('persona displayName formats correctly', () {
      final persona = HealthcareOrganization.all.first.personas.first;
      expect(persona.displayName, contains(persona.name));
      expect(persona.displayName, contains(persona.role));
    });

    test('organizations have different accent colors', () {
      final colors = HealthcareOrganization.all.map((o) => o.accentColor).toList();
      expect(colors.length, equals(colors.toSet().length)); // All unique
    });

    test('Central Medical Group has teal color', () {
      final central =
          HealthcareOrganization.all.firstWhere((o) => o.id == 'central-medical');
      expect(central.accentColor, equals(const Color(0xFF0E7C7B)));
    });
  });

  group('HealthcarePersona', () {
    test('creates persona with all fields', () {
      const persona = HealthcarePersona(
        name: 'Dr. Test',
        role: 'Doctor',
        dept: 'Clinical',
      );
      expect(persona.name, equals('Dr. Test'));
      expect(persona.role, equals('Doctor'));
      expect(persona.dept, equals('Clinical'));
    });

    test('displayName includes name and role', () {
      const persona = HealthcarePersona(
        name: 'Sarah Chen',
        role: 'Nurse',
        dept: 'Nursing',
      );
      expect(
        persona.displayName,
        equals('Sarah Chen (Nurse)'),
      );
    });
  });
}
