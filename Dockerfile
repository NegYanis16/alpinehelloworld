# Grab the latest Alpine-based Python image
FROM python:3.13.0a2-alpine

# Install necessary dependencies
RUN apk add --no-cache --update bash

# Set up a virtual environment
RUN python3 -m venv /env
ENV PATH="/env/bin:$PATH"

# Add and install dependencies in the virtual environment
ADD ./webapp/requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -q -r /tmp/requirements.txt

# Add our code
ADD ./webapp /opt/webapp/
WORKDIR /opt/webapp

# Run the image as a non-root user
RUN adduser -D myuser
USER myuser

# Run the app with Gunicorn
CMD gunicorn --bind 0.0.0.0:${PORT:-5000} wsgi
