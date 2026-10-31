export class AppError extends Error {
  status: number;

  constructor(status: number, message: string) {
    super(message);
    this.status = status;
  }
}

export function assertFound<T>(value: T | null | undefined, message: string): T {
  if (value == null) {
    throw new AppError(404, message);
  }
  return value;
}
