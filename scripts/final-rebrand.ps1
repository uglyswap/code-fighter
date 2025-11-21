# Final rebrand script - Rename remaining files and replace all references
$ErrorActionPreference = "Continue"

Write-Host "=== FINAL REBRAND: All remaining Dyad -> Code Fighter ===" -ForegroundColor Cyan

# 1. Rename remaining component files
Write-Host "`n--- Renaming remaining component files ---" -ForegroundColor Yellow

$renames = @(
    @{From="src/components/chat/DyadMcpToolCall.tsx"; To="src/components/chat/CodeFighterMcpToolCall.tsx"},
    @{From="src/components/chat/DyadMcpToolResult.tsx"; To="src/components/chat/CodeFighterMcpToolResult.tsx"},
    @{From="src/components/chat/DyadOutput.tsx"; To="src/components/chat/CodeFighterOutput.tsx"},
    @{From="src/components/chat/DyadProblemSummary.tsx"; To="src/components/chat/CodeFighterProblemSummary.tsx"},
    @{From="src/components/chat/DyadRead.tsx"; To="src/components/chat/CodeFighterRead.tsx"},
    @{From="src/components/chat/DyadThink.tsx"; To="src/components/chat/CodeFighterThink.tsx"},
    @{From="src/components/chat/DyadTokenSavings.tsx"; To="src/components/chat/CodeFighterTokenSavings.tsx"},
    @{From="src/components/chat/DyadWebCrawl.tsx"; To="src/components/chat/CodeFighterWebCrawl.tsx"},
    @{From="src/components/chat/DyadWebSearchResult.tsx"; To="src/components/chat/CodeFighterWebSearchResult.tsx"},
    @{From="src/ipc/utils/dyad_tag_parser.ts"; To="src/ipc/utils/code_fighter_tag_parser.ts"},
    @{From="worker/dyad-component-selector-client.js"; To="worker/code-fighter-component-selector-client.js"},
    @{From="worker/dyad-shim.js"; To="worker/code-fighter-shim.js"},
    @{From="e2e-tests/dyad_tags_parsing.spec.ts"; To="e2e-tests/code_fighter_tags_parsing.spec.ts"},
    @{From="e2e-tests/fixtures/dyad-write-angle.md"; To="e2e-tests/fixtures/code-fighter-write-angle.md"},
    @{From="e2e-tests/fixtures/edit-made-with-dyad.md"; To="e2e-tests/fixtures/edit-made-with-code-fighter.md"}
)

foreach ($rename in $renames) {
    if (Test-Path $rename.From) {
        Move-Item -Path $rename.From -Destination $rename.To -Force
        Write-Host "Renamed: $($rename.From) -> $($rename.To)" -ForegroundColor Green
    } else {
        Write-Host "Not found: $($rename.From)" -ForegroundColor Red
    }
}

# 2. Define ALL replacements including new ones
Write-Host "`n--- Performing comprehensive text replacements ---" -ForegroundColor Yellow

