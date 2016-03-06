# WeatherCape

Change Log
==========

2016.03.05
Added Temperature and Humidity readings from HTU21D sensor.
SQLite Temperature column value is the average of the temperature readings from the BMP085 and HTU21D sensors.

2016.01.30
Initial upload of Shell and SQLite scripts.

Synopsis
========

This is a set of Shell and SQLite scripts for capturing BeagleBone WeatherCape sensor readings into a SQLite database.

Motivation
==========

I wanted a simple way to read WeatherCape sensors into a database. A cron job running every 5 minutes does it quite simply and neatly.

Installation
============

This requires that your BeagleBone Black be on the latest Robert C Nelson (RCN) Debian build. It also requires that SQLite be installed. Google both of these to learn how.

On my BeagleBone Black this application is installed in the /home/applications/WeatherCape directory. Create a crontab entry like so:

*/5 * * * * /home/applications/WeatherCape/scripts/SQLite_InsertOrReplaceIntoTable.sh

The scripts will create the SQLite database if it does not yet exist.

Contributors
============

As of the moment I'm not even sure that anyone would like to contribute, but please feel free to use and modify these scripts.

Bugs
====

Currently SQLite_SelectFromTable.sql outputs JSON that has commas after every record. I'll get to fixing this sometime in the future with the removal of the last comma.

For bugs please send email to jaltone@gmail.com. I'll try to respond as best as I can.

License
=======

Attribution-ShareAlike 4.0 International, https://creativecommons.org/licenses/by-sa/4.0/

