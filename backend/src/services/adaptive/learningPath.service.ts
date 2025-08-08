import { LearningPathNode } from "./learningPath.model";

export class AdaptivePathService {
  private paths: Map<string, LearningPathNode[]> = new Map();
  private progress: Map<string, Set<string>> = new Map();

  constructor() {
    this.paths.set("default", [
      { id: "intro", skill: "basics", prerequisiteIds: [] },
      { id: "advanced", skill: "advanced", prerequisiteIds: ["intro"] },
    ]);
  }

  async getNext(userId: string, pathId = "default"): Promise<LearningPathNode | null> {
    const completed = this.progress.get(userId) ?? new Set<string>();
    const nodes = this.paths.get(pathId) ?? [];
    return nodes.find((n) => n.prerequisiteIds.every((id) => completed.has(id))) ?? null;
  }

  async recordResult(userId: string, nodeId: string, success: boolean): Promise<void> {
    if (!success) return;
    const completed = this.progress.get(userId) ?? new Set<string>();
    completed.add(nodeId);
    this.progress.set(userId, completed);
  }
}
