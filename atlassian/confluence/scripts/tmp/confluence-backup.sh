
CONFLUENCE_DATA_LOCATION="/home/ask/msdata/confluence/data"
TIMESTAMP=$(date +'%d-%m-%Y')
CONFLUENCE_BACKUP_FOLDER="/mnt/hdd/confluence-backup"
POSTGRES_BACKUP_FOLDER="/mnt/hdd/postgres-backup/confluence"

function createConfluenceBackup() {
    echo "Stopping Confluence container...";
        docker stop confluence;
    echo "Done!";

    echo "Removing old confluence backups";
        find /mnt/hdd/confluence-backup/ -type f -name '*.gz' -mtime +7  -exec rm -rf {} \;
    echo "Done!";

    echo "Removing old postgres backups";
        find /mnt/hdd/postgres-backup/confluence/ -type f -name '*.sql' -mtime +7  -exec rm -rf {} \;
    echo "Done!";

    echo "Backup process started";
         tar -czpf  $CONFLUENCE_BACKUP_FOLDER/conflunece-backup-$TIMESTAMP.tar.gz $CONFLUENCE_DATA_LOCATION;
    echo "Created confluence-backup-$TIMESTAMP.tar.gz";

    echo "Postgres Backup started";
         docker exec -i postgres pg_dump --username postgres confluencedb > $POSTGRES_BACKUP_FOLDER/confluencedb-$TIMESTAMP.sql;
    echo "Created postgres-backup confluencedb.sql-$TIMESTAMP";

    echo "Starting Confluence container...";
        docker start confluence;
    echo "Done!";
};


createConfluenceBackup

