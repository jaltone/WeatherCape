/*
 ****************************************************************************************************
 * Creator: Alexander Cerna
 * License: Attribution-ShareAlike 4.0 International, https://creativecommons.org/licenses/by-sa/4.0/
 * Purpose: SQL Commands for SQLite.
 * History: 2016.01.16 Alexander Cerna: Inception.
 *          2016.03.05 Alexander Cerna: Added Humidity.
 ****************************************************************************************************
 */

/*
 ****************************************************************************************************
 * Create (if not exists) table without a row ID.
 ****************************************************************************************************
 */
PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS WeatherCapeTable(
	UtcUnixEpoch INTEGER DEFAULT (CAST(strftime('%s','now') AS INTEGER)) NOT NULL,
	AmbientLight INTEGER NOT NULL,
	Pressure REAL NOT NULL,
	Temperature REAL NOT NULL,
	Humidity REAL NOT NULL,
	PRIMARY KEY (UtcUnixEpoch, AmbientLight, Pressure, Temperature, Humidity) ON CONFLICT REPLACE
) WITHOUT ROWID;
COMMIT;

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
