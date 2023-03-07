apt-get install rsync

# will copy all the files from original directory to the backup one
# if you run this command several times, it doesnt re-copy files, since it checks if the files exist in second directory or not
# it will keep the two folders in sync with eachother
rsync original/* backup/

# this will also copy folders inside the main folder and the files inside them (recursive copy)
rsync -r original/ backup/

# this will copy the whole orginal directory and put it INSIDE the backup directory
rsync -r original backup/

# dryrun doesnt actually copy the data, but shows you what will be copied
# -v : shows what will be copied
rsync -rv --dry-run original/ backup/

# if there are files in backup that do not exist in the original folder, it will delete them.
rsync -r --delete original/ backup/

# sync a folder in one machine to another folder in another machine (similar to sftp)
# -z : zip target folder  -P : show the progress of sync
rsync -zrP ~/folder1/folder2 username@xxx.xxx.xx.xxx:~/destination/folder/

# sync from a remote original folder to our local machine (while we are on local machine)
rsync -zrP username@xxx.xxx.xx.xxx:~/original/folder ~/destination/folder