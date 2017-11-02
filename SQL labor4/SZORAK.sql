-----------------------------------------------------------
-- Takaritas: Szkript altal generalt objektumok eltuntetese
-----------------------------------------------------------
-- tablak eldobasa
Drop Table visits  Cascade Constraints Purge;
Drop Table places  Cascade Constraints Purge;
Drop Table persons Cascade Constraints Purge;
--
-- id generalo szekvenciak eldobasa
Drop Sequence seq_persons;
Drop Sequence seq_places;
Drop Sequence seq_visits;
--
----------------------------------------
-- szekvenciak letrehozasa
----------------------------------------
-- seq_persons szekvencia letrehozasa
Create Sequence seq_persons
    Increment By 1 
    Start With   10000
    Minvalue     10000
    Maxvalue     100000000     
    Nocycle
    Nocache
    Noorder;
--
-- seq_places szekvencia letrehozasa
Create Sequence seq_places
    Increment By 1 
    Start With   10000 
    Minvalue     10000
    Maxvalue     100000000
    Nocycle
    Nocache
    Noorder;
--
-- seq_visits szekvencia letrehozasa
Create Sequence seq_visits
    Increment By 1 
    Start With   10000 
    Minvalue     10000
    Maxvalue     100000000
    Nocycle
    Nocache
    Noorder;
--
--
----------------------------------------
-- tablak letrehozasa
----------------------------------------
-- places tabla letrehozasa
--
-- seq_places: a hely azonositoja
-- name: a hely neve
-- address: a hely cime
-- phone: a hely telefonszama
-- price: a hely arfekvese (low, medium, high)
-- place_type: hely tipusa
-- comments: a helyrol irt megjegyzesek
Create Table places (
	place_id        Number(10)      Not Null,
	name            NVarchar2(50)    Not Null,
	address         NVarchar2(100)   Not Null,
	phone           NVarchar2(20),
	price           NVarchar2(8),
	place_type      NVarchar2(50),
	comments        NVarchar2(500),
--    
    Constraint pk_places Primary Key (place_id),
    Constraint ck_places_price Check (price In ('low', 'high', 'medium'))
);
--
-- persons tabla letrehozasa
--
-- seq_persons: a szemely azonositoja
-- name: a szemely neve
-- address: a szemely lakcime
-- phone: a szemely telefonszama
-- income: a szemely jovedelme
-- hobby: a szemely hobbija, erdeklodesi kore
-- favourite_movie: a szemely kedvenc filmje
Create Table persons (
	person_id       Number(10)      Not Null,
	name            NVarchar2(50)    Not Null,
	address         NVarchar2(100),
	phone           NVarchar2(20),
	income          Number(8), 
	hobby           NVarchar2(500),
	favourite_movie NVarchar2(50),
--
    Constraint pk_persons Primary Key (person_id),
    Constraint ck_persons_income Check (income Between 15000 And 200000000)
);
--
-- visits tabla letrehozasa
--
-- seq_places: a hely azonositoja
-- seq_persons: a szemely azonositoja
-- frequency: latogatas gyakorisaga
-- last_visit: utolso latogatas datuma
-- first_visit: elso latogatas datuma
-- likes: a szemely kedveli-e a helyet (i/n)
-- average_spending: atlag koltes
Create Table visits (
	visit_id       Number(10)      Not Null,
	place_id         Not Null,
	person_id        Not Null,
	frequency        Number(1),
	last_visit       Date,
	first_visit      Date,
	likes            Number(1) Default 0,
	average_spending Number(8),
--
    Constraint pk_visits Primary Key (visit_id),
    Constraint fk_visits_places  Foreign Key (place_id)  References places  (place_id)  On Delete Cascade,
    Constraint fk_visits_persons Foreign Key (person_id) References persons (person_id) On Delete Cascade,
    Constraint ck_visits_frequency    Check (frequency Between 1 And 7),
    Constraint ck_visits_likes      	Check (likes In (1, 0)),
	Constraint ck_visits_firstv_lastv Check (first_visit <= last_visit)
);
comment on column visits.likes is 'A 0, 1 értékek rendre a Hamis, Igaz logikai értéket kódolják.';
-- Generate ID for visits table with a trigger
create or replace trigger bi_visits
before insert on visits
for each row
begin
  if :new.visit_id is null then
    select seq_visits.nextval into :new.visit_id
      from dual;
  end if;
end;
/
--
--
----------------------------------------
-- Tablak feltoltese
----------------------------------------

--
-- Places tabla feltoltese
--
Insert Into Places (place_id, Name, Address, Phone, Price, place_type, Comments)
Values (seq_places.NextVal, 'Ady Endre MK', 'IV., Tavasz u. 4.', '(1) 369-3533', 'low', 'művelődesi ház', '');
--
Insert Into Places (place_id, Name, Address, Phone, Price, place_type, Comments)
Values (seq_places.NextVal, 'Alcatraz Club', 'VII., Nyár u. 1.', '(1) 478-6010', 'low', 'diszkó', 'Jó a hely de rossz a zene.');
--
Insert Into Places (place_id, Name, Address, Phone, Price, place_type, Comments)
Values (seq_places.NextVal, 'Angyalföldi Gyermek és IH', 'XIII., Dagály u. 15/a.', '(1) 349-7761', 'high', 'művelodesi ház', '');
--
Insert Into Places (place_id, Name, Address, Phone, Price, place_type, Comments)
Values (seq_places.NextVal, 'Angyalföldi József Attila MK', 'XIII., József Attila tér 4.', '(1) 320-3844', 'medium', 'művelodesi ház', '');
--
Insert Into Places (place_id, Name, Address, Phone, Price, place_type, Comments)
Values (seq_places.NextVal, 'Arató Disco', 'XIV., Stefánia út 34.', '', 'high', 'diszkó', 'Jó a zene. Draga a sör.');
--
Insert Into Places (place_id, Name, Address, Phone, Price, place_type, Comments)
Values (seq_places.NextVal, 'Articsóka Színpad', 'VI., Zichy J. u. 17.', '(1) 302-7757', 'low', '', '');
--
Insert Into Places (place_id, Name, Address, Phone, Price, place_type, Comments)
Values (seq_places.NextVal, 'Bamboo Music Club', 'VI., Dessewffy u. 44.', '(1) 312-3619', 'medium', 'diszkó', 'Rossz a zene. A sör ára nem vészes');
--
Insert Into Places (place_id, Name, Address, Phone, Price, place_type, Comments)
Values (seq_places.NextVal, 'Benczúr Klub', 'VI., Benczúr u. 27.', '(1) 321-7334', 'low', '', '');
--
Insert Into Places (place_id, Name, Address, Phone, Price, place_type, Comments)
Values (seq_places.NextVal, 'Blues Alley Pub', 'V., Szt. István krt. 13.', '(30) 940-6692', 'low', '', '');
--
Insert Into Places (place_id, Name, Address, Phone, Price, place_type, Comments)
Values (seq_places.NextVal, 'Csili étterem', 'XX., Nagy Győri István u. 4-6.', '(1) 283-0229/33 m.', 'medium', '', '');
--
Insert Into Places (place_id, Name, Address, Phone, Price, place_type, Comments)
Values (seq_places.NextVal, 'Dózsa Művelodesi Ház', 'XVII., Pesti út 113.', '(1) 256-4626', 'low', 'művelődési ház', '');
--
Insert Into Places (place_id, Name, Address, Phone, Price, place_type, Comments)
Values (seq_places.NextVal, 'E-Klub', 'X., Népliget', '(1) 263-1614', 'medium', 'diszkó', '');
--
Insert Into Places (place_id, Name, Address, Phone, Price, place_type, Comments)
Values (seq_places.NextVal, 'End Station', 'VII., Kertész u. 33.', '', 'low', '', 'Olcsó a sör. Olcsó a bor is. Rossz a zene');
--
Insert Into Places (place_id, Name, Address, Phone, Price, place_type, Comments)
Values (seq_places.NextVal, 'Ezres Klub', 'XI., Irinyi József u. 9-11.', '(1) 463-4276', 'medium', 'diszkó', '');
--
Insert Into Places (place_id, Name, Address, Phone, Price, place_type, Comments)
Values (seq_places.NextVal, 'Fat Mo''s Club', 'V., Veres Pálné u. 9.', '(1) 267-3199', 'high', 'diszkó', '');
--
Insert Into Places (place_id, Name, Address, Phone, Price, place_type, Comments)
Values (seq_places.NextVal, 'Ferencvárosi Művelődési Központ', 'IX., Haller u. 27.', '(1) 216-1300', 'medium', 'művelődesi ház', '');
--
Insert Into Places (place_id, Name, Address, Phone, Price, place_type, Comments)
Values (seq_places.NextVal, 'Fonó Budai Zeneház', 'XI., Sztregova u. 3.', '(1) 206-5300', 'high', 'művelődési ház', '');
--
Insert Into Places (place_id, Name, Address, Phone, Price, place_type, Comments)
Values (seq_places.NextVal, 'Fővárosi Művelődési Ház', 'XI., Fehérvári út 47.', '(1) 203-3868', 'low', 'művelődési ház', '');
--
Insert Into Places (place_id, Name, Address, Phone, Price, place_type, Comments)
Values (seq_places.NextVal, 'Gödöllő, Café Hamvay', 'Gödöllő, Piac tér.', '(28) 422-008', 'low', '', '');
--
Insert Into Places (place_id, Name, Address, Phone, Price, place_type, Comments)
Values (seq_places.NextVal, 'Gödöllői Trafó Club', 'Gödöllő, Palotakert HÉV-all.', '(28) 432-436', 'high', '', 'Nagyon drága. Jól éreztük magunkat, igényes hely');
--
Insert Into Places (place_id, Name, Address, Phone, Price, place_type, Comments)
Values (seq_places.NextVal, 'Hades Jazztaurant', 'VI., Vörösmarty u. 31.', '(1) 352-1503', 'medium', '', '');
--
Insert Into Places (place_id, Name, Address, Phone, Price, place_type, Comments)
Values (seq_places.NextVal, 'Helldorádó Étterem, Disco és Pub', 'IX., Üllői út 45-47.', '', 'high', 'diszkó és étterem', '');
--
Insert Into Places (place_id, Name, Address, Phone, Price, place_type, Comments)
Values (seq_places.NextVal, 'Hemingway Club', 'XI., Kosztolányi D. tér 2.', '(1) 381-0522', 'low', '', '');
--
Insert Into Places (place_id, Name, Address, Phone, Price, place_type, Comments)
Values (seq_places.NextVal, 'Henry J. Bean''s Bar and Grill', 'V., Szt. István krt. 13.', '(1) 302-3112', 'low', '', '');
--
Insert Into Places (place_id, Name, Address, Phone, Price, place_type, Comments)
Values (seq_places.NextVal, 'Jazz Garden Club and Restaurant', 'V., Veres Pálné u. 44/A.', '(1) 266-7364', 'medium', '', '');
--
Insert Into Places (place_id, Name, Address, Phone, Price, place_type, Comments)
Values (seq_places.NextVal, 'Josefina Blues Bell', 'X., Kerepesi út 97.', '(30) 439-4446', 'high', '', '');
--
Insert Into Places (place_id, Name, Address, Phone, Price, place_type, Comments)
Values (seq_places.NextVal, 'Kultiplex Művelődési Ház', 'IX., Kinizsi u. 28.', '(1) 219-0706', 'high', 'művelődési ház', 'Jó hely');
--
Insert Into Places (place_id, Name, Address, Phone, Price, place_type, Comments)
Values (seq_places.NextVal, 'MATAV Zeneház', 'IX., Páva u. 10-12.', '(1) 215-7901', 'low', '', '');
--
Insert Into Places (place_id, Name, Address, Phone, Price, place_type, Comments)
Values (seq_places.NextVal, 'Macskafogó Music Pub', 'V., Nádor u. 29.', '(1) 473-0123', 'high', 'diszkó', '');
--
Insert Into Places (place_id, Name, Address, Phone, Price, place_type, Comments)
Values (seq_places.NextVal, 'Majd Leonard Könyves Kávéház', 'V., Balassi B. u. 7.', '(1) 301-3891', 'medium', '', '');
--
Insert Into Places (place_id, Name, Address, Phone, Price, place_type, Comments)
Values (seq_places.NextVal, 'Millenáris Park', 'II. Fény u. 20-22.', '(1) 438-5335', 'high', '', '');
--
Insert Into Places (place_id, Name, Address, Phone, Price, place_type, Comments)
Values (seq_places.NextVal, 'Morrison''s Music Pub', 'VI., Révay 25.', '(1) 269-4060', 'low', 'diszkó', '');
--
Insert Into Places (place_id, Name, Address, Phone, Price, place_type, Comments)
Values (seq_places.NextVal, 'Music Corner', 'V., Arany J. u. 25.', '(1) 269-3759', 'medium', 'diszkó', '');
--
Insert Into Places (place_id, Name, Address, Phone, Price, place_type, Comments)
Values (seq_places.NextVal, 'Old Man''s Music Pub', 'VII., Akácfa u. 13.', '(1) 322-7645', 'high', 'diszkó', 'Nem rossz');
--
Insert Into Places (place_id, Name, Address, Phone, Price, place_type, Comments)
Values (seq_places.NextVal, 'Petőfi Csarnok', 'XIV., Zichy út 14.', '(1) 363-3730', 'medium', 'művelődési ház', '');
--
Insert Into Places (place_id, Name, Address, Phone, Price, place_type, Comments)
Values (seq_places.NextVal, 'Ráday Klub', 'IX., Ráday u. 43-45.', '(1) 217-4766', 'high', 'diszkó', '');
--
Insert Into Places (place_id, Name, Address, Phone, Price, place_type, Comments)
Values (seq_places.NextVal, 'Sakáltanya', 'V., Kúria u. 2.', '(1) 266-1165', 'high', '', '');
--
Insert Into Places (place_id, Name, Address, Phone, Price, place_type, Comments)
Values (seq_places.NextVal, 'Árkádia Mulató', 'XI., Fehérvári út 120.', '(1) 206-1225', 'low', '', '');
--
Insert Into Places (place_id, Name, Address, Phone, Price, place_type, Comments)
Values (seq_places.NextVal, 'Sárkány Pub', 'Szeged, V. Hugó utca 16.', '(20) 317-8777', 'medium', 'étterem, pub', '');

