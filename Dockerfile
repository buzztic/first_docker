FROM python:3.8.14-slim

#Do not use env as this would persist after the build and would impact your containers, children images
ARG DEBIAN_FRONTEND=noninteractive

# force the stdout and stderr streams to be unbuffered.
ENV PYTHONUNBUFFERED 1

RUN apt-get -y update \
    && apt-get -y upgrade \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --uid 10000 -ms /bin/bash runner

WORKDIR /home/runner/app

USER 10000

ENV PATH="${PATH}:/home/runner/.local/bin"

COPY ./  ./

RUN pip install --upgrade --no-cache-dir pip==24 \
    && pip install --no-cache-dir poetry==1.8.2 \
    && poetry install --only main

EXPOSE 8000

ENTRYPOINT [ "poetry", "run" ]
CMD ["sh", "-c", "uvicorn app.main:app --host 0.0.0.0 --port $PORT"]

