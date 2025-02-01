# Infrastruktur

## Technologie

Die aktuelle Website besteht aus den folgenden Komponenten:

| Komponente | Technologie | Repository |
| --- | --- | --- |
| Frontend | Website basierend auf ReactJS | https://github.com/cncde/Frontend-nwlieder |
| Backend | API basierend auf Express | https://github.com/cncde/Backend-nwlieder |
| Datenbank | PostgreSQL | https://github.com/cncde/Backend-nwlieder |

## Cloud Components

Das gesamte Setup läuft auf/benutzt folgende AWS Services:

* S3 bucket: Frontend und Lieder
* Cognito: Authentifizierung der Nutzer und Admins
* RDS: PostgreSQL-Datenbank
* App Runner: Backend in einem Docker Container
* Elastic Container Registry (ECR): Docker image für das Backend

## Deployment

Das Deployment für Frontend und Backend ist mittels GitHub workflow
automatisiert und wird bei jedem Push auf den main-Branch angestoßen. Es gibt
*kein Staging*, d.h. jede Änderung, die auf dem main-Branch gepusht wird, *wird
sofort auch auf das Live-System deployed*.

Datenbankmigrationen gibt es keine. Änderungen am Schema müssen manuell
durchgeführt werden.

## Datenbank 

Folgende Tabelle ist eine Darstellung aller Felder der Datenbank. Enum soll beschreiben, dass das Feld nur die in dem
Kommentar beschriebene Werte annehmen kann

| Feldname | Format | Kommentar |
| --- | --- | --- |
| name | String | Name des Liedes|
| audioUrl | Url | URL des/r Audiofiles|
| description | String | Ein Kommentar für ein Lied. Ist in der GUI noch nicht umgesetzt, aber ein Wunsch |
| imageUrl | Url | URL des Imagefiles (Aus der Liedermappe)|
| etappe | Enum(String) | Vorkatechumenat/Katechumenat/Auserwählung/liturgisch|
| liedtext | String | komplett Text des Liedes als String für die Volltextsuche|
| liturgischString | Enum(String) | Advent-Weihnachten/Fastenzeit/Ostern-Pfingsten/Jahreskreis|
| thematischString | Enum(String) |Marienlieder/Lieder-für-die-Kinder/ Einzugslieder/|Frieden-Gabenbereitung/Brotbrechen/Kelchkommunion/Auszugslieder|