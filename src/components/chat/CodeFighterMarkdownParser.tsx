import React, { useMemo } from "react";
import ReactMarkdown from "react-markdown";

import { CodeFighterWrite } from "./CodeFighterWrite";
import { CodeFighterRename } from "./CodeFighterRename";
import { CodeFighterDelete } from "./CodeFighterDelete";
import { CodeFighterAddDependency } from "./CodeFighterAddDependency";
import { CodeFighterExecuteSql } from "./CodeFighterExecuteSql";
import { CodeFighterAddIntegration } from "./CodeFighterAddIntegration";
import { CodeFighterEdit } from "./CodeFighterEdit";
import { CodeFighterSearchReplace } from "./CodeFighterSearchReplace";
import { CodeFighterCodebaseContext } from "./CodeFighterCodebaseContext";
import { CodeFighterThink } from "./CodeFighterThink";
import { CodeHighlight } from "./CodeHighlight";
import { useAtomValue } from "jotai";
import { isStreamingByIdAtom, selectedChatIdAtom } from "@/atoms/chatAtoms";
import { CustomTagState } from "./stateTypes";
import { CodeFighterOutput } from "./CodeFighterOutput";
import { CodeFighterProblemSummary } from "./CodeFighterProblemSummary";
import { IpcClient } from "@/ipc/ipc_client";
import { CodeFighterMcpToolCall } from "./CodeFighterMcpToolCall";
import { CodeFighterMcpToolResult } from "./CodeFighterMcpToolResult";
import { CodeFighterWebSearchResult } from "./CodeFighterWebSearchResult";
import { CodeFighterWebSearch } from "./CodeFighterWebSearch";
import { CodeFighterWebCrawl } from "./CodeFighterWebCrawl";
import { CodeFighterCodeSearchResult } from "./CodeFighterCodeSearchResult";
import { CodeFighterCodeSearch } from "./CodeFighterCodeSearch";
import { CodeFighterRead } from "./CodeFighterRead";
import { mapActionToButton } from "./ChatInput";
import { SuggestedAction } from "@/lib/schemas";

interface CodeFighterMarkdownParserProps {
  content: string;
}

type CustomTagInfo = {
  tag: string;
  attributes: Record<string, string>;
  content: string;
  fullMatch: string;
  inProgress?: boolean;
};

type ContentPiece =
  | { type: "markdown"; content: string }
  | { type: "custom-tag"; tagInfo: CustomTagInfo };

const customLink = ({
  node: _node,
  ...props
}: {
  node?: any;
  [key: string]: any;
}) => (
  <a
    {...props}
    onClick={(e) => {
      const url = props.href;
      if (url) {
        e.preventDefault();
        IpcClient.getInstance().openExternalUrl(url);
      }
    }}
  />
);

export const VanillaMarkdownParser = ({ content }: { content: string }) => {
  return (
    <ReactMarkdown
      components={{
        code: CodeHighlight,
        a: customLink,
      }}
    >
      {content}
    </ReactMarkdown>
  );
};

/**
 * Custom component to parse markdown content with Code Fighter-specific tags
 */
export const CodeFighterMarkdownParser: React.FC<CodeFighterMarkdownParserProps> = ({
  content,
}) => {
  const chatId = useAtomValue(selectedChatIdAtom);
  const isStreaming = useAtomValue(isStreamingByIdAtom).get(chatId!) ?? false;
  // Extract content pieces (markdown and custom tags)
  const contentPieces = useMemo(() => {
    return parseCustomTags(content);
  }, [content]);

  return (
    <>
      {contentPieces.map((piece, index) => (
        <React.Fragment key={index}>
          {piece.type === "markdown"
            ? piece.content && (
                <ReactMarkdown
                  components={{
                    code: CodeHighlight,
                    a: customLink,
                  }}
                >
                  {piece.content}
                </ReactMarkdown>
              )
            : renderCustomTag(piece.tagInfo, { isStreaming })}
        </React.Fragment>
      ))}
    </>
  );
};

/**
 * Pre-process content to handle unclosed custom tags
 * Adds closing tags at the end of the content for any unclosed custom tags
 * Assumes the opening tags are complete and valid
 * Returns the processed content and a map of in-progress tags
 */
