# Step 4 - Configurazione ed esecuzione della Pipeline Jenkins con Minikube

In questo esercizio, configureremo il **Jenkins Slave** per lavorare con il cluster Kubernetes locale di **Minikube** che avevamo installato sul Mac all'inizio dello Step 1. Successivamente, installeremo gli strumenti necessari (`kubectl` e `Helm`) sul Jenkins Slave, e ci assicureremo che la pipeline possa eseguire correttamente su Jenkins.

---

## Requisiti
- Un cluster **Minikube** in esecuzione su Mac e il suo namespace `formazione-sou`.
- **Jenkins Slave** correttamente configurato e accessibile.
- I seguenti strumenti devono essere installati:
  - **kubectl** (per interagire con il cluster Kubernetes).
  - **Helm** (per gestire le release di Kubernetes).

---

## Passaggi per la configurazione

### 1. Configurazione del Jenkins Slave con il cluster locale

#### 1.1. Installazione di `kubectl` e `Helm` su Jenkins Slave
Esegui i seguenti comandi sul Jenkins Slave per installare `kubectl` e `Helm`:

1. **Installa `kubectl`**:
   ```bash
   curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
   chmod +x ./kubectl
   mv ./kubectl /usr/local/bin/kubectl
   ```

2. **Installa** `Helm`:
   ```bash
   curl https://get.helm.sh/helm-v3.11.0-linux-amd64.tar.gz --output helm-v3.11.0-linux-amd64.tar.gz
   tar -zxvf helm-v3.11.0-linux-amd64.tar.gz
   mv linux-amd64/helm /usr/local/bin/helm
   ```

3. Verifica che entrambi gli strumenti siano installati correttamente:
   ```bash
   kubectl version --client
   helm version
   ```

### 2. Configurazione di kubectl per il Jenkins Slave

#### 2.1. Copia dei file di configurazione da Minikube

1. **Copia il file di configurazione** `config` **e i certificati di Minikube** dal MacBook al Jenkins Slave:
- Il file di configurazione di kubectl si trova in `~/.kube/config`.
- I certificati di Minikube si trovano nella cartella `~/.minikube/`.

2. Copia i seguenti file del Mac e incollali nel Jenkins Slave:
- **~/.kube/config**
   ```bash
   cat .kube/config
   ```
- **~/.minikube/ca.crt**
   ```bash
   cat .minikube/ca.crt
   ```
- **~/.minikube/client.crt**
   ```bash
   cat .minikube/profiles/minikube/client.crt
   ```
- **~/.minikube/client.key**
   ```bash
   cat .minikube/profiles/minikube/client.key
   ```

Per modificare i file all'interno del Jenkins Slave, installare `vim`:
   ```bash
   apt install vim
   ```

#### 2.2. Modifica dei percorsi nel file di configurazione

Una volta copiati i file, devi aggiornare i percorsi all’interno del file `config` di Kubernetes per il Jenkins Slave:
1. Apri il file di configurazione `~/.kube/config` sul Jenkins Slave e modifica i percorsi per i certificati. Assicurati che i percorsi siano corretti in base alla posizione dove hai copiato i file:
   ```bash    
   apiVersion: v1
   clusters:
   - cluster:
       certificate-authority: /var/jenkins_home/.minikube/ca.crt
   ```

   ```bash
   users:
   - name: minikube
     user:
       client-certificate: /var/jenkins_home/.minikube/profiles/minikube/client.crt
       client-key: /var/jenkins_home/.minikube/profiles/minikube/client.key
   ```

#### 2.3. Esportazione della configurazione

1. Dopo aver aggiornato il file di configurazione, esegui il seguente comando per esportare la configurazione di `kubectl`:
   ```bash
   export KUBECONFIG=/var/jenkins_home/.kube/config
   ```

2. Verifica che la configurazione sia corretta:
   ```bash
   kubectl config current-context
   kubectl get nodes
   kubectl get namespace
   ```

Se tutto è configurato correttamente, vedrai l’output relativo al tuo cluster Minikube.

### 3. Verifica e avvio della Pipeline su Jenkins

#### 3.1. Verifica della connessione su Jenkins

1. Accedi alla dashboard di Jenkins.
2. Crea la pipeline per eseguire l'Helm Install (è possibile reperirla sempre nella repo formazione_sou_k8s).
3. Avvia la pipeline dalla dashboard di Jenkins.

#### 3.2. Monitoraggio della Pipeline

La pipeline dovrebbe eseguire i seguenti passaggi:
- Clonare il repository Git contenente il progetto.
- Eseguire il test di connessione con kubectl.
- Eseguire il comando `helm upgrade --install` per distribuire l’applicazione nel namespace `formazione-sou` del cluster Minikube.

Assicurati che l’output della pipeline mostri che l’installazione è stata completata con successo e che l’applicazione è stata distribuita correttamente.

#### 3.3. Verifica dello stato dell’applicazione

1. Dopo aver eseguito la pipeline, verifica che il rilascio di Helm sia stato eseguito correttamente:
   ```bash
   helm list --namespace formazione-sou
   kubectl get pods --namespace formazione-sou
   kubectl get svc --namespace formazione-sou
   ```

2. Se tutto è stato eseguito correttamente, dovresti vedere i pod in esecuzione e il servizio esposto per l’accesso.

### Conclusioni

Questo esercizio ti ha guidato attraverso la configurazione del Jenkins Slave per lavorare con Minikube e l’esecuzione di una pipeline di Helm. Assicurati che tutti gli strumenti siano correttamente installati e configurati e che la pipeline possa essere eseguita senza problemi per distribuire correttamente l’applicazione nel cluster Kubernetes.
