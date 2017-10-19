# SQL alapok
*Az SQL nyelv dekleratív (eredmény-orientál) jellegű.*

*A **"Mit számítsunk ki?"** kérdésre fókuszál*

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

SELECT name, address FROM customer; -- konkrét példa (customer táblából name és address oszlop megjelenítése)

SELECT * FROM customer; --ez mindent oszlopot kijelől

SELECT prodID, startdate, 1.27*stdprice FROM price; --használhatunk egyszerűbb aritmetikai kifejezéseket, oszlopfüggvényeket

SELECT prodID, startdate, 1.27*stdprice AS pricewithtax FROM price; --adhatunk "oszlopszinonimát" is az `AS` kulcs szóval amelyre horme 
```

Az eredménytáblában lehetnek azonos sorok, ami ellent mondd a relációs táblák alapelvének.
Ha ez zavaró számunka *(pl. hibás eredmény)* akkor ki tudjuk szűrni a következő képpen
```sql
SELECT DISTINCT name FROM customer;
```
*Igazából ez a művelet feletethető meg a relációs algeba **vetítés** műveletének.*

## Szelekció
Itt valójában a `WHERE` kulcs szó után megadott logikai kifejezésel szelektálhatunk az eredménytábla sorai köztt.
Különböző oszloptípusok értékeire értelem szerűen különböző adatműveletek vannak.
* Számokhoz aritmetikai kifejezések és függvények
* Szöveghez SUBSTR(), INSTR(), UPPER(), LOWER(), stb ...
* Dátumoknál +, -, és egyébb konverziók
* Halmazokhoz pl: (10, 20, 30);
Ezen műveletekkel képzet adatokból további logikai értékeket előállíthatunk
* relációkkal ...
* intervallumba tartozással 	`BETWEEN ... AND ... `
* elme-e vizsgálattal 	`IN <halmaz>`
* minta összevetéssel 	`LIKE <mint>`
```sql
--minta
SELECT 	<jellemzők>
FROM 	<táblanév>
WHERE 	<logikai kif>

-- példa: 2000$-nál magasabb áfás árak növekvő sorrendben
SELECT prodID, startdate, 1.27*stdprice AS pricewithtax
FROM price
WHERE 1.27*stdprice > 2000
ORDER BY pricewithtax;
```

## Illesztés (join)
Az illesztés azaz "természetes illesztés" műveletnél,
két vagy több tábla soraiból készítünk egy-egy új rekordot,
akkor, ha a két sor egy-egy mezőjének értéke megegyezik.

```sql
SELECT product.descrip, price.* 	-- eredmény táblában megjelenő oszlopok
FROM product, price					-- két vagy több érintett tábla	
WHERE product.prodID=price.prodID; 	-- az illesztést megvalósító oszlopok (azok a rekordok jelenek meg, ahol ezek egyenlőek)
```

*Észrevehető, hogy ez a relációs algebrában megismert **természetes illesztésnél** álltalánosabb,
inkább a **theta illesztésnek** feleltethető meg.*

Előfordulhat, hogy nem jelennek meg egyes sorok, mert az adott sorhoz
a másik táblában nem található illeszthető sor. Ez lehet kellemetlen eredmény.
Erre való a **külső illesztés**

```SQL
SELECT product.descrip, product.stdprice, price.startdate
FROM product, price
WHERE product.prodID = price.prodID(+);
```

Így ha egy adot sorhoz a másik táblából nem található illeszthető sor, akkor
egy üres sort fog hozzárendelni.

Illesztésnél lehet ugyan arra a táblára többször is hivatkozni.
*(pl. logikai kifejezésnél)*
```sql
--pl. ha szeretnénk megkapni az azonos nevű termékeket (páronként)
SELECT a.descrip, a.prodID, b.prodID				  -- Már itt hivatkozhatunk a lokális nevekre
FROM product a, product b							  -- A táblákat lokális nevekkel látjuk el.
WHERE a.descrip = b.descrip AND a.prodID < b.prodID; -- Ha azonos a leírás, de az id nem. (páronként)
```

## Oszlopfüggvények

* AVG() --> átlag
* SUM() --> összeg
* COUNT() --> darabszám
* MAX() --> legnagyobb érték
* MIN() --> legkisebb érték

pl. 1994.jan.1-től induló árak átlaga:
`sql SELECT AVG(stdprice) FROM price WHERE startdate = '01-jan-1994';`


















