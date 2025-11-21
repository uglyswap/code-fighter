# Fix camelCase dyad patterns
$ErrorActionPreference = "Continue"

Write-Host "=== FIX CAMELCASE: dyad patterns ===" -ForegroundColor Cyan

$replacements = @(
    # Interface/Type names
    @{Old='DyadEngineProvider'; New='CodeFighterEngineProvider'},
    @{Old='DyadOptions'; New='CodeFighterOptions'},
    @{Old='DyadConfig'; New='CodeFighterConfig'},

    # Property names
    @{Old='dyadOptions'; New='codeFighterOptions'},
    @{Old='dyadVersionedFiles'; New='codeFighterVersionedFiles'},
    @{Old='dyadFiles'; New='codeFighterFiles'},
    @{Old='dyadRequestId'; New='codeFighterRequestId'},
    @{Old='dyadDisableFiles'; New='codeFighterDisableFiles'},
    @{Old='dyadMentionedApps'; New='codeFighterMentionedApps'},

    # Function names
    @{Old='createDyadEngine'; New='createCodeFighterEngine'},
    @{Old='getDyadEngine'; New='getCodeFighterEngine'},
    @{Old='initDyad'; New='initCodeFighter'},

    # More patterns from code
    @{Old='parsedBody.dyadVersionedFiles'; New='parsedBody.codeFighterVersionedFiles'},
    @{Old='parsedBody.dyadFiles'; New='parsedBody.codeFighterFiles'},
    @{Old='parsedBody.dyadRequestId'; New='parsedBody.codeFighterRequestId'},
    @{Old='parsedBody.dyadDisableFiles'; New='parsedBody.codeFighterDisableFiles'},
    @{Old='parsedBody.dyadMentionedApps'; New='parsedBody.codeFighterMentionedApps'},

    # Remaining patterns
    @{Old='dyadEnabled'; New='codeFighterEnabled'},
    @{Old='dyadProvider'; New='codeFighterProvider'},
    @{Old='dyadClient'; New='codeFighterClient'},
    @{Old='dyadResponse'; New='codeFighterResponse'},
    @{Old='dyadRequest'; New='codeFighterRequest'},
    @{Old='dyadApi'; New='codeFighterApi'},
    @{Old='dyadUrl'; New='codeFighterUrl'},
    @{Old='dyadKey'; New='codeFighterKey'},
    @{Old='dyadToken'; New='codeFighterToken'},
    @{Old='dyadUser'; New='codeFighterUser'},
    @{Old='dyadAuth'; New='codeFighterAuth'},
    @{Old='dyadSession'; New='codeFighterSession'},
    @{Old='dyadChat'; New='codeFighterChat'},
    @{Old='dyadMessage'; New='codeFighterMessage'},
    @{Old='dyadModel'; New='codeFighterModel'},
    @{Old='dyadStream'; New='codeFighterStream'},
    @{Old='dyadContext'; New='codeFighterContext'},
    @{Old='dyadState'; New='codeFighterState'},
    @{Old='dyadData'; New='codeFighterData'},
    @{Old='dyadResult'; New='codeFighterResult'},
    @{Old='dyadError'; New='codeFighterError'},
    @{Old='dyadStatus'; New='codeFighterStatus'},
    @{Old='dyadPath'; New='codeFighterPath'},
    @{Old='dyadDir'; New='codeFighterDir'},
    @{Old='dyadFile'; New='codeFighterFile'},
    @{Old='dyadName'; New='codeFighterName'},
    @{Old='dyadId'; New='codeFighterId'},
    @{Old='dyadType'; New='codeFighterType'},
    @{Old='dyadValue'; New='codeFighterValue'},
    @{Old='dyadContent'; New='codeFighterContent'},
    @{Old='dyadText'; New='codeFighterText'},
    @{Old='dyadHtml'; New='codeFighterHtml'},
    @{Old='dyadJson'; New='codeFighterJson'},
    @{Old='dyadXml'; New='codeFighterXml'},
    @{Old='dyadCode'; New='codeFighterCode'},
    @{Old='dyadScript'; New='codeFighterScript'},
    @{Old='dyadStyle'; New='codeFighterStyle'},
    @{Old='dyadClass'; New='codeFighterClass'},
    @{Old='dyadEvent'; New='codeFighterEvent'},
    @{Old='dyadHandler'; New='codeFighterHandler'},
    @{Old='dyadCallback'; New='codeFighterCallback'},
    @{Old='dyadFunction'; New='codeFighterFunction'},
    @{Old='dyadMethod'; New='codeFighterMethod'},
    @{Old='dyadParam'; New='codeFighterParam'},
    @{Old='dyadArg'; New='codeFighterArg'},
    @{Old='dyadOption'; New='codeFighterOption'},
    @{Old='dyadSetting'; New='codeFighterSetting'},
    @{Old='dyadConfig'; New='codeFighterConfig'},
    @{Old='dyadEnv'; New='codeFighterEnv'},
    @{Old='dyadPort'; New='codeFighterPort'},
    @{Old='dyadHost'; New='codeFighterHost'},
    @{Old='dyadOrigin'; New='codeFighterOrigin'},
    @{Old='dyadDomain'; New='codeFighterDomain'},
    @{Old='dyadScheme'; New='codeFighterScheme'},
    @{Old='dyadProtocol'; New='codeFighterProtocol'},

    # Caps patterns
    @{Old='DYAD_'; New='CODE_FIGHTER_'},
    @{Old='Dyad'; New='CodeFighter'},
    @{Old='dyad'; New='code-fighter'}
)

$files = Get-ChildItem -Path . -Recurse -Include *.ts,*.tsx,*.json,*.js -File |
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

Write-Host "`n=== CAMELCASE FIX COMPLETE ===" -ForegroundColor Cyan
Write-Host "Total replacements: $totalReplacements" -ForegroundColor Green
