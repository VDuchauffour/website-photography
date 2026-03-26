# Skill: Add Series

Add a new photo series content page to the Hugo photography portfolio.

Trigger: "add series", "new series", "add content page", "add photos"

## Content Pattern

Every series lives as a single markdown file at `content/series/{slug}.md`. The slug is lowercase, hyphenated (e.g. `tour-duo`, `caserne-massena`).

### Frontmatter (YAML)

```yaml
---
title: Series Name
fullname: Series Name, District, City, Country Code
date: YYYY-MM-DD
location: District, City, Country Code
year: 'YYYY'
coverImage: https://photos-vincentduchauffour.s3.fr-par.scw.cloud/{date}/{slug}/{filename}.jpg
images:
  - src: https://photos-vincentduchauffour.s3.fr-par.scw.cloud/{date}/{slug}/{filename}.jpg
    alt: Descriptive text in English
    caption: Short caption in French
---
```

**Field rules:**

| Field | Format | Example |
|---|---|---|
| `title` | Short name, no quotes needed unless special chars | `Tour Duo` |
| `fullname` | `{title}, {district}, {country}` | `Tour Duo, Paris 13, FR` |
| `date` | ISO date (YYYY-MM-DD), used for sort order | `2026-03-26` |
| `location` | `{district}, {country}` | `Paris 13, FR` |
| `year` | Quoted string, can span years | `'2026'` or `'2024-2025'` |
| `coverImage` | First image of the series (or best representative) | Full S3 URL |
| `images` | Array, each entry has `src`, `alt`, `caption` | See below |

### Image URL Pattern

```
https://photos-vincentduchauffour.s3.fr-par.scw.cloud/{date}/{slug}/{filename}.jpg
```

- `{date}` — shoot date, e.g. `2026-03-26`
- `{slug}` — series slug matching the filename, e.g. `tour-duo`
- `{filename}` — original camera file, e.g. `DSC_0336.jpg`

### Image Entry Rules

- `alt`: **English**. Descriptive — what is visible in the photo. Include the series name as prefix. Example: `Tour Duo — facade detail`
- `caption`: **French**. Short — 2-5 words. Example: `Detail facade`, `Vue d'ensemble`
- The `coverImage` should also be the `src` of the first image in the array

### Body Text (MANDATORY)

After the closing `---`, write **exactly 2 paragraphs in English**:

1. **First paragraph**: Historical and contextual introduction — what the building is, where it sits, when it was built, by whom if known, its purpose or architectural movement.
2. **Second paragraph**: Architectural and photographic observations — describe the visual character: materials, geometry, light, textures, what black-and-white photography reveals.

Each paragraph should be 2-3 sentences. Write real, factual, descriptive content. No lorem ipsum, no filler.

**Example** (from Tour Duo):

```
Tour Duo rises at the gateway to Paris's 13th arrondissement, a pair of office towers completed in the early 2020s as part of the city's ongoing urban renewal. The twin volumes play with asymmetry — one tower taller, their copper-toned facades catching light differently throughout the day.

The cladding breaks into rhythmic vertical fins and glazed strips, creating a moire effect that shifts with viewing angle. Black and white emphasizes the interplay of shadow and reflection across the faceted surfaces.
```

## Checklist

1. Create `content/series/{slug}.md` with complete frontmatter
2. Verify all image URLs follow the `{date}/{slug}/{filename}` pattern
3. Confirm `coverImage` matches the first image `src`
4. Write 2 English paragraphs as body text
5. Run `hugo` — build must exit 0

## DO NOT

- Use placeholder text or lorem ipsum
- Leave `alt` or `caption` empty
- Use inline HTML in the body
- Add tags, categories, or extra frontmatter fields not listed above
- Store images in the git repo — they are always external S3 URLs
