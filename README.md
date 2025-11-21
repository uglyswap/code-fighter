# Code Fighter

Code Fighter is a local, open-source AI code editor with all Pro features unlocked. It's fast, private, and fully under your control.

## Features

- **Local**: Fast, private and no lock-in
- **Bring your own keys**: Use your own AI API keys (OpenAI, Anthropic, Google, etc.)
- **Cross-platform**: Mac, Windows, and Linux
- **All Pro Features**: Turbo Edits V2, Smart Context, Web Search - all enabled by default
- **No limits**: No API key required for Pro features, no credit limits

## Pro Features Included

- **Turbo Edits V2**: Surgical code edits with search/replace
- **Smart Context Mode**: Intelligent file context selection
- **Web Search**: Search the web from within the editor
- **Auto Provider**: Automatic provider selection

## Installation

```bash
# Clone the repository
git clone https://github.com/your-username/code-fighter.git
cd code-fighter

# Install dependencies
npm install

# Run in development mode
npm start

# Build for production
npm run make
```

## Configuration

You need to configure at least one AI provider API key to use Code Fighter:

1. Go to Settings
2. Select your preferred AI provider (OpenAI, Anthropic, Google, etc.)
3. Enter your API key

## Based on Dyad

Code Fighter is a derivative work based on [Dyad](https://github.com/dyad-sh/dyad), an open-source project by Will Chen and the Dyad team.

### Changes from Original

- Rebranded to "Code Fighter"
- All Pro features enabled by default
- No API key requirement for Pro features
- No credit limits
- Deep link protocol changed to `codefighter://`

## License

Licensed under the Apache License, Version 2.0. See [LICENSE](./LICENSE) for details.

Original work Copyright 2025 Dyad Tech, Inc.
Modifications Copyright 2025 Code Fighter Contributors.
