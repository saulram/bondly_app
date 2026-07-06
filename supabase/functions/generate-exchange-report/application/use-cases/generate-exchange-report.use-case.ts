/**
 * Generate Exchange Report Use Case
 * Application layer business logic
 */

import type { IExchangeRepository } from "../../domain/ports/exchange.repository.port.ts";
import type { ExchangeRow, ExchangeReportFilters } from "../../domain/entities/exchange.entity.ts";
import { csvGeneratorService, type CsvColumn } from "../../../_shared/mod.ts";

export interface GenerateExchangeReportResult {
  content: string;
  filename: string;
}

export class GenerateExchangeReportUseCase {
  constructor(private readonly repository: IExchangeRepository) {}

  async execute(filters: ExchangeReportFilters): Promise<GenerateExchangeReportResult> {
    const exchanges = await this.repository.findAll(filters);

    const columns: CsvColumn<ExchangeRow>[] = [
      { header: "Código", accessor: (e) => e.code ?? "" },
      { header: "Fecha Solicitud", accessor: (e) => new Date(e.created_at).toLocaleDateString("es-MX") },
      { header: "Fecha Actualización", accessor: (e) => new Date(e.updated_at).toLocaleDateString("es-MX") },
      { header: "Estado", accessor: (e) => e.status },
      { header: "Usuario", accessor: (e) => e.user?.complete_name ?? "" },
      { header: "Email", accessor: (e) => e.user?.email ?? "" },
      { header: "No. Empleado", accessor: (e) => e.user?.employee_number ?? "" },
      { header: "Recompensa", accessor: (e) => e.reward?.name ?? "" },
      { header: "Categoría", accessor: (e) => e.reward?.category ?? "" },
      { header: "Puntos", accessor: (e) => e.reward?.points ?? 0 },
      { header: "Empresa", accessor: (e) => e.company_name ?? "" },
    ];

    const content = csvGeneratorService.generate(exchanges, columns);
    const filename = `exchange-report-${new Date().toISOString().split("T")[0]}.csv`;

    return { content, filename };
  }
}
