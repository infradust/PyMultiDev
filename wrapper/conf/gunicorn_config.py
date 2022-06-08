import os
daemon = False

bind = os.environ.get("GUNICORN_BIND", "0.0.0.0:80")
workers = int(os.environ.get("GUNICORN_WORKERS", 3))
worker_class = os.environ.get("GUNICORN_WORKER_CLASS", 'gevent')


# Logging
errorlog = '-'
loglevel = os.environ.get("GUNICORN_LOG_LEVEL", 'info')
accesslog = '-'
access_log_format = '%(h)s %(l)s %(u)s %(t)s "%(r)s" %(s)s %(b)s "%(f)s" "%(a)s"'
timeout = 90
