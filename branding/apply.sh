#!/usr/bin/env bash
# Applique la configuration OLSx aux sources RustDesk avant compilation.
#
# Idempotent : rejouable autant de fois que voulu, y compris apres un
# rebase sur l'amont. Aucune dependance en dehors de bash et python3, pour
# tourner a l'identique sur les runners Windows, macOS et Linux.
#
#   ./branding/apply.sh          applique la configuration
#   ./branding/apply.sh --check  verifie sans rien modifier
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

CHECK_ONLY=0
[ "${1:-}" = "--check" ] && CHECK_ONLY=1

# shellcheck source=/dev/null
source branding/branding.env

fail() { echo "branding: $*" >&2; exit 1; }

[ "$RENDEZVOUS_SERVER" = "REMPLIR" ] && fail "RENDEZVOUS_SERVER n'est pas renseigne dans branding/branding.env"
[ "$RS_PUB_KEY" = "REMPLIR" ] && fail "RS_PUB_KEY n'est pas renseignee dans branding/branding.env"
[ -f libs/hbb_common/src/config.rs ] || fail "submodule hbb_common absent, lancer: git submodule update --init --recursive"

export RENDEZVOUS_SERVER RS_PUB_KEY API_SERVER APP_NAME CHECK_ONLY

# Les runners Windows n'exposent pas toujours python3 sous ce nom.
PY_BIN="$(command -v python3 || command -v python)" || fail "python3 introuvable"

"$PY_BIN" - <<'PY'
import os, re, sys

check_only = os.environ["CHECK_ONLY"] == "1"
host = os.environ["RENDEZVOUS_SERVER"]
key = os.environ["RS_PUB_KEY"]
api = os.environ["API_SERVER"]
app = os.environ["APP_NAME"]
changed = []


def patch(path, rules):
    src = open(path, encoding="utf-8").read()
    out = src
    for pattern, replacement, label in rules:
        out, n = re.subn(pattern, replacement.replace("\\", "\\\\"), out, count=1)
        if n != 1:
            sys.exit("branding: motif introuvable dans %s (%s). "
                     "L'amont a probablement change, corriger apply.sh." % (path, label))
    if out != src:
        changed.append(path)
        if not check_only:
            open(path, "w", encoding="utf-8").write(out)


patch("libs/hbb_common/src/config.rs", [
    (r'pub const RENDEZVOUS_SERVERS: &\[&str\] = &\[[^\]]*\];',
     'pub const RENDEZVOUS_SERVERS: &[&str] = &["%s"];' % host,
     "RENDEZVOUS_SERVERS"),
    (r'pub const RS_PUB_KEY: &str = "[^"]*";',
     'pub const RS_PUB_KEY: &str = "%s";' % key,
     "RS_PUB_KEY"),
    (r'pub static ref APP_NAME: RwLock<String> = RwLock::new\("[^"]*"\.to_owned\(\)\);',
     'pub static ref APP_NAME: RwLock<String> = RwLock::new("%s".to_owned());' % app,
     "APP_NAME"),
])

# Serveur API : uniquement utile avec RustDesk Server Pro. On injecte un retour
# anticipe dans get_api_server_, entre marqueurs, pour rester rejouable.
common = open("src/common.rs", encoding="utf-8").read()
stripped = re.sub(r'\n *// OLSX-BEGIN\n.*?\n *// OLSX-END\n', '\n', common, flags=re.S)
anchor = "fn get_api_server_(api: String, custom: String) -> String {\n"
if anchor not in stripped:
    sys.exit("branding: get_api_server_ introuvable dans src/common.rs")
if api:
    block = ('    // OLSX-BEGIN\n    if api.is_empty() {\n'
             '        return "%s".to_owned();\n    }\n    // OLSX-END\n' % api)
    stripped = stripped.replace(anchor, anchor + block, 1)
if stripped != common:
    changed.append("src/common.rs")
    if not check_only:
        open("src/common.rs", "w", encoding="utf-8").write(stripped)

if check_only:
    if changed:
        sys.exit("branding: les sources ne sont PAS a jour (%s)" % ", ".join(changed))
    print("branding: sources deja conformes a branding.env")
else:
    print("branding: applique -> serveur=%s cle=%s... api=%s nom=%s"
          % (host, key[:12], api or "(derive du serveur)", app))
    print("branding: fichiers modifies: %s" % (", ".join(changed) or "aucun"))
PY

# Expose le prefixe des binaires aux etapes suivantes du workflow.
if [ -n "${GITHUB_ENV:-}" ]; then
  echo "ASSET_PREFIX=$ASSET_PREFIX" >> "$GITHUB_ENV"
fi
