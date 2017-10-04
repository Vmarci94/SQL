# SQL alapok

# Táblák létrehozása, törlése

## Táblák létrehozása
```sql
CREATE TABLE <táblanév> (<oszlop1> <típus1> [NOT NULL], <oszlop2> <típus2> [NOT NULL], ...);
-- példa
CREATE TABLE customer	(	
							custid NUMBER(6) NOT NULL,
							name CHAR(45) NOT NULL,
							address CHAR(45)
						);
```
## Táblák törlése
```sql
DROP TABLE <táblanév>;
```

# Adatok bevitele, törlése módosítása

## Adatok bevitele
```sql
INSERT INTO <táblanév> (<oszlop1>, <oszlop2>, ...) VALUES (<érték1>, <érték2>, ...);

-- példa

INSERT INTO customer (custid, name) VALUES (121212, 'Varga Márton');

/*	nem feltétlenül szükséges megadni az oszlopokat,
	de akkor minden oszlopnak egymást követően értéket kell adni
	akkor is ha null értéket kap.
*/

INSERT INTO customer VALUES (121213, 'Test Elek', NULL);
```
## Adatok törlése
```sql

-- !!FONTOS ha nincs megadva a WHERE akkor a tábla összes sorát törli!!
DELETE FROM <táblanév> WHERE <logikai kif>;

-- Tehát pl. ha minden adatot törölni akarunk egy táblából, de nem akarjuk eldobni a táblát
DELETE FROM <táblanév>

-- példa:
DELETE FROM customer WHERE custid=121212;
```
## Adatok módosítása
```sql
UPDATE <táblanév> SET (<oszlop1> = <kif1>, <oszlop2> = <kif2>, ... ) WHERE <logikai kif>;
```
Ha elhagyjuk a `WHERE` kulcs szót akkor az adott oszlopok minden sorát felülírja az adott értékkel.
példa:
```sql
UPDATE customer SET address = 'Miskolc' WHERE name='Test Elek';
```

# Lekérdezések

```sql
SELECT  <jellemzők> FROM <táblák> WHERE <logikai kif> <csoportosítás> <rendezés>;
```
Fontos tudni, hogy a lekérdezés művelet eredményként egy táblát állít elő, ha úgy tetszik add vissza.
Ezt szokás "eredmény táblának" is hívni. Persze ez a tábla is adható egy másik parancsnak beágyazva, akár csak a 
"valódi" táblák.

A különböző attribútumok jelentései:
	* `<jellemzők>` = itt definiáljuk az eredménytábla oszlopait
	* `<táblák>` = itt adjuk meg a lekérdezésben résztvevő táblák neveit
	* `<logikai kif>` = szűrhetünk a kapott sorok között [ez már nem kötelező attribútum]
	* `<csoportosítás>` = az eredménytábla sorait egymás mellé rendezi. [nem kötelező]
	* `<rendezés>` = az eredménytábla sorainak sorrendjét adhatjuk meg vele. [nem kötelező]

### Vetítés

Egy táblából adott oszlopokat válogathatunk ki.
A <jellemzők> közöttt sorolhatjuk fel a kívánt oszlopokat

```sql
SELECT <jellemzők> FROM <táblanév>; -- sablon

SELECT name, address FROM customer; -- konkrét példa

SELECT * FROM customer; --ez mindent oszlopot kijelől

SELECT prodID, startdate, 1.27*stdprice FROM price; //használhatunk egyszerűbb aritmetikai kifejezéseket
```
