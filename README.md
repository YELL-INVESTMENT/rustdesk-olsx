# Client de prise en main à distance OLSx

Version personnalisée de [RustDesk](https://github.com/rustdesk/rustdesk), aux couleurs
d'OLSx et pré-configurée pour se connecter au serveur de relais opéré par MettaDev.
L'utilisateur n'a aucun paramètre à saisir : il télécharge, il installe, il communique
l'identifiant affiché à l'écran.

## Téléchargement

| Système | Fichier |
|---|---|
| Windows 10 et 11, Intel ou AMD | [Installeur .exe](https://github.com/YELL-INVESTMENT/rustdesk-olsx/releases/latest/download/olsx-remote-windows-x86_64.exe) · [Paquet .msi](https://github.com/YELL-INVESTMENT/rustdesk-olsx/releases/latest/download/olsx-remote-windows-x86_64.msi) |
| Windows sur ARM | [Installeur .exe](https://github.com/YELL-INVESTMENT/rustdesk-olsx/releases/latest/download/olsx-remote-windows-aarch64.exe) · [Paquet .msi](https://github.com/YELL-INVESTMENT/rustdesk-olsx/releases/latest/download/olsx-remote-windows-aarch64.msi) |
| macOS, puce Apple M1 et suivantes | [Image .dmg](https://github.com/YELL-INVESTMENT/rustdesk-olsx/releases/latest/download/olsx-remote-macos-aarch64.dmg) |
| macOS, processeur Intel | [Image .dmg](https://github.com/YELL-INVESTMENT/rustdesk-olsx/releases/latest/download/olsx-remote-macos-x86_64.dmg) |

Ces liens pointent toujours vers la dernière version publiée. Ils ne changent pas d'une
compilation à l'autre et peuvent donc être communiqués tels quels. Pour mettre à jour,
retélécharger et réinstaller par dessus : cette version ne se met pas à jour toute seule.

### Installation sous Windows

Lancer le fichier téléchargé. Le paquet .msi convient mieux à un déploiement par
stratégie de groupe. Comme le binaire n'est pas signé par un certificat commercial,
Windows SmartScreen affiche un avertissement au premier lancement : cliquer sur
**Informations complémentaires** puis **Exécuter quand même**.

### Installation sous macOS

Ouvrir l'image .dmg et glisser l'application dans le dossier Applications. L'application
n'étant pas signée par un certificat Apple, le premier lancement demande un détour :
clic droit sur l'application, puis **Ouvrir**, puis confirmer. Un double-clic simple
sera refusé.

macOS demande ensuite deux autorisations dans Réglages Système, Confidentialité et
sécurité. Sans elles, la prise en main affiche un écran noir ou ne réagit pas :

- **Enregistrement de l'écran**, pour voir le poste distant
- **Accessibilité**, pour piloter le clavier et la souris

## Ce qui distingue cette version de RustDesk

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

## Compiler soi-même

```bash
git clone --recurse-submodules https://github.com/YELL-INVESTMENT/rustdesk-olsx.git
cd rustdesk-olsx
./branding/apply.sh
```

`apply.sh` lit `branding/branding.env` et refuse de s'exécuter tant que le serveur et la
clé publique ne sont pas renseignés. Il écrit dans le sous-module `libs/hbb_common`, que
`git status` signalera donc comme modifié : c'est normal et voulu, les sources versionnées
restent celles du projet amont. Il est rejouable, y compris après une remise à jour
depuis le projet amont. `./branding/apply.sh --check` vérifie l'état des sources sans
rien modifier.

La compilation elle-même suit la procédure du projet amont, décrite dans
[README.upstream.md](README.upstream.md). Elle demande Rust, Flutter, vcpkg et, pour la
cible Windows, le compilateur de Visual Studio. En pratique, la compilation Windows et
macOS passe par le workflow ci-dessous plutôt que par un poste de développement.

Pour changer le logo, remplacer `branding/assets/logo-square.png` par un carré de
1024 pixels à fond transparent, puis lancer `./branding/gen-icons.sh`. Les icônes
produites sont versionnées, la compilation n'a donc besoin d'aucun outil graphique.

## Publier une nouvelle version

Le workflow **Client OLSx** compile Windows et macOS puis publie les binaires sous les
noms de fichiers utilisés par les liens ci-dessus. Il se déclenche à la main depuis
l'onglet Actions, ou sur la pose d'un tag `olsx-v*` pour figer une version livrée.

## Suivre les mises à jour du projet amont

```bash
git remote add upstream https://github.com/rustdesk/rustdesk.git
git fetch upstream
git merge upstream/master
./branding/apply.sh --check
```

Si `--check` signale que les sources ne sont plus conformes, relancer `apply.sh`. S'il
signale un motif introuvable, c'est que le code amont a bougé à l'endroit patché : il
faut alors corriger `branding/apply.sh`.

## Licence

RustDesk est distribué sous licence **GNU AGPL version 3**, que ce dépôt reprend
intégralement dans le fichier [LICENCE](LICENCE). Cette licence impose de publier les
sources de toute version modifiée qui est distribuée, ce que fait ce dépôt public.

Projet d'origine : [github.com/rustdesk/rustdesk](https://github.com/rustdesk/rustdesk).
RustDesk est une marque de ses auteurs. Ce fork n'est ni affilié ni soutenu par eux.
