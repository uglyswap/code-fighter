# Complete rebrand script - Replace ALL Dyad references with CodeFighter
# This script must be run from the code-fighter directory

$ErrorActionPreference = "Continue"

Write-Host "=== COMPLETE REBRAND: Dyad -> Code Fighter ===" -ForegroundColor Cyan

# 1. Rename all Dyad*.tsx files to CodeFighter*.tsx
Write-Host "`n--- Renaming component files ---" -ForegroundColor Yellow

$renames = @(
    @{From="src/components/chat/DyadAddDependency.tsx"; To="src/components/chat/CodeFighterAddDependency.tsx"},
    @{From="src/components/chat/DyadAddIntegration.tsx"; To="src/components/chat/CodeFighterAddIntegration.tsx"},
    @{From="src/components/chat/DyadCodebaseContext.tsx"; To="src/components/chat/CodeFighterCodebaseContext.tsx"},
    @{From="src/components/chat/DyadCodeSearch.tsx"; To="src/components/chat/CodeFighterCodeSearch.tsx"},
    @{From="src/components/chat/DyadCodeSearchResult.tsx"; To="src/components/chat/CodeFighterCodeSearchResult.tsx"},
    @{From="src/components/chat/DyadDelete.tsx"; To="src/components/chat/CodeFighterDelete.tsx"},
    @{From="src/components/chat/DyadEdit.tsx"; To="src/components/chat/CodeFighterEdit.tsx"},
    @{From="src/components/chat/DyadExecuteSql.tsx"; To="src/components/chat/CodeFighterExecuteSql.tsx"},
    @{From="src/components/chat/DyadMarkdownParser.tsx"; To="src/components/chat/CodeFighterMarkdownParser.tsx"},
    @{From="src/components/chat/DyadRename.tsx"; To="src/components/chat/CodeFighterRename.tsx"},
    @{From="src/components/chat/DyadSearchReplace.tsx"; To="src/components/chat/CodeFighterSearchReplace.tsx"},
    @{From="src/components/chat/DyadSecurityFinding.tsx"; To="src/components/chat/CodeFighterSecurityFinding.tsx"},
    @{From="src/components/chat/DyadThinking.tsx"; To="src/components/chat/CodeFighterThinking.tsx"},
    @{From="src/components/chat/DyadWebSearch.tsx"; To="src/components/chat/CodeFighterWebSearch.tsx"},
    @{From="src/components/chat/DyadWrite.tsx"; To="src/components/chat/CodeFighterWrite.tsx"},
    @{From="src/components/DyadProSuccessDialog.tsx"; To="src/components/CodeFighterProSuccessDialog.tsx"},
    @{From="scaffold/src/components/made-with-dyad.tsx"; To="scaffold/src/components/made-with-code-fighter.tsx"}
)

foreach ($rename in $renames) {
    if (Test-Path $rename.From) {
        Move-Item -Path $rename.From -Destination $rename.To -Force
        Write-Host "Renamed: $($rename.From) -> $($rename.To)" -ForegroundColor Green
    } else {
        Write-Host "Not found: $($rename.From)" -ForegroundColor Red
    }
}

# 2. Define all replacements
Write-Host "`n--- Performing text replacements ---" -ForegroundColor Yellow

