/**
 * Generate Badge Report Use Case
 * Application layer business logic
 */

import type { IBadgeReportRepository } from "../../domain/ports/badge-report.repository.port.ts";
import type { BadgeReportRow, BadgeReportFilters } from "../../domain/entities/badge-report.entity.ts";
import { csvGeneratorService, type CsvColumn } from "../../../_shared/mod.ts";

export interface GenerateBadgeReportResult {
  content: string;
  filename: string;
}

export class GenerateBadgeReportUseCase {
  constructor(private readonly repository: IBadgeReportRepository) {}

  async execute(filters: BadgeReportFilters): Promise<GenerateBadgeReportResult> {
    const reports = await this.repository.findAll(filters);

    const columns: CsvColumn<BadgeReportRow>[] = [
      { header: "Fecha", accessor: (r) => new Date(r.created_at).toLocaleDateString("es-MX") },
      { header: "Insignia", accessor: (r) => r.badge?.name ?? "" },
      { header: "Categoría", accessor: (r) => r.category?.name ?? "" },
      { header: "Valor", accessor: (r) => r.badge?.value ?? 0 },
      { header: "Emisor", accessor: (r) => r.sender?.complete_name ?? "" },
      { header: "Email Emisor", accessor: (r) => r.sender?.email ?? "" },
      { header: "Puesto Emisor", accessor: (r) => r.sender_profile?.job_position ?? "" },
      { header: "Área Emisor", accessor: (r) => r.sender_profile?.job_area ?? "" },
      { header: "Receptor", accessor: (r) => r.receiver?.complete_name ?? "" },
      { header: "Email Receptor", accessor: (r) => r.receiver?.email ?? "" },
      { header: "Puesto Receptor", accessor: (r) => r.receiver_profile?.job_position ?? "" },
      { header: "Área Receptor", accessor: (r) => r.receiver_profile?.job_area ?? "" },
    ];

    const content = csvGeneratorService.generate(reports, columns);
    const filename = `badge-report-${new Date().toISOString().split("T")[0]}.csv`;

    return { content, filename };
  }
}
