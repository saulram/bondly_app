/**
 * Generate Area Chart Use Case
 * Application layer business logic
 */

import type { IAreaChartRepository } from "../../domain/ports/area-chart.repository.port.ts";
import type { ChartDataPoint, AreaChartFilters } from "../../domain/entities/area-chart.entity.ts";

const MONTH_NAMES = ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"];

export class GenerateAreaChartUseCase {
  constructor(private readonly repository: IAreaChartRepository) {}

  async execute(filters: AreaChartFilters): Promise<ChartDataPoint[]> {
    const months = filters.months ?? 12;

    // Calculate date range
    const endDate = new Date();
    const startDate = new Date();
    startDate.setMonth(startDate.getMonth() - months);

    const acknowledgments = await this.repository.findAcknowledgments(
      startDate,
      endDate,
      filters.account
    );

    // Initialize all months with zero values
    const monthlyData = new Map<string, { count: number; points: number }>();

    for (let i = 0; i < months; i++) {
      const date = new Date();
      date.setMonth(date.getMonth() - i);
      const monthKey = `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, "0")}`;
      monthlyData.set(monthKey, { count: 0, points: 0 });
    }

    // Populate with data
    for (const ack of acknowledgments) {
      const date = new Date(ack.created_at);
      const monthKey = `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, "0")}`;

      const current = monthlyData.get(monthKey);
      if (current) {
        current.count++;
        current.points += ack.badge?.value ?? 0;
      }
    }

    // Convert to array and sort by date
    const chartData: ChartDataPoint[] = Array.from(monthlyData.entries())
      .map(([month, data]) => ({
        month,
        label: this.formatMonth(month),
        count: data.count,
        points: data.points,
      }))
      .sort((a, b) => a.month.localeCompare(b.month));

    return chartData;
  }

  private formatMonth(monthKey: string): string {
    const [year, month] = monthKey.split("-");
    return `${MONTH_NAMES[parseInt(month, 10) - 1]} ${year}`;
  }
}
