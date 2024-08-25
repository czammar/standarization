# Scripts to 

#################################
# Constants / global variables
#################################

SPARK_VERSION="3.1"
PYTHON_VERSION="3.9"
DATAPROC_VERSION="1.2.3"

# Path to execute the test
TEST_PATH=$(pwd)

# RELEVNAT FORMATS TO EXECUTE TESTS
REQS_FORMAT='requirements.txt'
PYTHON_FORMAT='.py'
SCALA_FORMAT='.scala'
NOTEBOOK_FORMAT='.ipynb'

# LOGS constants
LOGFILE='example.log'
LOGLEVEL='INFO'


#################################
# Functions
#################################

# --------------- Logging functions
function log_output {
  echo `date "+%Y/%m/%d %H:%M:%S"`" $1"
  echo `date "+%Y/%m/%d %H:%M:%S"`" $1" >> $LOGFILE
}

function log_debug {
  if [[ "$LOGLEVEL" =~ ^(DEBUG)$ ]]; then
    log_output "DEBUG $1"
  fi
}

function log_info {
  if [[ "$LOGLEVEL" =~ ^(DEBUG|INFO)$ ]]; then
    log_output "INFO $1"
  fi
}

function log_warn {
  if [[ "$LOGLEVEL" =~ ^(DEBUG|INFO|WARN)$ ]]; then
    log_output "WARN $1"
  fi
}

function log_error {
  if [[ "$LOGLEVEL" =~ ^(DEBUG|INFO|WARN|ERROR)$ ]]; then
    log_output "ERROR $1"
  fi
}

# Locate recursively all files with some extension

function get_paths {
    # Obtains the file paths of the file extension given
    # This functions works recursively
    REG_EXPRESION=$1
    find $(pwd) -type f -name "*$REG_EXPRESION"
}


#  --------------- Extracting code from Notebooks
function extractNotebookCode {
    FILE_PATH=$1

    # Extract the code of a .ipynb file
    cat $FILE_PATH | \
    egrep -v "   \"(.*)\":" | \
    egrep -v "\}" | egrep -v "\}|\{" | \
    egrep -v "\[|\]" | sed -e '/^ \"nbformat\":/d' | \
    sed -e '/^ \"nbformat\_minor\"/d' | \
    awk 'BEGIN{FS="   \""} {print $2}' | \
    egrep '^([^#|^////].*)' | \
    egrep '^([^\\n\",].*)' | \
    egrep '^([^<].*)'
}


########
# --------------- Execution
#####


# Remove log file if already exists
if [ -f "$LOGFILE" ] ; then
    echo "Log file encountered....."
    echo "Deleting previous Log file"
    rm "$LOGFILE"
fi

# Create empyt log file
echo "Creating a new Log file in $LOGFILE"
touch "$LOGFILE"

for FILE in $(get_paths $NOTEBOOK_FORMAT)
do
    echo "Execution for file: $FILE"
    echo "Execution for file: $FILE" >> $LOGFILE
    MSG_1="This is a test1: [PASSED]"
    log_info "This is a test1: [PASSED]"

    MSG_2="This is a test2: [FAILED]"
    log_warn "This is a test2: [FAILED]"

    echo "------------------------"
    echo "------------------------" >> $LOGFILE
    echo "" >> $LOGFILE

done