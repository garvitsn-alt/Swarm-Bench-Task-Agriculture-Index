#!/bin/bash
set +e

mkdir -p /logs/verifier
cd /testbed

python3 /tests/verify.py > /logs/verifier/test-output.log 2>&1
exit_code=$?

if [ ! -f /logs/verifier/reward.txt ]; then
  if [ "$exit_code" -eq 0 ]; then
    echo "1.0" > /logs/verifier/reward.txt
  else
    echo "0.0" > /logs/verifier/reward.txt
  fi
fi

cat /logs/verifier/test-output.log

exit 0