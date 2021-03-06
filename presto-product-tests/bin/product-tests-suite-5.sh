#!/usr/bin/env bash

set -xeuo pipefail

suite_exit_code=0

presto-product-tests-launcher/bin/run-launcher test run \
    --environment singlenode-hive-impersonation \
    -- -g storage_formats,hdfs_impersonation \
    || suite_exit_code=1

presto-product-tests-launcher/bin/run-launcher test run \
    --environment singlenode-kerberos-hive-impersonation \
    -- -g storage_formats,hdfs_impersonation,authorization -x iceberg \
    || suite_exit_code=1

# TODO: enable avro tests once https://github.com/prestosql/presto/issues/3794 is fixed
presto-product-tests-launcher/bin/run-launcher test run \
    --environment multinode-hive-caching \
    -- -g hive_caching,storage_formats -x iceberg,avro \
    || suite_exit_code=1

echo "$0: exiting with ${suite_exit_code}"
exit "${suite_exit_code}"
