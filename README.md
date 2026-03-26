# Website for my photographies

Photography portfolio built with Hugo. Deployed to Scaleway Object Storage via GitHub Actions, served through Edge Services CDN.

## Quick Start

```bash
# Dev server (Docker) — live reload, drafts enabled, localhost:1313
make dev

# Stop dev server
make dev-stop
```

## Deployment

Deploys automatically on push to `main` via GitHub Actions: Hugo build, S3 sync, Edge Services cache purge.

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

Bucket, Edge Services CDN, DNS records, and upload credentials are managed with Terraform in `infra/`.

```bash
cd infra/website
cp terraform.tfvars.example terraform.tfvars # fill in your Scaleway API keys + user ID
terraform init && terraform apply
```

## Project Structure

```
.envrc               direnv config — loads S3 credentials
config.toml          Site config (title, menu, social links)
content/             Markdown content
  series/*.md        Photo series (frontmatter + body text)
  about/_index.md    About page
layouts/             Hugo templates (no themes directory)
static/css/style.css All styling — single vanilla CSS file
infra/website/       Terraform — Object Storage, Edge Services CDN, DNS
infra/storage/       Terraform — photo storage bucket + IAM
```
