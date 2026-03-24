# Website for my photographies

Photography portfolio built with Hugo.

## Quick Start

```bash
# Dev server — live reload, drafts enabled, localhost:1313
docker compose --profile dev up

# Production — nginx, localhost:8080
docker compose --profile prod up --build
```

## Adding a Series

Create a new file in `content/series/` (copy an existing one as template). Fill in `title`, `location`, `year`, `coverImage`, and `images` array. See `content/series/brutalist-towers.md` for reference.

## Image Storage

Photos are hosted on Scaleway Object Storage. Images are referenced as URLs in series frontmatter.

```bash
# One-time setup: configure s3cmd via Scaleway CLI
scw object config install type=s3cmd

# Upload a series
./infra/scripts/upload.sh ./photos/brutalist-towers series/brutalist-towers
```

Then reference in your markdown:

```yaml
coverImage: https://photos.s3.fr-par.scw.cloud/series/brutalist-towers/cover.jpg
```

### Infrastructure

Bucket and access policies are managed with Terraform in `infra/`.

```bash
cd infra
cp terraform.tfvars.example terraform.tfvars # fill in your Scaleway API keys
tofu init && tofu apply
```

## Project Structure

```
config.toml          Site config (title, menu, social links)
content/             Markdown content
  series/*.md         Photo series (frontmatter + body text)
  about/_index.md    About page
layouts/             Hugo templates (no themes directory)
static/css/style.css All styling — single vanilla CSS file
infra/               Terraform — Scaleway Object Storage bucket
  scripts/upload.sh  Upload images via s3cmd
```
