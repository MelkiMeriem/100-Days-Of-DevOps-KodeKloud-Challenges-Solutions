ssh banner@stapp03
vi /scripts/beta_backup.sh
chmod +x /scripts/beta_backup.sh
ssh-keygen -t rsa
ssh-copy-id clint@stbkp01
/scripts/beta_backup.sh