--
-- Persons tabla feltoltese
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Ács Benedek', 'Bp. IV., Berda József utca', '(1) 369-2031', 416250);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Ács Fábián', 'Bp. VII., Alpár utca', '(1) 322-8706', 20000000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Ács Lehel', 'Bp. IV., Liszt Ferenc utca', '(1) 379-6051', 110000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Ács Szabina', 'Bp. VIII., Baross utca', '(1) 303-2702', 155000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Albert Gertrúd', 'Bp. III., Királylaki út', '(1) 250-4656', 315000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Antal Irma', 'Gödöllő, Batsányi János utca', '(28) 514-255', 308750);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Aranyos Domonkos', 'Bp. III., Szellő utca', '(1) 388-4657', 465000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Ármos Bernadett', 'Bp. X., Kővágó utca', '(1) 262-1729', 15000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Árpás Ambrus', 'Bp. IV., Kassai utca', '(1) 389-8459', 317500);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Balázsovics Benedek', 'Bp. IV., Berda József utca', '(1) 369-2031', 58000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Balogh Jakob', 'Bp. IV., Káposztásmegyeri út', '(1) 233-0975', 577500);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Bana Bozsidár', 'Bp. XI., Etele út', '(1) 205-6948', 390000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Bana Nadinka', 'Bp. XI., Verbena utca', '(1) 208-5836', 915000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Bana Oresztész', 'Bp. XIII., Bulcsú utca', '(1) 320-3139', 420000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Bana Renáta', 'Bp. XI., Csóka utca', '(1) 206-7249', 16000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Bana Vladimir', 'Bp. XI., Szováta utca', '(1) 203-1103', 367500);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Barta Barbara', 'Gödöllő, Batthyány Lajos utca', '(28) 414-297', 322500);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Bartik Soma', 'Bp. VII., Károly körút', '(1) 317-6373', 601875);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Bata Gyöngyi', 'Bp. II., Endrődi Sándor utca', '(1) 275-2300', 925000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Benyó Domonkos', 'Bp. III., Szellő utca', '(1) 388-4657', 930000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Berze Ádám', 'Bp. XI., Rátz László utca', '(1) 208-2455', 635000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Berze Sebestyén', 'Gödöllő, Palotakert utca', '(30) 256-9667', 40000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Bobák Oresztész', 'Bp. XIII., Bulcsú utca', '(1) 320-3139', 1120000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Borszéki Vendel', 'Bp. III., Pablo Neruda utca', '(1) 243-1909', 319375);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Both Bertolda', 'Bp. III., Kerék utca', '(1) 368-4383', 270000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Both Domonkos', 'Bp. III., Szellő utca', '(1) 388-4657', 175000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Both Paszkál', 'Bp. III., Szőlő utca', '(1) 388-2833', 280000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Bucsai Roland', 'Bp. XIII., Hun utca', '(1) 359-5963', 50000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Buday Nadinka', 'Bp. XI., Verbena utca', '(1) 208-5836', 415000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Bukovics Lídia', 'Bp. VIII., Losonci tér', '(1) 334-6298', 56000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Bundik Elemér', 'Bp. XIII., Gidófalvy Lajos utca', '(1) 320-7828', 468750);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Czifra Anikó', 'Bp. IX., Üllői út', '(1) 281-5337', 351875);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Csepi Panna', 'Bp. XIII., Béke utca', '(1) 320-0241', 53900);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Csepi Sarolta', 'Bp. XI., Budaörsi út', '(1) 247-1978', 13000000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Cserhidy Bertolda', 'Bp. III., Kerék utca', '(1) 368-4383', 580000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Csima Benedek', 'Bp. IV., Berda József utca', '(1) 369-2031', 17000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Csombor Miklós', 'Bp. XII., Tartsay Vilmos utca', '(1) 375-1638', 2012500);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Dávid Samu', 'Bp. IV., Tél utca', '(1) 360-4733', 222220);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Dóczi Gilda', 'Bp. III., Torma Károly utca', '(1) 242-7074', 235000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Dóra Jakob', 'Bp. IV., Káposztásmegyeri út', '(1) 233-0975', 13000000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Dr. Bodó Sámson', 'Bp. XIV., Utász utca', '(1) 222-5318', 100000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Dr. Flóri Lehel', 'Bp. IV., Liszt Ferenc utca', '(1) 379-6051', 150300);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Dr. Helyes Cecil', 'Bp. II., Kökeny utca', '(1) 376-9130', 70000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Dr. Hudák Jakob', 'Bp. IV., Káposztásmegyeri út', '(1) 233-0975', 150000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Dr. Mészáros Ali', 'Bp. VII., Damjanich utca', '(1) 322-5733', 335000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Dr-né Kiss Zoltánné', 'Bp. XI., Bukarest utca', '(1) 466-2760', 285000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Dr-né Lászlo Márkné', 'Gödöllő, Facan sor', '(28) 422-363', 19000000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Dr-né Petrei Alajosné', 'Bp. X., Bolgár utca', '(1) 261-6265', 330000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Dr. Pék Rita', 'Bp. VII., Kertész utca', '(1) 342-2080', 150000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Dr. Szabó Hedvig', 'Gödöllő, Aulich Lajos utca', '(28) 417-820', 420000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Dr. Szabó Rebeka', 'Gödöllő, Ambrus Zoltán köz', '(20) 935-5135', 15000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Dr. Vincze Ingrid', 'Bp. IV., Lőcsei utca', '(1) 230-5004', 16000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Dr. Zsóka Rita', 'Bp. VII., Kertész utca', '(1) 342-2080', 335000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Dudás Gyöngyi', 'Bp. II., Endrődi Sándor utca', '(1) 275-2300', 325000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Dudás Reka', 'Bp. II., Alvinci út', '(1) 316-7620', 580000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Egyházi Leopold', 'Gödöllő, Fürdő utca', '(28) 417-126', 497500);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Erdélyi Roland', 'Bp. XIII., Hun utca', '(1) 359-5963', 260000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Farkas Izolda', 'Bp. VI., Munkácsy Mihály utca', '(1) 331-0489', 310000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Farkas Noé', 'Bp. V., József nádor tér', '(1) 317-2352', 333330);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Fazekas Zsófia', 'Bp. XII., Thomán István utca', '(1) 395-4828', 250000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Fogarasi Márkus', 'Bp. X., Gergely utca', '(1) 260-7653', 395000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Fudi Zsófia', 'Bp. XII., Thomán István utca', '(1) 395-4828', 447500);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Galambos Imre Elemér', 'Bp. XIII., Gidófalvy Lajos utca', '(1) 320-7828', 165000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Gambár Gilda', 'Bp. III., Torma Károly utca', '(1) 242-7074', 753125);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Gáspár Emília', 'Bp. XI., Bukarest utca', '(1) 466-2760', 348750);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Gáspár Enikő', 'Bp. XI., Fadrusz utca', '(1) 365-8252', 310000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Gódor Bozsidár', 'Bp. XI., Etele út', '(1) 205-6948', 345000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Guba Ida', 'Bp. XI., Neszmélyi út', '(1) 310-2185', 310000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Gulyás Anikó', 'Bp. IX., Üllői út', '(1) 281-5337', 320000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Gulyás Fruzsina', 'Bp. IX., Üllői út', '(1) 215-5263', 420625);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Gyetván Ali', 'Bp. VII., Damjanich utca', '(1) 322-5733', 140000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Gyetván Pongrác', 'Bp. VII., Dembinszky utca', '(1) 321-2292', 582500);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Gyöngyösi Adorján', 'Bp. XI., Beregszász ut', '(20) 935-3298', 275000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Gyurcsik Márkus', 'Bp. X., Gergely utca', '(1) 260-7653', 55000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Hajdu Ilona', 'Bp. VI., Király utca', '(1) 341-0463', 310000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Harangi Marianna', 'Bp. XII., Nárcisz utca', '(1) 375-9428', 3333330);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Harangozó Friderika', 'Bp. IV., Külső Szilágyi út', '(1) 380-9097', 333330);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Haraszti Bertalan', 'Gödöllő, Batsányi János utca', '(30) 231-9526', 320000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Hegyi Dolli', 'Bp. I., Táncsics Mihály utca', '(1) 356-9734', 510000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Horváth Egyed', 'Bp. XII., Maros utca', '(1) 356-5181', 120000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Horváth Orsika', 'Bp. XII., Maros utca', '(1) 213-9711', 562500);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Ifj. Hornyák Vanessza', 'Bp. XIII., Jász utca', '(1) 239-4000', 185000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Ipsits Barna', 'Gödöllő, Erzsébet királyné körút', '(20) 330-8827', 75000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Izsó Edvárd', 'Gödöllő, Szőlő utca', '(28) 411-315', 440000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Izsó Margaréta', 'Gödöllő, Szent István tér', '(28) 412-151', 685000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Izsó Vilmos', 'Gödöllő, Remsey Jenő körút', '(28) 430-351', 60000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Jávorszki Enikő', 'Bp. XI., Fadrusz utca', '(1) 365-8252', 65000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Jávorszky Renáta', 'Bp. XI., Csóka utca', '(1) 206-7249', 115000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Jeney Paszkál', 'Bp. III., Szőlő utca', '(1) 388-2833', 375000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Kanai Samu', 'Bp. IV., Tél utca', '(1) 360-4733', 367500);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Kapcsándi Dolli', 'Bp. I., Táncsics Mihály utca', '(1) 356-9734', 111110);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Kapcsándi Herta', 'Bp. I., Kuny Domokos utca', '(1) 375-0666', 556250);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Kaposi Margit', 'Bp. VIII., Baross utca', '(1) 323-0797', 467500);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Kapu Diána', 'Bp. VIII., Rákóczi út', '(1) 314-0909', 346250);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Kapu Ilona', 'Bp. VI., Király utca', '(1) 341-0463', 740625);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Kasza Ágnes', 'Bp. II., Horvát utca', '(1) 202-4351', 360000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Kasza Gyöngyi', 'Bp. II., Endrődi Sándor utca', '(1) 275-2300', 210000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Katona Jolán', 'Gödöllő, Erzsébet királyné körút', '(20) 925-5141', 115000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Katona Nemere', 'Bp. II., Tárogató út', '(1) 200-7505', 165000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Katona Réka', 'Bp. II., Alvinci út', '(1) 316-7620', 503750);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Katrin Samu', 'Bp. IV., Tél utca', '(1) 360-4733', 502500);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Kis Henrik', 'Bp. XIII., Kárpát utca', '(1) 340-6261', 125000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Kiss Balázs', 'Bp. XII., Csaba utca', '(1) 355-5393', 111110);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Kiss Ingrid', 'Bp. IV., Lőcsei utca', '(1) 230-5004', 115000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Kiss Zelma', 'Bp. IV., Pálya utca', '(70) 513-0051', 480000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Kohári Vanessza', 'Bp. XIII., Jász utca', '(1) 239-4000', 442500);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Kolozs Aurélia', 'Bp. X., Tölcsér utca', '(1) 260-5639', 95000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Kolozs Cecil', 'Bp. II., Kökény utca', '(1) 376-9130', 445000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Kolozs Zorán', 'Bp. X., Gyakorló utca', '(1) 262-8105', 111110);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Komár Márk', 'Gödöllő, Fácán sor', '(28) 422-363', 111110);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Komeáthy Anikó', 'Bp. IX., Üllői út', '(1) 281-5337', 436875);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Komeáthy Izolda', 'Bp. VI., Munkácsy Mihály utca', '(1) 331-0489', 110000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Komeáthy Noé', 'Bp. V., József nádor tér', '(1) 317-2352', 410000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Korbély Ágnes', 'Bp. II., Horvát utca', '(1) 202-4351', 195000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Kovács Ernő', 'Gödöllő, Munkácsy Mihály út', '(30) 300-9382', 315000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Kovács Konrád', 'Gödöllő, Mohács utca', '(70) 204-8161', 135000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Kovács Tádé', 'Gödöllő, Munkácsy Mihály út', '(30) 962-6029', 390000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Kristóf Hajnalka', 'Bp. VI., Eötvös utca', '(1) 269-5609', 365000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Kristóf Ilona', 'Bp. VI., Király utca', '(1) 341-0463', 376250);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Kulcsár Zelma', 'Bp. IV., Pálya utca', '(70) 513-0051', 431250);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'László Cecil', 'Bp. II., Kökény utca', '(1) 376-9130', 1368750);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Lászlo Hagár', 'Bp. III., Silvanus sétány', '(1) 242-1418', 205000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Lécz Ádám', 'Bp. XI., Rátz Lászlo utca', '(1) 208-2455', 383750);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Lécz Bonifác', 'Bp. XI., Sasadi út', '(1) 246-3705', 375000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Légrády Berta', 'Bp. XI., Kaptárkő utca', '(1) 246-8576', 327500);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Lengyel Jenő', 'Bp. XII., Thomán István utca', '(1) 395-5043', 430000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Lerch Zsóka', 'Bp. XIV., Gvadányi utca', '(1) 223-2559', 1497500);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Linkes Emánuel', 'Bp. IV., Bajza József utca', '(1) 370-9000', 111110);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Lipták Ambrus', 'Bp. IV., Kassai utca', '(1) 389-8459', 140000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Macsár Tímea', 'Bp. I., Bem rakpart', '(1) 201-2152', 230000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Márkus Hagár', 'Bp. III., Silvanus sétány', '(1) 242-1418', 120000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Maronits Gertrúd', 'Bp. III., Királylaki ut', '(1) 250-4656', 115000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Maronits Vendel', 'Bp. III., Pablo Neruda utca', '(1) 243-1909', 380000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Maszlagi Lehel', 'Bp. IV., Liszt Ferenc utca', '(1) 379-6051', 150600);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Mészáros Gizella', 'Bp. VI., Munkácsy Mihály utca', '(70) 299-5688', 441250);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Mészáros Izolda', 'Bp. VI., Munkácsy Mihály utca', '(1) 331-0489', 135000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Misik Dolli', 'Bp. I., Táncsics Mihály utca', '(1) 356-9734', 125000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Misik Nemere', 'Bp. II., Tárogató út', '(1) 200-7505', 115000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Misik Réka', 'Bp. II., Alvinci út', '(1) 316-7620', 2112500);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Molnár Friderika', 'Bp. IV., Külső Szilágyi út', '(1) 380-9097', 440000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Molnár Fruzsina', 'Bp. IX., Üllői út', '(1) 215-5263', 120000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Mukk Emánuel', 'Bp. IV., Bajza József utca', '(1) 370-9000', 115000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Mukk Ingrid', 'Bp. IV., Lőcsei utca', '(1) 230-5004', 370000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Nagy Henrik', 'Bp. XIII., Kárpát utca', '(1) 340-6261', 505000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Nyári Edvárd', 'Gödöllő, Szőlő utca', '(28) 411-315', 115000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Oláh Rebeka', 'Gödöllő, Ambrus Zoltán köz', '(20) 935-5135', 195000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Oláh Sámson', 'Bp. XIV., Utász utca', '(1) 222-5318', 638125);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Oláh Zsóka', 'Bp. XIV., Gvadányi utca', '(1) 223-2559', 1110000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Olajos Ágnes', 'Bp. II., Horvát utca', '(1) 202-4351', 525000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Özv. Albert Andrásné', 'Bp. III., Silvanus sétány', '(1) 242-1418', 120000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Özv. Futas Sebestyénné', 'Gödöllő, Palotakert utca', '(30) 256-9667', 111110);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Özv. Jászai Péterné', 'Bp. XII., Kálló esperes utca', '(1) 319-9206', 510000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Özv. Tóth Lénárdné', 'Bp. XI., Fehérvári út', '(1) 204-1577', 115000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Papp Róza', 'Bp. XII., Kálló esperes utca', '(1) 319-9206', 140000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Parajdi Konrád', 'Gödöllő, Mohács utca', '(70) 204-8161', 2605000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Patkó Jenő', 'Bp. XII., Thomán István utca', '(1) 395-5043', 1732500);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Perjesi Lőrinc', 'Bp. XI., Vincellér utca', '(1) 385-0461', 120000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Péter Margaréta', 'Gödöllő, Szent István tér', '(28) 412-151', 115000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Petrák Tímea', 'Bp. I., Bem rakpart', '(1) 201-2152', 435000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Pinke Vladimir', 'Bp. XI., Szováta utca', '(1) 203-1103', 125000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Pintér Bonifác', 'Bp. XI., Sasadi út', '(1) 246-3705', 110000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Pintér Lénárd', 'Bp. XI., Fehérvári út', '(1) 204-1577', 305625);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Pintér Zsuzsa', 'Bp. XI., Tűzkő utca', '(70) 500-8670', 222220);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Pólya Ambrus', 'Bp. IV., Kassai utca', '(1) 389-8459', 222220);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Polyák Ali', 'Bp. VII., Damjanich utca', '(1) 322-5733', 3335000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Polyák Pongrác', 'Bp. VII., Dembinszky utca', '(1) 321-2292', 165000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Pozsár Edgár', 'Gödöllő, Bessenyei György utca', '(28) 432-934', 570000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Pozsgai Lídia', 'Bp. VIII., Losonci tér', '(1) 334-6298', 102000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Radics Margit', 'Bp. VIII., Baross utca', '(1) 323-0797', 3333330);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Radics Tímea', 'Bp. I., Bem rakpart', '(1) 201-2152', 340000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Rajkó Marianna', 'Bp. XII., Nárcisz utca', '(1) 375-9428', 500000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Rajkó Miklós', 'Bp. XII., Tartsay Vilmos utca', '(1) 375-1638', 215000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Rajkó Panna', 'Bp. XIII., Béke utca', '(1) 320-0241', 400000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Rédei Barbara', 'Gödöllő, Batthyány Lajos utca', '(28) 414-297', 255000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Rédei Bertalan', 'Gödöllő, Batsányi János utca', '(30) 231-9526', 1111110);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Rédei Edgár', 'Gödöllő, Bessenyei Gyorgy utca', '(28) 432-934', 310000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Richter Berta', 'Bp. XI., Kaptárkő utca', '(1) 246-8576', 1011000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Richter Viola', 'Bp. XI., Dayka Gábor utca', '(1) 319-7044', 205000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Rudics Orsika', 'Bp. XII., Maros utca', '(1) 213-9711', 1111110);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Rudics Zorán', 'Bp. X., Gyakorló utca', '(1) 262-8105', 370000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Sain Tádé', 'Gödöllő, Munkácsy Mihály út', '(30) 962-6029', 295000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Sári Bertolda', 'Bp. III., Kerék utca', '(1) 368-4383', 485000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Sepetán Herta', 'Bp. I., Kuny Domokos utca', '(1) 375-0666', 1115000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Sidó Gertrud', 'Bp. III., Királylaki ut', '(1) 250-4656', 370000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Sipos Aladár', 'Bp. X., Noszlopy utca', '(1) 261-4081', 175000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Solt Aurélia', 'Bp. X., Tölcsér utca', '(1) 260-5639', 2110000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Strausz Noé', 'Bp. V., József nádor tér', '(1) 317-2352', 5222000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Sütő Gilda', 'Bp. III., Torma Károly utca', '(1) 242-7074', 345000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Szabadi Balázs', 'Bp. XII., Csaba utca', '(1) 355-5393', 115000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Szabados Rita', 'Bp. VII., Kertész utca', '(1) 342-2080', 2250000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Szabó Edmond', 'Gödöllő, Hunyadi János utca', '(28) 420-565', 2225000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Szabó Egyed', 'Bp. XII., Maros utca', '(1) 356-5181', 70000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Szabó Ida', 'Bp. XI., Neszmélyi út', '(1) 310-2185', 90000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Szabó Leopold', 'Gödöllő, Fürdő utca', '(28) 417-126', 1597500);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Szabó Lőrinc', 'Bp. XI., Vincellér utca', '(1) 385-0461', 750000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Szabó Sarolta', 'Bp. XI., Budaörsi út', '(1) 247-1978', 438750);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Szekeres Fábián', 'Bp. VII., Alpár utca', '(1) 322-8706', 393750);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Szina Vendel', 'Bp. III., Pablo Neruda utca', '(1) 243-1909', 1175000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Takács Nemere', 'Bp. II., Tárogató út', '(1) 200-7505', 215000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Tamás Hedvig', 'Gödöllő, Aulich Lajos utca', '(28) 417-820', 145000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Tamás Paszkál', 'Bp. III., Szőlő utca', '(1) 388-2833', 230000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Tasnádi Herta', 'Bp. I., Kuny Domokos utca', '(1) 375-0666', 2202500);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Téglási Hajnalka', 'Bp. VI., Eötvös utca', '(1) 269-5609', 435000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Terjek Zelma', 'Bp. IV., Pálya utca', '(70) 513-0051', 65000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Ternusz Nagy Irma', 'Gödöllő, Batsányi János utca', '(28) 514-255', 75000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Tímár Szabina', 'Bp. VIII., Baross utca', '(1) 303-2702', 95000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Tóth Aladar', 'Bp. X., Noszlopy utca', '(1) 261-4081', 71110);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Tóth Alajos', 'Bp. X., Bolgár utca', '(1) 261-6265', 375000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Tóth Diána', 'Bp. VIII., Rákóczi út', '(1) 314-0909', 55000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Tóth Zaránd', 'Bp. X., Harmat utca', '(1) 262-2949', 480000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Tóth Zaránd', 'Bp. X., Harmat utca', '(1) 262-2949', 666660);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Tőke Zsuzsa', 'Bp. XI., Tűzkő utca', '(70) 500-8670', 745000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Törő Edmond', 'Gödöllő, Hunyadi János utca', '(28) 420-565', 230000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Turai Adorján', 'Bp. XI., Beregszász út', '(20) 935-3298', 515000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Turai Elek', 'Bp. XII., Maros utca', '(1) 202-7593', 777770);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Turai Soma', 'Bp. VII., Károly körút', '(1) 317-6373', 430000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Vajda Emánuel', 'Bp. IV., Bajza József utca', '(1) 370-9000', 150000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Venglovecz Vilmos', 'Gödöllő, Remsey Jenő körút', '(28) 430-351', 412500);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Viczián Barna', 'Gödöllő, Erzsébet királyné körút', '(20) 330-8827', 315000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Viczián Eleonóra', 'Gödöllő, Erzsébet királyne körút', '(20) 924-2026', 349375);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Viczián Ernő', 'Gödöllő, Munkácsy Mihály út', '(30) 300-9382', 115000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Viczián Jolán', 'Gödöllő, Erzsébet királyné körút', '(20) 925-5141', 405000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Willin Eleonóra', 'Gödöllő, Erzsébet királyné körút', '(20) 924-2026', 75000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Zágonyi Elek', 'Bp. XII., Maros utca', '(1) 202-7593', 220000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Zagyva Gizella', 'Bp. VI., Munkácsy Mihály utca', '(70) 299-5688', 265000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Zajak Bernadett', 'Bp. X., Kővágó utca', '(1) 262-1729', 455000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Zarándi Viola', 'Bp. XI., Dayka Gábor utca', '(1) 319-7044', 275000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Zlatnik Gizella', 'Bp. VI., Munkácsy Mihály utca', '(70) 299-5688', 380000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Zlatnik Hajnalka', 'Bp. VI., Eötvös utca', '(1) 269-5609', 85000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Zsamba Friderika', 'Bp. IV., Kulső Szilágyi út', '(1) 380-9097', 90000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Zsamba Fruzsina', 'Bp. IX., Üllői út', '(1) 215-5263', 70000);
--
Insert Into Persons (person_id, Name, Address, Phone, Income)
Values (seq_persons.NextVal, 'Zsamba Pongrác', 'Bp. VII., Dembinszky utca', '(1) 321-2292', 60000);

