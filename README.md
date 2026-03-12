# Concrete Visions

Architecture photography portfolio built with Hugo. Dark brutalist aesthetic, no JavaScript frameworks.

## Quick Start

```bash
# Dev server — live reload, drafts enabled, localhost:1313
docker compose --profile dev up

# Production — nginx, localhost:8080
docker compose --profile prod up --build
```

## Adding a Gallery Series

Create a new file in `content/gallery/` (copy an existing one as template). Fill in `title`, `location`, `year`, `coverImage`, and `images` array. See `content/gallery/brutalist-towers.md` for reference.

## Project Structure

```
config.toml          Site config (title, menu, social links)
content/             Markdown content
  gallery/*.md       Photo series (frontmatter + body text)
  about/_index.md    About page
layouts/             Hugo templates (no themes directory)
static/css/style.css All styling — single vanilla CSS file
```
