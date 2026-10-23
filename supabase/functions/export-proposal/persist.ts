export async function savePdfAndRecord(args: {
  upload: () => Promise<{ error: unknown } | void>;
  insert: () => Promise<{ error: unknown } | void>;
  remove: () => Promise<void>;
}): Promise<void> {
  const uploaded = (await args.upload()) ?? { error: null };
  if (uploaded.error) throw uploaded.error;
  try {
    const recorded = (await args.insert()) ?? { error: null };
    if (recorded.error) throw recorded.error;
  } catch (error) {
    await args.remove();
    throw error;
  }
}
