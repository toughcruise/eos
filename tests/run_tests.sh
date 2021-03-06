#!/bin/bash

path=`dirname $0`

# Test to sync transaction across cluster with 1 producing, 1 non-producing nodes
scriptNames[0]='trans_sync_across_mixed_cluster_test.sh -p 1 -n 2'

# Test to transfer funds across multiple accounts in cluster and validate
scriptNames[1]='distributed-transactions-test.py -p 1 -n 4'

failingTestsCount=0
for scriptName in "${scriptNames[@]}"; do
    echo "********* Running script: $scriptName"
    $path/$scriptName
    retCode=$?
    if [[ $retCode != 0 ]]; then
	failingTests[$failingTestsCount]=$scriptName
	(( failingTestsCount++ ))
    fi
    echo "********* Script run finished"
done

if [[ $failingTestsCount > 0 ]]; then
    echo "********* END ALL TESTS WITH FAILURES" >&2
    echo "********* FAILED TESTS ($failingTestsCount): " >&2
    printf '*********\t%s\n' "${failingTests[@]}" >&2
else
    echo "********* END ALL TESTS SUCCESSFULLY"
fi
exit $failingTestsCount
