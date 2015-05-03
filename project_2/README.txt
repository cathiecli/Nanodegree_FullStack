The Tournament Results project contains the following files:

1. tournament.sql: create tables and views in tournament database schema
2. tournament.py: functions for various database actions to manipulate data 
3. tournament_test.py: the test file

How to run the project?
a. cd fullstack/vagrant
b. vagrant up   -- start the VirtualBox
c. vagrant ssh
d. cd /vagrant/tournament   -- navigate to the location of the files
e. vagrant@vagrant-ubuntu-trusty-32:/vagrant/tournament$psql tournament  
f. tournament=>\i tournament.sql   -- run the create tables and views
g. tournament=>\q   -- exit
f. vagrant@vagrant-ubuntu-trusty-32:/vagrant/tournament$python tournament_test.py   -- command to run the Tournament Results python file

