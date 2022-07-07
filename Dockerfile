FROM python:3.10.5-alpine

RUN apk update
RUN apk add make automake gcc g++ subversion python3-dev musl-dev postgresql-dev nginx gettext apache2-utils

RUN pip install mlflow

COPY run.sh run.sh
RUN chmod u+x run.sh

COPY nginx.conf_template /etc/nginx/sites-available/default/nginx.conf_template

RUN rm /etc/nginx/http.d/default.conf

CMD ./run.sh