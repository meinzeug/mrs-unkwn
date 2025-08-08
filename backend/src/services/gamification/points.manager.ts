export class PointsManager {
  private points: Map<string, number> = new Map();

  async addPoints(userId: string, amount: number): Promise<number> {
    const current = this.points.get(userId) ?? 0;
    const updated = current + amount;
    this.points.set(userId, updated);
    return updated;
  }

  async subtractPoints(userId: string, amount: number): Promise<number> {
    const current = this.points.get(userId) ?? 0;
    const updated = Math.max(0, current - amount);
    this.points.set(userId, updated);
    return updated;
  }

  async getPoints(userId: string): Promise<number> {
    return this.points.get(userId) ?? 0;
  }
}
