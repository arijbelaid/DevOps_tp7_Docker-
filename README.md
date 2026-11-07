<div align="center">

# 🐳 TP7 - Docker Avancé & Docker Compose
### Multi-stage, Non-root, PostgreSQL & Buildx

[![Docker](https://img.shields.io/badge/Docker-29.1.3-blue?style=for-the-badge&logo=docker)](https://www.docker.com/)
[![Compose](https://img.shields.io/badge/Compose-v2.40.3-blue?style=for-the-badge)](https://docs.docker.com/compose/)
[![Buildx](https://img.shields.io/badge/Buildx-v0.30.1-purple?style=for-the-badge)](https://docs.docker.com/buildx/working-with-buildx/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15--alpine-blue?style=for-the-badge&logo=postgresql)](https://www.postgresql.org/)

📄 **[Télécharger le rapport complet (PDF)](rapport_tp7.pdf)**
</div>

---

## 🎯 Objectifs du TP

Ce TP a pour but de maîtriser les fonctionnalités avancées de Docker :

- **Couches et cache** : Comprendre le cache de build et l'invalidation des couches.
- **Multi-stage** : Écrire un Dockerfile multi-stage avec `.dockerignore`, utilisateur non-root et `HEALTHCHECK`.
- **Docker Compose** : Décrire une pile (app + PostgreSQL + Adminer) avec réseaux, volumes, healthchecks et `.env`.
- **Buildx** : Construire une image multi-architecture (amd64 / arm64).

---

## 📝 Description

Le projet déploie une API TypeScript (`visits-app`) qui compte les visites dans PostgreSQL :
1.  Comparaison entre une image **naïve** (lourde, root) et une image **multi-stage** (légère, non-root).
2.  Mesure des temps de build et du cache.
3.  Scan des vulnérabilités avec **Trivy**.
4.  Déploiement de la pile complète avec **Docker Compose** (app, db, adminer).
5.  Test de persistance, isolation réseau, et mise à l'échelle.
6.  Construction d'une image **multi-architecture** avec **Buildx**.

---

### 🛠️ Partie 1 : Couches et cache

#### 1. Versions de Docker, Compose et Buildx
![01](captures/01_docker_versions.png)

#### 2. Génération de package-lock.json
![02](captures/02_npm_install.png)

#### 3. Build de l'image naïve
![03](captures/03_build_naive.png)

#### 4. Modification de src/server.ts
![04](captures/04_modif_server_ts.png)

#### 5. Rebuild après modification (avec CACHED)
![05](captures/05_rebuild_naive.png)

#### 6. Docker history (couches et tailles)
![06](captures/06_docker_history.png)

### 📊 Partie 2 : Mesurer l'image naïve

#### 7. Scan Trivy (vulnérabilités HIGH/CRITICAL)
![07](captures/07_trivy_naive.png)
![07](captures/07_trivy_naive2.png)


#### 8. Utilisateur root dans l'image naïve
![08](captures/08_run_naive_id.png)

### 🏗️ Partie 3 : Dockerfile multi-stage

#### 9. Fichier .dockerignore
![09](captures/09_dockerignore.png)

#### 10. Dockerfile multi-stage complété
![10](captures/10_dockerfile_multistage.png)

#### 11. Build de l'image multi-stage
![11](captures/11_build_multistage.png)

#### 12. Comparaison des tailles (naive vs multistage)
![12](captures/12_comparison_images.png)

#### 13. Utilisateur non-root (node)
![13](captures/13_non_root.png)

### 🐘 Partie 4 : Pile Docker Compose

#### 14. Fichier compose.yaml complété
![14](captures/14_compose_yaml.png)

#### 15. Validation de la configuration
![15](captures/15_compose_config.png)

#### 16. Démarrage de la pile
![16](captures/16_compose_up.png)
![16](captures/16_compose_up2.png)

#### 17. État des conteneurs (db healthy)
![17](captures/17_compose_ps.png)

#### 18. Test de l'application (curl)
![18](captures/18_curl_app.png)

#### 19. Interface Adminer avec la table visits
![19](captures/19_adminer.png)

#### 20. Persistance du compteur (down/up)
![20](captures/20_persistence.png)

#### 21. Isolation réseau (psql -h localhost échoue)
![21](captures/21_isolation_reseau.png)

### 🚀 Partie 5 : Buildx et images multi-architecture

#### 22. Création du builder multiarch
![22](captures/22_buildx_create.png)

#### 23. Build multi-architecture (amd64 + arm64)
![23](captures/23_buildx_build.png)

#### 24. Manifeste (amd64 et arm64)
![24](captures/24_buildx_manifest.png)

---

## 📊 Tableau comparatif

| Indicateur | naive | multistage |
| :--- | :--- | :--- |
| **Taille de l'image** | 1.67 GB | 250 MB |
| **Temps de build (à froid)** | ~142 s | ~35 s |
| **Temps de build (code modifié)** | ~10 s (npm install réexécuté) | ~5 s (cache npm ci) |
| **Vulnérabilités HIGH/CRITICAL** | 566 | 0 |
| **Utilisateur** | root (uid=0) | node (uid=1000) |

---

<div align="center">
  <b>Fait avec ❤️ par Arij Belaid</b>
</div>