function preprocessUnclosedTags(content: string): {
  processedContent: string;
  inProgressTags: Map<string, Set<number>>;
} {
  const customTagNames = [
    "code-fighter-write",
    "code-fighter-rename",
    "code-fighter-delete",
    "code-fighter-add-dependency",
    "code-fighter-execute-sql",
    "code-fighter-add-integration",
    "code-fighter-output",
    "code-fighter-problem-report",
    "code-fighter-chat-summary",
    "code-fighter-edit",
    "code-fighter-search-replace",
    "code-fighter-codebase-context",
    "code-fighter-web-search-result",
    "code-fighter-web-search",
    "code-fighter-web-crawl",
    "code-fighter-read",
    "think",
    "code-fighter-command",
    "code-fighter-mcp-tool-call",
    "code-fighter-mcp-tool-result",
  ];

  let processedContent = content;
  // Map to track which tags are in progress and their positions
  const inProgressTags = new Map<string, Set<number>>();

  // For each tag type, check if there are unclosed tags
  for (const tagName of customTagNames) {
    // Count opening and closing tags
    const openTagPattern = new RegExp(`<${tagName}(?:\\s[^>]*)?>`, "g");
    const closeTagPattern = new RegExp(`</${tagName}>`, "g");

    // Track the positions of opening tags
    const openingMatches: RegExpExecArray[] = [];
    let match;

    // Reset regex lastIndex to start from the beginning
    openTagPattern.lastIndex = 0;

    while ((match = openTagPattern.exec(processedContent)) !== null) {
      openingMatches.push({ ...match });
    }

    const openCount = openingMatches.length;
    const closeCount = (processedContent.match(closeTagPattern) || []).length;

    // If we have more opening than closing tags
    const missingCloseTags = openCount - closeCount;
    if (missingCloseTags > 0) {
      // Add the required number of closing tags at the end
      processedContent += Array(missingCloseTags)
        .fill(`</${tagName}>`)
        .join("");

      // Mark the last N tags as in progress where N is the number of missing closing tags
      const inProgressIndexes = new Set<number>();
      const startIndex = openCount - missingCloseTags;
      for (let i = startIndex; i < openCount; i++) {
        inProgressIndexes.add(openingMatches[i].index);
      }
      inProgressTags.set(tagName, inProgressIndexes);
    }
  }

  return { processedContent, inProgressTags };
}

/**
 * Parse the content to extract custom tags and markdown sections into a unified array
 */
function parseCustomTags(content: string): ContentPiece[] {
  const { processedContent, inProgressTags } = preprocessUnclosedTags(content);

  const customTagNames = [
    "code-fighter-write",
    "code-fighter-rename",
    "code-fighter-delete",
    "code-fighter-add-dependency",
    "code-fighter-execute-sql",
    "code-fighter-add-integration",
    "code-fighter-output",
    "code-fighter-problem-report",
    "code-fighter-chat-summary",
    "code-fighter-edit",
    "code-fighter-search-replace",
    "code-fighter-codebase-context",
    "code-fighter-web-search-result",
    "code-fighter-web-search",
    "code-fighter-web-crawl",
    "code-fighter-code-search-result",
    "code-fighter-code-search",
    "code-fighter-read",
    "think",
    "code-fighter-command",
    "code-fighter-mcp-tool-call",
    "code-fighter-mcp-tool-result",
  ];

  const tagPattern = new RegExp(
    `<(${customTagNames.join("|")})\\s*([^>]*)>(.*?)<\\/\\1>`,
    "gs",
  );

  const contentPieces: ContentPiece[] = [];
  let lastIndex = 0;
  let match;

  // Find all custom tags
  while ((match = tagPattern.exec(processedContent)) !== null) {
    const [fullMatch, tag, attributesStr, tagContent] = match;
    const startIndex = match.index;

    // Add the markdown content before this tag
    if (startIndex > lastIndex) {
      contentPieces.push({
        type: "markdown",
        content: processedContent.substring(lastIndex, startIndex),
      });
    }

    // Parse attributes
    const attributes: Record<string, string> = {};
    const attrPattern = /(\w+)="([^"]*)"/g;
    let attrMatch;
    while ((attrMatch = attrPattern.exec(attributesStr)) !== null) {
      attributes[attrMatch[1]] = attrMatch[2];
    }

    // Check if this tag was marked as in progress
    const tagInProgressSet = inProgressTags.get(tag);
    const isInProgress = tagInProgressSet?.has(startIndex);

    // Add the tag info
    contentPieces.push({
      type: "custom-tag",
      tagInfo: {
        tag,
        attributes,
        content: tagContent,
        fullMatch,
        inProgress: isInProgress || false,
      },
    });

    lastIndex = startIndex + fullMatch.length;
  }

  // Add the remaining markdown content
  if (lastIndex < processedContent.length) {
    contentPieces.push({
      type: "markdown",
      content: processedContent.substring(lastIndex),
    });
  }

  return contentPieces;
}

function getState({
  isStreaming,
  inProgress,
}: {
  isStreaming?: boolean;
  inProgress?: boolean;
}): CustomTagState {
  if (!inProgress) {
    return "finished";
  }
  return isStreaming ? "pending" : "aborted";
}

/**
 * Render a custom tag based on its type
 */
