# Utilisation de l'image Python basée sur Debian
FROM python:3.13-slim

# Définir l'encodage pour éviter les erreurs de locale
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# Installer bash et autres dépendances si nécessaire
RUN apt-get update && apt-get install -y bash && rm -rf /var/lib/apt/lists/*

# Copier les dépendances et les installer
ADD ./webapp/requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -q -r /tmp/requirements.txt

# Copier le code de l'application
ADD ./webapp /opt/webapp/
WORKDIR /opt/webapp

# Créer un utilisateur non-root et l'utiliser
RUN useradd -m myuser
USER myuser

# Définir la commande de lancement
CMD gunicorn --bind 0.0.0.0:${PORT:-5000} wsgi
