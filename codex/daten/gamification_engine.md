# Gamification Engine Konzept

## Ziele
- Motivation der Lernenden durch Punkte, Levels und Abzeichen.
- Flexible Erweiterbarkeit für zukünftige Spielmechaniken.

## Kernkomponenten
### PointsManager
- Verwaltet Punkte pro Nutzer.
- Schnittstellen zum Hinzufügen, Abziehen und Abfragen von Punkten.

### LevelManager
- Berechnet Nutzerlevel basierend auf Gesamtpunkten.
- Unterstützt Levelaufstieg und Benachrichtigungen.

### BadgeManager
- Vergibt Badges bei Erreichen bestimmter Meilensteine.
- Nutzt von [`scripts/generate_badge_assets.sh`](../../scripts/generate_badge_assets.sh) erzeugte Icons.

## Datenmodell
- Tabellen/Collections für `points`, `levels`, `badges`, `user_badges`.
- Jeder Eintrag enthält Metadaten wie Beschreibung und Bedingungen.

## Integration
- Backend stellt APIs für Punkte- und Badge-Operationen bereit.
- Flutter-App synchronisiert Fortschritt und zeigt Belohnungen an.

## Nächste Schritte
- Basisklassen und Services in Backend & Flutter anlegen.
- Ereignisse definieren, die Punkte vergeben.
- Badge-Vergaberegeln implementieren.