function renderCustomTag(
  tagInfo: CustomTagInfo,
  { isStreaming }: { isStreaming: boolean },
): React.ReactNode {
  const { tag, attributes, content, inProgress } = tagInfo;

  switch (tag) {
    case "code-fighter-read":
      return (
        <CodeFighterRead
          node={{
            properties: {
              path: attributes.path || "",
            },
          }}
        >
          {content}
        </CodeFighterRead>
      );
    case "code-fighter-web-search":
      return (
        <CodeFighterWebSearch
          node={{
            properties: {},
          }}
        >
          {content}
        </CodeFighterWebSearch>
      );
    case "code-fighter-web-crawl":
      return (
        <CodeFighterWebCrawl
          node={{
            properties: {},
          }}
        >
          {content}
        </CodeFighterWebCrawl>
      );
    case "code-fighter-code-search":
      return (
        <CodeFighterCodeSearch
          node={{
            properties: {},
          }}
        >
          {content}
        </CodeFighterCodeSearch>
      );
    case "code-fighter-code-search-result":
      return (
        <CodeFighterCodeSearchResult
          node={{
            properties: {},
          }}
        >
          {content}
        </CodeFighterCodeSearchResult>
      );
    case "code-fighter-web-search-result":
      return (
        <CodeFighterWebSearchResult
          node={{
            properties: {
              state: getState({ isStreaming, inProgress }),
            },
          }}
        >
          {content}
        </CodeFighterWebSearchResult>
      );
    case "think":
      return (
        <CodeFighterThink
          node={{
            properties: {
              state: getState({ isStreaming, inProgress }),
            },
          }}
        >
          {content}
        </CodeFighterThink>
      );
    case "code-fighter-write":
      return (
        <CodeFighterWrite
          node={{
            properties: {
              path: attributes.path || "",
              description: attributes.description || "",
              state: getState({ isStreaming, inProgress }),
            },
          }}
        >
          {content}
        </CodeFighterWrite>
      );

    case "code-fighter-rename":
      return (
        <CodeFighterRename
          node={{
            properties: {
              from: attributes.from || "",
              to: attributes.to || "",
            },
          }}
        >
          {content}
        </CodeFighterRename>
      );

    case "code-fighter-delete":
      return (
        <CodeFighterDelete
          node={{
            properties: {
              path: attributes.path || "",
            },
          }}
        >
          {content}
        </CodeFighterDelete>
      );

    case "code-fighter-add-dependency":
      return (
        <CodeFighterAddDependency
          node={{
            properties: {
              packages: attributes.packages || "",
            },
          }}
        >
          {content}
        </CodeFighterAddDependency>
      );

    case "code-fighter-execute-sql":
      return (
        <CodeFighterExecuteSql
          node={{
            properties: {
              state: getState({ isStreaming, inProgress }),
              description: attributes.description || "",
            },
          }}
        >
          {content}
        </CodeFighterExecuteSql>
      );

    case "code-fighter-add-integration":
      return (
        <CodeFighterAddIntegration
          node={{
            properties: {
              provider: attributes.provider || "",
            },
          }}
        >
          {content}
        </CodeFighterAddIntegration>
      );

    case "code-fighter-edit":
      return (
        <CodeFighterEdit
          node={{
            properties: {
              path: attributes.path || "",
              description: attributes.description || "",
              state: getState({ isStreaming, inProgress }),
            },
          }}
        >
          {content}
        </CodeFighterEdit>
      );

    case "code-fighter-search-replace":
      return (
        <CodeFighterSearchReplace
          node={{
            properties: {
              path: attributes.path || "",
              description: attributes.description || "",
              state: getState({ isStreaming, inProgress }),
            },
          }}
        >
          {content}
        </CodeFighterSearchReplace>
      );

    case "code-fighter-codebase-context":
      return (
        <CodeFighterCodebaseContext
          node={{
            properties: {
              files: attributes.files || "",
              state: getState({ isStreaming, inProgress }),
            },
          }}
        >
          {content}
        </CodeFighterCodebaseContext>
      );

    case "code-fighter-mcp-tool-call":
      return (
        <CodeFighterMcpToolCall
          node={{
            properties: {
              serverName: attributes.server || "",
              toolName: attributes.tool || "",
            },
          }}
        >
          {content}
        </CodeFighterMcpToolCall>
      );

    case "code-fighter-mcp-tool-result":
      return (
        <CodeFighterMcpToolResult
          node={{
            properties: {
              serverName: attributes.server || "",
              toolName: attributes.tool || "",
            },
          }}
        >
          {content}
        </CodeFighterMcpToolResult>
      );

    case "code-fighter-output":
      return (
        <CodeFighterOutput
          type={attributes.type as "warning" | "error"}
          message={attributes.message}
        >
          {content}
        </CodeFighterOutput>
      );

    case "code-fighter-problem-report":
      return (
        <CodeFighterProblemSummary summary={attributes.summary}>
          {content}
        </CodeFighterProblemSummary>
      );

    case "code-fighter-chat-summary":
      // Don't render anything for code-fighter-chat-summary
      return null;

    case "code-fighter-command":
      if (attributes.type) {
        const action = {
          id: attributes.type,
        } as SuggestedAction;
        return <>{mapActionToButton(action)}</>;
      }
      return null;

    default:
      return null;
  }
}
