# Usa un'immagine base ufficiale di Python
FROM python:3.10-slim

# Imposta la directory di lavoro all'interno del container
WORKDIR /app

# Copia i file di configurazione nell'immagine
COPY requirements.txt requirements.txt

# Installa le dipendenze
RUN pip install --no-cache-dir -r requirements.txt

# Copia il codice sorgente dell'app nell'immagine
COPY app.py app.py

# Espone la porta 5000
EXPOSE 5000

# Comando di avvio del container
CMD ["python", "app.py"]
