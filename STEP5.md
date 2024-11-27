# Step 5 - Check Deployment Best Practices

## Obiettivo

In questo step, creerai uno script che verifica se il **Deployment** dell'applicazione **Flask** (gestita tramite Helm) soddisfa le **best practices** in Kubernetes. In particolare, lo script controllerà la presenza dei seguenti elementi:

- **Readiness Probes**
- **Liveness Probes**
- **Resource Requests**
- **Resource Limits**

Se uno o più di questi elementi non sono configurati, lo script restituirà un errore.

## Prerequisiti

1. **Accesso al Cluster Kubernetes**
   - Assicurati di avere configurato correttamente `kubectl` sul tuo ambiente, con accesso al cluster Kubernetes dove è stato rilasciato il **Deployment**.
   - Lo script richiede l'accesso tramite un **Service Account** con il ruolo `cluster-reader` (definito nel file `rbac.yaml`).

2. **Service Account e RBAC configurati**
   - Prima di eseguire lo script, assicurati di aver creato il **Service Account** e il relativo **ClusterRoleBinding** (seguendo i passaggi descritti nei file `serviceaccount.yaml` e `clusterrolebinding.yaml`).

3. **Installazione di `jq`**
   - Lo script utilizza `jq` per processare l'output JSON di `kubectl`. Se non hai `jq` installato nel tuo ambiente (per esempio, nel container Jenkins Slave), esegui il comando:
     ```bash
     apt-get install jq
     ```

## Creazione dello Script

Lo script che verrà creato si chiama `check_deployment.sh` ed effettua le seguenti operazioni:

1. **Autenticazione tramite Service Account**:
   Utilizzerà un **Service Account** di tipo `cluster-reader` per ottenere l'accesso al cluster Kubernetes.

2. **Recupero del Deployment**:
   Lo script eseguirà il comando `kubectl get deployment` per ottenere la configurazione del deployment `formazione-sou-deployment` nel namespace `formazione-sou`.

3. **Verifica della configurazione**:
   Lo script controllerà se sono presenti:
   - **Readiness Probe**
   - **Liveness Probe**
   - **Resource Requests**
   - **Resource Limits**

4. **Output di Errore**:
   Se una o più delle configurazioni richieste sono mancanti, lo script restituirà un errore con il dettaglio delle configurazioni mancanti.

## Esecuzione dello Script

1. **Salva lo script** su una macchina locale o sul container Jenkins come `check_deployment.sh` oppure `check_deployent.py`:

   Lo script è in questa repo, sia in versione bash che python.

2. **Esegui lo script** nel tuo ambiente (sia che sia nel container Jenkins oppure sul Mac):

   ```bash
   bash check_deployment.sh
   ```

   ```bash
   bash check_deployment.py
   ```

   Se lo script rileva che una o più configurazioni mancano nel `Deployment`, restituirà un errore indicando le voci mancanti (ad esempio, “Liveness Probe”, “Readiness Probe”, ecc.).
   
3. **Verifica il risultato**:
   Se lo script restituisce un messaggio di errore, aggiorna il tuo `values.yaml` e il `deployment.yaml` per includere le configurazioni mancanti (come `livenessProbe`, `readinessProbe`, `requests` e `limits`).
   - Dopo aver aggiornato i file, rilancia la pipeline su Jenkins per applicare le modifiche.

## Conclusioni

L’esecuzione dello script garantirà che il tuo **Deployment** rispetti le best practices in Kubernetes, assicurando che siano configurati correttamente i **Readiness Probes, Liveness Probes, Resource Requests e Resource Limits**. Se mancano, lo script ti indicherà cosa manca, così potrai aggiornare la configurazione e migliorare la stabilità e l’affidabilità della tua applicazione.
