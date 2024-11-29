# STEP 3 - Helm Chart

## Descrizione

In questo step è stato creato un **Helm Chart** personalizzato che consente il deploy dell'immagine Docker generata dalla pipeline `flask-app-example-build`. Il chart è configurato per permettere la specifica del tag dell'immagine da rilasciare, garantendo così flessibilità nell'ambiente di deploy. 

Gli Helm Chart sono fondamentali per semplificare e standardizzare il deploy delle applicazioni su Kubernetes, fornendo un set di strumenti per gestire configurazioni complesse in modo dichiarativo e modulare.

Il chart è stato strutturato seguendo le best practice e si trova nella cartella `charts` della repository `formazione_sou_k8s`. Tutti i file necessari (inclusi `Chart.yaml`, `values.yaml` e i template dei manifest Kubernetes) sono inclusi e pronti per essere utilizzati.

Per la creazione sono stati presi come riferimento:
- Il progetto [flask-chart](https://github.com/thedataincubator/flask-chart)
- I chart disponibili nella repository ufficiale di [Bitnami](https://github.com/bitnami/charts)

## Utilizzo dello Helm Chart

Questo chart costituisce la base per gli step successivi:
- **Step 4 - Helm Install:** Lo chart verrà utilizzato da una pipeline Jenkins per eseguire un deploy su un'istanza Kubernetes locale nel namespace `formazione_sou`.
- **Step 5 - Check Deployment Best Practices:** Sarà verificata la correttezza del Deployment effettuato tramite lo chart, controllando l'implementazione di best practice come l'uso di Readiness e Liveness Probes, nonché delle risorse `Limits` e `Requests`.
- **Step 6 - Bonus Track:** Lo chart sarà ampliato per gestire l'installazione di un Ingress Controller Nginx, configurando un hostname per esporre l'applicazione Flask su `http://formazionesou.local`.

L'Helm Chart realizzato non solo semplifica il deploy, ma rappresenta un componente modulare e facilmente estendibile per gestire esigenze sempre più avanzate nei contesti Kubernetes.

## Note Finali

Per utilizzare lo Helm Chart, è sufficiente seguire le istruzioni standard di Helm, specificando il tag desiderato tramite i file dei valori (`values.yaml`) o direttamente tramite la CLI:

```bash
helm install flask-app ./charts --set image.tag=<your-tag>
```

Questo chart fornisce una base robusta per implementare pipeline CI/CD e deploy applicativi scalabili su Kubernetes.

