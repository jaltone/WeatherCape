/*
 ****************************************************************************************************
 * Creator: Alexander Cerna
 * License: Attribution-ShareAlike 4.0 International, https://creativecommons.org/licenses/by-sa/4.0/
 * Purpose: SQL Commands for SQLite.
 * History: 2016.01.16 Alexander Cerna: Inception.
 ****************************************************************************************************
 */

/*
 ****************************************************************************************************
 * Show or hide column names.
 ****************************************************************************************************
 */
.headers off

/*
 ****************************************************************************************************
 * Define column separator and row separator.
 * For JSON output we use a '' null-string column separator in conjunction with printf().
 * For JSON output we use a '' null-string row separator in conjunction with printf().
 ****************************************************************************************************
 */
.separator '' ''

/*
 ****************************************************************************************************
 * Show rows from table.
 * For JSON output the ',]' at the end needs to be replaced with ']' using sed.
 ****************************************************************************************************
 */
SELECT printf('[');
SELECT
	printf('{"UtcUnixEpoch":%ld,', UtcUnixEpoch),
	printf('"LocalTimeStamp":"%s",', strftime('%Y-%m-%dT%H:%M:%S',UtcUnixEpoch,'unixepoch','localtime')),
	printf('"AmbientLight":%ld,', AmbientLight),
	printf('"Pressure":%lf,', Pressure),
	printf('"Temperature":%lf},', Temperature)
FROM WeatherCapeTable;
SELECT printf(']');

/*
 ****************************************************************************************************
 * Quit.
 ****************************************************************************************************
 */
.quit

/*
 ****************************************************************************************************
 * End of file.
 ****************************************************************************************************
 */
