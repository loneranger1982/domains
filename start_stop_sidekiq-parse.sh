#!/bin/bash
cmd=$1
PROJECT_DIR=/var/www/domains/code
STATUS=$PROJECT_DIR/tmp/pids/status
PIDFILE=$PROJECT_DIR/tmp/pids/sidekiq-$2.pid
LOGFILE=/home/domains/logs/sidekiq-parser-$2.log

cd $PROJECT_DIR

start_function(){
  
  echo "Starting sidekiq..."
  bundle exec sidekiq -d -L $LOGFILE -P $PIDFILE -q parsedomains -c 10 -e production
}

stop_function(){
  if [ ! -f $PIDFILE ]; then
    ps -ef | grep sidekiq | grep busy | grep -v grep | awk '{print $2}'  > $PIDFILE
  fi
  bundle exec sidekiqctl stop $PIDFILE
}
status_function(){

    ps -ef | grep sidekiq | grep busy | grep -v grep | awk '{print $PROJECT_DIR}' > $STATUS  
   cat $STATUS
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
  status)
   status_function
   ;;
  *)
    echo $"Usage: $0 {start|stop|restart}"
esac
