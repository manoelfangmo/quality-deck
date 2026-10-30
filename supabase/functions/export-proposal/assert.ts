export function assert(condition: unknown, message = "Assertion failed"): asserts condition {
  if (!condition) throw new Error(message);
}

export function assertEquals<T>(actual: T, expected: T, message?: string) {
  const left = JSON.stringify(actual);
  const right = JSON.stringify(expected);
  if (left !== right) {
    throw new Error(message ?? `Expected ${right} but got ${left}`);
  }
}

export async function assertRejects(
  fn: () => Promise<unknown>,
  ErrorType?: new (...args: never[]) => Error,
): Promise<void> {
  try {
    await fn();
  } catch (error) {
    if (ErrorType && !(error instanceof ErrorType)) {
      throw new Error(`Expected ${ErrorType.name} but got ${error}`);
    }
    return;
  }
  throw new Error("Expected promise to reject");
}
