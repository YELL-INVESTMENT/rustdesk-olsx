<div align="center">

<img src="branding/assets/logo-wide.png" alt="OLSx" width="260">

<h1>Assistance à distance</h1>

<p>
Laissez notre équipe prendre la main sur votre ordinateur, le temps d'une intervention.<br>
Rien à configurer : vous téléchargez, vous installez, vous communiquez le code affiché.
</p>

[![Dernière version][badge-version]][releases]
[![Windows et macOS][badge-os]][releases]
[![Licence AGPL-3.0][badge-licence]][licence]

</div>

---

> **Page de téléchargement : [yell-investment.github.io/rustdesk-olsx][page]**
> C'est l'adresse à communiquer aux clients. Elle détecte leur système et ne montre aucun code.

## Télécharger

| Votre ordinateur | Fichier à télécharger |
|---|---|
| **Windows**, la très grande majorité des PC | **[Installeur .exe][win-exe]** ou [paquet .msi][win-msi] |
| **Windows sur processeur ARM**, rare | [Installeur .exe][win-arm-exe] ou [paquet .msi][win-arm-msi] |
| **Mac à puce Apple**, M1 et suivantes | **[Image .dmg][mac-arm]** |
| **Mac à processeur Intel**, avant 2021 | **[Image .dmg][mac-intel]** |

En cas de doute sur votre Mac, ouvrez le menu Pomme puis **À propos de ce Mac**. La ligne
Puce ou Processeur vous donne la réponse.

Ces liens pointent toujours vers la version la plus récente. Ils ne changent jamais, vous
pouvez donc les conserver. Le paquet `.msi` s'adresse aux services informatiques qui
déploient le logiciel sur plusieurs postes à la fois.

## Comment ça marche

**1. Installez le logiciel.** Une seule fois, en suivant la section ci-dessous
correspondant à votre système.

**2. Ouvrez-le quand on vous le demande.** L'application affiche un identifiant à neuf
chiffres et un mot de passe.

**3. Communiquez-nous ces deux informations.** Nous nous connectons, vous voyez tout ce
qui se passe à l'écran, et vous pouvez interrompre la session à tout moment en fermant
l'application.

Le logiciel ne tourne que lorsque vous l'ouvrez. Personne ne peut se connecter à votre
poste sans que vous ayez communiqué le mot de passe affiché.

## Premier lancement

<details>
<summary><b>Windows</b></summary>

<br>

Ouvrez le fichier téléchargé et suivez l'installation.

Windows affiche un écran bleu intitulé **Windows a protégé votre ordinateur**. C'est le
comportement normal face à un logiciel qui n'est pas distribué par un grand éditeur.
Cliquez sur **Informations complémentaires**, puis sur **Exécuter quand même**.

</details>

<details>
<summary><b>macOS</b></summary>

<br>

Ouvrez l'image `.dmg` téléchargée, puis glissez l'application dans le dossier
**Applications**.

Au tout premier lancement, ne double-cliquez pas sur l'application : macOS refuserait de
l'ouvrir. Faites un **clic droit** dessus, choisissez **Ouvrir**, puis confirmez. Les
lancements suivants se font normalement.

macOS demande ensuite deux autorisations, dans **Réglages Système**, rubrique
**Confidentialité et sécurité**. Sans elles, l'écran reste noir ou ne réagit pas :

- **Enregistrement de l'écran**, pour que nous voyions votre écran
- **Accessibilité**, pour que nous puissions utiliser le clavier et la souris

</details>

## Mise à jour

Le logiciel ne se met pas à jour tout seul. Pour installer une nouvelle version,
retéléchargez le fichier depuis cette page et réinstallez par dessus. Vos réglages sont
conservés.

## Confidentialité

Ce logiciel est une version de [RustDesk][rustdesk] configurée pour nous. Deux
conséquences concrètes :

- **Vos sessions ne passent pas par les serveurs publics de RustDesk.** Elles transitent
  uniquement par notre serveur, dont l'adresse et la clé sont inscrites dans le logiciel.
- **Aucun autre serveur n'est joignable.** La clé de notre serveur étant intégrée au
  fichier que vous installez, ce logiciel ne peut pas être détourné vers ailleurs.

Le code source complet est publié sur cette page, comme l'exige la licence du projet
d'origine. N'importe qui peut vérifier ce que fait le logiciel.

## Une question

Contactez votre interlocuteur habituel chez OLSx.

---

<div align="center">
<sub>
Développeurs : la compilation et la maintenance sont décrites dans <a href="BUILD.md">BUILD.md</a>.<br>
Fondé sur <a href="https://github.com/rustdesk/rustdesk">RustDesk</a>, sous licence GNU AGPL version 3.
</sub>
</div>

[releases]: https://github.com/YELL-INVESTMENT/rustdesk-olsx/releases/latest
[licence]: LICENCE
[rustdesk]: https://github.com/rustdesk/rustdesk
[page]: https://yell-investment.github.io/rustdesk-olsx/

[badge-version]: https://img.shields.io/github/v/release/YELL-INVESTMENT/rustdesk-olsx?label=version&color=F02429
[badge-os]: https://img.shields.io/badge/syst%C3%A8mes-Windows%20%7C%20macOS-555
[badge-licence]: https://img.shields.io/badge/licence-AGPL--3.0-555

[win-exe]: https://github.com/YELL-INVESTMENT/rustdesk-olsx/releases/latest/download/olsx-remote-windows-x86_64.exe
[win-msi]: https://github.com/YELL-INVESTMENT/rustdesk-olsx/releases/latest/download/olsx-remote-windows-x86_64.msi
[win-arm-exe]: https://github.com/YELL-INVESTMENT/rustdesk-olsx/releases/latest/download/olsx-remote-windows-aarch64.exe
[win-arm-msi]: https://github.com/YELL-INVESTMENT/rustdesk-olsx/releases/latest/download/olsx-remote-windows-aarch64.msi
[mac-arm]: https://github.com/YELL-INVESTMENT/rustdesk-olsx/releases/latest/download/olsx-remote-macos-aarch64.dmg
[mac-intel]: https://github.com/YELL-INVESTMENT/rustdesk-olsx/releases/latest/download/olsx-remote-macos-x86_64.dmg
