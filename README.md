# Laboratorio di piattaforme e metodologie di sviluppo cloud

# Analisi

Prenotiamo è un App web sviluppata in Nuxt3 che consente ai dipendenti la prenotazione del pranzo.
By design, le applicazioni nuxt3 integrano in un unico progetto sia Frontend che Backend.
Il Backend fa riferiemento ad un database mysql per la raccolta delle info (menu, ordini, aziende, etc).

# Design

Ho realizzato il deploy di questa applicazione su Google Cloud Provider. Lo schema dell'architettura che ho realizzato è il seguente:

<div align="center">
  <a href="https://github.com/gerardocipriano/prenotiamo">
    <img src="src/public/img/logo.png" alt="Logo" width="200">
  </a>
</div>

# Design dettagliato

Questa sezione elenca ciascun componente necessario al deploy in cloud dell'applicazione.

<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#Container">Container</a></li>
    <li><a href="#Database">Database</a></li>
    <li><a href="#Google Cloud Run">Google Cloud Run</a></li>
    <li><a href="#Google Cloud Build">Google Cloud Build</a></li>
    <li><a href="#Google Alerts">Google Alerts</a></li>
  </ol>
</details>

## Container

Il primo step è stato quello di creare un Dockerfile che mi consentisse di traddure in un container il codice della mia applicazione scritta in nuxt.
Ho creato un branch <i>docker</i> all'interno del quale ho rimosso i file non necessari e poi ho creato il Dockerfile e il .dockerignore per ignorare altri file non necessari alla compilazione del progetto:

```yml
# Utilizzare un'immagine slim di Node.js come base
FROM node:lts-slim

# Impostare la directory di lavoro
WORKDIR /app

# Copiare i file package.json e package-lock.json
COPY package*.json ./

# Installare le dipendenze
RUN npm install

# Copiare il resto dei file dell'applicazione
COPY . .

# Esporre la porta 3000
EXPOSE 3000

# Avviare l'applicazione
CMD [ "npm", "run", "dev" ]
```

Ho creato un istanza del Container Registry su GCP.
Ho eseguito il build dell'immagine con il comando <i>docker build -t gcr.io/prenotiamo/prenotiamo-image . </i>
Dopo aver correttamente verificato il funzionamento del nuovo container, tramite la CLI gcloud ho eseguito il push dell'immagine sul container registry.

## Database

Tutti gli aspetti di creazione, gestione e distruzione del Database sono stati completamente automatizzati utilizzando Terraform.
Ho creato una risorsa google_sql_database_instance chiamata prenotiamo_instance nella regione asia-east1. Questa risorsa rappresenta un’istanza di database Cloud SQL per MySQL.
Ho impostato la versione del database a MYSQL_5_7 e ho disabilitato la protezione dall’eliminazione. Ho anche configurato le impostazioni del database, come il livello di servizio db-f1-micro, il tipo di disponibilità REGIONAL **garantisce l'HA dell'istanza** e la configurazione del backup.

Ho anche impostato alcune flag del database, come il timeout di attesa e il numero massimo di connessioni.

Inoltre, ho creato due risorse google_sql_user per creare gli utenti del servizio che verranno utilizzate dalla WebApp per accedere al database. Ho specificato i nomi utente, le password e l’host per entrambi gli utenti.

Infine, ho creato una risorsa null_resource per inizializzare il database. Ho utilizzato un provisioner local-exec per eseguire un comando mysql che popola il database con i dati dal file script.sql. Questa istruzione può essere lanciata solo da un client sul quale sia installato mysql.

In future versioni del progetto, vorrei rimuovere l'accesso pubblico al database, e sfruttare unicamente l'indirizzamento privato interno per far dialogare WebApp e DB.

Ho scelto di utilizzare un’istanza gestita di Cloud SQL invece di creare una mia istanza di database perché è più facile da configurare e gestire. Cloud SQL gestisce automaticamente le attività di manutenzione, come i backup e gli aggiornamenti, in modo da non dovermi preoccupare di queste attività.
Usando Terraform, ho creato una risorsa google_cloud_run_v2_service chiamata prenotiamo nella regione asia-east1. Questa risorsa rappresenta un servizio Cloud Run che eseguirà la nostra applicazione.

Per maggiori dettagli sul codice, fare riferimento a https://github.com/gerardocipriano/deploy-terraform-gcp-prenotiamo/blob/7ab26a248b31017103d89cc07800ed77771a7af3/google_sql.tf

## Google Cloud Run

Tutti gli aspetti di creazione, gestione e distruzione di Google Cloud Run sono stati completamente automatizzati utilizzando Terraform.

Ho creato una risorsa google_cloud_run_v2_service chiamata prenotiamo nella regione asia-east1. Questa risorsa rappresenta un servizio Cloud Run che eseguirà la nostra applicazione.

