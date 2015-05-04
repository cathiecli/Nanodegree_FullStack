The Tournament Results project contains the following files:

1. tournament.sql: create tables and views in tournament database schema
2. tournament.py: functions for various database actions to manipulate data 
3. tournament_test.py: the test file

How to run the project?
1). Start up the VirtualBox

a. cd fullstack/vagrant
b. vagrant up   -- start the VM VirtualBox
c. vagrant ssh    -- log terminal in to the virtual machine
d. cd /vagrant/tournament   -- navigate to the location of the tournament files

2). Create database objects
e. vagrant@vagrant-ubuntu-trusty-32:/vagrant/tournament$psql tournament  -- login database  
f. tournament=>\i tournament.sql   -- run the .sql script to create tables and views
g. tournament=>\q   -- exit database

3). Run the Tournament Results project
f. vagrant@vagrant-ubuntu-trusty-32:/vagrant/tournament$python tournament_test.py   -- command to run the Tournament Results python file