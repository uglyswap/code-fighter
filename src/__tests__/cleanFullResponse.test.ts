import { cleanFullResponse } from "@/ipc/utils/cleanFullResponse";
import { describe, it, expect } from "vitest";

describe("cleanFullResponse", () => {
  it("should replace < characters in code-fighter-write attributes", () => {
    const input = `<code-fighter-write path="src/file.tsx" description="Testing <a> tags.">content</code-fighter-write>`;
    const expected = `<code-fighter-write path="src/file.tsx" description="Testing ＜a＞ tags.">content</code-fighter-write>`;

    const result = cleanFullResponse(input);
    expect(result).toBe(expected);
  });

  it("should replace < characters in multiple attributes", () => {
    const input = `<code-fighter-write path="src/<component>.tsx" description="Testing <div> tags.">content</code-fighter-write>`;
    const expected = `<code-fighter-write path="src/＜component＞.tsx" description="Testing ＜div＞ tags.">content</code-fighter-write>`;

    const result = cleanFullResponse(input);
    expect(result).toBe(expected);
  });

  it("should handle multiple nested HTML tags in a single attribute", () => {
    const input = `<code-fighter-write path="src/file.tsx" description="Testing <div> and <span> and <a> tags.">content</code-fighter-write>`;
    const expected = `<code-fighter-write path="src/file.tsx" description="Testing ＜div＞ and ＜span＞ and ＜a＞ tags.">content</code-fighter-write>`;

    const result = cleanFullResponse(input);
    expect(result).toBe(expected);
  });

  it("should handle complex example with mixed content", () => {
    const input = `
      BEFORE TAG
  <code-fighter-write path="src/pages/locations/neighborhoods/louisville/Highlands.tsx" description="Updating Highlands neighborhood page to use <a> tags.">
import React from 'react';
</code-fighter-write>
AFTER TAG
    `;

    const expected = `
      BEFORE TAG
  <code-fighter-write path="src/pages/locations/neighborhoods/louisville/Highlands.tsx" description="Updating Highlands neighborhood page to use ＜a＞ tags.">
import React from 'react';
</code-fighter-write>
AFTER TAG
    `;

    const result = cleanFullResponse(input);
    expect(result).toBe(expected);
  });

  it("should handle other code-fighter tag types", () => {
    const input = `<code-fighter-rename from="src/<old>.tsx" to="src/<new>.tsx"></code-fighter-rename>`;
    const expected = `<code-fighter-rename from="src/＜old＞.tsx" to="src/＜new＞.tsx"></code-fighter-rename>`;

    const result = cleanFullResponse(input);
    expect(result).toBe(expected);
  });

  it("should handle code-fighter-delete tags", () => {
    const input = `<code-fighter-delete path="src/<component>.tsx"></code-fighter-delete>`;
    const expected = `<code-fighter-delete path="src/＜component＞.tsx"></code-fighter-delete>`;

    const result = cleanFullResponse(input);
    expect(result).toBe(expected);
  });

  it("should not affect content outside code-fighter tags", () => {
    const input = `Some text with <regular> HTML tags. <code-fighter-write path="test.tsx" description="With <nested> tags.">content</code-fighter-write> More <html> here.`;
    const expected = `Some text with <regular> HTML tags. <code-fighter-write path="test.tsx" description="With ＜nested＞ tags.">content</code-fighter-write> More <html> here.`;

    const result = cleanFullResponse(input);
    expect(result).toBe(expected);
  });

  it("should handle empty attributes", () => {
    const input = `<code-fighter-write path="src/file.tsx">content</code-fighter-write>`;
    const expected = `<code-fighter-write path="src/file.tsx">content</code-fighter-write>`;

    const result = cleanFullResponse(input);
    expect(result).toBe(expected);
  });

  it("should handle attributes without < characters", () => {
    const input = `<code-fighter-write path="src/file.tsx" description="Normal description">content</code-fighter-write>`;
    const expected = `<code-fighter-write path="src/file.tsx" description="Normal description">content</code-fighter-write>`;

    const result = cleanFullResponse(input);
    expect(result).toBe(expected);
  });
});
