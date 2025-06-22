BITBUCKET_DATA_LOCATION="/home/ask/msdata/bitbucket/data/bitbucket"
TIMESTAMP=$(date +'%d-%m-%Y')
BITBUCKET_BACKUP_FOLDER="/mnt/hdd/bitbucket-backup"
POSTGRES_BACKUP_FOLDER="/mnt/hdd/postgres-backup/bitbucket"

function createBitbucketBackup() {
    echo "Stopping Bitbucket container...";
        docker stop bitbucket;
    echo "Done!";

    echo "Removing old bitbucket backups";
        find /mnt/hdd/bitbucket-backup/ -type f -name '*.gz' -mtime +7  -exec rm -rf {} \;
    echo "Done!";

    echo "Removing old postgres backups";
        find /mnt/hdd/postgres-backup/bitbucket/ -type f -name '*.sql' -mtime +7  -exec rm -rf {} \;
    echo "Done!";

    echo "Backup process started";
         tar -czpf  $BITBUCKET_BACKUP_FOLDER/bitbucket-backup-$TIMESTAMP.tar.gz $BITBUCKET_DATA_LOCATION;
    echo "Created bitbucket-backup-$TIMESTAMP.tar.gz";

    echo "Postgres Backup started";
         docker exec -i postgres pg_dump --username postgres bitbucketdb > $POSTGRES_BACKUP_FOLDER/bitbucketdb-$TIMESTAMP.sql;
    echo "Created postgres-backup bitbucketdb.sql-$TIMESTAMP";

    echo "Starting Bitbucket container...";
        docker start bitbucket;
    echo "Done!";
};


createBitbucketBackup

