#!/usr/bin/env bash
# Degrade gracefully when a library wheel is not importable in the docs build
# environment: strip the trailing ':::' mkdocstrings autodoc block from that
# library's reference page so the curated tables still render under --strict.
# (A page with no autodoc block is a no-op.)
set -u

for slug in petektools petekio petekstatic peteksim; do
  page="docs/reference/$slug.md"
  [ -f "$page" ] || continue
  if ! python -c "import $slug" 2>/dev/null; then
    awk 'BEGIN{skip=0} /^::: /{skip=1} skip==0{print}' "$page" > "$page.tmp" \
      && mv "$page.tmp" "$page"
    echo "strip_unimportable_refs: $slug not importable — autodoc block stripped from $page"
  fi
done