$replacements = @(
    # Component imports and references
    @{Old='DyadAddDependency'; New='CodeFighterAddDependency'},
    @{Old='DyadAddIntegration'; New='CodeFighterAddIntegration'},
    @{Old='DyadCodebaseContext'; New='CodeFighterCodebaseContext'},
    @{Old='DyadCodeSearch'; New='CodeFighterCodeSearch'},
    @{Old='DyadCodeSearchResult'; New='CodeFighterCodeSearchResult'},
    @{Old='DyadDelete'; New='CodeFighterDelete'},
    @{Old='DyadEdit'; New='CodeFighterEdit'},
    @{Old='DyadExecuteSql'; New='CodeFighterExecuteSql'},
    @{Old='DyadMarkdownParser'; New='CodeFighterMarkdownParser'},
    @{Old='DyadRename'; New='CodeFighterRename'},
    @{Old='DyadSearchReplace'; New='CodeFighterSearchReplace'},
    @{Old='DyadSecurityFinding'; New='CodeFighterSecurityFinding'},
    @{Old='DyadThinking'; New='CodeFighterThinking'},
    @{Old='DyadWebSearch'; New='CodeFighterWebSearch'},
    @{Old='DyadWrite'; New='CodeFighterWrite'},
    @{Old='DyadProSuccessDialog'; New='CodeFighterProSuccessDialog'},
    @{Old='DyadProButton'; New='CodeFighterProButton'},
    @{Old='MadeWithDyad'; New='MadeWithCodeFighter'},
    @{Old='made-with-dyad'; New='made-with-code-fighter'},

    # Settings and Pro references
    @{Old='enableDyadPro'; New='enableCodeFighterPro'},
    @{Old='isDyadPro'; New='isCodeFighterPro'},
    @{Old='isDyadProEnabled'; New='isCodeFighterProEnabled'},
    @{Old='hasDyadProKey'; New='hasCodeFighterProKey'},
    @{Old='showDyadProSuccessDialog'; New='showCodeFighterProSuccessDialog'},
    @{Old='setUpDyadPro'; New='setUpCodeFighterPro'},
    @{Old='setUpDyadProvider'; New='setUpCodeFighterProvider'},

    # API and environment variables
    @{Old='DYAD_ENGINE_URL'; New='CODEFIGHTER_ENGINE_URL'},
    @{Old='DYAD_GATEWAY_URL'; New='CODEFIGHTER_GATEWAY_URL'},
    @{Old='Dyad API Key'; New='Code Fighter API Key'},
    @{Old='Set Dyad API Key'; New='Set Code Fighter API Key'},
    @{Old='testdyadkey'; New='testcodefighterkey'},

    # User data and paths
    @{Old='dyad-apps'; New='code-fighter-apps'},
    @{Old='dyad-e2e-tests'; New='code-fighter-e2e-tests'},
    @{Old='$dyadUserDataDir'; New='$codeFighterUserDataDir'},
    @{Old='dyad-generated-app'; New='code-fighter-generated-app'},
    @{Old='dyad-dump-path'; New='code-fighter-dump-path'},

    # Deep links and protocols
    @{Old='dyad-pro-return'; New='code-fighter-pro-return'},
    @{Old='dyad-component-overlays'; New='code-fighter-component-overlays'},

    # Package names
    @{Old='@dyad-sh/supabase-management-js'; New='@code-fighter/supabase-management-js'},
    @{Old='@dyad-sh/nextjs-webpack-component-tagger'; New='@code-fighter/nextjs-webpack-component-tagger'},
    @{Old='@dyad-sh/react-vite-component-tagger'; New='@code-fighter/react-vite-component-tagger'},

    # Tags in content (keep lowercase for XML tags)
    @{Old='<dyad-write'; New='<code-fighter-write'},
    @{Old='</dyad-write>'; New='</code-fighter-write>'},
    @{Old='<dyad-read'; New='<code-fighter-read'},
    @{Old='</dyad-read>'; New='</code-fighter-read>'},
    @{Old='<dyad-delete'; New='<code-fighter-delete'},
    @{Old='</dyad-delete>'; New='</code-fighter-delete>'},
    @{Old='<dyad-rename'; New='<code-fighter-rename'},
    @{Old='</dyad-rename>'; New='</code-fighter-rename>'},
    @{Old='<dyad-edit'; New='<code-fighter-edit'},
    @{Old='</dyad-edit>'; New='</code-fighter-edit>'},
    @{Old='<dyad-search-replace'; New='<code-fighter-search-replace'},
    @{Old='</dyad-search-replace>'; New='</code-fighter-search-replace>'},
    @{Old='<dyad-add-dependency'; New='<code-fighter-add-dependency'},
    @{Old='</dyad-add-dependency>'; New='</code-fighter-add-dependency>'},
    @{Old='<dyad-add-integration'; New='<code-fighter-add-integration'},
    @{Old='</dyad-add-integration>'; New='</code-fighter-add-integration>'},
    @{Old='<dyad-execute-sql'; New='<code-fighter-execute-sql'},
    @{Old='</dyad-execute-sql>'; New='</code-fighter-execute-sql>'},
    @{Old='<dyad-chat-summary'; New='<code-fighter-chat-summary'},
    @{Old='</dyad-chat-summary>'; New='</code-fighter-chat-summary>'},
    @{Old='<dyad-security-finding'; New='<code-fighter-security-finding'},
    @{Old='</dyad-security-finding>'; New='</code-fighter-security-finding>'},
    @{Old='<dyad-file'; New='<code-fighter-file'},
    @{Old='</dyad-file>'; New='</code-fighter-file>'},
    @{Old='<dyad-'; New='<code-fighter-'},

    # Data attributes
    @{Old='data-dyad-id'; New='data-code-fighter-id'},
    @{Old='data-dyad-name'; New='data-code-fighter-name'},

    # Tagger plugin names
    @{Old='dyadTagger'; New='codeFighterTagger'},
    @{Old='dyadTaggerLoader'; New='codeFighterTaggerLoader'},
    @{Old='vite-plugin-dyad-tagger'; New='vite-plugin-code-fighter-tagger'},
    @{Old='[dyad-tagger]'; New='[code-fighter-tagger]'},

    # UI text and messages
    @{Old='Ask Dyad to build'; New='Ask Code Fighter to build'},
    @{Old='Made with Dyad'; New='Made with Code Fighter'},
    @{Old='Welcome to your Dyad app'; New='Welcome to your Code Fighter app'},
    @{Old='Dyad capabilities'; New='Code Fighter capabilities'},
    @{Old='Restart Dyad'; New='Restart Code Fighter'},
    @{Old='Init Dyad app'; New='Init Code Fighter app'},
    @{Old='Dyad app'; New='Code Fighter app'},

    # Error sources
    @{Old='"dyad-app"'; New='"code-fighter-app"'},

    # Test IDs
    @{Old='data-testid="title-bar-dyad-pro-button"'; New='data-testid="title-bar-code-fighter-pro-button"'},

    # Regex patterns in code
    @{Old='/\[dyad\]/i'; New='/\[code-fighter\]/i'},
    @{Old='^\[dyad\]'; New='^\[code-fighter\]'},

    # URLs (keep codefighter.dev)
    @{Old='utm_source=dyad-app'; New='utm_source=code-fighter-app'},

    # Provider labels
    @{Old='/^DyadNeeds Setup$/'; New='/^Code FighterNeeds Setup$/'},
    @{Old='^Dyad'; New='^Code Fighter'},

    # General Dyad -> Code Fighter (be careful with these)
    @{Old='Dyad Pro'; New='Code Fighter Pro'},
    @{Old='Dyad AI'; New='Code Fighter AI'},
    @{Old=' Dyad '; New=' Code Fighter '},
    @{Old='Dyad''s'; New='Code Fighter''s'}
)

# Get all relevant files
$files = Get-ChildItem -Path . -Recurse -Include *.ts,*.tsx,*.json,*.md,*.html,*.css -File |
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

        $originalContent = $content
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

Write-Host "`n=== REBRAND COMPLETE ===" -ForegroundColor Cyan
Write-Host "Total replacements: $totalReplacements" -ForegroundColor Green
Write-Host "`nPlease review the changes and test the application." -ForegroundColor Yellow
