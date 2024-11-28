# STEP 2 - Pipeline CI/CD con Jenkins e Docker

Questo esercizio guida alla configurazione di una pipeline CI/CD utilizzando **Jenkins**, **Docker** e una semplice applicazione Flask. La pipeline consente di costruire, taggare e pubblicare un'immagine Docker su **Docker Hub**. Inoltre, viene spiegato come eseguire manualmente l'immagine per verificare che l'applicazione funzioni.

---

## Requisiti

1. Ambiente VM configurato nello **Step 1**.
2. Accesso a un account **GitHub** e **Docker Hub**.
3. Repository GitHub contenente:
   - **Jenkinsfile** (pipeline Jenkins dichiarativa).
   - Applicazione Flask con un **Dockerfile** (esempio: [formazione_sou_k8s](https://github.com/lucacis8/formazione_sou_k8s)).

---

## Configurazione della Pipeline

### Installazione di Docker su Jenkins Slave

1. Accedi al container **Jenkins Slave** con privilegi `sudo`:
   ```bash
   sudo docker exec --user root -it jenkins_slave bash
   ```

2. Installa Docker all'interno del container:
   ```bash
   apt-get update && apt-get install -y docker.io
   ```
3. Verifica l'installazione:
   ```bash
   docker --version
   ```
   
4. Esci dal container:
   ```bash
   exit
   ```

---

### Configurazione delle credenziali Jenkins

1. Vai su **Gestisci Jenkins > Credenziali > System > Credenziali globali**.
2. Aggiugni le seguenti credenziali:
- **ID** `github_credentials`: le tue credenziali GitHub (nome utente e password).
- **ID** `dockerhub_credentials`: le tue credenziali Docker Hub (nome utente e password).

---

### Configurazione del Repository GitHub

1. Crea un repository GitHub denominato `formazione_sou_k8s` (forka quello esistente).
2. Crea una **release GitHub** con il tag v1.0:
   - Vai su **Releases > Create a new release**.
   - Imposta il tag come v1.0 e pubblica la release.

---

### Esecuzione della Pipeline

1. Accedi alla dashboard Jenkins e crea un nuovo elemento **Pipeline** denominato `flask-app-example-build`.
2. Configura l'elemento per utilizzare il repository GitHub:
- Inserisci l'URL del repository.
- Usa le credenziali `github_credentials`.
- Specifica il branch `*/main`.
3. Salva e avvia la pipeline.

---

## Verifica del risultato

Se la pipeline è configurata correttamente, verranno eseguite le seguenti operazioni:
1. **Clonazione del repository.**
2. **Build dell'immagine Docker** con il nome `lucacisotto/flask-app-example:latest`.
3. **Push dell'immagine Docker** su Docker Hub.

---

### Test dell'immagine Docker localmente

1. Scarica l'immagine da Docker Hub:
   ```bash
   sudo docker pull lucacisotto/flask-app-example:latest
   ```

2. Esegui l’immagine sulla porta `5000`:
   ```bash
   sudo docker run -p 5000:5000 lucacisotto/flask-app-example:latest
   ```

3. Apri un browser e visita http://localhost:5000. Dovresti vedere il messaggio **“hello world”**.

---

### Risoluzione dei problemi

- **Errore di push su Docker Hub:** Verifica le credenziali `dockerhub credentials` in Jenkins.
- **Pipeline fallita durante il build:** Assicurati che il **Dockerfile** sia corretto e che il container Jenkins Slave abbia Docker installato.
- **Problemi con il rare limit di Docker Hub:** Configura un registro Docker locale.

---

Ora la pipeline è configurata e l’applicazione Flask è pronta per l'uso.
