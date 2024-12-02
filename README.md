# Formazione Sourcesense - DevOps Academy - Track 2

## Strumenti e Pratiche Utilizzate

- **Docker** o **Podman**
- **Jenkins**
- **Ansible**
- **Vagrant** (solo per workstation Intel)
- **Kind**, **K3s** o **Minikube**
- **Groovy**
- **Helm**
- **Git**
- **Flask**
- **CI/CD**
- **Configuration Management**

---

## Scopo del Modulo Formativo

Il modulo mira a fornire una solida base pratica nelle seguenti aree:

- Utilizzo di **Ansible** per l'installazione di **Jenkins** e la configurazione di interazioni con **Kubernetes**.
- Configurazione di un **Jenkins pipeline** per la **build** di immagini **Docker**.
- Interazione con le API di **Kubernetes** per comprendere meglio i principali oggetti (Deployment, StatefulSet, Services, ecc.).
- Utilizzo di **Helm** per gestire il deploy e le versioni delle applicazioni in un cluster **Kubernetes**.

---

## Tecnologie e Metodologie Utilizzate

Durante l'esecuzione degli **Step** di questa track, sono stati utilizzati i seguenti strumenti:

- **Vagrant** è stato utilizzato per la creazione di una VM Rocky Linux 9 su cui installare Docker/Podman e configurare Jenkins.
- **Ansible** è stato utilizzato per automatizzare l'installazione di Docker/Podman, Jenkins, e altre configurazioni necessarie.
- **Jenkins** ha gestito il processo di Continuous Integration e Continuous Deployment (CI/CD) per la creazione delle immagini Docker.
- **Kubernetes** è stato utilizzato per l'orchestrazione dei container e il deployment dell'applicazione in un ambiente distribuito.
- **Helm** è stato utilizzato per gestire e versionare il deploy dell'applicazione su Kubernetes.
- **Flask** è stato utilizzato per creare un'applicazione semplice in Python da containerizzare con Docker.

---

## Dettaglio degli Step

### Step 1: Configurazione della Workstation

In questo step sono stati utilizzati **Vagrant** e **Ansible** per configurare un ambiente di sviluppo locale:

1. Creazione di una VM con **Rocky Linux 9**.
2. Installazione di **Docker** o **Podman**.
3. Creazione di una rete **Docker/Podman** per l'assegnazione di IP statici.
4. Installazione di **Jenkins** tramite Docker/Podman, configurando sia il master che uno slave.

### Step 2: Jenkins Pipeline e Docker

In questo step è stata creata una **Jenkins pipeline dichiarativa** che:

1. Esegue il **build** di un'immagine **Docker** di un'app Flask (Python).
2. Esegue il **push** dell'immagine su un registry Docker (in alternativa, si può usare un registry locale per evitare il rate-limiting di DockerHub).

### Step 3: Helm Chart

1. Creazione di un **Helm Chart** per il deploy dell'applicazione Flask su Kubernetes.
2. Versionamento del chart nella repository sotto la cartella **charts**.

### Step 4: Jenkins Pipeline per Helm Install

Creazione di una seconda pipeline Jenkins che:

1. Prende il chart Helm dalla repository **Git**.
2. Esegue il deploy dell'applicazione su Kubernetes utilizzando il comando `helm install`.

### Step 5: Best Practices per Deployment

In questo step, è stato scritto uno **script Bash/Python** che:

1. Si autentica tramite un **Service Account** di tipo **cluster-reader** su Kubernetes.
2. Esegue un check sui deployment per verificare la presenza di **Readiness** e **Liveness Probes**, e la configurazione di **Limits** e **Requests**.

### Step 6: Bonus Track - Ingress Controller

1. Installazione di un **Ingress Controller Nginx** su Kubernetes.
2. Modifica del chart Helm per includere l'Ingress Controller.
3. Configurazione di un **Ingress** per esporre l'applicazione Flask all'URL `http://formazionesou.local`.

---

## Repository

Questa repository **formazione_sou_k8s** contiene tutti i file creati durante l'esecuzione degli Step, come configurazioni di Jenkins, Dockerfile, Helm charts, script e altri strumenti necessari.

---

## Conclusione

Questa repository è strettamente legata alla Track 2 dell'Academy. Il suo scopo è fornire una guida pratica e una base di partenza per implementare un ambiente CI/CD con Kubernetes, utilizzando tecnologie come Jenkins, Docker, Helm, e altre pratiche di gestione delle applicazioni moderne.
