# Adaptive Learning Paths Konzept

## Ziel
- Personalisierte Lernpfade auf Basis der Nutzerleistung.

## Komponenten
- `LearningPathNode` Modell beschreibt einen Abschnitt des Lernpfads.
- `AdaptivePathService` verwaltet Pfade, speichert Fortschritt und liefert den nächsten Abschnitt.

## Aktueller Stand
- Algorithmus berücksichtigt prerequisites und Nutzerfortschritt pro Pfad.
- REST-Endpoint `POST /api/adaptive/progress` nimmt Ergebnisse entgegen und liefert den nächsten Abschnitt.

## Trainingsskript
- [`scripts/train_adaptive_model.sh`](../../scripts/train_adaptive_model.sh) generiert das Modell automatisch.
- Die erzeugten Dateien werden nicht versioniert und können bei Bedarf neu erstellt werden.

## Nächste Schritte
- Personalisierungslogik erweitern (Schwierigkeitsanpassung, Remediation).
- Persistente Speicherung des Lernfortschritts hinzufügen.
