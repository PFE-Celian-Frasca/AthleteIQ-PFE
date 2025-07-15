import 'package:athlete_iq/models/message/media_file.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MediaFile', () {
    // Vérifie que les propriétés sont correctement initialisées
    test('initializes properties correctly', () {
      const mediaFile = MediaFile(
        url: 'https://example.com/file.jpg',
        name: 'file.jpg',
        mimeType: 'image/jpeg',
        size: 1024,
      );

      expect(mediaFile.url, 'https://example.com/file.jpg');
      expect(mediaFile.name, 'file.jpg');
      expect(mediaFile.mimeType, 'image/jpeg');
      expect(mediaFile.size, 1024);
    });

    // Vérifie le comportement avec une taille de fichier nulle
    test('handles zero file size gracefully', () {
      const mediaFile = MediaFile(
        url: 'https://example.com/file.jpg',
        name: 'file.jpg',
        mimeType: 'image/jpeg',
        size: 0,
      );

      expect(mediaFile.size, 0);
    });

    // Vérifie le comportement avec un type MIME vide
    test('handles empty mimeType gracefully', () {
      const mediaFile = MediaFile(
        url: 'https://example.com/file.jpg',
        name: 'file.jpg',
        mimeType: '',
        size: 1024,
      );

      expect(mediaFile.mimeType, '');
    });

    // Vérifie le comportement avec une URL vide
    test('handles empty URL gracefully', () {
      const mediaFile = MediaFile(
        url: '',
        name: 'file.jpg',
        mimeType: 'image/jpeg',
        size: 1024,
      );

      expect(mediaFile.url, '');
    });

    test('parses valid JSON correctly', () {
      const json = {
        'url': 'https://example.com/file.jpg',
        'name': 'file.jpg',
        'mimeType': 'image/jpeg',
        'size': 1024,
      };

      final mediaFile = MediaFile.fromJson(json);

      expect(mediaFile.url, 'https://example.com/file.jpg');
      expect(mediaFile.name, 'file.jpg');
      expect(mediaFile.mimeType, 'image/jpeg');
      expect(mediaFile.size, 1024);
    });

    test('throws an error when required fields are missing', () {
      const json = {
        'url': 'https://example.com/file.jpg',
        'name': 'file.jpg',
      };

      expect(() => MediaFile.fromJson(json), throwsA(isA<TypeError>()));
    });

    // Vérifie le comportement avec un nom de fichier vide
    test('handles empty name gracefully', () {
      const mediaFile = MediaFile(
        url: 'https://example.com/file.jpg',
        name: '',
        mimeType: 'image/jpeg',
        size: 1024,
      );

      expect(mediaFile.name, '');
    });
  });
}
