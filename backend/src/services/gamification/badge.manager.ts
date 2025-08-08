import { PointsManager } from "./points.manager";

interface Badge {
  id: string;
  description: string;
  pointsRequired: number;
}

export class BadgeManager {
  private badges: Badge[] = [
    { id: "novice", description: "Earn 100 points", pointsRequired: 100 },
    { id: "intermediate", description: "Earn 250 points", pointsRequired: 250 },
    { id: "expert", description: "Earn 500 points", pointsRequired: 500 },
  ];

  private userBadges: Map<string, Set<string>> = new Map();

  constructor(private pointsManager: PointsManager) {}

  async awardEarnedBadges(userId: string): Promise<string[]> {
    const total = await this.pointsManager.getPoints(userId);
    const earned: string[] = [];
    for (const badge of this.badges) {
      if (total >= badge.pointsRequired) {
        const set = this.userBadges.get(userId) ?? new Set<string>();
        if (!set.has(badge.id)) {
          set.add(badge.id);
          this.userBadges.set(userId, set);
          earned.push(badge.id);
        }
      }
    }
    return earned;
  }

  async getBadges(userId: string): Promise<string[]> {
    return Array.from(this.userBadges.get(userId) ?? []);
  }
}
