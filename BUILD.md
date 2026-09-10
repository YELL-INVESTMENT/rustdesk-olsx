# Compiler et maintenir le client OLSx

Ce document s'adresse aux développeurs. Les utilisateurs trouveront les liens de
téléchargement et la marche à suivre dans le [README](README.md).

## Ce qui distingue ce dépôt de RustDesk

Trois choses seulement :

1. **Le serveur de rendez-vous** pointe vers l'infrastructure MettaDev, et non vers les
   serveurs publics de RustDesk.
2. **La clé publique du serveur** est intégrée au binaire, ce qui interdit toute connexion
   passant par un autre serveur.
3. **Les icônes et le logo** affichés sont ceux d'OLSx.

Les deux premiers points sont appliqués à la compilation par `branding/apply.sh`, à partir
des valeurs de `branding/branding.env`. Le troisième vient de fichiers d'icônes versionnés,
produits une fois pour toutes par `branding/gen-icons.sh`.

L'application porte encore le nom RustDesk dans ses fenêtres et son dossier d'installation.
Ce nom est codé en dur dans le packaging des trois plateformes, le changer est un chantier
à part entière qui n'a pas été mené.

Le reste du code est celui du projet amont, sans modification. Le README d'origine est
conservé dans [README.upstream.md](README.upstream.md).

## Structure

| Chemin | Rôle |
|---|---|
| `branding/branding.env` | serveur, clé publique, serveur API, préfixe des binaires |
| `branding/apply.sh` | applique ces valeurs aux sources avant compilation |
| `branding/gen-icons.sh` | régénère toutes les icônes depuis le logo source |
| `branding/pack-icns.py` | assemble le conteneur ICNS de macOS |
| `branding/assets/` | logo carré et logo horizontal d'origine |
| `.github/workflows/olsx-release.yml` | compile et publie Windows et macOS |

## Appliquer la configuration

```bash
git clone --recurse-submodules https://github.com/YELL-INVESTMENT/rustdesk-olsx.git
cd rustdesk-olsx
./branding/apply.sh
```

`apply.sh` lit `branding/branding.env` et refuse de s'exécuter tant que le serveur et la
clé publique ne sont pas renseignés, pour qu'aucun binaire ne parte en pointant vers les
serveurs publics de RustDesk. Il écrit dans le sous-module `libs/hbb_common`, que
`git status` signalera donc comme modifié : c'est normal et voulu, les sources versionnées
restent celles du projet amont.

Le script est rejouable autant de fois que nécessaire. `./branding/apply.sh --check`
vérifie l'état des sources sans rien modifier.

## Changer le logo

Remplacer `branding/assets/logo-square.png` par un carré de 1024 pixels à fond
transparent, puis lancer `./branding/gen-icons.sh`. ImageMagick est requis. Les icônes
produites sont versionnées, la compilation n'a donc besoin d'aucun outil graphique.

## Compiler

La compilation locale suit la procédure du projet amont, décrite dans
[README.upstream.md](README.upstream.md). Elle demande Rust, Flutter, vcpkg et, pour la
cible Windows, le compilateur de Visual Studio. macOS exige Xcode sur du matériel Apple.

En pratique, Windows et macOS passent par le workflow **Client OLSx**, qui se déclenche à
la main depuis l'onglet Actions, ou sur la pose d'un tag `olsx-v*` pour figer une version
livrée. Il publie les binaires sous des noms de fichiers stables, sans numéro de version,
afin que les liens du README restent valides d'une compilation à l'autre.

Les workflows hérités de RustDesk qui ne servent pas ici sont désactivés, pour éviter des
compilations inutiles à chaque poussée.

## Suivre les mises à jour du projet amont

```bash
git remote add upstream https://github.com/rustdesk/rustdesk.git
git fetch upstream
git merge upstream/master
./branding/apply.sh --check
```

Si `--check` signale que les sources ne sont plus conformes, relancer `apply.sh`. S'il
signale un motif introuvable, c'est que le code amont a bougé à l'endroit patché : il faut
alors corriger `branding/apply.sh`.

## Signature des binaires

Les binaires ne sont signés par aucun certificat commercial, ce qui provoque un
avertissement au premier lancement sur les deux systèmes. Le workflow amont sait signer si
les secrets correspondants existent, et les ignore sinon :

| Plateforme | Secrets attendus |
|---|---|
| macOS | `MACOS_P12_BASE64`, `MACOS_P12_PASSWORD`, `MACOS_CODESIGN_IDENTITY`, `MACOS_NOTARIZE_JSON` |
| Windows | `SIGN_BASE_URL`, `SIGN_SECRET_KEY` |

## Licence

RustDesk est distribué sous licence **GNU AGPL version 3**, reprise intégralement dans le
fichier [LICENCE](LICENCE). Cette licence impose de publier les sources de toute version
modifiée qui est distribuée, ce que fait ce dépôt public.

Projet d'origine : [github.com/rustdesk/rustdesk](https://github.com/rustdesk/rustdesk).
RustDesk est une marque de ses auteurs. Ce dépôt n'est ni affilié ni soutenu par eux.
