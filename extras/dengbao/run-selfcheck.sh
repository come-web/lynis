#!/bin/sh
# Run a Lynis scan using the MLPS 2.0 / 等保 technical profile.
# This does not produce the official v10.2 self-check zip.

set -u

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
LYNIS_ROOT=$(CDPATH= cd -- "${SCRIPT_DIR}/../.." && pwd)
PROFILE="${LYNIS_ROOT}/dengbao.prf"
LYNIS="${LYNIS_ROOT}/lynis"

if [ ! -x "${LYNIS}" ]; then
    echo "Cannot find lynis at ${LYNIS}" >&2
    exit 1
fi
if [ ! -f "${PROFILE}" ]; then
    echo "Cannot find profile ${PROFILE}" >&2
    exit 1
fi

echo "=============================================================="
echo " MLPS 2.0 / 等保 technical scan"
echo " Official self-check zip: Windows v10.2 tool only"
echo " Do not mix with the 备案填报 / 更新工具"
echo "=============================================================="
echo ""

cd "${LYNIS_ROOT}" || exit 1
exec ./lynis audit system --profile dengbao.prf --quick --auditor "dengbao-selfcheck" "$@"