--
-- Visits tabla feltoltese
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 231, seq_places.CurrVal -  27, 5, Trunc(Sysdate-149), Trunc(Sysdate-1993), 1, 6000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 230, seq_places.CurrVal -  33, 6, Trunc(Sysdate-193), Trunc(Sysdate-1085), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 230, seq_places.CurrVal -  32, 1, Trunc(Sysdate-64), Trunc(Sysdate-2499), 1, 6000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 230, seq_places.CurrVal -  18, 7, Trunc(Sysdate-230), Trunc(Sysdate-589), 0, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 230, seq_places.CurrVal -   4, 6, Trunc(Sysdate-85), Trunc(Sysdate-1664), 0, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 229, seq_places.CurrVal -  33, 3, Trunc(Sysdate-59), Trunc(Sysdate-390), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 228, seq_places.CurrVal -  33, 2, Trunc(Sysdate-273), Trunc(Sysdate-2290), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 228, seq_places.CurrVal -  24, 3, Trunc(Sysdate-238), Trunc(Sysdate-293), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 228, seq_places.CurrVal -  17, 5, Trunc(Sysdate-188), Trunc(Sysdate-1217), 0, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 228, seq_places.CurrVal -  15, 3, Trunc(Sysdate-223), Trunc(Sysdate-1337), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 227, seq_places.CurrVal -  37, 2, Trunc(Sysdate-175), Trunc(Sysdate-1736), 1, 10000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 227, seq_places.CurrVal -  16, 2, Trunc(Sysdate-213), Trunc(Sysdate-2421), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 226, seq_places.CurrVal -  34, 2, Trunc(Sysdate-121), Trunc(Sysdate-893), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 226, seq_places.CurrVal -  12, 5, Trunc(Sysdate-320), Trunc(Sysdate-1097), 0, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 226, seq_places.CurrVal -   8, 5, Trunc(Sysdate-243), Trunc(Sysdate-1435), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 226, seq_places.CurrVal -   6, 2, Trunc(Sysdate-151), Trunc(Sysdate-1339), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 225, seq_places.CurrVal -  24, 6, Trunc(Sysdate-166), Trunc(Sysdate-2426), 0, 9000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 225, seq_places.CurrVal -  22, 1, Trunc(Sysdate-50), Trunc(Sysdate-77), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 225, seq_places.CurrVal -  12, 5, Trunc(Sysdate-53), Trunc(Sysdate-1501), 1, 10000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 225, seq_places.CurrVal -   5, 5, Trunc(Sysdate-266), Trunc(Sysdate-1132), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 224, seq_places.CurrVal -  31, 1, Trunc(Sysdate-241), Trunc(Sysdate-393), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 224, seq_places.CurrVal -  10, 5, Trunc(Sysdate-259), Trunc(Sysdate-696), 1, 6000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 224, seq_places.CurrVal -   3, 2, Trunc(Sysdate-105), Trunc(Sysdate-2030), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 223, seq_places.CurrVal -   5, 6, Trunc(Sysdate-65), Trunc(Sysdate-180), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 222, seq_places.CurrVal -  36, 4, Trunc(Sysdate-267), Trunc(Sysdate-1612), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 222, seq_places.CurrVal -  26, 4, Trunc(Sysdate-167), Trunc(Sysdate-2472), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 222, seq_places.CurrVal -   2, 3, Trunc(Sysdate-264), Trunc(Sysdate-1621), 1, 6000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 221, seq_places.CurrVal -  37, 1, Trunc(Sysdate-8), Trunc(Sysdate-2021), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 221, seq_places.CurrVal -  35, 5, Trunc(Sysdate-309), Trunc(Sysdate-2244), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 221, seq_places.CurrVal -  34, 4, Trunc(Sysdate-292), Trunc(Sysdate-819), 0, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 221, seq_places.CurrVal -  32, 4, Trunc(Sysdate-187), Trunc(Sysdate-1941), 0, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 221, seq_places.CurrVal -   4, 3, Trunc(Sysdate-177), Trunc(Sysdate-1453), 1, 6000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 220, seq_places.CurrVal -  35, 4, Trunc(Sysdate-87), Trunc(Sysdate-822), 0, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 220, seq_places.CurrVal -   7, 2, Trunc(Sysdate-278), Trunc(Sysdate-1052), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 220, seq_places.CurrVal -   6, 2, Trunc(Sysdate-51), Trunc(Sysdate-2063), 0, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 219, seq_places.CurrVal -  32, 3, Trunc(Sysdate-131), Trunc(Sysdate-394), 0, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 219, seq_places.CurrVal -  20, 1, Trunc(Sysdate-243), Trunc(Sysdate-903), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 219, seq_places.CurrVal -  13, 1, Trunc(Sysdate-229), Trunc(Sysdate-1020), 1, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 219, seq_places.CurrVal -   2, 2, Trunc(Sysdate-240), Trunc(Sysdate-2399), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 218, seq_places.CurrVal -  17, 3, Trunc(Sysdate-53), Trunc(Sysdate-1713), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 218, seq_places.CurrVal -  10, 5, Trunc(Sysdate-277), Trunc(Sysdate-2337), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 218, seq_places.CurrVal -   5, 7, Trunc(Sysdate-297), Trunc(Sysdate-1338), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 218, seq_places.CurrVal -   4, 6, Trunc(Sysdate-105), Trunc(Sysdate-2266), 0, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 217, seq_places.CurrVal -  31, 3, Trunc(Sysdate-319), Trunc(Sysdate-850), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 217, seq_places.CurrVal -  18, 6, Trunc(Sysdate-297), Trunc(Sysdate-1602), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 217, seq_places.CurrVal -  12, 4, Trunc(Sysdate-177), Trunc(Sysdate-1149), 1, 6000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 217, seq_places.CurrVal -   8, 5, Trunc(Sysdate-231), Trunc(Sysdate-1638), 0, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 217, seq_places.CurrVal -   3, 1, Trunc(Sysdate-293), Trunc(Sysdate-2378), 1, 6000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 216, seq_places.CurrVal -  28, 1, Trunc(Sysdate-14), Trunc(Sysdate-237), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 215, seq_places.CurrVal -  24, 3, Trunc(Sysdate-92), Trunc(Sysdate-1980), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 215, seq_places.CurrVal -  20, 4, Trunc(Sysdate-299), Trunc(Sysdate-1815), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 215, seq_places.CurrVal -  16, 7, Trunc(Sysdate-48), Trunc(Sysdate-390), 1, 8000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 215, seq_places.CurrVal -  15, 7, Trunc(Sysdate-4), Trunc(Sysdate-1824), 0, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 215, seq_places.CurrVal -   5, 2, Trunc(Sysdate-37), Trunc(Sysdate-2259), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 214, seq_places.CurrVal -  29, 5, Trunc(Sysdate-84), Trunc(Sysdate-136), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 214, seq_places.CurrVal -  27, 2, Trunc(Sysdate-194), Trunc(Sysdate-250), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 214, seq_places.CurrVal -  13, 7, Trunc(Sysdate-139), Trunc(Sysdate-1011), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 213, seq_places.CurrVal -  28, 5, Trunc(Sysdate-36), Trunc(Sysdate-2202), 0, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 213, seq_places.CurrVal -  16, 1, Trunc(Sysdate-46), Trunc(Sysdate-374), 0, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 213, seq_places.CurrVal -  12, 2, Trunc(Sysdate-222), Trunc(Sysdate-2545), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 213, seq_places.CurrVal -   3, 3, Trunc(Sysdate-200), Trunc(Sysdate-1981), 0, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 213, seq_places.CurrVal -   0, 3, Trunc(Sysdate-224), Trunc(Sysdate-535), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 212, seq_places.CurrVal -  22, 5, Trunc(Sysdate-177), Trunc(Sysdate-1467), 1, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 212, seq_places.CurrVal -  11, 4, Trunc(Sysdate-116), Trunc(Sysdate-801), 0, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 212, seq_places.CurrVal -   0, 6, Trunc(Sysdate-75), Trunc(Sysdate-1137), 1, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 210, seq_places.CurrVal -  37, 4, Trunc(Sysdate-325), Trunc(Sysdate-1171), 0, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 210, seq_places.CurrVal -  28, 6, Trunc(Sysdate-9), Trunc(Sysdate-2397), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 210, seq_places.CurrVal -   5, 3, Trunc(Sysdate-41), Trunc(Sysdate-2288), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 209, seq_places.CurrVal -  33, 2, Trunc(Sysdate-298), Trunc(Sysdate-298), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 209, seq_places.CurrVal -  18, 6, Trunc(Sysdate-3), Trunc(Sysdate-2096), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 209, seq_places.CurrVal -  12, 5, Trunc(Sysdate-167), Trunc(Sysdate-2574), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 208, seq_places.CurrVal -  29, 5, Trunc(Sysdate-56), Trunc(Sysdate-1202), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 208, seq_places.CurrVal -  27, 1, Trunc(Sysdate-76), Trunc(Sysdate-1901), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 208, seq_places.CurrVal -  26, 6, Trunc(Sysdate-109), Trunc(Sysdate-1499), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 208, seq_places.CurrVal -  21, 7, Trunc(Sysdate-213), Trunc(Sysdate-1920), 0, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 207, seq_places.CurrVal -  23, 2, Trunc(Sysdate-239), Trunc(Sysdate-1581), 0, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 207, seq_places.CurrVal -  12, 5, Trunc(Sysdate-107), Trunc(Sysdate-1894), 0, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 207, seq_places.CurrVal -   2, 2, Trunc(Sysdate-186), Trunc(Sysdate-1459), 0, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 207, seq_places.CurrVal -   1, 7, Trunc(Sysdate-306), Trunc(Sysdate-2342), 0, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 206, seq_places.CurrVal -  37, 4, Trunc(Sysdate-170), Trunc(Sysdate-2575), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 206, seq_places.CurrVal -   2, 6, Trunc(Sysdate-173), Trunc(Sysdate-1416), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 205, seq_places.CurrVal -   6, 5, Trunc(Sysdate-68), Trunc(Sysdate-138), 1, 8000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 205, seq_places.CurrVal -   3, 2, Trunc(Sysdate-303), Trunc(Sysdate-2277), 0, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 205, seq_places.CurrVal -   1, 1, Trunc(Sysdate-263), Trunc(Sysdate-2128), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 204, seq_places.CurrVal -  36, 1, Trunc(Sysdate-293), Trunc(Sysdate-1320), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 204, seq_places.CurrVal -  22, 7, Trunc(Sysdate-149), Trunc(Sysdate-2390), 0, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 204, seq_places.CurrVal -   3, 1, Trunc(Sysdate-136), Trunc(Sysdate-1310), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 203, seq_places.CurrVal -  32, 2, Trunc(Sysdate-127), Trunc(Sysdate-2095), 0, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 203, seq_places.CurrVal -  18, 1, Trunc(Sysdate-15), Trunc(Sysdate-1837), 0, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 202, seq_places.CurrVal -  31, 6, Trunc(Sysdate-211), Trunc(Sysdate-1900), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 202, seq_places.CurrVal -  13, 2, Trunc(Sysdate-126), Trunc(Sysdate-725), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 201, seq_places.CurrVal -  37, 2, Trunc(Sysdate-89), Trunc(Sysdate-2385), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 201, seq_places.CurrVal -  26, 7, Trunc(Sysdate-166), Trunc(Sysdate-2493), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 201, seq_places.CurrVal -  23, 5, Trunc(Sysdate-284), Trunc(Sysdate-2128), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 200, seq_places.CurrVal -  27, 5, Trunc(Sysdate-296), Trunc(Sysdate-1145), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 200, seq_places.CurrVal -  24, 7, Trunc(Sysdate-98), Trunc(Sysdate-402), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 200, seq_places.CurrVal -   9, 6, Trunc(Sysdate-299), Trunc(Sysdate-2654), 1, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 199, seq_places.CurrVal -  30, 4, Trunc(Sysdate-298), Trunc(Sysdate-1833), 0, 8000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 199, seq_places.CurrVal -  28, 6, Trunc(Sysdate-12), Trunc(Sysdate-1974), 0, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 199, seq_places.CurrVal -  16, 1, Trunc(Sysdate-119), Trunc(Sysdate-1326), 1, 10000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 199, seq_places.CurrVal -  14, 4, Trunc(Sysdate-321), Trunc(Sysdate-1672), 1, 8000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 198, seq_places.CurrVal -   7, 3, Trunc(Sysdate-34), Trunc(Sysdate-1728), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 198, seq_places.CurrVal -   3, 6, Trunc(Sysdate-252), Trunc(Sysdate-1737), 1, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 198, seq_places.CurrVal -   0, 5, Trunc(Sysdate-116), Trunc(Sysdate-443), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 197, seq_places.CurrVal -  35, 2, Trunc(Sysdate-101), Trunc(Sysdate-1437), 0, 6000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 197, seq_places.CurrVal -  20, 1, Trunc(Sysdate-229), Trunc(Sysdate-994), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 197, seq_places.CurrVal -   3, 4, Trunc(Sysdate-301), Trunc(Sysdate-1053), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 196, seq_places.CurrVal -  28, 1, Trunc(Sysdate-179), Trunc(Sysdate-1101), 0, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 196, seq_places.CurrVal -  17, 7, Trunc(Sysdate-209), Trunc(Sysdate-331), 1, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 195, seq_places.CurrVal -  28, 4, Trunc(Sysdate-91), Trunc(Sysdate-729), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 195, seq_places.CurrVal -  21, 4, Trunc(Sysdate-120), Trunc(Sysdate-1045), 1, 10000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 195, seq_places.CurrVal -   8, 5, Trunc(Sysdate-300), Trunc(Sysdate-807), 0, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 195, seq_places.CurrVal -   4, 2, Trunc(Sysdate-114), Trunc(Sysdate-758), 0, 8000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 194, seq_places.CurrVal -  21, 2, Trunc(Sysdate-29), Trunc(Sysdate-29), 0, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 194, seq_places.CurrVal -  11, 3, Trunc(Sysdate-169), Trunc(Sysdate-1872), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 194, seq_places.CurrVal -   8, 4, Trunc(Sysdate-13), Trunc(Sysdate-837), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 194, seq_places.CurrVal -   7, 4, Trunc(Sysdate-147), Trunc(Sysdate-653), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 194, seq_places.CurrVal -   3, 5, Trunc(Sysdate-16), Trunc(Sysdate-143), 0, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 193, seq_places.CurrVal -  24, 1, Trunc(Sysdate-321), Trunc(Sysdate-1789), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 193, seq_places.CurrVal -   7, 5, Trunc(Sysdate-186), Trunc(Sysdate-2183), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 193, seq_places.CurrVal -   2, 1, Trunc(Sysdate-253), Trunc(Sysdate-1694), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 192, seq_places.CurrVal -  18, 5, Trunc(Sysdate-310), Trunc(Sysdate-2132), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 192, seq_places.CurrVal -  14, 2, Trunc(Sysdate-180), Trunc(Sysdate-592), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 192, seq_places.CurrVal -  12, 2, Trunc(Sysdate-303), Trunc(Sysdate-2248), 1, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 192, seq_places.CurrVal -   2, 6, Trunc(Sysdate-278), Trunc(Sysdate-2097), 0, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 192, seq_places.CurrVal -   1, 4, Trunc(Sysdate-184), Trunc(Sysdate-2430), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 191, seq_places.CurrVal -  12, 5, Trunc(Sysdate-6), Trunc(Sysdate-24), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 191, seq_places.CurrVal -   9, 6, Trunc(Sysdate-120), Trunc(Sysdate-561), 0, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 190, seq_places.CurrVal -  24, 3, Trunc(Sysdate-231), Trunc(Sysdate-2034), 1, 8000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 190, seq_places.CurrVal -  21, 6, Trunc(Sysdate-303), Trunc(Sysdate-409), 1, 9000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 189, seq_places.CurrVal -  37, 1, Trunc(Sysdate-210), Trunc(Sysdate-2421), 0, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 189, seq_places.CurrVal -  36, 4, Trunc(Sysdate-171), Trunc(Sysdate-673), 1, 6000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 189, seq_places.CurrVal -  22, 2, Trunc(Sysdate-137), Trunc(Sysdate-2540), 1, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 189, seq_places.CurrVal -  21, 6, Trunc(Sysdate-160), Trunc(Sysdate-2181), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 188, seq_places.CurrVal -  31, 7, Trunc(Sysdate-299), Trunc(Sysdate-2163), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 188, seq_places.CurrVal -   0, 5, Trunc(Sysdate-188), Trunc(Sysdate-2017), 1, 6000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 187, seq_places.CurrVal -  37, 4, Trunc(Sysdate-244), Trunc(Sysdate-967), 1, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 187, seq_places.CurrVal -   8, 1, Trunc(Sysdate-86), Trunc(Sysdate-2506), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 187, seq_places.CurrVal -   2, 5, Trunc(Sysdate-38), Trunc(Sysdate-808), 0, 8000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 186, seq_places.CurrVal -  33, 5, Trunc(Sysdate-59), Trunc(Sysdate-1639), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 186, seq_places.CurrVal -  27, 1, Trunc(Sysdate-56), Trunc(Sysdate-2437), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 186, seq_places.CurrVal -  16, 3, Trunc(Sysdate-30), Trunc(Sysdate-1364), 0, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 185, seq_places.CurrVal -  35, 6, Trunc(Sysdate-283), Trunc(Sysdate-705), 1, 9000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 185, seq_places.CurrVal -  22, 1, Trunc(Sysdate-253), Trunc(Sysdate-1187), 0, 10000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 185, seq_places.CurrVal -  14, 2, Trunc(Sysdate-284), Trunc(Sysdate-548), 1, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 184, seq_places.CurrVal -  36, 2, Trunc(Sysdate-100), Trunc(Sysdate-2138), 1, 9000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 184, seq_places.CurrVal -  33, 6, Trunc(Sysdate-269), Trunc(Sysdate-2186), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 184, seq_places.CurrVal -  30, 3, Trunc(Sysdate-106), Trunc(Sysdate-748), 0, 8000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 184, seq_places.CurrVal -  28, 1, Trunc(Sysdate-103), Trunc(Sysdate-1222), 0, 10000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 184, seq_places.CurrVal -  23, 6, Trunc(Sysdate-204), Trunc(Sysdate-2400), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 184, seq_places.CurrVal -   3, 6, Trunc(Sysdate-313), Trunc(Sysdate-1837), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 183, seq_places.CurrVal -  32, 6, Trunc(Sysdate-246), Trunc(Sysdate-601), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 183, seq_places.CurrVal -  27, 3, Trunc(Sysdate-82), Trunc(Sysdate-2041), 0, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 182, seq_places.CurrVal -  26, 5, Trunc(Sysdate-118), Trunc(Sysdate-311), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 181, seq_places.CurrVal -  28, 2, Trunc(Sysdate-162), Trunc(Sysdate-1610), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 181, seq_places.CurrVal -  24, 5, Trunc(Sysdate-218), Trunc(Sysdate-593), 0, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 181, seq_places.CurrVal -  21, 7, Trunc(Sysdate-187), Trunc(Sysdate-1395), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 181, seq_places.CurrVal -  18, 2, Trunc(Sysdate-135), Trunc(Sysdate-1137), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 181, seq_places.CurrVal -  10, 5, Trunc(Sysdate-80), Trunc(Sysdate-1574), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 181, seq_places.CurrVal -   7, 7, Trunc(Sysdate-235), Trunc(Sysdate-2292), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 180, seq_places.CurrVal -  30, 7, Trunc(Sysdate-178), Trunc(Sysdate-1545), 0, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 180, seq_places.CurrVal -  17, 3, Trunc(Sysdate-292), Trunc(Sysdate-1844), 0, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 180, seq_places.CurrVal -   4, 5, Trunc(Sysdate-318), Trunc(Sysdate-2289), 0, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 179, seq_places.CurrVal -  14, 3, Trunc(Sysdate-32), Trunc(Sysdate-1565), 1, 10000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 178, seq_places.CurrVal -   0, 7, Trunc(Sysdate-258), Trunc(Sysdate-839), 1, 9000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 177, seq_places.CurrVal -  26, 4, Trunc(Sysdate-251), Trunc(Sysdate-2651), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 177, seq_places.CurrVal -  20, 6, Trunc(Sysdate-4), Trunc(Sysdate-2350), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 177, seq_places.CurrVal -  17, 6, Trunc(Sysdate-191), Trunc(Sysdate-267), 0, 8000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 176, seq_places.CurrVal -  14, 4, Trunc(Sysdate-180), Trunc(Sysdate-552), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 176, seq_places.CurrVal -  12, 1, Trunc(Sysdate-278), Trunc(Sysdate-1379), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 176, seq_places.CurrVal -  11, 3, Trunc(Sysdate-257), Trunc(Sysdate-1372), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 176, seq_places.CurrVal -   7, 6, Trunc(Sysdate-150), Trunc(Sysdate-990), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 175, seq_places.CurrVal -  29, 2, Trunc(Sysdate-296), Trunc(Sysdate-1304), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 175, seq_places.CurrVal -  26, 7, Trunc(Sysdate-238), Trunc(Sysdate-1192), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 175, seq_places.CurrVal -  20, 2, Trunc(Sysdate-40), Trunc(Sysdate-1270), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 175, seq_places.CurrVal -   9, 6, Trunc(Sysdate-169), Trunc(Sysdate-2089), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 174, seq_places.CurrVal -  26, 3, Trunc(Sysdate-60), Trunc(Sysdate-1019), 0, 10000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 174, seq_places.CurrVal -  25, 6, Trunc(Sysdate-248), Trunc(Sysdate-1220), 1, 9000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 174, seq_places.CurrVal -  16, 5, Trunc(Sysdate-267), Trunc(Sysdate-1726), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 173, seq_places.CurrVal -  33, 2, Trunc(Sysdate-67), Trunc(Sysdate-67), 0, 9000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 173, seq_places.CurrVal -  26, 2, Trunc(Sysdate-294), Trunc(Sysdate-1298), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 173, seq_places.CurrVal -  11, 5, Trunc(Sysdate-253), Trunc(Sysdate-2684), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 173, seq_places.CurrVal -   9, 1, Trunc(Sysdate-221), Trunc(Sysdate-1863), 0, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 173, seq_places.CurrVal -   0, 1, Trunc(Sysdate-48), Trunc(Sysdate-1852), 1, 8000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 172, seq_places.CurrVal -  17, 2, Trunc(Sysdate-74), Trunc(Sysdate-2044), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 172, seq_places.CurrVal -  16, 3, Trunc(Sysdate-326), Trunc(Sysdate-2459), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 172, seq_places.CurrVal -  14, 1, Trunc(Sysdate-160), Trunc(Sysdate-358), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 171, seq_places.CurrVal -  36, 7, Trunc(Sysdate-118), Trunc(Sysdate-118), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 171, seq_places.CurrVal -  21, 4, Trunc(Sysdate-74), Trunc(Sysdate-1426), 0, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 171, seq_places.CurrVal -  20, 6, Trunc(Sysdate-88), Trunc(Sysdate-1578), 0, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 171, seq_places.CurrVal -  14, 7, Trunc(Sysdate-106), Trunc(Sysdate-1470), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 170, seq_places.CurrVal -  24, 6, Trunc(Sysdate-204), Trunc(Sysdate-618), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 170, seq_places.CurrVal -  23, 5, Trunc(Sysdate-200), Trunc(Sysdate-457), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 169, seq_places.CurrVal -  34, 4, Trunc(Sysdate-48), Trunc(Sysdate-530), 0, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 169, seq_places.CurrVal -  28, 3, Trunc(Sysdate-279), Trunc(Sysdate-1895), 0, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 169, seq_places.CurrVal -  24, 3, Trunc(Sysdate-32), Trunc(Sysdate-675), 1, 9000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 169, seq_places.CurrVal -  22, 2, Trunc(Sysdate-67), Trunc(Sysdate-455), 0, 6000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 169, seq_places.CurrVal -   1, 2, Trunc(Sysdate-156), Trunc(Sysdate-2189), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 168, seq_places.CurrVal -  37, 6, Trunc(Sysdate-207), Trunc(Sysdate-334), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 168, seq_places.CurrVal -  23, 6, Trunc(Sysdate-99), Trunc(Sysdate-1081), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 168, seq_places.CurrVal -   5, 4, Trunc(Sysdate-183), Trunc(Sysdate-214), 0, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 167, seq_places.CurrVal -  31, 1, Trunc(Sysdate-298), Trunc(Sysdate-1084), 1, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 167, seq_places.CurrVal -   1, 4, Trunc(Sysdate-33), Trunc(Sysdate-1526), 0, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 166, seq_places.CurrVal -  36, 4, Trunc(Sysdate-16), Trunc(Sysdate-1390), 0, 8000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 166, seq_places.CurrVal -  24, 4, Trunc(Sysdate-208), Trunc(Sysdate-1802), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 166, seq_places.CurrVal -  14, 6, Trunc(Sysdate-16), Trunc(Sysdate-575), 1, 9000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 165, seq_places.CurrVal -  36, 6, Trunc(Sysdate-202), Trunc(Sysdate-791), 0, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 165, seq_places.CurrVal -  34, 4, Trunc(Sysdate-240), Trunc(Sysdate-2236), 1, 10000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 165, seq_places.CurrVal -  29, 2, Trunc(Sysdate-269), Trunc(Sysdate-1337), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 165, seq_places.CurrVal -  23, 1, Trunc(Sysdate-89), Trunc(Sysdate-2304), 0, 8000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 165, seq_places.CurrVal -  19, 1, Trunc(Sysdate-199), Trunc(Sysdate-1776), 0, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 165, seq_places.CurrVal -  12, 1, Trunc(Sysdate-73), Trunc(Sysdate-2218), 0, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 165, seq_places.CurrVal -  11, 2, Trunc(Sysdate-217), Trunc(Sysdate-2304), 0, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 165, seq_places.CurrVal -   5, 3, Trunc(Sysdate-82), Trunc(Sysdate-401), 1, 8000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 163, seq_places.CurrVal -  10, 4, Trunc(Sysdate-125), Trunc(Sysdate-608), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 163, seq_places.CurrVal -   7, 5, Trunc(Sysdate-248), Trunc(Sysdate-488), 0, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 162, seq_places.CurrVal -  34, 2, Trunc(Sysdate-215), Trunc(Sysdate-2487), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 162, seq_places.CurrVal -  15, 7, Trunc(Sysdate-211), Trunc(Sysdate-2617), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 161, seq_places.CurrVal -   4, 4, Trunc(Sysdate-296), Trunc(Sysdate-582), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 160, seq_places.CurrVal -  34, 2, Trunc(Sysdate-78), Trunc(Sysdate-886), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 160, seq_places.CurrVal -  22, 1, Trunc(Sysdate-133), Trunc(Sysdate-757), 0, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 160, seq_places.CurrVal -   8, 7, Trunc(Sysdate-59), Trunc(Sysdate-2053), 0, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 160, seq_places.CurrVal -   3, 7, Trunc(Sysdate-158), Trunc(Sysdate-2472), 0, 6000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 159, seq_places.CurrVal -  22, 2, Trunc(Sysdate-165), Trunc(Sysdate-1965), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 159, seq_places.CurrVal -   8, 5, Trunc(Sysdate-240), Trunc(Sysdate-815), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 158, seq_places.CurrVal -  30, 2, Trunc(Sysdate-77), Trunc(Sysdate-1096), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 158, seq_places.CurrVal -  12, 3, Trunc(Sysdate-93), Trunc(Sysdate-1125), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 157, seq_places.CurrVal -  12, 6, Trunc(Sysdate-53), Trunc(Sysdate-1738), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 157, seq_places.CurrVal -   2, 1, Trunc(Sysdate-301), Trunc(Sysdate-1985), 0, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 157, seq_places.CurrVal -   1, 4, Trunc(Sysdate-255), Trunc(Sysdate-1727), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 156, seq_places.CurrVal -  29, 5, Trunc(Sysdate-67), Trunc(Sysdate-2064), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 156, seq_places.CurrVal -  28, 4, Trunc(Sysdate-26), Trunc(Sysdate-2064), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 156, seq_places.CurrVal -  16, 3, Trunc(Sysdate-49), Trunc(Sysdate-512), 1, 8000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 156, seq_places.CurrVal -   1, 5, Trunc(Sysdate-134), Trunc(Sysdate-1139), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 155, seq_places.CurrVal -  37, 5, Trunc(Sysdate-60), Trunc(Sysdate-2119), 0, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 155, seq_places.CurrVal -  35, 1, Trunc(Sysdate-53), Trunc(Sysdate-1390), 0, 9000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 155, seq_places.CurrVal -  11, 2, Trunc(Sysdate-150), Trunc(Sysdate-474), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 155, seq_places.CurrVal -   7, 3, Trunc(Sysdate-255), Trunc(Sysdate-798), 0, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 155, seq_places.CurrVal -   6, 6, Trunc(Sysdate-307), Trunc(Sysdate-2011), 0, 10000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 155, seq_places.CurrVal -   1, 7, Trunc(Sysdate-279), Trunc(Sysdate-1730), 0, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 154, seq_places.CurrVal -  33, 4, Trunc(Sysdate-65), Trunc(Sysdate-2164), 1, 10000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 154, seq_places.CurrVal -  15, 2, Trunc(Sysdate-119), Trunc(Sysdate-1452), 0, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 154, seq_places.CurrVal -  13, 1, Trunc(Sysdate-94), Trunc(Sysdate-465), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 154, seq_places.CurrVal -  11, 5, Trunc(Sysdate-142), Trunc(Sysdate-288), 0, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 153, seq_places.CurrVal -  22, 3, Trunc(Sysdate-223), Trunc(Sysdate-1736), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 153, seq_places.CurrVal -  20, 5, Trunc(Sysdate-19), Trunc(Sysdate-1612), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 153, seq_places.CurrVal -  18, 4, Trunc(Sysdate-152), Trunc(Sysdate-1152), 0, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 153, seq_places.CurrVal -  17, 5, Trunc(Sysdate-297), Trunc(Sysdate-1477), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 153, seq_places.CurrVal -  16, 1, Trunc(Sysdate-275), Trunc(Sysdate-1029), 1, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 153, seq_places.CurrVal -  11, 7, Trunc(Sysdate-56), Trunc(Sysdate-1388), 1, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 152, seq_places.CurrVal -  17, 6, Trunc(Sysdate-11), Trunc(Sysdate-1939), 1, 8000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 152, seq_places.CurrVal -  15, 5, Trunc(Sysdate-249), Trunc(Sysdate-737), 0, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 152, seq_places.CurrVal -   4, 1, Trunc(Sysdate-282), Trunc(Sysdate-2036), 0, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 151, seq_places.CurrVal -  33, 7, Trunc(Sysdate-186), Trunc(Sysdate-186), 1, 8000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 151, seq_places.CurrVal -  31, 6, Trunc(Sysdate-192), Trunc(Sysdate-1340), 0, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 151, seq_places.CurrVal -  29, 1, Trunc(Sysdate-184), Trunc(Sysdate-1929), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 151, seq_places.CurrVal -  21, 7, Trunc(Sysdate-250), Trunc(Sysdate-1244), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 151, seq_places.CurrVal -  20, 7, Trunc(Sysdate-135), Trunc(Sysdate-2262), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 150, seq_places.CurrVal -  16, 6, Trunc(Sysdate-210), Trunc(Sysdate-1996), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 149, seq_places.CurrVal -  25, 7, Trunc(Sysdate-275), Trunc(Sysdate-1340), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 148, seq_places.CurrVal -  33, 5, Trunc(Sysdate-238), Trunc(Sysdate-2510), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 148, seq_places.CurrVal -   6, 1, Trunc(Sysdate-230), Trunc(Sysdate-2189), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 148, seq_places.CurrVal -   5, 6, Trunc(Sysdate-193), Trunc(Sysdate-2316), 0, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 148, seq_places.CurrVal -   4, 7, Trunc(Sysdate-148), Trunc(Sysdate-799), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 147, seq_places.CurrVal -   0, 4, Trunc(Sysdate-274), Trunc(Sysdate-2158), 1, 8000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 146, seq_places.CurrVal -   6, 1, Trunc(Sysdate-3), Trunc(Sysdate-1805), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 145, seq_places.CurrVal -  34, 3, Trunc(Sysdate-133), Trunc(Sysdate-279), 0, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 145, seq_places.CurrVal -  33, 7, Trunc(Sysdate-195), Trunc(Sysdate-1288), 1, 9000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 145, seq_places.CurrVal -   4, 4, Trunc(Sysdate-124), Trunc(Sysdate-1878), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 144, seq_places.CurrVal -  14, 2, Trunc(Sysdate-77), Trunc(Sysdate-864), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 144, seq_places.CurrVal -   9, 2, Trunc(Sysdate-260), Trunc(Sysdate-904), 0, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 144, seq_places.CurrVal -   7, 6, Trunc(Sysdate-94), Trunc(Sysdate-1094), 0, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 144, seq_places.CurrVal -   0, 3, Trunc(Sysdate-141), Trunc(Sysdate-2551), 1, 6000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 143, seq_places.CurrVal -  36, 3, Trunc(Sysdate-150), Trunc(Sysdate-1512), 1, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 143, seq_places.CurrVal -  24, 1, Trunc(Sysdate-128), Trunc(Sysdate-2057), 1, 8000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 143, seq_places.CurrVal -   9, 1, Trunc(Sysdate-125), Trunc(Sysdate-1050), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 143, seq_places.CurrVal -   7, 3, Trunc(Sysdate-7), Trunc(Sysdate-27), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 142, seq_places.CurrVal -  15, 5, Trunc(Sysdate-291), Trunc(Sysdate-2701), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 142, seq_places.CurrVal -  11, 3, Trunc(Sysdate-314), Trunc(Sysdate-325), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 142, seq_places.CurrVal -   4, 2, Trunc(Sysdate-178), Trunc(Sysdate-178), 1, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 141, seq_places.CurrVal -  20, 2, Trunc(Sysdate-157), Trunc(Sysdate-2379), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 141, seq_places.CurrVal -  19, 4, Trunc(Sysdate-284), Trunc(Sysdate-471), 0, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 141, seq_places.CurrVal -  16, 3, Trunc(Sysdate-120), Trunc(Sysdate-1696), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 141, seq_places.CurrVal -  10, 2, Trunc(Sysdate-321), Trunc(Sysdate-910), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 140, seq_places.CurrVal -   7, 6, Trunc(Sysdate-258), Trunc(Sysdate-1399), 1, 9000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 139, seq_places.CurrVal -  37, 6, Trunc(Sysdate-244), Trunc(Sysdate-1942), 0, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 139, seq_places.CurrVal -  19, 7, Trunc(Sysdate-85), Trunc(Sysdate-2181), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 138, seq_places.CurrVal -   5, 2, Trunc(Sysdate-11), Trunc(Sysdate-753), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 138, seq_places.CurrVal -   1, 3, Trunc(Sysdate-103), Trunc(Sysdate-601), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 137, seq_places.CurrVal -  35, 1, Trunc(Sysdate-52), Trunc(Sysdate-2069), 1, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 137, seq_places.CurrVal -  24, 3, Trunc(Sysdate-253), Trunc(Sysdate-1052), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 137, seq_places.CurrVal -  18, 7, Trunc(Sysdate-326), Trunc(Sysdate-871), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 137, seq_places.CurrVal -   2, 4, Trunc(Sysdate-9), Trunc(Sysdate-1823), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 135, seq_places.CurrVal -  35, 6, Trunc(Sysdate-173), Trunc(Sysdate-174), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 135, seq_places.CurrVal -  31, 1, Trunc(Sysdate-117), Trunc(Sysdate-283), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 135, seq_places.CurrVal -  30, 7, Trunc(Sysdate-128), Trunc(Sysdate-171), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 135, seq_places.CurrVal -  17, 7, Trunc(Sysdate-301), Trunc(Sysdate-1101), 1, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 135, seq_places.CurrVal -   3, 3, Trunc(Sysdate-58), Trunc(Sysdate-710), 0, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 135, seq_places.CurrVal -   2, 7, Trunc(Sysdate-275), Trunc(Sysdate-1065), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 134, seq_places.CurrVal -  32, 6, Trunc(Sysdate-236), Trunc(Sysdate-1711), 0, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 134, seq_places.CurrVal -  14, 7, Trunc(Sysdate-149), Trunc(Sysdate-1516), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 133, seq_places.CurrVal -  35, 1, Trunc(Sysdate-126), Trunc(Sysdate-827), 0, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 133, seq_places.CurrVal -  32, 3, Trunc(Sysdate-216), Trunc(Sysdate-1513), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 133, seq_places.CurrVal -  15, 6, Trunc(Sysdate-143), Trunc(Sysdate-1003), 0, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 133, seq_places.CurrVal -   8, 6, Trunc(Sysdate-164), Trunc(Sysdate-261), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 133, seq_places.CurrVal -   5, 5, Trunc(Sysdate-226), Trunc(Sysdate-226), 1, 8000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 133, seq_places.CurrVal -   0, 6, Trunc(Sysdate-322), Trunc(Sysdate-1241), 0, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 132, seq_places.CurrVal -  36, 6, Trunc(Sysdate-267), Trunc(Sysdate-2397), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 132, seq_places.CurrVal -  35, 4, Trunc(Sysdate-157), Trunc(Sysdate-1425), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 132, seq_places.CurrVal -  26, 3, Trunc(Sysdate-299), Trunc(Sysdate-2647), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 132, seq_places.CurrVal -  18, 3, Trunc(Sysdate-57), Trunc(Sysdate-708), 1, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 132, seq_places.CurrVal -  16, 4, Trunc(Sysdate-57), Trunc(Sysdate-503), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 132, seq_places.CurrVal -  15, 2, Trunc(Sysdate-124), Trunc(Sysdate-1184), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 131, seq_places.CurrVal -   2, 7, Trunc(Sysdate-318), Trunc(Sysdate-986), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 131, seq_places.CurrVal -   1, 6, Trunc(Sysdate-3), Trunc(Sysdate-3), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 130, seq_places.CurrVal -  31, 2, Trunc(Sysdate-23), Trunc(Sysdate-273), 1, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 130, seq_places.CurrVal -  11, 7, Trunc(Sysdate-92), Trunc(Sysdate-2161), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 130, seq_places.CurrVal -   7, 5, Trunc(Sysdate-84), Trunc(Sysdate-1979), 0, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 129, seq_places.CurrVal -  26, 1, Trunc(Sysdate-213), Trunc(Sysdate-2032), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 129, seq_places.CurrVal -  12, 2, Trunc(Sysdate-273), Trunc(Sysdate-1417), 0, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 128, seq_places.CurrVal -  31, 3, Trunc(Sysdate-42), Trunc(Sysdate-2037), 1, 9000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 128, seq_places.CurrVal -   8, 2, Trunc(Sysdate-72), Trunc(Sysdate-2165), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 128, seq_places.CurrVal -   0, 7, Trunc(Sysdate-159), Trunc(Sysdate-1115), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 127, seq_places.CurrVal -  34, 1, Trunc(Sysdate-177), Trunc(Sysdate-1897), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 127, seq_places.CurrVal -  25, 7, Trunc(Sysdate-109), Trunc(Sysdate-201), 1, 10000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 127, seq_places.CurrVal -  23, 3, Trunc(Sysdate-148), Trunc(Sysdate-2326), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 126, seq_places.CurrVal -  32, 3, Trunc(Sysdate-172), Trunc(Sysdate-971), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 126, seq_places.CurrVal -  23, 4, Trunc(Sysdate-81), Trunc(Sysdate-845), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 126, seq_places.CurrVal -  17, 4, Trunc(Sysdate-214), Trunc(Sysdate-1914), 0, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 126, seq_places.CurrVal -  14, 2, Trunc(Sysdate-49), Trunc(Sysdate-425), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 125, seq_places.CurrVal -  25, 2, Trunc(Sysdate-200), Trunc(Sysdate-1075), 0, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 124, seq_places.CurrVal -  36, 1, Trunc(Sysdate-193), Trunc(Sysdate-368), 1, 8000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 124, seq_places.CurrVal -  31, 7, Trunc(Sysdate-202), Trunc(Sysdate-1701), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 124, seq_places.CurrVal -  26, 6, Trunc(Sysdate-43), Trunc(Sysdate-2059), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 124, seq_places.CurrVal -  23, 1, Trunc(Sysdate-30), Trunc(Sysdate-2207), 0, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 124, seq_places.CurrVal -  22, 5, Trunc(Sysdate-188), Trunc(Sysdate-2249), 1, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 124, seq_places.CurrVal -   6, 1, Trunc(Sysdate-43), Trunc(Sysdate-1759), 0, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 123, seq_places.CurrVal -  37, 6, Trunc(Sysdate-287), Trunc(Sysdate-1411), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 123, seq_places.CurrVal -  31, 5, Trunc(Sysdate-41), Trunc(Sysdate-1877), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 123, seq_places.CurrVal -  29, 7, Trunc(Sysdate-167), Trunc(Sysdate-1808), 0, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 123, seq_places.CurrVal -  25, 1, Trunc(Sysdate-165), Trunc(Sysdate-170), 0, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 123, seq_places.CurrVal -  11, 2, Trunc(Sysdate-274), Trunc(Sysdate-2630), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 123, seq_places.CurrVal -   9, 1, Trunc(Sysdate-43), Trunc(Sysdate-279), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 123, seq_places.CurrVal -   7, 1, Trunc(Sysdate-150), Trunc(Sysdate-955), 0, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 122, seq_places.CurrVal -   2, 4, Trunc(Sysdate-56), Trunc(Sysdate-224), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 121, seq_places.CurrVal -  25, 2, Trunc(Sysdate-217), Trunc(Sysdate-2052), 1, 9000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 121, seq_places.CurrVal -  20, 6, Trunc(Sysdate-303), Trunc(Sysdate-811), 0, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 121, seq_places.CurrVal -  16, 2, Trunc(Sysdate-139), Trunc(Sysdate-422), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 121, seq_places.CurrVal -   6, 2, Trunc(Sysdate-327), Trunc(Sysdate-938), 0, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 120, seq_places.CurrVal -  36, 6, Trunc(Sysdate-29), Trunc(Sysdate-675), 0, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 120, seq_places.CurrVal -  31, 2, Trunc(Sysdate-122), Trunc(Sysdate-994), 0, 6000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 120, seq_places.CurrVal -  24, 2, Trunc(Sysdate-133), Trunc(Sysdate-1036), 1, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 120, seq_places.CurrVal -  21, 6, Trunc(Sysdate-58), Trunc(Sysdate-162), 0, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 119, seq_places.CurrVal -  32, 1, Trunc(Sysdate-28), Trunc(Sysdate-772), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 119, seq_places.CurrVal -  22, 4, Trunc(Sysdate-269), Trunc(Sysdate-269), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 119, seq_places.CurrVal -  19, 4, Trunc(Sysdate-173), Trunc(Sysdate-227), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 119, seq_places.CurrVal -  17, 1, Trunc(Sysdate-84), Trunc(Sysdate-84), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 119, seq_places.CurrVal -   6, 1, Trunc(Sysdate-203), Trunc(Sysdate-2604), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 118, seq_places.CurrVal -  21, 1, Trunc(Sysdate-93), Trunc(Sysdate-498), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 117, seq_places.CurrVal -  32, 2, Trunc(Sysdate-91), Trunc(Sysdate-600), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 116, seq_places.CurrVal -   8, 4, Trunc(Sysdate-222), Trunc(Sysdate-559), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 116, seq_places.CurrVal -   1, 3, Trunc(Sysdate-263), Trunc(Sysdate-1704), 0, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 115, seq_places.CurrVal -  33, 5, Trunc(Sysdate-14), Trunc(Sysdate-351), 0, 10000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 115, seq_places.CurrVal -  25, 1, Trunc(Sysdate-51), Trunc(Sysdate-969), 0, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 115, seq_places.CurrVal -  18, 6, Trunc(Sysdate-275), Trunc(Sysdate-1106), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 114, seq_places.CurrVal -  22, 1, Trunc(Sysdate-97), Trunc(Sysdate-329), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 114, seq_places.CurrVal -  12, 2, Trunc(Sysdate-2), Trunc(Sysdate-635), 0, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 114, seq_places.CurrVal -   7, 3, Trunc(Sysdate-246), Trunc(Sysdate-1161), 0, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 113, seq_places.CurrVal -  29, 3, Trunc(Sysdate-288), Trunc(Sysdate-2191), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 113, seq_places.CurrVal -  13, 7, Trunc(Sysdate-317), Trunc(Sysdate-1594), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 113, seq_places.CurrVal -   9, 2, Trunc(Sysdate-212), Trunc(Sysdate-2243), 0, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 112, seq_places.CurrVal -  25, 5, Trunc(Sysdate-3), Trunc(Sysdate-1430), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 112, seq_places.CurrVal -  10, 1, Trunc(Sysdate-137), Trunc(Sysdate-137), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 111, seq_places.CurrVal -  31, 1, Trunc(Sysdate-110), Trunc(Sysdate-881), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 111, seq_places.CurrVal -  25, 4, Trunc(Sysdate-78), Trunc(Sysdate-757), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 111, seq_places.CurrVal -  16, 2, Trunc(Sysdate-55), Trunc(Sysdate-1504), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 110, seq_places.CurrVal -  36, 1, Trunc(Sysdate-17), Trunc(Sysdate-187), 0, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 110, seq_places.CurrVal -   5, 4, Trunc(Sysdate-293), Trunc(Sysdate-1116), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 109, seq_places.CurrVal -  18, 1, Trunc(Sysdate-121), Trunc(Sysdate-1410), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 108, seq_places.CurrVal -  36, 3, Trunc(Sysdate-305), Trunc(Sysdate-2626), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 108, seq_places.CurrVal -  20, 2, Trunc(Sysdate-80), Trunc(Sysdate-364), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 107, seq_places.CurrVal -  32, 2, Trunc(Sysdate-38), Trunc(Sysdate-2438), 0, 9000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 107, seq_places.CurrVal -  22, 7, Trunc(Sysdate-211), Trunc(Sysdate-1144), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 107, seq_places.CurrVal -  12, 7, Trunc(Sysdate-102), Trunc(Sysdate-264), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 107, seq_places.CurrVal -   6, 1, Trunc(Sysdate-212), Trunc(Sysdate-1431), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 107, seq_places.CurrVal -   3, 2, Trunc(Sysdate-313), Trunc(Sysdate-695), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 107, seq_places.CurrVal -   1, 3, Trunc(Sysdate-287), Trunc(Sysdate-305), 1, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 106, seq_places.CurrVal -  37, 5, Trunc(Sysdate-111), Trunc(Sysdate-1761), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 106, seq_places.CurrVal -  27, 3, Trunc(Sysdate-53), Trunc(Sysdate-1496), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 106, seq_places.CurrVal -   3, 3, Trunc(Sysdate-81), Trunc(Sysdate-829), 0, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 106, seq_places.CurrVal -   0, 1, Trunc(Sysdate-168), Trunc(Sysdate-1479), 1, 6000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 105, seq_places.CurrVal -  18, 2, Trunc(Sysdate-224), Trunc(Sysdate-431), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 105, seq_places.CurrVal -  12, 5, Trunc(Sysdate-105), Trunc(Sysdate-1785), 0, 10000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 105, seq_places.CurrVal -   0, 5, Trunc(Sysdate-304), Trunc(Sysdate-2625), 0, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 104, seq_places.CurrVal -  37, 6, Trunc(Sysdate-179), Trunc(Sysdate-1420), 0, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 104, seq_places.CurrVal -  35, 2, Trunc(Sysdate-120), Trunc(Sysdate-1768), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 104, seq_places.CurrVal -  14, 4, Trunc(Sysdate-111), Trunc(Sysdate-1277), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 104, seq_places.CurrVal -  12, 2, Trunc(Sysdate-54), Trunc(Sysdate-801), 1, 8000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 104, seq_places.CurrVal -   6, 5, Trunc(Sysdate-16), Trunc(Sysdate-2077), 0, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 103, seq_places.CurrVal -  31, 3, Trunc(Sysdate-15), Trunc(Sysdate-148), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 103, seq_places.CurrVal -  30, 4, Trunc(Sysdate-250), Trunc(Sysdate-773), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 103, seq_places.CurrVal -  22, 6, Trunc(Sysdate-262), Trunc(Sysdate-2060), 0, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 103, seq_places.CurrVal -  13, 4, Trunc(Sysdate-103), Trunc(Sysdate-1376), 1, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 102, seq_places.CurrVal -  36, 5, Trunc(Sysdate-6), Trunc(Sysdate-1868), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 102, seq_places.CurrVal -  29, 1, Trunc(Sysdate-101), Trunc(Sysdate-1975), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 102, seq_places.CurrVal -  20, 3, Trunc(Sysdate-160), Trunc(Sysdate-1425), 0, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 102, seq_places.CurrVal -  10, 4, Trunc(Sysdate-246), Trunc(Sysdate-2545), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 102, seq_places.CurrVal -   8, 7, Trunc(Sysdate-138), Trunc(Sysdate-290), 1, 10000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 101, seq_places.CurrVal -  34, 3, Trunc(Sysdate-290), Trunc(Sysdate-1140), 0, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 101, seq_places.CurrVal -  28, 3, Trunc(Sysdate-181), Trunc(Sysdate-2554), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 101, seq_places.CurrVal -  25, 7, Trunc(Sysdate-157), Trunc(Sysdate-477), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 101, seq_places.CurrVal -  24, 3, Trunc(Sysdate-16), Trunc(Sysdate-2383), 0, 6000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 100, seq_places.CurrVal -  32, 1, Trunc(Sysdate-25), Trunc(Sysdate-1328), 1, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 100, seq_places.CurrVal -  15, 7, Trunc(Sysdate-303), Trunc(Sysdate-534), 0, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 100, seq_places.CurrVal -   9, 6, Trunc(Sysdate-17), Trunc(Sysdate-1865), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal - 100, seq_places.CurrVal -   3, 4, Trunc(Sysdate-275), Trunc(Sysdate-828), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  99, seq_places.CurrVal -  11, 2, Trunc(Sysdate-157), Trunc(Sysdate-738), 1, 6000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  98, seq_places.CurrVal -  36, 7, Trunc(Sysdate-9), Trunc(Sysdate-2427), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  98, seq_places.CurrVal -  33, 2, Trunc(Sysdate-170), Trunc(Sysdate-170), 1, 8000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  97, seq_places.CurrVal -  35, 5, Trunc(Sysdate-69), Trunc(Sysdate-1170), 0, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  97, seq_places.CurrVal -  27, 3, Trunc(Sysdate-325), Trunc(Sysdate-1792), 0, 6000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  97, seq_places.CurrVal -   6, 6, Trunc(Sysdate-327), Trunc(Sysdate-1703), 1, 9000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  97, seq_places.CurrVal -   5, 2, Trunc(Sysdate-181), Trunc(Sysdate-286), 0, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  97, seq_places.CurrVal -   4, 7, Trunc(Sysdate-71), Trunc(Sysdate-71), 1, 10000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  96, seq_places.CurrVal -  32, 3, Trunc(Sysdate-200), Trunc(Sysdate-2434), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  96, seq_places.CurrVal -  14, 1, Trunc(Sysdate-276), Trunc(Sysdate-1394), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  96, seq_places.CurrVal -   9, 2, Trunc(Sysdate-225), Trunc(Sysdate-1492), 1, 9000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  96, seq_places.CurrVal -   0, 2, Trunc(Sysdate-157), Trunc(Sysdate-2598), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  95, seq_places.CurrVal -  37, 5, Trunc(Sysdate-112), Trunc(Sysdate-1113), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  95, seq_places.CurrVal -  20, 1, Trunc(Sysdate-144), Trunc(Sysdate-821), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  95, seq_places.CurrVal -  17, 1, Trunc(Sysdate-279), Trunc(Sysdate-912), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  95, seq_places.CurrVal -   3, 6, Trunc(Sysdate-263), Trunc(Sysdate-1129), 1, 10000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  94, seq_places.CurrVal -  10, 4, Trunc(Sysdate-269), Trunc(Sysdate-705), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  93, seq_places.CurrVal -  21, 2, Trunc(Sysdate-234), Trunc(Sysdate-743), 0, 6000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  93, seq_places.CurrVal -   2, 3, Trunc(Sysdate-178), Trunc(Sysdate-178), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  92, seq_places.CurrVal -  25, 4, Trunc(Sysdate-303), Trunc(Sysdate-1687), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  91, seq_places.CurrVal -  21, 3, Trunc(Sysdate-12), Trunc(Sysdate-555), 1, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  91, seq_places.CurrVal -  18, 4, Trunc(Sysdate-257), Trunc(Sysdate-867), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  91, seq_places.CurrVal -   2, 4, Trunc(Sysdate-5), Trunc(Sysdate-818), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  90, seq_places.CurrVal -  10, 2, Trunc(Sysdate-292), Trunc(Sysdate-431), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  90, seq_places.CurrVal -   7, 3, Trunc(Sysdate-136), Trunc(Sysdate-655), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  89, seq_places.CurrVal -  29, 4, Trunc(Sysdate-10), Trunc(Sysdate-123), 0, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  88, seq_places.CurrVal -  32, 4, Trunc(Sysdate-10), Trunc(Sysdate-904), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  88, seq_places.CurrVal -  19, 2, Trunc(Sysdate-206), Trunc(Sysdate-1878), 1, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  88, seq_places.CurrVal -  17, 7, Trunc(Sysdate-322), Trunc(Sysdate-1075), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  88, seq_places.CurrVal -  11, 1, Trunc(Sysdate-243), Trunc(Sysdate-1121), 0, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  88, seq_places.CurrVal -   7, 2, Trunc(Sysdate-320), Trunc(Sysdate-1469), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  88, seq_places.CurrVal -   3, 3, Trunc(Sysdate-78), Trunc(Sysdate-2228), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  87, seq_places.CurrVal -   9, 5, Trunc(Sysdate-217), Trunc(Sysdate-2233), 0, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  86, seq_places.CurrVal -  26, 1, Trunc(Sysdate-249), Trunc(Sysdate-1297), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  86, seq_places.CurrVal -   7, 6, Trunc(Sysdate-152), Trunc(Sysdate-1265), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  85, seq_places.CurrVal -  37, 5, Trunc(Sysdate-169), Trunc(Sysdate-787), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  85, seq_places.CurrVal -  33, 3, Trunc(Sysdate-260), Trunc(Sysdate-1437), 1, 6000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  85, seq_places.CurrVal -  20, 7, Trunc(Sysdate-154), Trunc(Sysdate-341), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  85, seq_places.CurrVal -  16, 4, Trunc(Sysdate-118), Trunc(Sysdate-756), 1, 6000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  84, seq_places.CurrVal -  32, 6, Trunc(Sysdate-172), Trunc(Sysdate-2477), 1, 8000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  84, seq_places.CurrVal -  30, 5, Trunc(Sysdate-101), Trunc(Sysdate-2451), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  84, seq_places.CurrVal -  21, 6, Trunc(Sysdate-26), Trunc(Sysdate-954), 0, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  84, seq_places.CurrVal -   4, 7, Trunc(Sysdate-165), Trunc(Sysdate-410), 0, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  82, seq_places.CurrVal -  17, 2, Trunc(Sysdate-17), Trunc(Sysdate-758), 1, 8000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  82, seq_places.CurrVal -  16, 2, Trunc(Sysdate-183), Trunc(Sysdate-469), 1, 9000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  82, seq_places.CurrVal -  11, 2, Trunc(Sysdate-220), Trunc(Sysdate-777), 1, 6000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  82, seq_places.CurrVal -   9, 1, Trunc(Sysdate-286), Trunc(Sysdate-452), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  81, seq_places.CurrVal -  33, 6, Trunc(Sysdate-268), Trunc(Sysdate-2258), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  81, seq_places.CurrVal -   1, 5, Trunc(Sysdate-115), Trunc(Sysdate-505), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  80, seq_places.CurrVal -  14, 1, Trunc(Sysdate-14), Trunc(Sysdate-1467), 0, 8000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  79, seq_places.CurrVal -  32, 7, Trunc(Sysdate-112), Trunc(Sysdate-926), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  79, seq_places.CurrVal -  30, 7, Trunc(Sysdate-196), Trunc(Sysdate-2302), 1, 8000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  79, seq_places.CurrVal -  21, 6, Trunc(Sysdate-182), Trunc(Sysdate-958), 0, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  79, seq_places.CurrVal -  14, 4, Trunc(Sysdate-4), Trunc(Sysdate-657), 0, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  79, seq_places.CurrVal -   4, 1, Trunc(Sysdate-120), Trunc(Sysdate-1880), 0, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  78, seq_places.CurrVal -  22, 2, Trunc(Sysdate-131), Trunc(Sysdate-1520), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  77, seq_places.CurrVal -  29, 7, Trunc(Sysdate-207), Trunc(Sysdate-457), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  77, seq_places.CurrVal -  13, 1, Trunc(Sysdate-315), Trunc(Sysdate-2332), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  77, seq_places.CurrVal -   6, 6, Trunc(Sysdate-313), Trunc(Sysdate-459), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  76, seq_places.CurrVal -  30, 5, Trunc(Sysdate-216), Trunc(Sysdate-1906), 0, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  76, seq_places.CurrVal -  21, 1, Trunc(Sysdate-51), Trunc(Sysdate-1789), 1, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  76, seq_places.CurrVal -  15, 1, Trunc(Sysdate-135), Trunc(Sysdate-904), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  76, seq_places.CurrVal -  11, 2, Trunc(Sysdate-226), Trunc(Sysdate-1055), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  76, seq_places.CurrVal -   1, 4, Trunc(Sysdate-53), Trunc(Sysdate-1809), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  75, seq_places.CurrVal -  32, 3, Trunc(Sysdate-151), Trunc(Sysdate-2360), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  75, seq_places.CurrVal -   5, 6, Trunc(Sysdate-317), Trunc(Sysdate-2172), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  74, seq_places.CurrVal -  36, 6, Trunc(Sysdate-211), Trunc(Sysdate-2533), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  74, seq_places.CurrVal -  12, 7, Trunc(Sysdate-81), Trunc(Sysdate-1995), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  74, seq_places.CurrVal -   7, 1, Trunc(Sysdate-220), Trunc(Sysdate-705), 1, 6000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  73, seq_places.CurrVal -  28, 1, Trunc(Sysdate-119), Trunc(Sysdate-758), 0, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  73, seq_places.CurrVal -  16, 4, Trunc(Sysdate-111), Trunc(Sysdate-884), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  73, seq_places.CurrVal -  11, 6, Trunc(Sysdate-79), Trunc(Sysdate-406), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  73, seq_places.CurrVal -   2, 4, Trunc(Sysdate-2), Trunc(Sysdate-1763), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  72, seq_places.CurrVal -  35, 4, Trunc(Sysdate-197), Trunc(Sysdate-749), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  72, seq_places.CurrVal -  14, 1, Trunc(Sysdate-124), Trunc(Sysdate-148), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  72, seq_places.CurrVal -  12, 4, Trunc(Sysdate-95), Trunc(Sysdate-106), 1, 6000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  72, seq_places.CurrVal -   9, 7, Trunc(Sysdate-324), Trunc(Sysdate-614), 0, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  72, seq_places.CurrVal -   8, 4, Trunc(Sysdate-229), Trunc(Sysdate-827), 0, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  71, seq_places.CurrVal -  36, 1, Trunc(Sysdate-312), Trunc(Sysdate-917), 0, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  71, seq_places.CurrVal -  32, 3, Trunc(Sysdate-267), Trunc(Sysdate-363), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  71, seq_places.CurrVal -  31, 4, Trunc(Sysdate-64), Trunc(Sysdate-627), 0, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  71, seq_places.CurrVal -  18, 3, Trunc(Sysdate-144), Trunc(Sysdate-1804), 1, 10000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  71, seq_places.CurrVal -  12, 6, Trunc(Sysdate-122), Trunc(Sysdate-285), 0, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  70, seq_places.CurrVal -  37, 3, Trunc(Sysdate-214), Trunc(Sysdate-2595), 1, 10000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  70, seq_places.CurrVal -  22, 1, Trunc(Sysdate-108), Trunc(Sysdate-1669), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  69, seq_places.CurrVal -  37, 3, Trunc(Sysdate-316), Trunc(Sysdate-673), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  69, seq_places.CurrVal -  34, 7, Trunc(Sysdate-204), Trunc(Sysdate-349), 0, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  69, seq_places.CurrVal -  30, 3, Trunc(Sysdate-210), Trunc(Sysdate-1701), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  69, seq_places.CurrVal -  20, 3, Trunc(Sysdate-248), Trunc(Sysdate-1927), 0, 8000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  69, seq_places.CurrVal -   2, 1, Trunc(Sysdate-289), Trunc(Sysdate-1381), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  69, seq_places.CurrVal -   1, 2, Trunc(Sysdate-128), Trunc(Sysdate-1275), 0, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  68, seq_places.CurrVal -  34, 7, Trunc(Sysdate-222), Trunc(Sysdate-1362), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  68, seq_places.CurrVal -  28, 1, Trunc(Sysdate-162), Trunc(Sysdate-2464), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  68, seq_places.CurrVal -   7, 1, Trunc(Sysdate-268), Trunc(Sysdate-828), 1, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  68, seq_places.CurrVal -   0, 4, Trunc(Sysdate-181), Trunc(Sysdate-1418), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  67, seq_places.CurrVal -  36, 6, Trunc(Sysdate-196), Trunc(Sysdate-365), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  67, seq_places.CurrVal -  31, 6, Trunc(Sysdate-22), Trunc(Sysdate-1867), 0, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  67, seq_places.CurrVal -  20, 5, Trunc(Sysdate-148), Trunc(Sysdate-307), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  67, seq_places.CurrVal -  19, 3, Trunc(Sysdate-153), Trunc(Sysdate-698), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  66, seq_places.CurrVal -  16, 4, Trunc(Sysdate-322), Trunc(Sysdate-612), 1, 6000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  66, seq_places.CurrVal -   9, 4, Trunc(Sysdate-137), Trunc(Sysdate-1252), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  65, seq_places.CurrVal -  36, 2, Trunc(Sysdate-228), Trunc(Sysdate-1537), 1, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  65, seq_places.CurrVal -  26, 7, Trunc(Sysdate-94), Trunc(Sysdate-1383), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  65, seq_places.CurrVal -  19, 4, Trunc(Sysdate-27), Trunc(Sysdate-1805), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  65, seq_places.CurrVal -   2, 2, Trunc(Sysdate-144), Trunc(Sysdate-1303), 1, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  64, seq_places.CurrVal -  31, 1, Trunc(Sysdate-166), Trunc(Sysdate-694), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  64, seq_places.CurrVal -  28, 7, Trunc(Sysdate-14), Trunc(Sysdate-2279), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  64, seq_places.CurrVal -  21, 4, Trunc(Sysdate-215), Trunc(Sysdate-2652), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  64, seq_places.CurrVal -  18, 5, Trunc(Sysdate-279), Trunc(Sysdate-2569), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  64, seq_places.CurrVal -  13, 5, Trunc(Sysdate-64), Trunc(Sysdate-64), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  63, seq_places.CurrVal -  15, 5, Trunc(Sysdate-27), Trunc(Sysdate-1046), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  62, seq_places.CurrVal -  36, 2, Trunc(Sysdate-134), Trunc(Sysdate-587), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  62, seq_places.CurrVal -  34, 3, Trunc(Sysdate-286), Trunc(Sysdate-404), 1, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  62, seq_places.CurrVal -  25, 1, Trunc(Sysdate-150), Trunc(Sysdate-2315), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  62, seq_places.CurrVal -  24, 7, Trunc(Sysdate-206), Trunc(Sysdate-942), 1, 9000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  62, seq_places.CurrVal -   8, 3, Trunc(Sysdate-275), Trunc(Sysdate-947), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  61, seq_places.CurrVal -  31, 1, Trunc(Sysdate-135), Trunc(Sysdate-927), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  61, seq_places.CurrVal -  29, 3, Trunc(Sysdate-221), Trunc(Sysdate-2437), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  61, seq_places.CurrVal -  27, 4, Trunc(Sysdate-315), Trunc(Sysdate-1074), 1, 6000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  61, seq_places.CurrVal -   5, 2, Trunc(Sysdate-312), Trunc(Sysdate-696), 0, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  61, seq_places.CurrVal -   2, 7, Trunc(Sysdate-60), Trunc(Sysdate-255), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  61, seq_places.CurrVal -   1, 3, Trunc(Sysdate-324), Trunc(Sysdate-1642), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  60, seq_places.CurrVal -  35, 5, Trunc(Sysdate-86), Trunc(Sysdate-1809), 1, 10000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  60, seq_places.CurrVal -   8, 3, Trunc(Sysdate-28), Trunc(Sysdate-1557), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  59, seq_places.CurrVal -  23, 7, Trunc(Sysdate-209), Trunc(Sysdate-1072), 0, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  58, seq_places.CurrVal -  31, 7, Trunc(Sysdate-238), Trunc(Sysdate-1508), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  58, seq_places.CurrVal -  29, 1, Trunc(Sysdate-118), Trunc(Sysdate-1739), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  58, seq_places.CurrVal -  25, 7, Trunc(Sysdate-44), Trunc(Sysdate-2113), 1, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  58, seq_places.CurrVal -  10, 4, Trunc(Sysdate-311), Trunc(Sysdate-451), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  57, seq_places.CurrVal -  11, 7, Trunc(Sysdate-286), Trunc(Sysdate-1499), 0, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  57, seq_places.CurrVal -   6, 2, Trunc(Sysdate-20), Trunc(Sysdate-1117), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  57, seq_places.CurrVal -   1, 3, Trunc(Sysdate-279), Trunc(Sysdate-279), 0, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  56, seq_places.CurrVal -  37, 1, Trunc(Sysdate-299), Trunc(Sysdate-2628), 0, 6000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  56, seq_places.CurrVal -  31, 6, Trunc(Sysdate-98), Trunc(Sysdate-810), 1, 6000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  55, seq_places.CurrVal -  35, 1, Trunc(Sysdate-146), Trunc(Sysdate-1597), 0, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  55, seq_places.CurrVal -  28, 5, Trunc(Sysdate-160), Trunc(Sysdate-1266), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  55, seq_places.CurrVal -  23, 1, Trunc(Sysdate-151), Trunc(Sysdate-1041), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  55, seq_places.CurrVal -  20, 4, Trunc(Sysdate-302), Trunc(Sysdate-1299), 0, 9000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  55, seq_places.CurrVal -  15, 3, Trunc(Sysdate-208), Trunc(Sysdate-2426), 0, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  55, seq_places.CurrVal -   3, 5, Trunc(Sysdate-161), Trunc(Sysdate-1769), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  54, seq_places.CurrVal -  31, 4, Trunc(Sysdate-22), Trunc(Sysdate-95), 1, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  53, seq_places.CurrVal -  25, 2, Trunc(Sysdate-70), Trunc(Sysdate-1037), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  52, seq_places.CurrVal -  34, 4, Trunc(Sysdate-119), Trunc(Sysdate-584), 1, 8000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  52, seq_places.CurrVal -  29, 6, Trunc(Sysdate-284), Trunc(Sysdate-478), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  51, seq_places.CurrVal -  29, 2, Trunc(Sysdate-131), Trunc(Sysdate-1428), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  51, seq_places.CurrVal -  20, 6, Trunc(Sysdate-315), Trunc(Sysdate-1825), 0, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  51, seq_places.CurrVal -  11, 2, Trunc(Sysdate-23), Trunc(Sysdate-2216), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  51, seq_places.CurrVal -   8, 4, Trunc(Sysdate-253), Trunc(Sysdate-1317), 1, 10000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  50, seq_places.CurrVal -  37, 2, Trunc(Sysdate-148), Trunc(Sysdate-781), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  50, seq_places.CurrVal -  36, 7, Trunc(Sysdate-174), Trunc(Sysdate-703), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  50, seq_places.CurrVal -  19, 5, Trunc(Sysdate-19), Trunc(Sysdate-2126), 0, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  50, seq_places.CurrVal -   9, 5, Trunc(Sysdate-300), Trunc(Sysdate-1587), 0, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  50, seq_places.CurrVal -   8, 7, Trunc(Sysdate-293), Trunc(Sysdate-1005), 1, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  50, seq_places.CurrVal -   0, 6, Trunc(Sysdate-59), Trunc(Sysdate-179), 0, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  49, seq_places.CurrVal -  29, 4, Trunc(Sysdate-77), Trunc(Sysdate-2188), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  49, seq_places.CurrVal -  26, 3, Trunc(Sysdate-195), Trunc(Sysdate-2512), 0, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  49, seq_places.CurrVal -  15, 2, Trunc(Sysdate-315), Trunc(Sysdate-2482), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  49, seq_places.CurrVal -  12, 7, Trunc(Sysdate-159), Trunc(Sysdate-1360), 0, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  49, seq_places.CurrVal -  11, 2, Trunc(Sysdate-21), Trunc(Sysdate-1395), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  48, seq_places.CurrVal -  32, 3, Trunc(Sysdate-89), Trunc(Sysdate-1039), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  48, seq_places.CurrVal -  30, 3, Trunc(Sysdate-46), Trunc(Sysdate-1266), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  48, seq_places.CurrVal -  27, 4, Trunc(Sysdate-64), Trunc(Sysdate-1460), 0, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  48, seq_places.CurrVal -  17, 1, Trunc(Sysdate-17), Trunc(Sysdate-553), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  48, seq_places.CurrVal -  14, 7, Trunc(Sysdate-280), Trunc(Sysdate-1379), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  48, seq_places.CurrVal -   5, 2, Trunc(Sysdate-244), Trunc(Sysdate-2644), 0, 8000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  47, seq_places.CurrVal -  29, 6, Trunc(Sysdate-27), Trunc(Sysdate-425), 0, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  47, seq_places.CurrVal -  28, 5, Trunc(Sysdate-247), Trunc(Sysdate-2318), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  47, seq_places.CurrVal -  23, 2, Trunc(Sysdate-313), Trunc(Sysdate-1327), 1, 6000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  47, seq_places.CurrVal -  22, 6, Trunc(Sysdate-68), Trunc(Sysdate-1314), 0, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  46, seq_places.CurrVal -  17, 5, Trunc(Sysdate-116), Trunc(Sysdate-1319), 0, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  46, seq_places.CurrVal -  16, 1, Trunc(Sysdate-112), Trunc(Sysdate-607), 0, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  46, seq_places.CurrVal -  13, 3, Trunc(Sysdate-300), Trunc(Sysdate-1456), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  45, seq_places.CurrVal -  29, 1, Trunc(Sysdate-312), Trunc(Sysdate-2482), 1, 8000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  45, seq_places.CurrVal -   8, 4, Trunc(Sysdate-226), Trunc(Sysdate-1060), 0, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  45, seq_places.CurrVal -   3, 7, Trunc(Sysdate-101), Trunc(Sysdate-524), 1, 8000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  44, seq_places.CurrVal -  21, 4, Trunc(Sysdate-191), Trunc(Sysdate-1308), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  43, seq_places.CurrVal -  36, 6, Trunc(Sysdate-214), Trunc(Sysdate-1306), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  43, seq_places.CurrVal -  32, 4, Trunc(Sysdate-178), Trunc(Sysdate-1951), 1, 8000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  43, seq_places.CurrVal -  28, 7, Trunc(Sysdate-321), Trunc(Sysdate-2317), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  43, seq_places.CurrVal -  25, 7, Trunc(Sysdate-88), Trunc(Sysdate-576), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  43, seq_places.CurrVal -  24, 1, Trunc(Sysdate-215), Trunc(Sysdate-989), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  43, seq_places.CurrVal -  15, 2, Trunc(Sysdate-253), Trunc(Sysdate-2536), 1, 6000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  42, seq_places.CurrVal -  29, 6, Trunc(Sysdate-126), Trunc(Sysdate-1858), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  41, seq_places.CurrVal -  34, 4, Trunc(Sysdate-176), Trunc(Sysdate-830), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  41, seq_places.CurrVal -  22, 1, Trunc(Sysdate-121), Trunc(Sysdate-276), 1, 10000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  41, seq_places.CurrVal -  10, 5, Trunc(Sysdate-276), Trunc(Sysdate-2403), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  41, seq_places.CurrVal -   4, 5, Trunc(Sysdate-39), Trunc(Sysdate-2139), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  41, seq_places.CurrVal -   3, 2, Trunc(Sysdate-159), Trunc(Sysdate-444), 0, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  40, seq_places.CurrVal -  37, 6, Trunc(Sysdate-105), Trunc(Sysdate-596), 1, 9000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  40, seq_places.CurrVal -   7, 4, Trunc(Sysdate-53), Trunc(Sysdate-1567), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  40, seq_places.CurrVal -   1, 4, Trunc(Sysdate-39), Trunc(Sysdate-1192), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  39, seq_places.CurrVal -  35, 5, Trunc(Sysdate-150), Trunc(Sysdate-2280), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  39, seq_places.CurrVal -  30, 6, Trunc(Sysdate-1), Trunc(Sysdate-1491), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  39, seq_places.CurrVal -  26, 3, Trunc(Sysdate-210), Trunc(Sysdate-1392), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  39, seq_places.CurrVal -  14, 1, Trunc(Sysdate-69), Trunc(Sysdate-468), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  39, seq_places.CurrVal -  13, 7, Trunc(Sysdate-269), Trunc(Sysdate-1965), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  39, seq_places.CurrVal -   5, 3, Trunc(Sysdate-111), Trunc(Sysdate-216), 1, 6000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  39, seq_places.CurrVal -   2, 3, Trunc(Sysdate-285), Trunc(Sysdate-489), 0, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  37, seq_places.CurrVal -  31, 7, Trunc(Sysdate-234), Trunc(Sysdate-921), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  37, seq_places.CurrVal -  29, 5, Trunc(Sysdate-132), Trunc(Sysdate-1240), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  37, seq_places.CurrVal -  28, 2, Trunc(Sysdate-326), Trunc(Sysdate-2347), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  37, seq_places.CurrVal -  25, 1, Trunc(Sysdate-19), Trunc(Sysdate-1863), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  37, seq_places.CurrVal -  20, 4, Trunc(Sysdate-89), Trunc(Sysdate-766), 0, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  37, seq_places.CurrVal -  18, 7, Trunc(Sysdate-143), Trunc(Sysdate-1209), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  37, seq_places.CurrVal -  13, 7, Trunc(Sysdate-177), Trunc(Sysdate-177), 1, 6000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  37, seq_places.CurrVal -   6, 1, Trunc(Sysdate-83), Trunc(Sysdate-1181), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  36, seq_places.CurrVal -  22, 4, Trunc(Sysdate-168), Trunc(Sysdate-1103), 0, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  36, seq_places.CurrVal -   3, 3, Trunc(Sysdate-2), Trunc(Sysdate-2413), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  36, seq_places.CurrVal -   0, 6, Trunc(Sysdate-272), Trunc(Sysdate-272), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  35, seq_places.CurrVal -  29, 1, Trunc(Sysdate-168), Trunc(Sysdate-380), 0, 6000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  35, seq_places.CurrVal -  16, 7, Trunc(Sysdate-309), Trunc(Sysdate-1296), 0, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  35, seq_places.CurrVal -   7, 2, Trunc(Sysdate-87), Trunc(Sysdate-87), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  34, seq_places.CurrVal -  13, 7, Trunc(Sysdate-286), Trunc(Sysdate-2584), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  33, seq_places.CurrVal -  30, 4, Trunc(Sysdate-88), Trunc(Sysdate-1987), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  33, seq_places.CurrVal -  27, 6, Trunc(Sysdate-184), Trunc(Sysdate-1386), 0, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  33, seq_places.CurrVal -  24, 7, Trunc(Sysdate-137), Trunc(Sysdate-969), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  33, seq_places.CurrVal -  22, 7, Trunc(Sysdate-116), Trunc(Sysdate-2167), 1, 10000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  33, seq_places.CurrVal -  17, 5, Trunc(Sysdate-158), Trunc(Sysdate-294), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  32, seq_places.CurrVal -  36, 2, Trunc(Sysdate-188), Trunc(Sysdate-1681), 0, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  32, seq_places.CurrVal -  33, 5, Trunc(Sysdate-80), Trunc(Sysdate-2437), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  32, seq_places.CurrVal -  26, 6, Trunc(Sysdate-37), Trunc(Sysdate-1109), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  31, seq_places.CurrVal -  35, 6, Trunc(Sysdate-76), Trunc(Sysdate-1967), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  31, seq_places.CurrVal -  24, 6, Trunc(Sysdate-313), Trunc(Sysdate-1554), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  31, seq_places.CurrVal -  21, 7, Trunc(Sysdate-236), Trunc(Sysdate-780), 1, 9000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  31, seq_places.CurrVal -  20, 3, Trunc(Sysdate-262), Trunc(Sysdate-761), 0, 6000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  31, seq_places.CurrVal -   3, 3, Trunc(Sysdate-226), Trunc(Sysdate-2491), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  31, seq_places.CurrVal -   1, 2, Trunc(Sysdate-56), Trunc(Sysdate-1048), 0, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  30, seq_places.CurrVal -  21, 7, Trunc(Sysdate-256), Trunc(Sysdate-472), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  29, seq_places.CurrVal -  23, 7, Trunc(Sysdate-195), Trunc(Sysdate-2566), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  29, seq_places.CurrVal -  10, 4, Trunc(Sysdate-163), Trunc(Sysdate-857), 1, 10000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  28, seq_places.CurrVal -  35, 7, Trunc(Sysdate-178), Trunc(Sysdate-454), 0, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  28, seq_places.CurrVal -  34, 3, Trunc(Sysdate-169), Trunc(Sysdate-1654), 0, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  28, seq_places.CurrVal -  23, 1, Trunc(Sysdate-201), Trunc(Sysdate-1247), 0, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  28, seq_places.CurrVal -  18, 2, Trunc(Sysdate-303), Trunc(Sysdate-2653), 0, 9000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  28, seq_places.CurrVal -   5, 3, Trunc(Sysdate-65), Trunc(Sysdate-2340), 1, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  28, seq_places.CurrVal -   2, 1, Trunc(Sysdate-279), Trunc(Sysdate-2007), 0, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  28, seq_places.CurrVal -   0, 6, Trunc(Sysdate-61), Trunc(Sysdate-2227), 0, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  27, seq_places.CurrVal -  25, 2, Trunc(Sysdate-35), Trunc(Sysdate-866), 0, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  27, seq_places.CurrVal -  23, 6, Trunc(Sysdate-211), Trunc(Sysdate-2115), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  27, seq_places.CurrVal -  21, 3, Trunc(Sysdate-261), Trunc(Sysdate-2294), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  27, seq_places.CurrVal -  20, 4, Trunc(Sysdate-82), Trunc(Sysdate-1508), 0, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  26, seq_places.CurrVal -  37, 1, Trunc(Sysdate-15), Trunc(Sysdate-1390), 0, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  26, seq_places.CurrVal -  27, 4, Trunc(Sysdate-299), Trunc(Sysdate-2067), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  26, seq_places.CurrVal -  24, 3, Trunc(Sysdate-268), Trunc(Sysdate-564), 1, 10000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  26, seq_places.CurrVal -  21, 2, Trunc(Sysdate-282), Trunc(Sysdate-1518), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  26, seq_places.CurrVal -  19, 2, Trunc(Sysdate-175), Trunc(Sysdate-1069), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  26, seq_places.CurrVal -  10, 3, Trunc(Sysdate-209), Trunc(Sysdate-209), 0, 6000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  24, seq_places.CurrVal -  37, 7, Trunc(Sysdate-315), Trunc(Sysdate-2214), 1, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  24, seq_places.CurrVal -  34, 4, Trunc(Sysdate-145), Trunc(Sysdate-670), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  23, seq_places.CurrVal -  18, 1, Trunc(Sysdate-315), Trunc(Sysdate-2382), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  23, seq_places.CurrVal -  12, 1, Trunc(Sysdate-15), Trunc(Sysdate-477), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  21, seq_places.CurrVal -  27, 6, Trunc(Sysdate-173), Trunc(Sysdate-709), 0, 9000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  21, seq_places.CurrVal -  24, 4, Trunc(Sysdate-172), Trunc(Sysdate-1894), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  21, seq_places.CurrVal -  12, 6, Trunc(Sysdate-142), Trunc(Sysdate-2104), 0, 9000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  21, seq_places.CurrVal -   2, 1, Trunc(Sysdate-19), Trunc(Sysdate-1222), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  20, seq_places.CurrVal -  29, 6, Trunc(Sysdate-127), Trunc(Sysdate-242), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  20, seq_places.CurrVal -  25, 1, Trunc(Sysdate-257), Trunc(Sysdate-766), 0, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  20, seq_places.CurrVal -  14, 6, Trunc(Sysdate-311), Trunc(Sysdate-2171), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  20, seq_places.CurrVal -  11, 6, Trunc(Sysdate-267), Trunc(Sysdate-1088), 0, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  20, seq_places.CurrVal -   7, 2, Trunc(Sysdate-208), Trunc(Sysdate-687), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  19, seq_places.CurrVal -   8, 7, Trunc(Sysdate-219), Trunc(Sysdate-1444), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  18, seq_places.CurrVal -  36, 3, Trunc(Sysdate-305), Trunc(Sysdate-771), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  18, seq_places.CurrVal -  10, 7, Trunc(Sysdate-218), Trunc(Sysdate-623), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  16, seq_places.CurrVal -  35, 2, Trunc(Sysdate-129), Trunc(Sysdate-963), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  16, seq_places.CurrVal -  28, 6, Trunc(Sysdate-222), Trunc(Sysdate-1997), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  16, seq_places.CurrVal -  27, 6, Trunc(Sysdate-173), Trunc(Sysdate-2065), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  16, seq_places.CurrVal -   2, 1, Trunc(Sysdate-85), Trunc(Sysdate-1295), 1, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  15, seq_places.CurrVal -  29, 6, Trunc(Sysdate-62), Trunc(Sysdate-1966), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  15, seq_places.CurrVal -  17, 1, Trunc(Sysdate-34), Trunc(Sysdate-1238), 0, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  15, seq_places.CurrVal -   7, 1, Trunc(Sysdate-185), Trunc(Sysdate-908), 1, 9000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  15, seq_places.CurrVal -   5, 6, Trunc(Sysdate-142), Trunc(Sysdate-1208), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  14, seq_places.CurrVal -  25, 5, Trunc(Sysdate-261), Trunc(Sysdate-2161), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  14, seq_places.CurrVal -  17, 6, Trunc(Sysdate-135), Trunc(Sysdate-888), 0, 9000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  14, seq_places.CurrVal -  16, 2, Trunc(Sysdate-223), Trunc(Sysdate-1123), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  13, seq_places.CurrVal -  18, 7, Trunc(Sysdate-120), Trunc(Sysdate-416), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  12, seq_places.CurrVal -  36, 7, Trunc(Sysdate-193), Trunc(Sysdate-2487), 1, 6000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  12, seq_places.CurrVal -  13, 3, Trunc(Sysdate-79), Trunc(Sysdate-2360), 1, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  12, seq_places.CurrVal -   4, 3, Trunc(Sysdate-95), Trunc(Sysdate-1042), 1, 7000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  11, seq_places.CurrVal -  34, 2, Trunc(Sysdate-124), Trunc(Sysdate-2271), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  11, seq_places.CurrVal -  29, 1, Trunc(Sysdate-263), Trunc(Sysdate-869), 0, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  11, seq_places.CurrVal -  23, 4, Trunc(Sysdate-232), Trunc(Sysdate-2084), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  11, seq_places.CurrVal -  12, 3, Trunc(Sysdate-83), Trunc(Sysdate-1690), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  10, seq_places.CurrVal -  24, 5, Trunc(Sysdate-132), Trunc(Sysdate-792), 1, 8000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  10, seq_places.CurrVal -  20, 1, Trunc(Sysdate-81), Trunc(Sysdate-1761), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  10, seq_places.CurrVal -  19, 3, Trunc(Sysdate-253), Trunc(Sysdate-2679), 0, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -  10, seq_places.CurrVal -  15, 2, Trunc(Sysdate-173), Trunc(Sysdate-1841), 1, 9000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -   9, seq_places.CurrVal -   9, 4, Trunc(Sysdate-27), Trunc(Sysdate-895), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -   9, seq_places.CurrVal -   6, 3, Trunc(Sysdate-90), Trunc(Sysdate-1232), 0, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -   8, seq_places.CurrVal -  32, 2, Trunc(Sysdate-104), Trunc(Sysdate-1798), 0, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -   8, seq_places.CurrVal -  20, 7, Trunc(Sysdate-120), Trunc(Sysdate-952), 0, 9000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -   8, seq_places.CurrVal -   6, 5, Trunc(Sysdate-240), Trunc(Sysdate-1844), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -   8, seq_places.CurrVal -   2, 2, Trunc(Sysdate-86), Trunc(Sysdate-2399), 0, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -   7, seq_places.CurrVal -  28, 7, Trunc(Sysdate-309), Trunc(Sysdate-1723), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -   6, seq_places.CurrVal -  35, 4, Trunc(Sysdate-100), Trunc(Sysdate-1121), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -   6, seq_places.CurrVal -  30, 1, Trunc(Sysdate-96), Trunc(Sysdate-2112), 0, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -   6, seq_places.CurrVal -  16, 1, Trunc(Sysdate-56), Trunc(Sysdate-2355), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -   6, seq_places.CurrVal -  13, 7, Trunc(Sysdate-96), Trunc(Sysdate-1137), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -   5, seq_places.CurrVal -  32, 5, Trunc(Sysdate-68), Trunc(Sysdate-1402), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -   5, seq_places.CurrVal -  28, 1, Trunc(Sysdate-301), Trunc(Sysdate-1954), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -   5, seq_places.CurrVal -   3, 1, Trunc(Sysdate-16), Trunc(Sysdate-2142), 1, 9000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -   5, seq_places.CurrVal -   1, 1, Trunc(Sysdate-55), Trunc(Sysdate-1056), 1, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -   5, seq_places.CurrVal -   0, 6, Trunc(Sysdate-104), Trunc(Sysdate-1549), 0, 10000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -   4, seq_places.CurrVal -  28, 6, Trunc(Sysdate-285), Trunc(Sysdate-307), 1, 6000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -   4, seq_places.CurrVal -  27, 1, Trunc(Sysdate-247), Trunc(Sysdate-507), 0, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -   4, seq_places.CurrVal -  15, 1, Trunc(Sysdate-22), Trunc(Sysdate-1221), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -   4, seq_places.CurrVal -   7, 1, Trunc(Sysdate-306), Trunc(Sysdate-1961), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -   4, seq_places.CurrVal -   3, 2, Trunc(Sysdate-320), Trunc(Sysdate-2062), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -   3, seq_places.CurrVal -  30, 1, Trunc(Sysdate-76), Trunc(Sysdate-486), 0, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -   3, seq_places.CurrVal -   7, 3, Trunc(Sysdate-209), Trunc(Sysdate-2376), 1, 8000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -   2, seq_places.CurrVal -  33, 1, Trunc(Sysdate-252), Trunc(Sysdate-2193), 0, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -   2, seq_places.CurrVal -  26, 7, Trunc(Sysdate-326), Trunc(Sysdate-1683), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -   2, seq_places.CurrVal -  24, 3, Trunc(Sysdate-158), Trunc(Sysdate-1237), 0, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -   2, seq_places.CurrVal -  21, 2, Trunc(Sysdate-113), Trunc(Sysdate-857), 0, 4000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -   2, seq_places.CurrVal -   0, 3, Trunc(Sysdate-232), Trunc(Sysdate-2044), 1, 5000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -   1, seq_places.CurrVal -   6, 5, Trunc(Sysdate-234), Trunc(Sysdate-1677), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -   0, seq_places.CurrVal -  37, 2, Trunc(Sysdate-190), Trunc(Sysdate-1542), 1, 6000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -   0, seq_places.CurrVal -  36, 1, Trunc(Sysdate-144), Trunc(Sysdate-1675), 1, 1000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -   0, seq_places.CurrVal -  31, 1, Trunc(Sysdate-228), Trunc(Sysdate-1611), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -   0, seq_places.CurrVal -  17, 6, Trunc(Sysdate-278), Trunc(Sysdate-641), 0, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -   0, seq_places.CurrVal -  12, 7, Trunc(Sysdate-272), Trunc(Sysdate-2666), 1, 3000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -   0, seq_places.CurrVal -  10, 6, Trunc(Sysdate-162), Trunc(Sysdate-882), 1, 2000);
--
Insert Into Visits (person_id, place_id, Frequency, last_visit, first_visit, Likes, average_spending)
Values (seq_persons.CurrVal -   0, seq_places.CurrVal -   2, 1, Trunc(Sysdate-41), Trunc(Sysdate-2052), 1, 3000);
--
Commit;
