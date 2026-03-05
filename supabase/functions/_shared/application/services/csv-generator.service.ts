/**
 * CSV Generator Service
 * Application service for generating CSV content
 */

export interface CsvColumn<T> {
  header: string;
  accessor: (item: T) => string | number | null | undefined;
}

export class CsvGeneratorService {
  /**
   * Generate CSV content from data
   */
  generate<T>(data: T[], columns: CsvColumn<T>[]): string {
    const headers = columns.map((col) => col.header);

    const rows = data.map((item) =>
      columns.map((col) => {
        const value = col.accessor(item);
        return this.escapeCsvValue(value?.toString() ?? "");
      })
    );

    return [
      headers.join(","),
      ...rows.map((row) => row.join(",")),
    ].join("\n");
  }

  private escapeCsvValue(value: string): string {
    if (value.includes(",") || value.includes('"') || value.includes("\n")) {
      return `"${value.replace(/"/g, '""')}"`;
    }
    return value;
  }
}

export const csvGeneratorService = new CsvGeneratorService();
