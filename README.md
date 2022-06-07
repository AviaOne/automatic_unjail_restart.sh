This should work with all nodes built with Cosmos

1- Add your setting and parameters in automatic_unjail_restart.sh

2- Create directory /home/script/

3- Upload automatic_unjail_restart.sh + Automatic_unjail_and_restart_LOG.log in /home/script/

4- Do not forget the permissions files, you must do ->

   cd scripts
   
   chmod +x *
   
5- Create crontab/job ->

   sudo nano /etc/crontab
   
   */10 * * * * root /root/scripts/automatic_unjail_restart.sh
   
6- it's done, every 10 minutes, the script will check is something is wrong, and will restart only if it's necessary and will send request to go out jail if you are there.
   
7- You can test the script directly with ->

   /root/scripts/automatic_unjail_restart.sh
   
