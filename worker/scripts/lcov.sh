#!/usr/bin/env bash

current_dir=${PWD##*/}

LCOV="./deps/lcov/bin/lcov"
GENHTML="./deps/lcov/bin/genhtml"
OBJECTS_DIR="./out/Release/obj.target/mediasoup-worker-test/"
HTML_REPORT_DIR="/tmp/mediasoup-worker-lcov-report"
COVERAGE_INFO="/tmp/mediasoup-worker-lcov-report.info"

if [ "${current_dir}" != "worker" ] ; then
	echo ">>> [ERROR] $(basename $0) must be called from mediasoup/worker/ directory" >&2
	exit 1
fi

echo ">>> [INFO] Clearing *.gcda files ..."
find ${OBJECTS_DIR} -name *.gcda -exec rm -rf {} \;

echo ">>> [INFO] running tests ..."
gulp test:worker

echo ">>> [INFO] generating coverage info file ..."
$LCOV --no-external --capture --directory ./ --output-file ${COVERAGE_INFO}

echo ">>> [INFO] removing tests from coverage info file ..."
$LCOV -r ${COVERAGE_INFO} "`pwd`/test/*" -o ${COVERAGE_INFO}

echo ">>> [INFO] removing deps from coverage info file ..."
$LCOV -r ${COVERAGE_INFO} "`pwd`/deps/*" -o ${COVERAGE_INFO}

echo ">>> [INFO] Clearing previous report data ..."
if [[ -d ${HTML_REPORT_DIR} ]] ; then
   rm -rf ${HTML_REPORT_DIR}
else
   mkdir ${HTML_REPORT_DIR}
fi

echo ">>> [INFO] Generating HTML report ..."
$GENHTML -o ${HTML_REPORT_DIR} ${COVERAGE_INFO}

echo ">>> [INFO] Clearing coverage info file ..."
rm ${COVERAGE_INFO}

if type "open" &> /dev/null; then
	echo ">>> [INFO] opening HTML report ..."
	open ${HTML_REPORT_DIR}/index.html
fi
