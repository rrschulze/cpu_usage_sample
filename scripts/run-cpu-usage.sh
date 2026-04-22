# Sample shell script to start the cpu usage sample running.
# Alternatively this could be specified as a service

# Variables to be specified:
# - Location of SDSF libraries (normally /usr/lpp/sdsf/java/lib_64) 
SDSF=/usr/lpp/sdsf/java/lib_64

# - Port number to run this from
PORT={available_port_number}

DIR=`dirname $0`

java -Djava.library.path=.:$SDSF -Xms16m -Xmx512m \
    -Dserver.port=$PORT \
    -jar $DIR/cpu-1.0.0.jar