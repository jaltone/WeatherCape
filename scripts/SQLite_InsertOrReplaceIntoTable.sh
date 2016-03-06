#!/bin/sh
####################################################################################################
# Creator: Alexander Cerna
# License: Attribution-ShareAlike 4.0 International, https://creativecommons.org/licenses/by-sa/4.0/
# Purpose: Shell driver for SQLite.
# Crontab: */5 * * * * /home/applications/WeatherCape/scripts/SQLite_InsertOrReplaceIntoTable.sh
# History: 2016.01.16 Alexander Cerna: Inception.
#          2016.03.05 Alexander Cerna: Added Humidity.
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
AMBIENT_LIGHT_SENSOR_TSL2550="/sys/bus/i2c/devices/i2c-2/2-0039/lux1_input"
if [ -f ${AMBIENT_LIGHT_SENSOR_TSL2550} ]; then
	AMBIENT_LIGHT_READING_TSL2550="$(${CAT} ${AMBIENT_LIGHT_SENSOR_TSL2550} 2>/dev/null)"
else
	AMBIENT_LIGHT_READING_TSL2550=""
fi
# echo "AmbientLight is ${AMBIENT_LIGHT_READING_TSL2550} lux."

####################################################################################################
# Read Pressure Sensor (BMP085).
# The BeagleBone Weather Cape uses the BMP085 to measure the temperature and barometric pressure.
# BMP085 is an ultra-low power barometric pressure sensor capable of measuring between 300 and
# 1100 hPa (or millibar) and providing an output data in steps of 0.01 hPa. It can also measure
# the temperature between 0°C and 65°C at 0.1°C resolution. BMP085 has a flexible supply voltage
# range, provides low noise measurements at high accuracy via two-wire interface.
####################################################################################################
PRESSURE_SENSOR_BMP085="/sys/bus/i2c/devices/i2c-2/2-0077/pressure0_input"
if [ -f ${PRESSURE_SENSOR_BMP085} ]; then
	PRESSURE_READING_BMP085="$(echo $(${CAT} ${PRESSURE_SENSOR_BMP085} 2>/dev/null)/100.0 | ${BC} -l | ${SED} 's/[0]*$//g')"
else
	PRESSURE_READING_BMP085=""
fi
# echo "Pressure is ${PRESSURE_READING_BMP085} millibar."

####################################################################################################
# Read Temperature Sensor (BMP085).
# The BeagleBone Weather Cape uses the BMP085 to measure the temperature and barometric pressure.
# BMP085 is an ultra-low power barometric pressure sensor capable of measuring between 300 and
# 1100 hPa (or millibar) and providing an output data in steps of 0.01 hPa. It can also measure
# the temperature between 0°C and 65°C at 0.1°C resolution. BMP085 has a flexible supply voltage
# range, provides low noise measurements at high accuracy via two-wire interface.
####################################################################################################
TEMPERATURE_SENSOR_BMP085="/sys/bus/i2c/devices/i2c-2/2-0077/temp0_input"
if [ -f ${TEMPERATURE_SENSOR_BMP085} ]; then
	TEMPERATURE_READING_BMP085="$(echo $(${CAT} ${TEMPERATURE_SENSOR_BMP085} 2>/dev/null)/10.0 | ${BC} -l | ${SED} 's/[0]*$//g')"
else
	TEMPERATURE_READING_BMP085=""
fi
# echo "BMP085 temperature is ${TEMPERATURE_READING_BMP085} celsius."

