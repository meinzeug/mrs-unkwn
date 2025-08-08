export interface LearningPathNode {
  id: string;
  skill: string;
  prerequisiteIds: string[];
}

export interface UserProgress {
  userId: string;
  completed: { [pathId: string]: Set<string> };
}
