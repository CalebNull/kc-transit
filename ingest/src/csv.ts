import { createReadStream } from "node:fs";
import { parse } from "csv-parse";

export async function* readCsv(path: string) {
  const parser = createReadStream(path).pipe(
    parse({ columns: true, bom: true, trim: true, skip_empty_lines: true })
  );
  for await (const row of parser) yield row as Record<string, string>;
}