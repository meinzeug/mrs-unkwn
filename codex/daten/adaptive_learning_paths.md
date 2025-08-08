# Adaptive Learning Paths Konzept

## Ziel
- Personalisierte Lernpfade auf Basis der Nutzerleistung.

## Komponenten
- `LearningPathNode` Modell beschreibt einen Abschnitt des Lernpfads.
- `AdaptivePathService` verwaltet Pfade, speichert Fortschritt und liefert den nächsten Abschnitt.

## Trainingsskript
- [`scripts/train_adaptive_model.sh`](../../scripts/train_adaptive_model.sh) generiert das Modell automatisch.
- Die erzeugten Dateien werden nicht versioniert und können bei Bedarf neu erstellt werden.

## Nächste Schritte
- Algorithmus zur Berechnung der nächsten Lernschritte verfeinern.
- REST-Endpunkte zur Fortschrittsübermittlung und Pfadabfrage implementieren.
