# Fix remaining dyad references - specific XML tags and patterns
$ErrorActionPreference = "Continue"

Write-Host "=== FIX REMAINING: Specific patterns ===" -ForegroundColor Cyan

# All remaining specific replacements
$replacements = @(
    # XML tag names (with quotes for string literals)
    @{Old='"dyad-add-dependency"'; New='"code-fighter-add-dependency"'},
    @{Old='"dyad-execute-sql"'; New='"code-fighter-execute-sql"'},
    @{Old='"dyad-add-integration"'; New='"code-fighter-add-integration"'},
    @{Old='"dyad-output"'; New='"code-fighter-output"'},
    @{Old='"dyad-problem-report"'; New='"code-fighter-problem-report"'},
    @{Old='"dyad-chat-summary"'; New='"code-fighter-chat-summary"'},
    @{Old='"dyad-search-replace"'; New='"code-fighter-search-replace"'},
    @{Old='"dyad-codebase-context"'; New='"code-fighter-codebase-context"'},
    @{Old='"dyad-web-search-result"'; New='"code-fighter-web-search-result"'},
    @{Old='"dyad-web-search"'; New='"code-fighter-web-search"'},
    @{Old='"dyad-web-crawl"'; New='"code-fighter-web-crawl"'},
    @{Old='"dyad-code-search-result"'; New='"code-fighter-code-search-result"'},
    @{Old='"dyad-code-search"'; New='"code-fighter-code-search"'},
    @{Old='"dyad-command"'; New='"code-fighter-command"'},
    @{Old='"dyad-mcp-tool-call"'; New='"code-fighter-mcp-tool-call"'},
    @{Old='"dyad-mcp-tool-result"'; New='"code-fighter-mcp-tool-result"'},
    @{Old='"dyad-security-finding"'; New='"code-fighter-security-finding"'},
    @{Old='"dyad-think"'; New='"code-fighter-think"'},
    @{Old='"dyad-file"'; New='"code-fighter-file"'},
    @{Old='"dyad-read"'; New='"code-fighter-read"'},
    @{Old='"dyad-write"'; New='"code-fighter-write"'},
    @{Old='"dyad-delete"'; New='"code-fighter-delete"'},
    @{Old='"dyad-rename"'; New='"code-fighter-rename"'},
    @{Old='"dyad-edit"'; New='"code-fighter-edit"'},
    @{Old='"dyad-token-savings"'; New='"code-fighter-token-savings"'},

    # Case statements without quotes
    @{Old='case "dyad-web-search":'; New='case "code-fighter-web-search":'},
    @{Old='case "dyad-web-crawl":'; New='case "code-fighter-web-crawl":'},
    @{Old='case "dyad-code-search":'; New='case "code-fighter-code-search":'},
    @{Old='case "dyad-code-search-result":'; New='case "code-fighter-code-search-result":'},
    @{Old='case "dyad-web-search-result":'; New='case "code-fighter-web-search-result":'},
    @{Old='case "dyad-add-dependency":'; New='case "code-fighter-add-dependency":'},
    @{Old='case "dyad-execute-sql":'; New='case "code-fighter-execute-sql":'},
    @{Old='case "dyad-add-integration":'; New='case "code-fighter-add-integration":'},
    @{Old='case "dyad-search-replace":'; New='case "code-fighter-search-replace":'},
    @{Old='case "dyad-codebase-context":'; New='case "code-fighter-codebase-context":'},
    @{Old='case "dyad-mcp-tool-call":'; New='case "code-fighter-mcp-tool-call":'},
    @{Old='case "dyad-mcp-tool-result":'; New='case "code-fighter-mcp-tool-result":'},
    @{Old='case "dyad-output":'; New='case "code-fighter-output":'},
    @{Old='case "dyad-problem-report":'; New='case "code-fighter-problem-report":'},
    @{Old='case "dyad-chat-summary":'; New='case "code-fighter-chat-summary":'},
    @{Old='case "dyad-command":'; New='case "code-fighter-command":'},

    # URL patterns
    @{Old='DYAD_ENGINE_URL'; New='CODE_FIGHTER_ENGINE_URL'},
    @{Old='DYAD_GATEWAY_URL'; New='CODE_FIGHTER_GATEWAY_URL'},
    @{Old='DYAD_API_KEY'; New='CODE_FIGHTER_API_KEY'},
    @{Old='DYAD_PRO_'; New='CODE_FIGHTER_PRO_'},

    # Variable names
    @{Old='dyadEngineUrl'; New='codeFighterEngineUrl'},
    @{Old='dyadGatewayUrl'; New='codeFighterGatewayUrl'},
    @{Old='dyadApiKey'; New='codeFighterApiKey'},
    @{Old='dyadTagTypes'; New='codeFighterTagTypes'},
    @{Old='dyadParsedTag'; New='codeFighterParsedTag'},
    @{Old='parseDyadTag'; New='parseCodeFighterTag'},
    @{Old='isDyadTagName'; New='isCodeFighterTagName'},
    @{Old='dyadTagName'; New='codeFighterTagName'},
    @{Old='DyadTagName'; New='CodeFighterTagName'},
    @{Old='getDyadTag'; New='getCodeFighterTag'},

    # Provider names
    @{Old='dyad:'; New='code-fighter:'},
    @{Old='"dyad"'; New='"code-fighter"'},
    @{Old="'dyad'"; New="'code-fighter'"},

    # Comments
    @{Old='for dyad-chat-summary'; New='for code-fighter-chat-summary'},
    @{Old='// dyad'; New='// code-fighter'},

    # Upgrade and version handlers
    @{Old='dyadDefaultOrigin'; New='codeFighterDefaultOrigin'},
    @{Old='DYAD_DEFAULT_ORIGIN'; New='CODE_FIGHTER_DEFAULT_ORIGIN'},

    # Settings fields
    @{Old="enableDyadPro"; New="enableCodeFighterPro"},
    @{Old="dyadProApiKey"; New="codeFighterProApiKey"},

    # Preload
    @{Old='postToDyad'; New='postToCodeFighter'},
    @{Old='receiveFromDyad'; New='receiveFromCodeFighter'},

    # Copy/paste
    @{Old='removeDyadTags'; New='removeCodeFighterTags'},
    @{Old='convertDyad'; New='convertCodeFighter'},
    @{Old='stripDyad'; New='stripCodeFighter'},

    # Generic patterns that may have been missed
    @{Old='dyad_tag'; New='code_fighter_tag'},
    @{Old='dyadTag'; New='codeFighterTag'},
    @{Old='DyadTag'; New='CodeFighterTag'},
    @{Old='dyad-'; New='code-fighter-'}
)

