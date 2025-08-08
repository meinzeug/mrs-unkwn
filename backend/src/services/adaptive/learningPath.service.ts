import { LearningPathNode } from "./learningPath.model";

/**
 * Service verwaltet Lernpfade und Nutzerfortschritt im Speicher.
 * Fortschritt wird pro Nutzer und Pfad getrennt gespeichert.
 */
export class AdaptivePathService {
  private paths: Map<string, LearningPathNode[]> = new Map();
  private progress: Map<string, Map<string, Set<string>>> = new Map();

  constructor() {
    this.paths.set("default", [
      { id: "intro", skill: "basics", prerequisiteIds: [] },
      { id: "advanced", skill: "advanced", prerequisiteIds: ["intro"] },
    ]);
  }

  /**
   * Liefert den nächsten Abschnitt basierend auf abgeschlossenem Fortschritt.
   */
  async getNext(
    userId: string,
    pathId = "default",
  ): Promise<LearningPathNode | null> {
    const userProgress = this.progress.get(userId)?.get(pathId) ?? new Set<string>();
    const nodes = this.paths.get(pathId) ?? [];
    return (
      nodes.find(
        (n) => !userProgress.has(n.id) && n.prerequisiteIds.every((id) => userProgress.has(id)),
      ) ?? null
    );
  }

  /**
   * Speichert das Ergebnis eines Lernabschnitts und aktualisiert den Fortschritt.
   */
  async recordResult(
    userId: string,
    pathId: string,
    nodeId: string,
    success: boolean,
  ): Promise<void> {
    if (!success) return;
    const userMap = this.progress.get(userId) ?? new Map<string, Set<string>>();
    const completed = userMap.get(pathId) ?? new Set<string>();
    completed.add(nodeId);
    userMap.set(pathId, completed);
    this.progress.set(userId, userMap);
  }
}
