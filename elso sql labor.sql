DROP TABLE latogatas;
DROP TABLE szorakozohely;
DROP TABLE latogato;

CREATE TABLE szorakozohely (
    szorakozohely_id NUMBER PRIMARY KEY,
    nev VARCHAR2(100) UNIQUE NOT NULL,
    cim VARCHAR2(100) NOT NULL,
    telefonszam NUMBER(11),
    arfekves VARCHAR2(10),
    tipus LONG,
    CONSTRAINT CHK_arfekves CHECK ( arfekves IN ('low', 'medium', 'high'))
);

CREATE TABLE latogato (
    latogato_id NUMBER PRIMARY KEY,
    nev VARCHAR2(100) NOT NULL UNIQUE,
    cim VARCHAR2(100),
    telefonszam NUMBER(11),
    jovedelem NUMBER(9), 
    erdeklodesi_kor VARCHAR2(500),
    kedvenc_filmcim VARCHAR2(500),
    CONSTRAINT CHK_jovedelem CHECK (jovedelem in (15000, 200000000))
);

CREATE TABLE latogatas (
    latogatas_id NUMBER PRIMARY KEY,
    szorakozohely_id NUMBER,
    latogato_id NUMBER,
    latogatasok_szama NUMBER NOT NULL,
    utolso_latogatas_ideje DATE NOT NULL,
    elso_latogatas_ideje DATE NOT NULL,
    kedveli NUMBER(1) DEFAULT 0,
    atlagos_fogyasztas_ara NUMBER(9) NOT NULL,
    CONSTRAINT CHK_kedveli CHECK (kedveli in (0, 1)),
    CONSTRAINT CHK_latogatasok_szama CHECK (latogatasok_szama in (1, 7)),
    CONSTRAINT CHK_konzisztens_datum CHECK (elso_latogatas_ideje <= utolso_latogatas_ideje),
    CONSTRAINT FK_szorakozohely FOREIGN KEY (szorakozohely_id) REFERENCES szorakozohely(szorakozohely_id),
    CONSTRAINT FK_latogato FOREIGN KEY (latogato_id) REFERENCES latogato(latogato_id)
);