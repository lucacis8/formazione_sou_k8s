Ecco il file README.md che puoi caricare nel tuo repository GitHub, includendo tutte le informazioni necessarie per spiegare l’esercizio:

# STEP 6 - Bonus Track

## Obiettivo

In questo esercizio, l'obiettivo è configurare un **Ingress Controller Nginx** all'interno dell'istanza Kubernetes e assicurarsi che l'applicazione Flask, installata tramite Helm, sia accessibile tramite un URL personalizzato: `http://formazionesou.local`.

### Steps completati

1. **Installazione di Nginx Ingress Controller:**
   Abbiamo equipaggiato il cluster Kubernetes con un Nginx Ingress Controller, utilizzando i comandi di Kubernetes e Minikube.

2. **Configurazione dell'Ingress:**
   Abbiamo aggiunto un Ingress resource nel nostro cluster per instradare il traffico HTTP al nostro servizio Flask, esponendolo tramite il dominio `formazionesou.local`.

3. **Configurazione del file `ingress.yaml`:**
   Il file `ingress.yaml` è già presente nella repository all'interno della cartella `/charts/templates` del progetto `formazione_sou_k8s`. Questo file configura l'Ingress per il nostro servizio e lo collega all'Ingress Controller Nginx.

4. **Modifica del file `/etc/hosts`:**
   Per far sì che il dominio `formazionesou.local` punti correttamente all'IP del nodo Minikube, è stato aggiunto un mapping statico nel file `/etc/hosts` del sistema operativo.

5. **Verifica accesso tramite HTTP:**
   Una volta configurato l'Ingress, è possibile accedere al servizio Flask via HTTP all'indirizzo `http://formazionesou.local`, che restituisce la risposta "hello world" fornita dall'applicazione Flask.

### File Importanti

- **`ingress.yaml`**: Il file di configurazione Ingress per il servizio Flask è situato nella directory `/charts/templates` del progetto. Questo file definisce come il traffico HTTP deve essere instradato verso il servizio Flask.

   Esempio di configurazione Ingress:
   ```yaml
   apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: flask-app-ingress
  namespace: formazione-sou
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
  - host: formazionesou.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: formazione-sou-service
            port:
              number: 80
   ```

### Come testare l’esercizio

1. **Verifica l’Ingress Controller:**
Controlla che l’Ingress Controller Nginx sia correttamente avviato e in esecuzione nel namespace `ingress-nginx`:
   ```bash
   kubectl get pods -n ingress-nginx
   ```

2. **Verifica l’accesso tramite HTTP:**
Una volta configurato l’Ingress, puoi verificare l’accesso al servizio tramite HTTP con il comando `curl`:
   ```bash
   curl http://formazionesou.local
   ```

Questo comando dovrebbe restituire la risposta “hello world” dall’applicazione Flask.

3. **Configurazione del DNS locale:**
Se il dominio `formazionesou.local` non è risolvibile, aggiungi il mapping nel file `/etc/hosts`:
   ```bash
   sudo vim /etc/hosts
   ```

Aggiungi la riga:
   ```bash
   192.168.64.4 formazionesou.local
   ```

Questo mapping permette di risolvere `formazionesou.local` all’indirizzo IP del nodo Minikube.

### Conclusioni

Questo esercizio ha dimostrato come equipaggiare un cluster Kubernetes con un Nginx Ingress Controller e come configurare l’accesso esterno a un’applicazione Flask tramite Ingress, utilizzando un dominio personalizzato.

Il lavoro include la configurazione di un file `ingress.yaml` e la modifica del file `/etc/hosts` per risolvere il dominio localmente, rendendo il servizio Flask accessibile tramite `http://formazionesou.local`.
