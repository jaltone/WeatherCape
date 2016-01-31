#!/bin/sh
####################################################################################################
# Creator: Alexander Cerna
# License: Attribution-ShareAlike 4.0 International, https://creativecommons.org/licenses/by-sa/4.0/
# Purpose: Shell driver for SQLite.
# Crontab: */5 * * * * /home/applications/WeatherCape/scripts/SQLite_InsertOrReplaceIntoTable.sh
# History: 2016.01.16 Alexander Cerna: Inception.
####################################################################################################

####################################################################################################
# Turn on or turn off execution trace.
####################################################################################################
set +x

####################################################################################################
# Set the top level application directory.
####################################################################################################
APPLICATION_DIR=/home/applications/WeatherCape

####################################################################################################
# Create (if not exists) table without a row ID.
####################################################################################################
${APPLICATION_DIR}/scripts/SQLite_CreateIfNotExistsTable.sh

####################################################################################################
# Read Ambient Light Sensor (TSL2550).
# The BeagleBone Weather Cape captures ambient light data using an ambient light sensor TSL2550.
# The TSL2550 features two photodiodes, an analog-to-digital (ADC) converter and transmits
# ambient light measurements over a two-wire SMBus serial interface. The ambient light data
# is provided in “Lux”, which is a commonly used illuminance unit.
####################################################################################################
CAT=/bin/cat
BC=/usr/bin/bc
SED=/bin/sed
AMBIENT_LIGHT_SENSOR="/sys/bus/i2c/devices/i2c-2/2-0039/lux1_input"
if [ -f ${AMBIENT_LIGHT_SENSOR} ]; then
	AMBIENT_LIGHT_READING="$(${CAT} ${AMBIENT_LIGHT_SENSOR} 2>/dev/null)"
else
	AMBIENT_LIGHT_READING=""
fi
# echo "AmbientLight is ${AMBIENT_LIGHT_READING} lux."

####################################################################################################
# Read Pressure Sensor (BMP085).
# The BeagleBone Weather Cape uses the BMP085 to measure the temperature and barometric pressure.
# BMP085 is an ultra-low power barometric pressure sensor capable of measuring between 300 and
# 1100 hPa (or millibar) and providing an output data in steps of 0.01 hPa. It can also measure
# the temperature between 0°C and 65°C at 0.1°C resolution. BMP085 has a flexible supply voltage
# range, provides low noise measurements at high accuracy via two-wire interface.
####################################################################################################
PRESSURE_SENSOR="/sys/bus/i2c/devices/i2c-2/2-0077/pressure0_input"
if [ -f ${PRESSURE_SENSOR} ]; then
	PRESSURE_READING="$(echo $(${CAT} ${PRESSURE_SENSOR} 2>/dev/null)/100.0 | ${BC} -l | ${SED} 's/[0]*$//g')"
else
	PRESSURE_READING=""
fi
# echo "Pressure is ${PRESSURE_READING} millibar."

####################################################################################################
# Read Temperature Sensor (BMP085).
# The BeagleBone Weather Cape uses the BMP085 to measure the temperature and barometric pressure.
# BMP085 is an ultra-low power barometric pressure sensor capable of measuring between 300 and
# 1100 hPa (or millibar) and providing an output data in steps of 0.01 hPa. It can also measure
# the temperature between 0°C and 65°C at 0.1°C resolution. BMP085 has a flexible supply voltage
# range, provides low noise measurements at high accuracy via two-wire interface.
####################################################################################################
TEMPERATURE_SENSOR="/sys/bus/i2c/devices/i2c-2/2-0077/temp0_input"
if [ -f ${TEMPERATURE_SENSOR} ]; then
	TEMPERATURE_READING="$(echo $(${CAT} ${TEMPERATURE_SENSOR} 2>/dev/null)/10.0 | ${BC} -l | ${SED} 's/[0]*$//g')"
else
	TEMPERATURE_READING=""
fi
# echo "Temperature is ${TEMPERATURE_READING} celsius."

####################################################################################################
# Pipe SQL commands to SQLite.
####################################################################################################
# SQLITE_EXEC_BIN="/usr/bin/sqlite3 -echo"
SQLITE_EXEC_BIN=/usr/bin/sqlite3
SQLITE_DB_FILE=${APPLICATION_DIR}/data/SQLite_WeatherCape.db
SQLITE_SQL_COMMANDS=${APPLICATION_DIR}/scripts/SQLite_InsertOrReplaceIntoTable.sql
${CAT} ${SQLITE_SQL_COMMANDS} \
	| ${SED} "s/_REPLACE_THIS_PLACEHOLDER_WITH_AMBIENT_LIGHT_READING_/${AMBIENT_LIGHT_READING}/g" \
	| ${SED} "s/_REPLACE_THIS_PLACEHOLDER_WITH_PRESSURE_READING_/${PRESSURE_READING}/g" \
	| ${SED} "s/_REPLACE_THIS_PLACEHOLDER_WITH_TEMPERATURE_READING_/${TEMPERATURE_READING}/g" \
	| ${SQLITE_EXEC_BIN} ${SQLITE_DB_FILE}

####################################################################################################
# End of file.
####################################################################################################
