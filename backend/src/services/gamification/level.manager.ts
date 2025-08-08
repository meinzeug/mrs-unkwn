import { PointsManager } from "./points.manager";

interface LevelConfig {
  level: number;
  threshold: number;
}

export class LevelManager {
  private levels: LevelConfig[] = [
    { level: 1, threshold: 0 },
    { level: 2, threshold: 100 },
    { level: 3, threshold: 250 },
    { level: 4, threshold: 500 },
  ];

  constructor(private pointsManager: PointsManager) {}

  async addPoints(userId: string, amount: number) {
    const beforeLevel = await this.getLevel(userId);
    const total = await this.pointsManager.addPoints(userId, amount);
    const afterLevel = await this.getLevel(userId);
    return {
      points: total,
      level: afterLevel,
      leveledUp: afterLevel > beforeLevel,
    };
  }

  async getLevel(userId: string): Promise<number> {
    const total = await this.pointsManager.getPoints(userId);
    const found = [...this.levels].reverse().find((lvl) => total >= lvl.threshold);
    return found ? found.level : 1;
  }
}