Nel blocco template, ho impostato il limite massimo di revisioni da mantenere a 3 utilizzando l’annotazione "run.googleapis.com/revision-limit". Ho impostato questo limite perchè altrimenti le revisioni afferenti a build precendenti sarebbero rimaste ad occupare risorse inutilmente.
Ho configurato **l’autoscaling (i criteri sono gestiti automaticamente da GCP)per avere un minimo di 1 istanza e un massimo di 5 istanze**.
Nel blocco containers, ho specificato l’immagine Docker da utilizzare per il nostro servizio e ho impostato diverse variabili d’ambiente per la configurazione dell’applicazione. Dopo diversi test, ho impostato i limiti di risorse per la CPU e la memoria a 2 e 2 GB rispettivamente.

Infine, ho creato una risorsa google_cloud_run_service_iam_member per concedere l’accesso pubblico al nostro servizio Cloud Run. L'accesso al servizio, anche in questo caso, è completamente gestito dal provider tramite un suo load balancer (per noi il processo è trasparente).

Ho scelto di utilizzare Cloud Run invece di GKE per diversi motivi. Innanzitutto, Cloud Run è più economico perché si paga solo per il tempo di elaborazione effettivamente utilizzato. Inoltre, Cloud Run è più facile da configurare e gestire rispetto a GKE perché non è necessario gestire un cluster Kubernetes.
Cloud Run inoltre è integrato molto bene con il servizio Cloud Build (prossima sezione) che garantisce una pipeline di CI/CD

Per maggiori dettagli sul codice, fare riferimento a https://github.com/gerardocipriano/deploy-terraform-gcp-prenotiamo/blob/8d008d3ace546964e504e5abe00e4ece4408e0f2/google_run.tf

## Google Cloud Build

Ho creato una risorsa google_cloudbuild_trigger chiamata prenotiamo_trigger. Questa risorsa rappresenta un trigger di Cloud Build che si attiverà quando viene eseguito un push sul branch specificato del repository GitHub specificato.

Nel blocco github, ho specificato il proprietario e il nome del repository GitHub da collegare a Cloud Build. Ho anche specificato il branch del repository da monitorare per i push. Questi valori sono impostati utilizzando le variabili github_owner, github_repo_name e github_branch.

Ho anche specificato il nome del file di configurazione di Cloud Build da utilizzare per il trigger. In questo caso, ho impostato il valore a cloudbuild.yaml, il che significa che Cloud Build utilizzerà il file cloudbuild.yaml nella radice del repository GitHub per definire i passaggi di compilazione.

```yml
steps:
  - name: "gcr.io/cloud-builders/gcloud"
    args: ["builds", "submit", "--tag", "gcr.io/$PROJECT_ID/prenotiamo-image"]
  - name: "gcr.io/cloud-builders/gcloud"
    args:
      [
        "run",
        "deploy",
        "prenotiamo",
        "--image",
        "gcr.io/$PROJECT_ID/prenotiamo-image",
        "--region",
        "asia-east1",
      ]
```

Per maggiori dettagli sul codice, fare riferimento a https://github.com/gerardocipriano/deploy-terraform-gcp-prenotiamo/blob/8d008d3ace546964e504e5abe00e4ece4408e0f2/google_build_trigger.tf

## Google Alerts

Ho creato diverse risorse google_monitoring_alert_policy per configurare avvisi di monitoraggio per il nostro servizio Cloud Run e il nostro database Cloud SQL.

La prima risorsa google_monitoring_alert_policy chiamata cloud_run_errors configura un avviso per il numero elevato di errori del server. Ho impostato il filtro per contare solo le richieste con codici di risposta 5xx e ho impostato la soglia a 10 richieste in un periodo di 300 secondi. Ho anche specificato un canale di notifica email per ricevere notifiche quando l’avviso viene attivato.

La seconda risorsa google_monitoring_alert_policy chiamata cloud_run_latency configura un avviso per la latenza elevata del nostro servizio Cloud Run. Ho impostato il filtro per misurare la latenza delle richieste e ho impostato la soglia a 300 ms in un periodo di 60 secondi. Ho anche specificato un canale di notifica email per ricevere notifiche quando l’avviso viene attivato.

La terza risorsa google_monitoring_alert_policy chiamata cloud_sql_cpu configura un avviso per l’utilizzo elevato della CPU del nostro database Cloud SQL. Ho impostato il filtro per misurare l’utilizzo della CPU e ho impostato la soglia al 90% in un periodo di 300 secondi. Ho anche specificato un canale di notifica email per ricevere notifiche quando l’avviso viene attivato.

Infine, ho creato una risorsa google_monitoring_notification_channel chiamata email per configurare un canale di notifica email. Ho specificato il mio indirizzo email, di norma bisognerebbe usare una DL o una SharedMailbox.

Per maggiori dettagli sul codice, fare riferimento a https://github.com/gerardocipriano/deploy-terraform-gcp-prenotiamo/blob/8d008d3ace546964e504e5abe00e4ece4408e0f2/alert.tf