$replacements = @(
    # New component names
    @{Old='DyadMcpToolCall'; New='CodeFighterMcpToolCall'},
    @{Old='DyadMcpToolResult'; New='CodeFighterMcpToolResult'},
    @{Old='DyadOutput'; New='CodeFighterOutput'},
    @{Old='DyadProblemSummary'; New='CodeFighterProblemSummary'},
    @{Old='DyadRead'; New='CodeFighterRead'},
    @{Old='DyadThink'; New='CodeFighterThink'},
    @{Old='DyadTokenSavings'; New='CodeFighterTokenSavings'},
    @{Old='DyadWebCrawl'; New='CodeFighterWebCrawl'},
    @{Old='DyadWebSearchResult'; New='CodeFighterWebSearchResult'},

    # File references
    @{Old='dyad_tag_parser'; New='code_fighter_tag_parser'},
    @{Old='dyad-component-selector-client'; New='code-fighter-component-selector-client'},
    @{Old='dyad-shim'; New='code-fighter-shim'},
    @{Old='dyad_tags_parsing'; New='code_fighter_tags_parsing'},
    @{Old='dyad-write-angle'; New='code-fighter-write-angle'},
    @{Old='edit-made-with-dyad'; New='edit-made-with-code-fighter'},
    @{Old='dyadwrite'; New='codefighterwrite'},
    @{Old='edited-mde-with-dyad'; New='edited-mde-with-code-fighter'},

    # Variable names
    @{Old='dyadId'; New='codeFighterId'},
    @{Old='dyadTags'; New='codeFighterTags'},
    @{Old='parseDyadTags'; New='parseCodeFighterTags'},
    @{Old='getDyadTagType'; New='getCodeFighterTagType'},
    @{Old='extractDyadTags'; New='extractCodeFighterTags'},
    @{Old='DyadTagType'; New='CodeFighterTagType'},
    @{Old='DyadTag'; New='CodeFighterTag'},
    @{Old='isDyadTag'; New='isCodeFighterTag'},

    # Test related
    @{Old='tc=dyad-write-angle'; New='tc=code-fighter-write-angle'},
    @{Old='tc=edit-made-with-dyad'; New='tc=edit-made-with-code-fighter'},

    # Settings
    @{Old='enableDyadPro'; New='enableCodeFighterPro'},
    @{Old='DyadNeeds Setup'; New='Code Fighter Needs Setup'},

    # Messages and UI text
    @{Old='restartDyad'; New='restartCodeFighter'},
    @{Old='Restart Dyad'; New='Restart Code Fighter'},
    @{Old='Dyad AI credits'; New='Code Fighter AI credits'},
    @{Old='Dyad Pro'; New='Code Fighter Pro'},
    @{Old='Dyad app'; New='Code Fighter app'},
    @{Old='dyad.exe'; New='code-fighter.exe'},

    # Any remaining dyad patterns
    @{Old='isDyad'; New='isCodeFighter'},
    @{Old='fromDyad'; New='fromCodeFighter'},
    @{Old='toDyad'; New='toCodeFighter'},
    @{Old='DyadConfig'; New='CodeFighterConfig'},
    @{Old='dyadConfig'; New='codeFighterConfig'},
    @{Old='dyad-app'; New='code-fighter-app'},

    # Documentation specific
    @{Old='Dyad is still a very early-stage project'; New='Code Fighter is still a very early-stage project'},
    @{Old='in Dyad'; New='in Code Fighter'},
    @{Old="Dyad's sub-reddit"; New="Code Fighter's discussion forum"},
    @{Old='Dyad is an Electron app'; New='Code Fighter is an Electron app'},
    @{Old='workflow of Dyad'; New='workflow of Code Fighter'},
    @{Old='Dyad essentially'; New='Code Fighter essentially'},
    @{Old="Dyad on the other hand"; New="Code Fighter on the other hand"},
    @{Old="keep Dyad"; New="keep Code Fighter"},
    @{Old="does Dyad send"; New="does Code Fighter send"},
    @{Old="Dyad''s"; New="Code Fighter''s"},
    @{Old="use Dyad"; New="use Code Fighter"},
    @{Old='version of Dyad'; New='version of Code Fighter'}
)

# Get all relevant files
$files = Get-ChildItem -Path . -Recurse -Include *.ts,*.tsx,*.json,*.md,*.html,*.css,*.js,*.yml -File |
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
            Write-Host "Updated $($file.FullName): $fileReplacements replacements" -ForegroundColor Green
            $totalReplacements += $fileReplacements
        }
    } catch {
        Write-Host "Error processing $($file.FullName): $_" -ForegroundColor Red
    }
}

Write-Host "`n=== FINAL REBRAND COMPLETE ===" -ForegroundColor Cyan
Write-Host "Total replacements: $totalReplacements" -ForegroundColor Green
