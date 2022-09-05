# Docker Image that we are using
# alpine is an linux based env (lightweight)
FROM python:3.9-alpine3.13
LABEL maintainer="saadijutt007@gmail.com"

# Dont buffer the python output
# Output printed directly to console
ENV PYTHONUNBUFFERED 1

# Copy files to tmp
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
# Working directly, default directory
WORKDIR /app
EXPOSE 8000

ARG DEV=false

RUN python -m venv /py && \
	  /py/bin/pip install  --upgrade pip && \
	  /py/bin/pip install -r /tmp/requirements.txt && \
	  if [ $DEV = "true" ]: \
			then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
	  fi && \
	  rm -rf /tmp && \
	  adduser \
		  --disabled-password \
		  --no-create-home \
		  django-user

# Updated ENV var inside the image
# Updating PATH created on linux operating systems
ENV PATH="/py/bin:$PATH"

USER django-user