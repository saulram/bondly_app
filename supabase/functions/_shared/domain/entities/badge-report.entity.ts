/**
 * Badge Report Entity - Domain model
 */

export interface BadgeReportEntity {
  id: string;
  createdAt: Date;
  badge: {
    name: string;
    value: number;
  } | null;
  category: {
    name: string;
  } | null;
  sender: {
    completeName: string;
    email: string;
  } | null;
  receiver: {
    completeName: string;
    email: string;
  } | null;
  senderProfile: {
    jobPosition: string;
    jobArea: string;
  } | null;
  receiverProfile: {
    jobPosition: string;
    jobArea: string;
  } | null;
}

export interface BadgeReportFilters {
  badgeId?: string;
  categoryId?: string;
  startDate?: string;
  endDate?: string;
  account?: number;
}
