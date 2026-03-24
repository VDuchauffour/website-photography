# AGENTS.md — Concrete Visions (Hugo Photography Portfolio)

## Project Overview

Static photography portfolio built with **Hugo** (no themes, no JS frameworks). Dark brutalist aesthetic for architecture photography. Three pages: Home, Series (with individual series), About.

## Build & Dev Commands

Hugo is not globally installed. Use nix:

```bash
# Dev server (with drafts)
nix-shell -p hugo --run "hugo server -D"

# Production build
nix-shell -p hugo --run "hugo --gc --minify"

# Build output lands in public/
```

There are **no tests, no linter, no CI pipeline**. Verification is: `hugo` exits 0 and produces expected page count (currently 16 pages).

## Project Structure

```
config.toml                    # Site config (TOML only — not YAML, not JSON)
content/
  _index.md                    # Homepage (minimal frontmatter)
  about/_index.md              # About page (branch bundle)
  series/
    _index.md                  # Series listing page (branch bundle)
    brutalist-towers.md        # Individual series (leaf pages)
    ...
layouts/
  _default/baseof.html         # Base template — all pages inherit from this
  index.html                   # Homepage layout
  series/list.html             # Series grid listing
  series/single.html           # Individual series page
  about/list.html              # About page layout
  _default/taxonomy.html       # Tags/categories (minimal)
  partials/header.html         # Nav bar (fixed, gradient bg)
  partials/footer.html         # Social SVG icons + copyright
static/css/style.css           # ALL styling — single CSS file, no preprocessor
archetypes/default.md          # Scaffolding template for new series entries
infra/
  providers.tf                 # Scaleway provider config
  main.tf                      # Object Storage bucket, public-read policy, CORS
  variables.tf                 # Input variables (credentials, region, bucket name)
  outputs.tf                   # Bucket name, endpoint, public base URL
  terraform.tfvars.example     # Template for secrets — copy to terraform.tfvars
  scripts/upload.sh            # Upload images via s3cmd (configured by scw CLI)
```

No `themes/` directory is used — all layouts live at project level. Do NOT create theme directories.

## Image Storage

Images are hosted on **Scaleway Object Storage** (S3-compatible) and referenced as external URLs in frontmatter. No images are stored in the git repo.

**Bucket URL pattern:** `https://{bucket}.s3.{region}.scw.cloud/{key}`

Example in frontmatter:

```yaml
coverImage: https://photos.s3.fr-par.scw.cloud/series/brutalist-towers/cover.jpg
```

### Infrastructure (Terraform)

Infra lives in `infra/`. Managed with OpenTofu/Terraform.

```bash
# Init + apply
cd infra
cp terraform.tfvars.example terraform.tfvars # fill in Scaleway API keys
tofu init && tofu apply
```

Provisioned resources:

- `scaleway_object_bucket` — photo storage with CORS and lifecycle rules
- `scaleway_object_bucket_policy` — public-read access for all objects

### Uploading Images

Requires `scw` CLI and `s3cmd`:

```bash
# One-time: configure s3cmd via Scaleway CLI
scw object config install type=s3cmd

# Upload a series
./infra/scripts/upload.sh ./photos/brutalist-towers series/brutalist-towers
```

Images land at `s3://{bucket}/series/{series-name}/` and are publicly accessible immediately.

**File naming convention:** keep filenames lowercase, hyphenated, no spaces. Example: `bt-01.jpg`, `cover.jpg`.

## Content Authoring

### Series Frontmatter Schema

Every file in `content/series/*.md` must follow this exact schema:

```yaml
---
title: "Series Name"
date: 2025-11-15            # Used for sort order
location: "City, Country"
year: "2024–2025"           # Display string, can span years
coverImage: "https://..."   # Thumbnail for series grid (800x600)
images:                     # Array of photos in the series
  - src: "https://..."      # Full-size image URL (1200x800)
    alt: "Descriptive text"
    caption: "Location or technical detail"
---

Body text: 1–2 paragraphs describing the series. No lorem ipsum.
```

### Branch Bundles

- `content/series/_index.md` — only needs `title` and `description`
- `content/about/_index.md` — `title`, `description`, then markdown body
- `content/_index.md` — `title`, `description` only (layout pulls from config params)

### Adding a New Series

```bash
nix-shell -p hugo --run "hugo new series/new-series-name.md"
```

This uses `archetypes/default.md` which pre-fills coverImage with a picsum.photos URL seeded from the filename.