# Get all relevant files
$files = Get-ChildItem -Path . -Recurse -Include *.ts,*.tsx,*.json,*.md,*.js -File |
    Where-Object {
        $_.FullName -notmatch 'node_modules' -and
        $_.FullName -notmatch '\.git' -and
        $_.FullName -notmatch 'package-lock'
    }

$totalReplacements = 0

foreach ($file in $files) {
    try {
        $content = Get-Content -Path $file.FullName -Raw -ErrorAction Stop
        if ($null -eq $content) { continue }

        $fileReplacements = 0

        foreach ($replacement in $replacements) {
            $count = ([regex]::Matches($content, [regex]::Escape($replacement.Old))).Count
            if ($count -gt 0) {
                $content = $content -replace [regex]::Escape($replacement.Old), $replacement.New
                $fileReplacements += $count
            }
        }

        if ($fileReplacements -gt 0) {
            Set-Content -Path $file.FullName -Value $content -NoNewline
            Write-Host "Updated $($file.Name): $fileReplacements" -ForegroundColor Green
            $totalReplacements += $fileReplacements
        }
    } catch {
        Write-Host "Error: $($file.Name): $_" -ForegroundColor Red
    }
}

Write-Host "`n=== FIX COMPLETE ===" -ForegroundColor Cyan
Write-Host "Total replacements: $totalReplacements" -ForegroundColor Green
