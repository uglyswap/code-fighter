# Ultra-aggressive rebrand - Replace ALL remaining Dyad/dyad variants
$ErrorActionPreference = "Continue"

Write-Host "=== ULTRA REBRAND: All Dyad -> Code Fighter ===" -ForegroundColor Cyan

# Master list of ALL replacements
$replacements = @(
    # Case-sensitive replacements first (more specific)
    @{Old='DyadProvider'; New='CodeFighterProvider'},
    @{Old='DyadTagParser'; New='CodeFighterTagParser'},
    @{Old='DYAD_PRO_LAUNCH_DATE'; New='CODE_FIGHTER_PRO_LAUNCH_DATE'},
    @{Old='DYAD_DEFAULT_ORIGIN'; New='CODE_FIGHTER_DEFAULT_ORIGIN'},
    @{Old='dyadProLaunchDate'; New='codeFighterProLaunchDate'},

    # Preload and IPC
    @{Old='postMessageToDyad'; New='postMessageToCodeFighter'},
    @{Old='messageFromDyad'; New='messageFromCodeFighter'},
    @{Old='sendToDyad'; New='sendToCodeFighter'},
    @{Old='fromDyadIpc'; New='fromCodeFighterIpc'},

    # Pro related
    @{Old='proxyDyadProRequest'; New='proxyCodeFighterProRequest'},
    @{Old='dyadProApiKey'; New='codeFighterProApiKey'},
    @{Old='getDyadProApiKey'; New='getCodeFighterProApiKey'},
    @{Old='setDyadProApiKey'; New='setCodeFighterProApiKey'},
    @{Old='hasDyadProKey'; New='hasCodeFighterProKey'},
    @{Old='isDyadProEnabled'; New='isCodeFighterProEnabled'},
    @{Old='enableDyadPro'; New='enableCodeFighterPro'},
    @{Old='DYAD_PRO'; New='CODE_FIGHTER_PRO'},

    # Tags
    @{Old='DyadTagType'; New='CodeFighterTagType'},
    @{Old='DyadTag'; New='CodeFighterTag'},
    @{Old='dyadTagType'; New='codeFighterTagType'},
    @{Old='dyadTags'; New='codeFighterTags'},
    @{Old='parseDyadContent'; New='parseCodeFighterContent'},
    @{Old='extractDyadTags'; New='extractCodeFighterTags'},
    @{Old='parseDyadResponse'; New='parseCodeFighterResponse'},

    # URLs and Environment
    @{Old='DYAD_ENGINE_URL'; New='CODE_FIGHTER_ENGINE_URL'},
    @{Old='DYAD_GATEWAY_URL'; New='CODE_FIGHTER_GATEWAY_URL'},
    @{Old='dyad-app'; New='code-fighter-app'},
    @{Old='"dyad"'; New='"code-fighter"'},

    # Component names (already renamed but references may remain)
    @{Old='DyadWrite'; New='CodeFighterWrite'},
    @{Old='DyadRead'; New='CodeFighterRead'},
    @{Old='DyadDelete'; New='CodeFighterDelete'},
    @{Old='DyadRename'; New='CodeFighterRename'},
    @{Old='DyadEdit'; New='CodeFighterEdit'},
    @{Old='DyadExecuteSql'; New='CodeFighterExecuteSql'},
    @{Old='DyadAddDependency'; New='CodeFighterAddDependency'},
    @{Old='DyadAddIntegration'; New='CodeFighterAddIntegration'},
    @{Old='DyadSearchReplace'; New='CodeFighterSearchReplace'},
    @{Old='DyadCodebaseContext'; New='CodeFighterCodebaseContext'},
    @{Old='DyadCodeSearch'; New='CodeFighterCodeSearch'},
    @{Old='DyadCodeSearchResult'; New='CodeFighterCodeSearchResult'},
    @{Old='DyadWebSearch'; New='CodeFighterWebSearch'},
    @{Old='DyadSecurityFinding'; New='CodeFighterSecurityFinding'},
    @{Old='DyadThinking'; New='CodeFighterThinking'},
    @{Old='DyadMarkdownParser'; New='CodeFighterMarkdownParser'},
    @{Old='DyadProSuccessDialog'; New='CodeFighterProSuccessDialog'},
    @{Old='DyadOutput'; New='CodeFighterOutput'},
    @{Old='DyadProblemSummary'; New='CodeFighterProblemSummary'},
    @{Old='DyadThink'; New='CodeFighterThink'},
    @{Old='DyadTokenSavings'; New='CodeFighterTokenSavings'},
    @{Old='DyadWebCrawl'; New='CodeFighterWebCrawl'},
    @{Old='DyadWebSearchResult'; New='CodeFighterWebSearchResult'},
    @{Old='DyadMcpToolCall'; New='CodeFighterMcpToolCall'},
    @{Old='DyadMcpToolResult'; New='CodeFighterMcpToolResult'},
    @{Old='DyadProButton'; New='CodeFighterProButton'},
    @{Old='MadeWithDyad'; New='MadeWithCodeFighter'},

    # XML tags
    @{Old='<dyad-'; New='<code-fighter-'},
    @{Old='</dyad-'; New='</code-fighter-'},
    @{Old='dyad-write'; New='code-fighter-write'},
    @{Old='dyad-read'; New='code-fighter-read'},
    @{Old='dyad-delete'; New='code-fighter-delete'},
    @{Old='dyad-rename'; New='code-fighter-rename'},
    @{Old='dyad-edit'; New='code-fighter-edit'},
    @{Old='dyad-file'; New='code-fighter-file'},

    # Data attributes
    @{Old='data-dyad-'; New='data-code-fighter-'},

    # Comments and strings
    @{Old='// Dyad'; New='// Code Fighter'},
    @{Old='/* Dyad'; New='/* Code Fighter'},
    @{Old='* Dyad'; New='* Code Fighter'},

    # Generic patterns (careful with order)
    @{Old='dyadApp'; New='codeFighterApp'},
    @{Old='DyadApp'; New='CodeFighterApp'},
    @{Old='dyad_'; New='code_fighter_'},
    @{Old='Dyad_'; New='CodeFighter_'},
    @{Old='-dyad-'; New='-code-fighter-'},
    @{Old='-dyad.'; New='-code-fighter.'},
    @{Old='/dyad/'; New='/code-fighter/'},
    @{Old='[dyad]'; New='[code-fighter]'},
    @{Old='(dyad)'; New='(code-fighter)'},
    @{Old='"Dyad'; New='"Code Fighter'},
    @{Old="'Dyad"; New="'Code Fighter"},
    @{Old=' Dyad '; New=' Code Fighter '},
    @{Old=' Dyad.'; New=' Code Fighter.'},
    @{Old=' Dyad,'; New=' Code Fighter,'},
    @{Old=' Dyad''s'; New=' Code Fighter''s'},
    @{Old='Dyad''s '; New='Code Fighter''s '},
    @{Old=' dyad '; New=' code-fighter '},

    # Specific UI text
    @{Old='Ask Dyad'; New='Ask Code Fighter'},
    @{Old='from Dyad'; New='from Code Fighter'},
    @{Old='to Dyad'; New='to Code Fighter'},
    @{Old='in Dyad'; New='in Code Fighter'},
    @{Old='with Dyad'; New='with Code Fighter'},
    @{Old='by Dyad'; New='by Code Fighter'},
    @{Old='of Dyad'; New='of Code Fighter'},
    @{Old='Made with Dyad'; New='Made with Code Fighter'},
    @{Old='Powered by Dyad'; New='Powered by Code Fighter'},
    @{Old='Dyad Pro'; New='Code Fighter Pro'},
    @{Old='Dyad AI'; New='Code Fighter AI'},
    @{Old='Dyad app'; New='Code Fighter app'},

    # Executables
    @{Old='dyad.exe'; New='code-fighter.exe'}
)

# Get all relevant files
$files = Get-ChildItem -Path . -Recurse -Include *.ts,*.tsx,*.json,*.md,*.html,*.css,*.js -File |
    Where-Object {
        $_.FullName -notmatch 'node_modules' -and
        $_.FullName -notmatch '\.git' -and
        $_.FullName -notmatch 'package-lock'
    }

$totalReplacements = 0
$filesUpdated = 0

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
            $filesUpdated++
        }
    } catch {
        Write-Host "Error: $($file.Name): $_" -ForegroundColor Red
    }
}

Write-Host "`n=== ULTRA REBRAND COMPLETE ===" -ForegroundColor Cyan
Write-Host "Files updated: $filesUpdated" -ForegroundColor Green
Write-Host "Total replacements: $totalReplacements" -ForegroundColor Green
