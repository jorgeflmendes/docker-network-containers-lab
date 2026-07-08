"""Validate that the repository is safe and tidy enough for public review.

The check is intentionally portable: it does not start GNS3, Docker, routers,
or any offensive/traffic-generation scenario.  It only verifies that the
published tree contains the expected documentation/report structure and does
not include raw captures, licensed appliance images, local project state, or
obvious secret material.
"""
from __future__ import annotations

from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]

# Minimal repository structure expected by the README and CI workflow.
REQUIRED_PATHS = ["README.md", "docs/ARCHITECTURE.md", "docs/report"]

# Artefacts that should stay local because they are too large, generated,
# licensed/restricted, or likely to contain lab state that has not been
# reviewed for publication.
BANNED_SUFFIXES = {
    ".7z",
    ".bin",
    ".cap",
    ".env",
    ".gns3project",
    ".har",
    ".image",
    ".key",
    ".pcap",
    ".pcapng",
    ".pem",
    ".pfx",
    ".p12",
    ".qcow2",
    ".rar",
    ".vmdk",
    ".zip",
}
BANNED_NAMES = {
    ".env",
    "gns3_project_id.txt",
    "project_id.txt",
}

# Lightweight secret/local-state patterns.  Lab-only sample passwords that are
# visible in the academic report are not blocked; operational tokens and local
# host paths are blocked.
TEXT_SUFFIXES = {".md", ".txt", ".tex", ".py", ".yml", ".yaml", ".json", ".csv", ".sh"}
BANNED_TEXT_PATTERNS = {
    "GitHub token": re.compile(r"\bgh[opsu]_[A-Za-z0-9_]{20,}\b"),
    "Docker Swarm join token": re.compile(r"SWMTKN-[A-Za-z0-9._-]+"),
    "Windows user path": re.compile(r"[A-Z]:\\\\Users\\\\[^\\\s\"']+", re.IGNORECASE),
    "private key": re.compile(r"BEGIN (?:RSA |OPENSSH |EC |DSA )?PRIVATE KEY"),
}

missing = [path for path in REQUIRED_PATHS if not (ROOT / path).exists()]
if missing:
    raise SystemExit(f"missing required paths: {missing}")

bad_files: list[str] = []
bad_text: list[str] = []
for path in ROOT.rglob("*"):
    if ".git" in path.parts:
        continue
    if not path.is_file():
        continue

    rel = path.relative_to(ROOT).as_posix()
    if path.suffix.lower() in BANNED_SUFFIXES or path.name.lower() in BANNED_NAMES:
        bad_files.append(rel)
        continue

    if path.suffix.lower() in TEXT_SUFFIXES:
        text = path.read_text(encoding="utf-8", errors="replace")
        for label, pattern in BANNED_TEXT_PATTERNS.items():
            if pattern.search(text):
                bad_text.append(f"{rel}: {label}")

if bad_files:
    raise SystemExit("banned publish artefacts found:\n" + "\n".join(bad_files))

if bad_text:
    raise SystemExit("sensitive or local-only text found:\n" + "\n".join(bad_text))

print("repository publication checks passed")