####################################################################################################
# Read Temperature Sensor (HTU21D).
# The BeagleBone Weather Cape uses the HTU21D to measure the temperature and relative humidity.
# The HTU21D is a new digital humidity sensor with temperature output by MEAS.
# Setting new standards in terms of size and intelligence, it is embedded in a reflow solderable
# Dual Flat No leads (DFN) package with a small 3 x 3 x 0.9 mm footprint. This sensor provides
# calibrated, linearized signals in digital, I²C format. HTU21D digital humidity sensors
# are dedicated humidity and temperature plug and play transducers for OEM applications
# where reliable and accurate measurements are needed. Direct interface with a micro-controller
# is made possible with the module for humidity and temperature digital outputs.
####################################################################################################
TEMPERATURE_SENSOR_HTU21D="/sys/bus/i2c/devices/i2c-2/2-0040/hwmon/hwmon0/temp1_input"
if [ -f ${TEMPERATURE_SENSOR_HTU21D} ]; then
	TEMPERATURE_READING_HTU21D="$(echo $(${CAT} ${TEMPERATURE_SENSOR_HTU21D} 2>/dev/null)/1000.0 | ${BC} -l | ${SED} 's/[0]*$//g')"
else
	TEMPERATURE_READING_HTU21D=""
fi
# echo "HTU21D temperature is ${TEMPERATURE_READING_HTU21D} celsius."

####################################################################################################
# Calculate the average temperature from the BMP085 and HTU21D temperature readings.
####################################################################################################
TEMPERATURE_READING_AVERAGE=$(echo "(${TEMPERATURE_READING_BMP085}+${TEMPERATURE_READING_HTU21D})/2.0" | ${BC} -l | ${SED} 's/[0]*$//g')
# echo "Temperature is ${TEMPERATURE_READING_AVERAGE} celsius."

####################################################################################################
# Read Relative Humidity Sensor (HTU21D).
# The BeagleBone Weather Cape uses the HTU21D to measure the temperature and relative humidity.
# The HTU21D is a new digital humidity sensor with temperature output by MEAS.
# Setting new standards in terms of size and intelligence, it is embedded in a reflow solderable
# Dual Flat No leads (DFN) package with a small 3 x 3 x 0.9 mm footprint. This sensor provides
# calibrated, linearized signals in digital, I²C format. HTU21D digital humidity sensors
# are dedicated humidity and temperature plug and play transducers for OEM applications
# where reliable and accurate measurements are needed. Direct interface with a micro-controller
# is made possible with the module for humidity and temperature digital outputs.
####################################################################################################
HUMIDITY_SENSOR_HTU21D="/sys/bus/i2c/devices/i2c-2/2-0040/hwmon/hwmon0/humidity1_input"
if [ -f ${HUMIDITY_SENSOR_HTU21D} ]; then
	HUMIDITY_READING_HTU21D="$(echo $(${CAT} ${HUMIDITY_SENSOR_HTU21D} 2>/dev/null)/1000.0 | ${BC} -l | ${SED} 's/[0]*$//g')"
else
	HUMIDITY_READING_HTU21D=""
fi
# echo "Humidity is ${HUMIDITY_READING_HTU21D} percent relative humidity."

####################################################################################################
# Pipe SQL commands to SQLite.
####################################################################################################
# SQLITE_EXEC_BIN="/usr/bin/sqlite3 -echo"
SQLITE_EXEC_BIN=/usr/bin/sqlite3
SQLITE_DB_FILE=${APPLICATION_DIR}/data/SQLite_WeatherCape.db
SQLITE_SQL_COMMANDS=${APPLICATION_DIR}/scripts/SQLite_InsertOrReplaceIntoTable.sql
${CAT} ${SQLITE_SQL_COMMANDS} \
	| ${SED} "s/_REPLACE_THIS_PLACEHOLDER_WITH_AMBIENT_LIGHT_READING_/${AMBIENT_LIGHT_READING_TSL2550}/g" \
	| ${SED} "s/_REPLACE_THIS_PLACEHOLDER_WITH_PRESSURE_READING_/${PRESSURE_READING_BMP085}/g" \
	| ${SED} "s/_REPLACE_THIS_PLACEHOLDER_WITH_TEMPERATURE_READING_/${TEMPERATURE_READING_AVERAGE}/g" \
	| ${SED} "s/_REPLACE_THIS_PLACEHOLDER_WITH_HUMIDITY_READING_/${HUMIDITY_READING_HTU21D}/g" \
	| ${SQLITE_EXEC_BIN} ${SQLITE_DB_FILE}

####################################################################################################
# End of file.
####################################################################################################
