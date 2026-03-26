---
name: fetch-scaleway-photos
description: List and browse photos stored on Scaleway Object Storage (S3-compatible). Use when the user asks to list images, check what photos exist, find available series, or needs S3 URLs for content.
compatibility: Requires aws CLI and direnv
---

## S3 Configuration

- **Bucket**: `photos-vincentduchauffour`
- **Region**: `fr-par`
- **Endpoint**: `https://s3.fr-par.scw.cloud`
- **Public URL pattern**: `https://photos-vincentduchauffour.s3.fr-par.scw.cloud/{key}`

Credentials are loaded via `direnv` from `.envrc` (sets `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`).

## Commands

### List top-level prefixes (date folders)

```bash
eval "$(direnv export bash 2>/dev/null)" && aws s3 ls s3://photos-vincentduchauffour/ --endpoint-url https://s3.fr-par.scw.cloud
```

### List series within a date folder

```bash
eval "$(direnv export bash 2>/dev/null)" && aws s3 ls s3://photos-vincentduchauffour/{date}/ --endpoint-url https://s3.fr-par.scw.cloud
```

### List all images in a series

```bash
eval "$(direnv export bash 2>/dev/null)" && aws s3 ls s3://photos-vincentduchauffour/{date}/{series-name}/ --endpoint-url https://s3.fr-par.scw.cloud
```

### Example

```bash
# List all series from 2026-03-26
eval "$(direnv export bash 2>/dev/null)" && aws s3 ls s3://photos-vincentduchauffour/2026-03-26/ --endpoint-url https://s3.fr-par.scw.cloud

# List photos for avenue-lamballe
eval "$(direnv export bash 2>/dev/null)" && aws s3 ls s3://photos-vincentduchauffour/2026-03-26/avenue-lamballe/ --endpoint-url https://s3.fr-par.scw.cloud
```

## Output Format

`aws s3 ls` returns lines like:

```
2026-03-26 08:57:16    6112618 DSC_0690.jpg
```

Format: `{date} {time} {size_bytes} {filename}`

## Building Image URLs

Given a file listing, construct the public URL:

```
https://photos-vincentduchauffour.s3.fr-par.scw.cloud/{date}/{series-name}/{filename}
```

Example:

```
https://photos-vincentduchauffour.s3.fr-par.scw.cloud/2026-03-26/avenue-lamballe/DSC_0690.jpg
```

## Important Notes

- Always run `eval "$(direnv export bash 2>/dev/null)"` before `aws` commands to load credentials
- Always pass `--endpoint-url https://s3.fr-par.scw.cloud` (Scaleway, not AWS)
- Images are publicly accessible immediately after upload
- Filenames are typically `DSC_XXXX.jpg` (Nikon camera naming)
