---
name: add-series
description: Add a new photo series to the Hugo photography portfolio. Use when the user asks to create or add a series, a new building entry, or new content page. Covers S3 photo listing, frontmatter schema, language conventions, and build verification.
compatibility: Requires aws CLI and direnv
---

## Workflow

1. **List photos** from Scaleway S3 (use `fetch-scaleway-photos` skill or the command below)
2. **Research the building** — web search for architect, construction date, style, notable features
3. **Create the markdown file** at `content/series/{slug}.md`
4. **Verify** the Hugo build passes

## S3 Photo Listing

Load S3 credentials via direnv, then list the target prefix:

```bash
eval "$(direnv export bash 2>/dev/null)" && aws s3 ls s3://photos-vincentduchauffour/{prefix}/ --endpoint-url https://s3.fr-par.scw.cloud
```

Image URL pattern: `https://photos-vincentduchauffour.s3.fr-par.scw.cloud/{prefix}/{filename}`

## Frontmatter Schema (MANDATORY — every field required)

```yaml
---
title: "Short Name"                     # Street or building name, no number
fullname: "Full Address, Paris N, FR"   # Full street address with arrondissement
date: YYYY-MM-DD                        # Date of shoot, used for sort order
location: "Paris N, FR"                 # City + arrondissement
year: 'YYYY'                            # Year string (quote it — YAML interprets bare numbers)
coverImage: "https://..."               # First image in the series (S3 URL)
images:                                 # All photos in order
  - src: "https://..."
    alt: "Series Name — English description of what's visible"
    caption: "French caption"
---
```

## Language Rules (STRICT)

- **Body text**: ALWAYS in English. 1-2 paragraphs about the building — architect, date, style, notable features.
- **Alt attributes**: ALWAYS in English. Format: `"Series Name — description of what's visible"`
- **Captions**: ALWAYS in French. Short architectural terms (e.g. "Vue d'ensemble", "Facade", "Detail", "Perspective").
- **Title, fullname, location**: Use proper local names (French for Paris addresses).

## Body Text Guidelines

- Mention the **architect(s)** and **construction date** if known
- Describe the **architectural style** and notable features
- Keep it factual — no flowery language, no lorem ipsum
- Bold architect names and building names with `**`
- 2 paragraphs max

## Caption Vocabulary (French)

Use varied architectural photography terms:

```
Vue d'ensemble, Facade, Detail, Perspective, Composition,
Texture, Rythme, Materiau, Element architectural, Volume,
Structure, Trame, Relief, Contre-plongee, Couronnement,
Jeu d'ombres, Vue finale
```

## Verification

After creating the file, verify Hugo builds successfully:

```bash
# If Docker dev is running, check logs for rebuild
docker compose logs dev 2>&1 | tail -5

# Otherwise build directly
hugo --gc --minify
```

Expected: page count increases by 1, exit code 0.
