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
 * Insert (or replace) row into table.
 ****************************************************************************************************
 */
PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
INSERT OR REPLACE INTO WeatherCapeTable(AmbientLight,Pressure,Temperature,Humidity) VALUES(_REPLACE_THIS_PLACEHOLDER_WITH_AMBIENT_LIGHT_READING_,_REPLACE_THIS_PLACEHOLDER_WITH_PRESSURE_READING_,_REPLACE_THIS_PLACEHOLDER_WITH_TEMPERATURE_READING_,_REPLACE_THIS_PLACEHOLDER_WITH_HUMIDITY_READING_);
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
