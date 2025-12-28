#!/bin/bash

# Cockroach DB backup for Hashicorp Vault

# save it as s3 bucket:
kubectl -n 105-pcore-cockroach-eu-east-1 exec -it cockroach-0 -- bash

# inside the cockroach pods:
cd cockroach/data

ZIP_START_DATE=$(date -d '1 hour ago' "+%Y-%m-%d %H:%M:%S")
ZIP_START_DATE=$(date -d '1 hour ago' "2024-5-7 4:33:0")

TSDUMP_START_DATE=$(date -d '24 hour ago' "+%Y-%m-%d %H:%M:%S")
TSDUMP_START_DATE=$(date -d '24 hour ago' "2024-5-6 5:33:0")

END_DATE=$(date "2024-5-7 6:33:0")
FILE_NAME=$(date "2024-5-7 5:33:0")

# CockroachDB debug tool to collect logs and cluster details into a compressed zip file, used for troubleshooting
# gathers debug information (logs, stack traces, node status, etc.) from CockroachDB nodes.
# debug-${FILE_NAME}.zip: The output filename. It creates a zip file named dynamically based on the ${FILE_NAME} variable
# -certs-dir=../cockroach-certs-copy: Tells the command where to find the security certificates (CA, client cert, and key) needed to authenticate and connect to the cluster securely.
# --files-from --files-until: only add files generated between these two timestamps
cockroach debug zip debug-${FILE_NAME}.zip --certs-dir=../cockroach-certs-copy --files-from "${ZIP_START_DATE}" --files-until "${END_DATE}"
# exports time-series metrics (like CPU usage, query latency, and memory stats) from CockroachDB for a specific time range and saves them as a compressed file
# The command to dump the internal time-series data that CockroachDB collects for its Admin UI charts
cockroach debug tsdump --certs-dir=../cockroach-certs-copy --format=raw --from "${TSDUMP_START_DATE}" --to "${END_DATE}" | gzip > tsdump-${FILE_NAME}.gob.gz

BUCKET_NAME="105-pcore-db-backup"
# copy both files to S3
aws s3 cp tsdump-${FILE_NAME}.gob.gz s3://${BUCKET_NAME}/tsdump-${FILE_NAME}.gob.gz
aws s3 cp debug-${FILE_NAME}.zip s3://${BUCKET_NAME}/debug-${FILE_NAME}.zip
#  verifies that the file was successfully uploaded to Amazon S3 and displays its details
aws s3 ls --human-readable s3://${BUCKET_NAME}/debug-${FILE_NAME}.zip
aws s3 ls --human-readable s3://${BUCKET_NAME}/tsdump-${FILE_NAME}.gob.gz

rm debug-${FILE_NAME}.zip tsdump-${FILE_NAME}.gob.gz

# go into the pod running the cockroach db:
kubectl exec -it cockroach-client-0 -n 105-cockroach-sql-client -- ./cockroach sql --certs-dir=cockroach-certs-copy --user=cockroach_client --url=postgresql://cockroach-public 

# restore a table
RESTORE TABLE vault.vault_kv_store FROM LATEST IN 's3://105-dcore-cdb-backups-src/cockroach-backup?AUTH=implicit&AWS_REGION=eu-east-1' WITH KMS='aws:///arn:aws:kms:eu-east-1:6574564:alias/105-dcore-cockroach-cmk?AUTH=implicit&REGION=eu-east-1';

# restore a database:
# restore the backup from S3 with secret key from KMS
RESTORE DATABASE vault FROM LATEST IN 's3://105-dcore-cdb-backups-src/cockroach-backup?AUTH=implicit&AWS_REGION=eu-east-1' WITH KMS='aws:///arn:aws:kms:eu-east-1:6574564:alias/105-dcore-cockroach-cmk?AUTH=implicit&REGION=eu-east-1';

# restore specific point in time DB:
SHOW BACKUPS in 's3://105-dcore-cdb-backups-src/cockroach-backup?AUTH=implicit&AWS_REGION=eu-east-1'
RESTORE DATABASE vault FROM '/2024/05/13-023000.00' IN 's3://105-dcore-cdb-backups-src/cockroach-backup?AUTH=implicit&AWS_REGION=eu-east-1' WITH new_db_name='vault_restore_test', kms='aws:///arn:aws:kms:eu-east-1:6574564:alias/105-dcore-cockroach-cmk?AUTH=implicit&REGION=eu-east-1';

# compare records from the two cockroach databases:
USE vault;
SELECT * FROM vault_kv_store WHERE PATH='auth/dfgdf6567cvh/role/vault-operator-role';
USE vault_restore;
SELECT * FROM vault_restore WHERE PATH='auth/dfgdf6567cvh/role/vault-operator-role';