## Config (config.toml)

Site-wide params live under `[params]`:

- `heroImage1`, `heroImage2` — homepage hero images
- `instagram`, `vimeo`, `email` — social links (footer renders SVG icons conditionally)
- `tagline` — homepage subtitle
- `copyright` — footer text

Menu items under `[menu]` → `[[menu.main]]` with `name`, `url`, `weight`.

Goldmark renderer has `unsafe = true` (allows raw HTML in markdown).

## CSS Conventions

Single file: `static/css/style.css` (784 lines). No Sass, no PostCSS, no Tailwind.

### Design Tokens (CSS Custom Properties)

All colors, fonts, spacing, and transitions are defined in `:root`:

| Token | Value | Usage |
|---|---|---|
| `--black` | `#000000` | Page background |
| `--white` | `#ffffff` | Primary text, headings |
| `--gray-200` | `#cccccc` | Body text |
| `--gray-400` | `#8a8a8a` | Subdued text, labels |
| `--gray-600` | `#555555` | Muted text, captions |
| `--gray-800` | `#1a1a1a` | Borders, dividers |
| `--accent` | `#b8a88a` | Gold accent (title line 2, links, CTA hover) |
| `--accent-dim` | `#8a7d6a` | Dimmed accent (borders) |
| `--font-display` | Archivo Black | Headings, site logo |
| `--font-body` | Barlow (300/400/500/600) | Body text, nav, labels |

**Always use CSS variables** — never hardcode color/font values.

### Naming Convention

BEM-influenced flat classes. Pattern: `.component-element--modifier`

```
.hero-img--portrait    .title-line--1    .series-list-title
.hero-img--landscape   .title-line--2    .series-list-location
```

No nesting beyond `.parent:hover .child` for interactive states.

### Spacing

Use spacing tokens exclusively: `--space-xs` (0.5rem) through `--space-2xl` (8rem). Never use raw `px` or `rem` values for padding/margin/gap.

### Responsive Breakpoints

```css
/* Mobile: ≤640px   — 1 column, compact spacing */
/* Tablet: ≤1024px  — 2 columns, medium spacing */
/* Desktop: default — 1 column (series), 3 (featured) */
/* Large:  ≥1400px  — 4 columns (series) */
```

Spacing tokens are redefined at each breakpoint (no separate utility classes). Grid columns collapse progressively.

### Image Treatment

All series/featured images use:

- `object-fit: cover` with fixed `aspect-ratio`
- Base state: `filter: grayscale(20-30%) brightness(0.9)`
- Hover state: `filter: grayscale(0%) brightness(1)` + `transform: scale(1.03-1.05)`
- Transitions use `--transition-slow` (0.6s cubic-bezier)

### Animations

Two keyframes defined: `slideUp` and `fadeIn`. Used only on homepage hero elements with staggered `animation-delay`. CSS-only — no JavaScript animation libraries.

## HTML / Template Conventions

### Template Pattern

Every page layout follows:

```html
{{ define "main" }}
<section class="page-name">
  <!-- content -->
</section>
{{ end }}
```

### Hugo Functions Used

- `{{ partial "name.html" . }}` — include partials (always pass context `.`)
- `{{ with .Params.field }}` — conditional rendering (preferred over `{{ if }}` for simple presence checks)
- `{{ range .Pages }}` — iterate children
- `{{ range first N (where ...) }}` — filtered + limited iteration
- `{{ .Site.Params.key }}` — config params access
- `{{ .Site.Menus.main }}` — menu iteration
- `{{ now.Year }}` — dynamic copyright year

### Accessibility

- All `<img>` tags have `alt` attributes (from frontmatter `alt` field or `title`)
- Social links use `aria-label`
- External links use `target="_blank" rel="noopener noreferrer"`
- Hero images use `loading="eager"`, all others `loading="lazy"`

## Design Rules (DO / DON'T)

**DO:**

- Keep the dark theme — `#000` background everywhere
- Use Archivo Black for display/headings, Barlow for everything else
- Maintain generous negative space
- Use the accent gold sparingly (second title line, hover states, CTA)
- Write real descriptive content — no lorem ipsum, no placeholder filler text

**DON'T:**

- Add light/white backgrounds or sections
- Add JavaScript unless absolutely necessary
- Use additional fonts beyond the two loaded from Google Fonts
- Add a CSS preprocessor or framework — keep it vanilla
- Create files in `themes/` — all layouts stay at project root level
- Use inline styles — everything goes in `style.css`
