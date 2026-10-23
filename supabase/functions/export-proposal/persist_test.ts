import { assertEquals, assertRejects } from "./assert.ts";
import { savePdfAndRecord } from "./persist.ts";

Deno.test("keeps the file when the export row is saved", async () => {
  const calls: string[] = [];
  await savePdfAndRecord({
    upload: async () => {
      calls.push("upload");
    },
    insert: async () => {
      calls.push("insert");
    },
    remove: async () => {
      calls.push("remove");
    },
  });
  assertEquals(calls, ["upload", "insert"]);
});

Deno.test("deletes the uploaded file when the insert fails", async () => {
  const calls: string[] = [];
  await assertRejects(
    () =>
      savePdfAndRecord({
        upload: async () => {
          calls.push("upload");
        },
        insert: async () => {
          calls.push("insert");
          return { error: new Error("row failed") };
        },
        remove: async () => {
          calls.push("remove");
        },
      }),
  );
  assertEquals(calls, ["upload", "insert", "remove"]);
});
