export async function* batches<T>(rows: AsyncIterable<T>, size = 1000) {
  let buf: T[] = [];
  for await (const row of rows) {
    buf.push(row);
    if (buf.length === size) { yield buf; buf = []; }
  }
  if (buf.length) yield buf;
}

export const blankToNull = (s: string | undefined) => (s ? s : null);