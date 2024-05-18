FROM python:3.10-buster

RUN apt-get update && apt-get install nginx vim -y --no-install-recommends
RUN apt-get install graphviz libgraphviz-dev pkg-config supervisor -y 

COPY nginx-config/nginx.default /etc/nginx/sites-available/default
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

RUN mkdir -p /opt/app
RUN mkdir -p /opt/app/web_apps
WORKDIR /opt/app

COPY requirements.txt /opt/app/requirements.txt
RUN pip install -r requirements.txt

COPY app /opt/app/web_apps/
COPY docker-entry-point/start-server.sh /opt/app/

COPY supervisor-config/task_gunicorn.conf /etc/supervisor/conf.d/task_gunicorn.conf
COPY supervisor-config/task_rq_worker.conf /etc/supervisor/conf.d/task_rq_worker.conf
COPY supervisor-config/task_rq_scheduler.conf /etc/supervisor/conf.d/task_rq_scheduler.conf

RUN mkdir -p /var/log/gunicorn/
RUN mkdir -p /var/log/rq/

RUN mkdir -p /opt/app/web_apps/media
RUN chown -R www-data:www-data /opt/app

RUN chmod +x /opt/app/start-server.sh
ENTRYPOINT ["/opt/app/start-server.sh"]

CMD ["supervisord", "-n"]