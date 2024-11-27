from kubernetes import client, config
import sys

def check_deployment(namespace, deployment_name):
    try:
        # Carica la configurazione Kubernetes (usa il kubeconfig o in-cluster config)
        config.load_kube_config()

        # Crea il client API per interagire con Kubernetes
        api_instance = client.AppsV1Api()

        # Recupera il deployment
        deployment = api_instance.read_namespaced_deployment(deployment_name, namespace)

        # Flag per validazione
        readiness_probe = False
        liveness_probe = False
        resource_requests = False
        resource_limits = False

        # Verifica i container del deployment
        for container in deployment.spec.template.spec.containers:
            # Controlla liveness probe
            if container.liveness_probe:
                liveness_probe = True
            # Controlla readiness probe
            if container.readiness_probe:
                readiness_probe = True
            # Controlla le risorse (Requests & Limits)
            if container.resources:
                if container.resources.requests:
                    resource_requests = True
                if container.resources.limits:
                    resource_limits = True

        # Report dei risultati
        missing = []
        if not readiness_probe:
            missing.append("Readiness Probe")
        if not liveness_probe:
            missing.append("Liveness Probe")
        if not resource_requests:
            missing.append("Resource Requests")
        if not resource_limits:
            missing.append("Resource Limits")

        if missing:
            print(f"ERROR: Deployment '{deployment_name}' is missing: {', '.join(missing)}")
            sys.exit(1)
        else:
            print(f"SUCCESS: Deployment '{deployment_name}' meets all best practices.")
            sys.exit(0)

    except client.exceptions.ApiException as e:
        print(f"ERROR: Exception when calling Kubernetes API: {e}")
        sys.exit(1)

if __name__ == "__main__":
    # Specifica il namespace e il nome del deployment
    namespace = "formazione-sou"
    deployment_name = "formazione-sou-deployment"

    # Esegui il controllo
    check_deployment(namespace, deployment_name)
