# Contributing

This repository is an academic lab artefact curated for reproducibility, readability, and safe publication.

## Guidelines

- Do not commit Cisco images, VM disks, GNS3 appliance images, raw PCAPs, credentials, or local project IDs.
- Keep course handouts and third-party material referenced, not vendored, unless redistribution is explicitly allowed.
- Prefer reviewed evidence excerpts under `evidence/` over raw captures.
- Keep the final report PDF in `docs/report/`.
- When adding scripts, make them dry-run friendly and document environment assumptions.

## Pull request checklist

- [ ] The README still describes the current repository structure.
- [ ] `python scripts/check_repository.py` passes.
- [ ] No raw captures or licensed appliance images were added.
- [ ] Any new evidence is sanitized and explained.
