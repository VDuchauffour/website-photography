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

S3 credentials are loaded via `direnv` (`.envrc`). Run `direnv allow` once after cloning.

```bash
# Upload a single image
./infra/scripts/upload.sh photos-vincentduchauffour ./photo.jpg series/brutalist-towers

# Upload a directory
./infra/scripts/upload.sh photos-vincentduchauffour ./photos/brutalist-towers series/brutalist-towers
```

Then reference in your markdown:

```yaml
coverImage: https://photos-vincentduchauffour.s3.fr-par.scw.cloud/series/brutalist-towers/cover.jpg
```

### Infrastructure

Bucket, IAM policies, and upload credentials are managed with Terraform in `infra/`.

```bash
cd infra
cp terraform.tfvars.example terraform.tfvars # fill in your Scaleway API keys + user ID
tofu init && tofu apply
```

## Project Structure

```
.envrc               direnv config — loads hugo, s3cmd, and S3 credentials
config.toml          Site config (title, menu, social links)
content/             Markdown content
  series/*.md         Photo series (frontmatter + body text)
  about/_index.md    About page
layouts/             Hugo templates (no themes directory)
static/css/style.css All styling — single vanilla CSS file
infra/               Terraform — Scaleway Object Storage + IAM
  scripts/upload.sh  Upload images via s3cmd (single file or directory)
```
