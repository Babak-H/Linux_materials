# first create a shell script (it will be our service)
$ touch pointless.sh 

        #!/bin/bash
        while true
        do
            echo current time is $(date)
            sleep 1
        done

# make it executable
$ chmod =X pointless.sh

# create a service file in specific folder:
$ cd /etc/systemd/system
# create the service file, it should end with .service extension
$ sudo vim pointless.service

        [UNIT]
        Description=My Pointless Service # some description about the service
        After=network.target # only run the service when network connection exists

        [Service]
        ExecStart = /home/babak/pointless.sh   # where executable service exists
        Restart=always   # in case of error restart the service 
        WorkingDirectory=/home/babak   # user,group, home address for who runs this service
        User=babak
        Group=babak
        Environment=GOPATH=/home/babak/go USERNAME=babak_g  # environment variables, separate them with space

        [Install]
        WantedBy=multi-user.target  # this will allow service to be installed on all users

# first enable the service and then start it
$ sudo systemctl enable pointless

$ sudo systemctl start pointless

# check it's status
$ sudo systemctl status pointless

$ tail /var/log/syslog

# check the logs for the service
$ sudo journalctl -u pointless
$ sudo journalctl -u pointless -f

$ sudo systemctl stop pointless

$ sudo systemctl disable pointless

# if you change the service file, you have to do daemon reload
$ sudo systemctl daemon-reload





