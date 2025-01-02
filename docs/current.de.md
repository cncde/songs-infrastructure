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
