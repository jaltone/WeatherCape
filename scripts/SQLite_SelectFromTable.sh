#!/bin/sh
####################################################################################################
# Creator: Alexander Cerna
# License: Attribution-ShareAlike 4.0 International, https://creativecommons.org/licenses/by-sa/4.0/
# Purpose: Shell driver for SQLite.
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
# For JSON output the ',]' at the end needs to be replaced with ']' using sed.
####################################################################################################
TR=/usr/bin/tr
SED=/bin/sed

####################################################################################################
# Pipe SQL commands to SQLite.
# For JSON output the ',]' at the end needs to be replaced with ']' using sed.
####################################################################################################
# SQLITE_EXEC_BIN="/usr/bin/sqlite3 -echo"
SQLITE_EXEC_BIN=/usr/bin/sqlite3
SQLITE_DB_FILE=${APPLICATION_DIR}/data/SQLite_WeatherCape.db
SQLITE_SQL_COMMANDS=${APPLICATION_DIR}/scripts/SQLite_SelectFromTable.sql
${SQLITE_EXEC_BIN} ${SQLITE_DB_FILE} < ${SQLITE_SQL_COMMANDS} \
	| ${SED} 's/,]$/]/g'

####################################################################################################
# End of file.
####################################################################################################
