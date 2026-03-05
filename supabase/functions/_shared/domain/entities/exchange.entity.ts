/**
 * Exchange Entity - Domain model
 */

export type ExchangeStatus = "Entregado" | "En espera" | "Recibido" | "Devolución";

export interface ExchangeEntity {
  id: string;
  code: string | null;
  status: ExchangeStatus;
  createdAt: Date;
  updatedAt: Date;
  companyName: string | null;
  user: {
    completeName: string;
    email: string;
    employeeNumber: number | null;
  } | null;
  reward: {
    name: string;
    points: number;
    category: string | null;
  } | null;
}

export interface ExchangeFilters {
  status?: ExchangeStatus;
  startDate?: string;
  endDate?: string;
  companyName?: string;
}
