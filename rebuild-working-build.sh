#!/bin/bash
# rebuild-working-build.sh
# Rebuilds working build from known good base + all fixes in correct order
# Base: 2e81dc5f6 (feature/turboquant-kv-cache before Ooze's NextN/Qwen additions)
# Run from repo root: bash rebuild-working-build.sh

set -e

BASE="2e81dc5f6"
DATE=$(date +%Y%m%d-%H%M)
BRANCH="working-build-$DATE"

echo "=== Creating $BRANCH from base $BASE ==="
git checkout $BASE
git checkout -b $BRANCH

echo "=== 1. fix/turbo-fwht-prototype: CI warning fix ==="
git cherry-pick 1ea1ccec7

echo "=== 2. fix/mtp-assistant-tensor-prefix: drafter tensor routing ==="
git cherry-pick a4c3f9a0b

echo "=== 3. fix/iswa-get-can-shift-gemma4: SWA can_shift fix ==="
git cherry-pick d1333b0bc

echo "=== 4. fix/turbo-rope-shift-gemma4: TurboQuant shift graph fix ==="
git cherry-pick 31df030fe

echo "=== 5. fix/kv-checkpoint-cache-reuse: slot restore do_reset fix ==="
git cherry-pick e86be54e6

echo "=== 6. feat/draft-p-accept: p_accept implementation ==="
git cherry-pick 12706d051

echo "=== 7. feat/draft-p-accept: deferred accept fix (Ooze) ==="
git cherry-pick 1c5d20851

echo "=== 8. feat/draft-p-accept: cur_p optimisation ==="
git cherry-pick 530803f76

echo "=== 9. feat/mtp-cuda-stream: dedicated CUDA stream ==="
git cherry-pick 7dddcc268

# TODO: feat/kv-split-draft when ready
# TODO: feat/grammar-checkpoint-local when ready

# commit this script into the branch for reproducibility
cp /home/sujit/rebuild-working-build.sh rebuild-working-build.sh
git add rebuild-working-build.sh
git commit -m "chore: record rebuild script in working build branch"

echo ""
echo "=== Done: $BRANCH ==="
git log --oneline $BASE..$BRANCH
