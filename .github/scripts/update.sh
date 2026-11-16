#!/usr/bin/env bash
set -euo pipefail

[[ "${GITHUB_REF:-}" == refs/heads/* ]] || { echo 'Expected a branch ref.' >&2; exit 1; }
git check-ref-format --branch "${GITHUB_REF#refs/heads/}" >/dev/null
[[ -z "$(git status --porcelain --untracked-files=all)" ]] || { echo 'Checkout is not clean.' >&2; exit 1; }
git config user.name 'github-actions[bot]'
git config user.email '41898282+github-actions[bot]@users.noreply.github.com'

failed=()
for package in cherry-studio wordcraft gridcraft lyrune freshgram; do
  echo "::group::$package"
  candidate=$(mktemp -d "${RUNNER_TEMP:-/tmp}/package-update.${package}.XXXXXX")
  status=0
  if ! git worktree add --quiet --detach "$candidate" HEAD; then
    rmdir "$candidate"
    status=1
  else
    file="packages/$package.nix"
    if ! before=$(cd "$candidate" && nix eval --raw --no-update-lock-file --no-write-lock-file ".#$package.version"); then
      status=1
    elif ! (cd "$candidate" && nix develop --no-update-lock-file --no-write-lock-file -c ./update "$package"); then
      status=1
    elif ! after=$(cd "$candidate" && nix eval --raw --no-update-lock-file --no-write-lock-file ".#$package.version"); then
      status=1
    elif [[ "$before" == "$after" ]]; then
      if [[ -n "$(git -C "$candidate" status --porcelain --untracked-files=all)" ]]; then
        echo "Unexpected changes without a version update: $package" >&2
        status=1
      else
        printf '%s: no update (version %s)\n' "$package" "$before"
      fi
    elif [[ ! "$after" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] ||
         [[ "$(git -C "$candidate" status --porcelain --untracked-files=all)" != " M $file" ]]; then
      echo "Unexpected version or candidate changes: $package" >&2
      status=1
    elif ! git -C "$candidate" diff --check -- "$file"; then
      status=1
    else
      # ./update builds the changed Flake output before it returns successfully.
      if ! cp -- "$candidate/$file" "$file" ||
         ! git add -- "$file" ||
         ! git diff --cached --check ||
         ! git commit -m "$package: update to $after"; then
        git restore --staged --worktree -- "$file"
        status=1
      elif ! git push origin "HEAD:$GITHUB_REF"; then
        echo "Push failed for verified update: $package" >&2
        status=1
      fi
    fi
    if ! git worktree remove --force "$candidate"; then
      echo "Could not remove temporary worktree: $candidate" >&2
      status=1
    fi
  fi
  echo '::endgroup::'
  if (( status != 0 )); then
    echo "::error::$package update failed"
    failed+=("$package")
  fi
done

if (( ${#failed[@]} )); then
  printf 'Failed packages: %s\n' "${failed[*]}" >&2
  exit 1
fi
