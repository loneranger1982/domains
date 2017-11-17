#!/bin/bash
cmd=$1
PROJECT_DIR=$2

PIDFILE=$PROJECT_DIR/tmp/pids/sidekiq-parse.pid
cd $PROJECT_DIR

start_function(){
  LOGFILE=/home/domains/logs/sidekiq-parser.log
  echo "Starting sidekiq..."
  bundle exec sidekiq -d -L $LOGFILE -P $PIDFILE  -q parsedomains -c 1 -e production
}

stop_function(){
  if [ ! -f $PIDFILE ]; then
    ps -ef | grep sidekiq | grep busy | grep -v grep | awk '{print $2}'  > $PIDFILE
  fi
  bundle exec sidekiqctl stop $PIDFILE
}

case "$cmd" in
  start)
    start_function
    ;;
  stop)
    stop_function
    ;;
  restart)
    stop_function && start_function;
    ;;
  *)
    echo $"Usage: $0 {start|stop|restart} /path/to/rails/app"
esac
