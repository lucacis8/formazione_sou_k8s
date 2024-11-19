# Esercizio - Pipeline CI/CD con Jenkins e Docker

Questo esercizio guida alla configurazione di una pipeline CI/CD utilizzando **Jenkins**, **Docker** e una semplice applicazione Flask. La pipeline consente di costruire, taggare e pubblicare un'immagine Docker su **Docker Hub**. Inoltre, viene spiegato come eseguire manualmente l'immagine per verificare che l'applicazione funzioni.

## Requisiti

1. **Docker** installato sul sistema host.
2. Accesso a un account **GitHub** e **Docker Hub**.
3. Un repository GitHub con il file `Jenkinsfile` e il codice dell'applicazione (come [formazione_sou_k8s](https://github.com/lucacis8/formazione_sou_k8s)).

## Istruzioni

### Creazione e configurazione di Jenkins
1. Crea un container Jenkins con privilegi di root per installare Docker:
   ```bash
   sudo docker run -d --name jenkins_master --user root \
     -p 8080:8080 -p 50000:50000 \
     -v /var/run/docker.sock:/var/run/docker.sock \
     -v jenkins_home:/var/jenkins_home \
     jenkins/jenkins:lts
   ```
 
2. Recupera la password iniziale per accedere alla dashboard di Jenkins:
   ```bash
   sudo docker exec jenkins_master cat /var/jenkins_home/secrets/initialAdminPassword
   ```

3. Accedi alla dashboard di Jenkins su http://localhost:8080 e inserisci la password.

4. Durante la configurazione iniziale:
- Installa i plugin suggeriti.
- Salta la configurazione dell’utente amministratore.

### Installazione di Docker all’interno di Jenkins

1. Entra nel container Jenkins con privilegi sudo:
   ```bash
   sudo docker exec -it jenkins_master bash
   ```

2. Aggiorna i pacchetti e installa Docker:
   ```bash
   apt-get update && apt-get install -y docker.io
   ```

3. Esci dal container:
   ```bash
   exit
   ```

### Configurazione delle credenziali

1. Vai su Gestisci Jenkins > Credenziali > System > Credenziali globali.
2. Clicca su Add Credentials e aggiungi:
- ID github_credentials: i tuoi nome utente e password di GitHub.
- ID dockerhub_credentials: i tuoi nome utente e password di Docker Hub.

### Configurazione del repository GitHub

1. Forka o utilizza il repository formazione_sou_k8s.
2. Crea una release su GitHub con il tag v1.0:
- Vai su Releases > Create a new release.
- Inserisci v1.0 come tag e pubblica.

### Configurazione della pipeline Jenkins

1. Crea un nuovo elemento pipeline sulla dashboard di Jenkins e chiamalo **flask-app-example-build**.
2. Configura l'elemento per utilizzare il repository GitHub:
- Inserisci come URL di Deposito il link del repository GitHub.
- Usa le credenziali github_credentials configurate in precedenza.
- Come Ramo indicare */main.
3. Salva e avvia la pipeline.

## Verifica del risultato

Se la pipeline è configurata correttamente, verrà:
- Clonato il repository.
- Creata un’immagine Docker taggata come lucacisotto/flask-app-example:v1.0.
- L’immagine verrà pushata su Docker Hub.

### Eseguire l’immagine Docker localmente

1. Sul tuo computer, effettua il pull dell’immagine da Docker Hub:
   ```bash
   sudo docker pull lucacisotto/flask-app-example:v1.0
   ```

2. Esegui l’immagine sulla porta 5000:
   ```bash
   sudo docker run -p 5000:5000 lucacisotto/flask-app-example:v1.0
   ```

3. Apri un browser e visita http://localhost:5000. Dovresti vedere il messaggio “hello world”.

Ora la pipeline è configurata e l’applicazione è funzionante.
