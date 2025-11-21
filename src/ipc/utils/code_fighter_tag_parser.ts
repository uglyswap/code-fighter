import { normalizePath } from "../../../shared/normalizePath";
import log from "electron-log";
import { SqlQuery } from "../../lib/schemas";

const logger = log.scope("code_fighter_tag_parser");

export function getCodeFighterWriteTags(fullResponse: string): {
  path: string;
  content: string;
  description?: string;
}[] {
  const CodeFighterWriteRegex = /<code-fighter-write([^>]*)>([\s\S]*?)<\/code-fighter-write>/gi;
  const pathRegex = /path="([^"]+)"/;
  const descriptionRegex = /description="([^"]+)"/;

  let match;
  const tags: { path: string; content: string; description?: string }[] = [];

  while ((match = CodeFighterWriteRegex.exec(fullResponse)) !== null) {
    const attributesString = match[1];
    let content = match[2].trim();

    const pathMatch = pathRegex.exec(attributesString);
    const descriptionMatch = descriptionRegex.exec(attributesString);

    if (pathMatch && pathMatch[1]) {
      const path = pathMatch[1];
      const description = descriptionMatch?.[1];

      const contentLines = content.split("\n");
      if (contentLines[0]?.startsWith("```")) {
        contentLines.shift();
      }
      if (contentLines[contentLines.length - 1]?.startsWith("```")) {
        contentLines.pop();
      }
      content = contentLines.join("\n");

      tags.push({ path: normalizePath(path), content, description });
    } else {
      logger.warn(
        "Found <code-fighter-write> tag without a valid 'path' attribute:",
        match[0],
      );
    }
  }
  return tags;
}

export function getCodeFighterRenameTags(fullResponse: string): {
  from: string;
  to: string;
}[] {
  const CodeFighterRenameRegex =
    /<code-fighter-rename from="([^"]+)" to="([^"]+)"[^>]*>([\s\S]*?)<\/code-fighter-rename>/g;
  let match;
  const tags: { from: string; to: string }[] = [];
  while ((match = CodeFighterRenameRegex.exec(fullResponse)) !== null) {
    tags.push({
      from: normalizePath(match[1]),
      to: normalizePath(match[2]),
    });
  }
  return tags;
}

export function getCodeFighterDeleteTags(fullResponse: string): string[] {
  const CodeFighterDeleteRegex =
    /<code-fighter-delete path="([^"]+)"[^>]*>([\s\S]*?)<\/code-fighter-delete>/g;
  let match;
  const paths: string[] = [];
  while ((match = CodeFighterDeleteRegex.exec(fullResponse)) !== null) {
    paths.push(normalizePath(match[1]));
  }
  return paths;
}

export function getCodeFighterAddDependencyTags(fullResponse: string): string[] {
  const CodeFighterAddDependencyRegex =
    /<code-fighter-add-dependency packages="([^"]+)">[^<]*<\/code-fighter-add-dependency>/g;
  let match;
  const packages: string[] = [];
  while ((match = CodeFighterAddDependencyRegex.exec(fullResponse)) !== null) {
    packages.push(...match[1].split(" "));
  }
  return packages;
}

export function getCodeFighterChatSummaryTag(fullResponse: string): string | null {
  const codeFighterChatSummaryRegex =
    /<code-fighter-chat-summary>([\s\S]*?)<\/code-fighter-chat-summary>/g;
  const match = codeFighterChatSummaryRegex.exec(fullResponse);
  if (match && match[1]) {
    return match[1].trim();
  }
  return null;
}

export function getCodeFighterExecuteSqlTags(fullResponse: string): SqlQuery[] {
  const CodeFighterExecuteSqlRegex =
    /<code-fighter-execute-sql([^>]*)>([\s\S]*?)<\/code-fighter-execute-sql>/g;
  const descriptionRegex = /description="([^"]+)"/;
  let match;
  const queries: { content: string; description?: string }[] = [];

  while ((match = CodeFighterExecuteSqlRegex.exec(fullResponse)) !== null) {
    const attributesString = match[1] || "";
    let content = match[2].trim();
    const descriptionMatch = descriptionRegex.exec(attributesString);
    const description = descriptionMatch?.[1];

    // Handle markdown code blocks if present
    const contentLines = content.split("\n");
    if (contentLines[0]?.startsWith("```")) {
      contentLines.shift();
    }
    if (contentLines[contentLines.length - 1]?.startsWith("```")) {
      contentLines.pop();
    }
    content = contentLines.join("\n");

    queries.push({ content, description });
  }

  return queries;
}

export function getCodeFighterCommandTags(fullResponse: string): string[] {
  const CodeFighterCommandRegex =
    /<code-fighter-command type="([^"]+)"[^>]*><\/code-fighter-command>/g;
  let match;
  const commands: string[] = [];

  while ((match = CodeFighterCommandRegex.exec(fullResponse)) !== null) {
    commands.push(match[1]);
  }

  return commands;
}

export function getCodeFighterSearchReplaceTags(fullResponse: string): {
  path: string;
  content: string;
  description?: string;
}[] {
  const CodeFighterSearchReplaceRegex =
    /<code-fighter-search-replace([^>]*)>([\s\S]*?)<\/code-fighter-search-replace>/gi;
  const pathRegex = /path="([^"]+)"/;
  const descriptionRegex = /description="([^"]+)"/;

  let match;
  const tags: { path: string; content: string; description?: string }[] = [];

  while ((match = CodeFighterSearchReplaceRegex.exec(fullResponse)) !== null) {
    const attributesString = match[1] || "";
    let content = match[2].trim();

    const pathMatch = pathRegex.exec(attributesString);
    const descriptionMatch = descriptionRegex.exec(attributesString);

    if (pathMatch && pathMatch[1]) {
      const path = pathMatch[1];
      const description = descriptionMatch?.[1];

      // Handle markdown code fences if present
      const contentLines = content.split("\n");
      if (contentLines[0]?.startsWith("```")) {
        contentLines.shift();
      }
      if (contentLines[contentLines.length - 1]?.startsWith("```")) {
        contentLines.pop();
      }
      content = contentLines.join("\n");

      tags.push({ path: normalizePath(path), content, description });
    } else {
      logger.warn(
        "Found <code-fighter-search-replace> tag without a valid 'path' attribute:",
        match[0],
      );
    }
  }
  return tags;
}
