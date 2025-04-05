USE master
GO
--System rezerwacji biletow na imprezy masowe: SRB_IM

--Tworzenie bazy danych
IF EXISTS 
(
SELECT name FROM master.dbo.sysdatabases
WHERE name = 'SRB_IM' )
BEGIN
	DROP DATABASE SRB_IM
END
GO 

CREATE DATABASE SRB_IM
ON 
(NAME = SRB_IM,
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\SRB_IM.mdf',
SIZE = 10,
MAXSIZE = 50,
FILEGROWTH = 5)
LOG ON 
(
NAME = SRB_IM_log,
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\SRB_IM_log.ldf',
SIZE = 5 MB,
MAXSIZE = 25 MB,
FILEGROWTH = 5MB);
GO


USE [SRB_IM]
GO

--Rezerwacje
DROP TABLE IF EXISTS dbo.Użytkownicy;
GO

CREATE TABLE [Użytkownicy] (
[IDUżytkownika] INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
[IDDaneOsobowe] INT NOT NULL,
[Imię] NVARCHAR(50) NOT NULL,
[Nazwisko] NVARCHAR(50) NOT NULL,
[E-mail] NVARCHAR(50) NOT NULL
);
GO

--DaneOsobowe
DROP TABLE IF EXISTS dbo.DaneOsobowe;
GO

CREATE TABLE [DaneOsobowe] (
[IDDaneOsobowe] INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
[DataUrodzenia] DATE NULL,
[NumerTelefonu] NVARCHAR(20) NULL
);
GO

--Wydarzenia
DROP TABLE IF EXISTS dbo.Wydarzenia;
GO

CREATE TABLE [Wydarzenia] (
[IDWydarzenia] INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
[IDKategorii] INT NULL,
[NazwaWydarzenia] NVARCHAR(100) NOT NULL,
[Data] DATE NOT NULL,
[Lokalizacja] NVARCHAR(50) NOT NULL,
[Opis] NVARCHAR(100) NULL
);
GO

--Bilety
DROP TABLE IF EXISTS dbo.Bilety;
GO

CREATE TABLE [Bilety] (
[IDBiletu] INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
[IDWydarzenia] INT NOT NULL,
[IDUsługi] INT NULL,
[TypBiletu] NVARCHAR(20) NOT NULL,
[Cena] FLOAT NOT NULL,
[Dostępność] NVARCHAR(50) NOT NULL
);
GO

--Rezerwacje
DROP TABLE IF EXISTS dbo.Rezerwacje;
GO

CREATE TABLE [Rezerwacje] (
[IDRezerwacji] INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
[IDBiletu] INT NOT NULL,
[IDUżytkownika] INT NOT NULL,
[DataRezerwacji] DATE NOT NULL
);
GO

--Płatności
DROP TABLE IF EXISTS dbo.Płatności;
GO

CREATE TABLE [Płatności] (
[IDPłatności] INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
[IDRezerwacji] INT NOT NULL,
[IDUżytkownika] INT NOT NULL,
[DataPłatności] DATE NULL,
[MetodaPłatności] NVARCHAR(50) NULL,
[KwotaPłatności] FLOAT NOT NULL
);
GO

--Opinie
DROP TABLE IF EXISTS dbo.Opinie;
GO

CREATE TABLE [Opinie] (
[IDOpinii] INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
[IDUżytkownika] INT NULL,
[IDWydarzenia] INT NOT NULL,
[Komentarz] NVARCHAR(255) NULL,
[DataDodania] DATE NOT NULL,
[Ocena] int NULL
);
GO

--KategorieWydarzeń
DROP TABLE IF EXISTS dbo.KategorieWydarzeń;
GO

CREATE TABLE [KategorieWydarzeń] (
[IDKategorii] INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
[OpisKategorii] NVARCHAR(100) NULL,
[NazwaKategorii] NVARCHAR(75) NOT NULL
);
GO

--UsługiDodatkowe
DROP TABLE IF EXISTS dbo.UsługiDodatkowe;
GO

CREATE TABLE [UsługiDodatkowe] (
[IDUsługi] INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
[NazwaUsługi] NVARCHAR(50) NOT NULL,
[Cena] FLOAT NOT NULL,
[Opis] NVARCHAR(100) NULL
);
GO



-- klucze obce
IF OBJECT_ID('dbo.[FK_Rezerwacje_Użytkownicy]', 'FK') IS NOT NULL
	ALTER TABLE dbo.[Rezerwacje] DROP CONSTRAINT FK_Rezerwacje_Użytkownicy
GO
ALTER TABLE [Rezerwacje] ADD CONSTRAINT FK_Rezerwacje_Użytkownicy FOREIGN KEY([IDUżytkownika]) REFERENCES [Użytkownicy] ([IDUżytkownika]); 
GO

IF OBJECT_ID('dbo.[FK_Płatności_Użytkownicy]', 'FK') IS NOT NULL
	ALTER TABLE dbo.[Płatności] DROP CONSTRAINT FK_Płatności_Użytkownicy
GO
ALTER TABLE [Płatności] ADD CONSTRAINT FK_Płatności_Użytkownicy FOREIGN KEY([IDUżytkownika]) REFERENCES [Użytkownicy] ([IDUżytkownika]);
GO

IF OBJECT_ID('dbo.[FK_Opinie_Użytkownicy]', 'FK') IS NOT NULL
	ALTER TABLE dbo.[Opinie] DROP CONSTRAINT FK_Opinie_Użytkownicy
GO
ALTER TABLE [Opinie] ADD CONSTRAINT FK_Opinie_Użytkownicy FOREIGN KEY([IDUżytkownika]) REFERENCES [Użytkownicy] ([IDUżytkownika]);
GO

IF OBJECT_ID('dbo.[FK_Opinie_Wydarzenia]', 'FK') IS NOT NULL
	ALTER TABLE dbo.[Opinie] DROP CONSTRAINT FK_Opinie_Wydarzenia
GO
ALTER TABLE [Opinie] ADD CONSTRAINT FK_Opinie_Wydarzenia FOREIGN KEY([IDWydarzenia]) REFERENCES [Wydarzenia] ([IDWydarzenia]);
GO

IF OBJECT_ID('dbo.[FK_Użytkownicy_DaneOsobowe]', 'FK') IS NOT NULL
	ALTER TABLE dbo.[Użytkownicy] DROP CONSTRAINT FK_Użytkownicy_DaneOsobowe
GO
ALTER TABLE [Użytkownicy] ADD CONSTRAINT FK_Użytkownicy_DaneOsobowe FOREIGN KEY([IDDaneOsobowe]) REFERENCES [DaneOsobowe] ([IDDaneOsobowe]);
GO

IF OBJECT_ID('dbo.[FK_Płatności_Rezerwacje]', 'FK') IS NOT NULL
	ALTER TABLE dbo.[Płatności] DROP CONSTRAINT FK_Płatności_Rezerwacje
GO
ALTER TABLE [Płatności] ADD CONSTRAINT FK_Płatności_Rezerwacje FOREIGN KEY([IDRezerwacji]) REFERENCES [Rezerwacje] ([IDRezerwacji]);
GO

IF OBJECT_ID('dbo.[FK_Rezerwacje_Bilety]', 'FK') IS NOT NULL
	ALTER TABLE dbo.[Rezerwacje] DROP CONSTRAINT FK_Rezerwacje_Bilety
GO
ALTER TABLE [Rezerwacje] ADD CONSTRAINT FK_Rezerwacje_Bilety FOREIGN KEY([IDBiletu]) REFERENCES [Bilety] ([IDBiletu]);
GO

IF OBJECT_ID('dbo.[FK_Bilety_UsługiDodatkowe]', 'FK') IS NOT NULL
	ALTER TABLE dbo.[Bilety] DROP CONSTRAINT FK_Bilety_UsługiDodatkowe
GO
ALTER TABLE [Bilety] ADD CONSTRAINT FK_Bilety_UsługiDodatkowe FOREIGN KEY([IDUsługi]) REFERENCES [UsługiDodatkowe] ([IDUsługi]);
GO

IF OBJECT_ID('dbo.[FK_Bilety_Wydarzenia]', 'FK') IS NOT NULL
	ALTER TABLE dbo.[Bilety] DROP CONSTRAINT FK_Bilety_Wydarzenia
GO
ALTER TABLE [Bilety] ADD CONSTRAINT FK_Bilety_Wydarzenia FOREIGN KEY([IDWydarzenia]) REFERENCES [Wydarzenia] ([IDWydarzenia]);
GO

IF OBJECT_ID('dbo.[FK_Wydarzenia_KategorieWydarzeń]', 'FK') IS NOT NULL
	ALTER TABLE dbo.[Wydarzenia] DROP CONSTRAINT FK_Wydarzenia_KategorieWydarzeń
GO
ALTER TABLE [Wydarzenia] ADD CONSTRAINT FK_Wydarzenia_KategorieWydarzeń FOREIGN KEY([IDKategorii]) REFERENCES [KategorieWydarzeń] ([IDKategorii]);
GO






-- Implementacja niedeklaratywnych mechanizmów sprawdzania poprawności danych

-- Użytkownicy(Imię)
ALTER TABLE [Użytkownicy]
DROP CONSTRAINT IF EXISTS CHECK_Imię;
GO
ALTER TABLE [Użytkownicy]
ADD CONSTRAINT CHECK_Imię CHECK (Imię  LIKE '[A-Z]%');


--Użytkownicy(Nazwisko)
ALTER TABLE [Użytkownicy]
DROP CONSTRAINT IF EXISTS CHECK_Nazwisko;
GO
ALTER TABLE [Użytkownicy]
ADD CONSTRAINT CHECK_Nazwisko CHECK (Nazwisko  LIKE '[A-Z -]%');


--Użytkownicy(E-mail)
IF OBJECT_ID('TR_CHECK_Email', 'TR') IS NOT NULL
    DROP TRIGGER TR_CHECK_Email;
GO
CREATE TRIGGER TR_CHECK_Email ON [Użytkownicy]
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @InvalidEmails TABLE (Email NVARCHAR(100));

    INSERT INTO @InvalidEmails (Email)
    SELECT [E-mail]
    FROM inserted
    WHERE [E-mail] NOT LIKE '%@%.%' OR [E-mail] NOT LIKE '%.com%';

    IF EXISTS (SELECT 1 FROM @InvalidEmails)
    BEGIN
        RAISERROR('Invalid email address format.', 16, 1);
        RETURN;
    END;

    INSERT INTO [Użytkownicy] ([Imię], [Nazwisko], [E-mail], [IDDaneOsobowe])
    SELECT [Imię], [Nazwisko], [E-mail], [IDDaneOsobowe]
    FROM inserted;
END;


-- DaneOsobowe(DataUrodzenia i NumerTelefonu)
IF OBJECT_ID('TR_CHECK_DaneOsobowe', 'TR') IS NOT NULL
    DROP TRIGGER TR_CHECK_DaneOsobowe;
GO
CREATE TRIGGER TR_CHECK_DaneOsobowe ON [DaneOsobowe]
INSTEAD OF INSERT
AS	
BEGIN
	-- DataUrodzenia
    IF EXISTS (SELECT 1 FROM inserted WHERE DataUrodzenia >= GETDATE())
    BEGIN
        RAISERROR('Data urodzenia musi być wcześniejsza niż bieżąca data.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
	-- NumerTelefonu
	IF EXISTS (SELECT 1 FROM inserted WHERE NOT ([NumerTelefonu] LIKE '+[0-9]%' OR [NumerTelefonu] LIKE '[0-9]%'))
    BEGIN
        RAISERROR('Numer telefonu może zawierać tylko cyfry, spacje, myślniki oraz plus na początku.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
	INSERT INTO [DaneOsobowe] ([DataUrodzenia], [NumerTelefonu])
	SELECT [DataUrodzenia], [NumerTelefonu]
	FROM inserted;
END;


-- Wydarzenia(Nazwa Wydarzenia)
ALTER TABLE [Wydarzenia]
DROP CONSTRAINT IF EXISTS CHECK_Wydarzenia;
GO
ALTER TABLE [Wydarzenia]
ADD CONSTRAINT CHECK_Wydarzenia CHECK (NazwaWydarzenia NOT LIKE '%[^a-zA-Z]%');


-- Wydarzenia(Data i Lokalizacja)
IF OBJECT_ID('TR_CHECK_Wydarzenia', 'TR') IS NOT NULL
    DROP TRIGGER TR_CHECK_Wydarzenia;
GO
CREATE TRIGGER TR_CHECK_Wydarzenia ON [Wydarzenia]
INSTEAD OF INSERT
NOT FOR REPLICATION
AS
BEGIN
	--Data
    IF EXISTS (SELECT 1 FROM inserted WHERE [Data] < GETDATE())
    BEGIN
        RAISERROR('Data wydarzenia nie może być wcześniejsza niż bieżąca data.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
	--Lokalizacja
	IF EXISTS (SELECT 1 FROM inserted WHERE [Lokalizacja] NOT LIKE '%[a-zA-Z0-9]%')
    BEGIN
        RAISERROR('Lokalizacja wydarzenia może składać się tylko z ciągu znaków alfanumerycznych.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
	INSERT INTO [Wydarzenia] ([IDKategorii], [NazwaWydarzenia], [Data], [Lokalizacja], [Opis])
    SELECT [IDKategorii], [NazwaWydarzenia], [Data], [Lokalizacja], [Opis]
    FROM inserted;
END;


-- Bilety(TypBiletu, Dostępność)
IF OBJECT_ID('TR_CHECK_Bilety', 'TR') IS NOT NULL
    DROP TRIGGER TR_CHECK_Bilety;
GO

CREATE TRIGGER TR_CHECK_Bilety ON [Bilety]
INSTEAD OF INSERT
NOT FOR REPLICATION
AS
BEGIN
	-- TypBiletu
    IF EXISTS (SELECT 1 FROM inserted WHERE [TypBiletu] NOT IN ('Ulgowy', 'Normalny'))
    BEGIN
        RAISERROR('Typ biletu może zawierać tylko wartości "Ulgowy" lub "Normalny".', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
	--Dostępność
	IF EXISTS (SELECT 1 FROM inserted WHERE [Dostępność] NOT LIKE '%[a-zA-Z0-9]%')
    BEGIN
        RAISERROR('Stan dostępności biletu może składać się tylko z ciągu znaków alfanumerycznych i ewentualnych znaków specjalnych.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
	INSERT INTO [Bilety] ([IDWydarzenia], [IDUsługi], [TypBiletu], [Cena], [Dostępność])
    SELECT [IDWydarzenia], [IDUsługi], [TypBiletu], [Cena], [Dostępność]
    FROM inserted;
END;

-- Bilety(Cena)
ALTER TABLE [Bilety]
DROP CONSTRAINT IF EXISTS CHECK_Bilet_Cena;
GO
ALTER TABLE [Bilety]
ADD CONSTRAINT CHECK_Bilet_Cena CHECK (Cena >= 0);


-- Rezerwacje(DataRezerwacji)
IF OBJECT_ID('TR_CHECK_Rezerwacje', 'TR') IS NOT NULL
    DROP TRIGGER TR_CHECK_Rezerwacje;
GO

CREATE TRIGGER TR_CHECK_Rezerwacje
ON [Rezerwacje]
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE [DataRezerwacji] < GETDATE())
    BEGIN
        RAISERROR('Data rezerwacji nie może być wcześniejsza niż bieżąca data.', 16, 1);
        RETURN;
    END;
	-- Sprawdź, czy istnieją wpisy o podanych IDBiletu w tabeli Bilety
    IF EXISTS (SELECT 1 FROM inserted i LEFT JOIN Bilety b ON i.IDBiletu = b.IDBiletu WHERE b.IDBiletu IS NULL)
    BEGIN
        RAISERROR('ID biletu nie istnieje w tabeli Bilety.', 16, 1);
        RETURN;
    END;

    INSERT INTO [Rezerwacje] ([IDBiletu], [IDUżytkownika], [DataRezerwacji])
    SELECT [IDBiletu], [IDUżytkownika], [DataRezerwacji]
    FROM inserted;
END;



-- Płatności(DataPłatności, KwotaPłatności)
IF OBJECT_ID('TR_CHECK_Płatności', 'TR') IS NOT NULL
    DROP TRIGGER TR_CHECK_Płatności;
GO

CREATE TRIGGER TR_CHECK_Płatności
ON [Płatności]
INSTEAD OF INSERT
AS
BEGIN
    -- DataPłatności
    IF EXISTS (SELECT 1 FROM inserted WHERE [DataPłatności] < GETDATE())
    BEGIN
        RAISERROR('Data płatności nie może być wcześniejsza niż bieżąca data.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
	-- KwotaPłatności
	IF EXISTS (SELECT 1 FROM inserted WHERE [KwotaPłatności] < 0)
    BEGIN
        RAISERROR('Kwota płatności nie może być ujemna.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
	IF EXISTS (SELECT 1 FROM inserted i LEFT JOIN Rezerwacje r ON i.IDRezerwacji = r.IDRezerwacji WHERE r.IDRezerwacji IS NULL)
    BEGIN
        RAISERROR('ID rezerwacji nie istnieje w tabeli Rezerwacje.', 16, 1);
        RETURN;
    END;

    INSERT INTO [Płatności] ([IDRezerwacji], [IDUżytkownika], [DataPłatności], [MetodaPłatności], [KwotaPłatności])
    SELECT [IDRezerwacji], [IDUżytkownika], [DataPłatności], [MetodaPłatności], [KwotaPłatności]
    FROM inserted;
END;



-- Opinie(DataDodania, Ocena)
IF OBJECT_ID('TR_CHECK_Opinie', 'TR') IS NOT NULL
    DROP TRIGGER TR_CHECK_Opinie;
GO

CREATE TRIGGER TR_CHECK_Opinie
ON [Opinie]
INSTEAD OF INSERT
AS
BEGIN
	-- DataDodania
    IF EXISTS (SELECT 1 FROM inserted WHERE [DataDodania] > GETDATE())
    BEGIN
        RAISERROR('Data dodania nie może być późniejsza niż bieżąca data.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
	-- Ocena
	 IF EXISTS (SELECT 1 FROM inserted WHERE [Ocena] IS NOT NULL AND ([Ocena] < 1 OR [Ocena] > 5))
    BEGIN
        RAISERROR('Ocena musi być liczbą od 1 do 5.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
	INSERT INTO [Opinie] ([DataDodania], [Ocena])
    SELECT [DataDodania], [Ocena]
    FROM inserted;
END;


-- KategorieWydarzeń(NazwaKategorii)
IF OBJECT_ID('TR_CHECK_KategorieWydarzeń', 'TR') IS NOT NULL
    DROP TRIGGER TR_CHECK_KategorieWydarzeń;
GO

CREATE TRIGGER TR_CHECK_KategorieWydarzeń
ON [KategorieWydarzeń]
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE [NazwaKategorii] NOT LIKE '%[a-zA-Z0-9]%')
    BEGIN
        RAISERROR('Nazwa kategorii wydarzenia musi składać się tylko z ciągu znaków alfanumerycznych.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
	INSERT INTO [KategorieWydarzeń] ([NazwaKategorii])
    SELECT [NazwaKategorii]
    FROM inserted;
END;


-- UsługiDodatkowe(Cena)
ALTER TABLE [UsługiDodatkowe]
DROP CONSTRAINT IF EXISTS CHECK_Uslugi_Cena;
GO
ALTER TABLE [UsługiDodatkowe]
ADD CONSTRAINT CHECK_Uslugi_Cena CHECK (Cena >= 0);
GO




-- Implementacja kodu wspomagającego aplikację użytkową

-- Procedura do tworzenia nowej rezerwacji
DROP PROCEDURE IF EXISTS DodajRezerwacje;
GO
CREATE PROCEDURE DodajRezerwacje
    @IDUżytkownika INT,
    @IDBiletu INT,
    @DataRezerwacji DATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Bilety WHERE IDBiletu = @IDBiletu AND Dostępność > 0)
    BEGIN
        INSERT INTO Rezerwacje (IDUżytkownika, IDBiletu, DataRezerwacji)
        VALUES (@IDUżytkownika, @IDBiletu, @DataRezerwacji);

        UPDATE Bilety
        SET Dostępność = Dostępność - 1
        WHERE IDBiletu = @IDBiletu;
    END
    ELSE
    BEGIN
        RAISERROR('Brak dostępnych biletów.', 16, 1);
    END
END;
GO

-- Procedura do przetwarzania płatności
DROP PROCEDURE IF EXISTS PrzetworzPlatnosc;
GO
CREATE PROCEDURE PrzetworzPlatnosc
    @IDRezerwacji INT,
    @IDUżytkownika INT,
    @DataPłatności DATE,
    @MetodaPłatności NVARCHAR(50),
    @KwotaPłatności FLOAT
AS
BEGIN
    INSERT INTO Płatności (IDRezerwacji, IDUżytkownika, DataPłatności, MetodaPłatności, KwotaPłatności)
    VALUES (@IDRezerwacji, @IDUżytkownika, @DataPłatności, @MetodaPłatności, @KwotaPłatności);
END;
GO


-- Procedura do dodawania opinii
DROP PROCEDURE IF EXISTS DodajOpinie;
GO
CREATE PROCEDURE DodajOpinie
    @IDUżytkownika INT,
    @IDWydarzenia INT,
    @Komentarz NVARCHAR(255),
    @DataDodania DATE,
    @Ocena INT
AS
BEGIN
    INSERT INTO Opinie (IDUżytkownika, IDWydarzenia, Komentarz, DataDodania, Ocena)
    VALUES (@IDUżytkownika, @IDWydarzenia, @Komentarz, @DataDodania, @Ocena);
END;
GO


--Procedura do edytowania opinii
DROP PROCEDURE IF EXISTS EdytujOpinie;
GO
CREATE PROCEDURE EdytujOpinie
    @IDOpinii INT,
    @Komentarz NVARCHAR(255),
    @Ocena INT
AS
BEGIN
    -- Sprawdzenie czy opinia istnieje
    IF NOT EXISTS (SELECT 1 FROM Opinie WHERE IDOpinii = @IDOpinii)
    BEGIN
        RAISERROR('Opinia o podanym ID nie istnieje.', 16, 1);
        RETURN;
    END;

    -- Sprawdzenie poprawności oceny
    IF @Ocena IS NOT NULL AND (@Ocena < 1 OR @Ocena > 5)
    BEGIN
        RAISERROR('Ocena musi być liczbą od 1 do 5.', 16, 1);
        RETURN;
    END;

    -- Aktualizacja opinii
    UPDATE Opinie
    SET Komentarz = @Komentarz,
        Ocena = @Ocena,
        DataDodania = GETDATE()  
    WHERE IDOpinii = @IDOpinii;
END;
GO


-- Procedura do pobierania informacji o użytkowniku na podstawie ID użytkownika
DROP PROCEDURE IF EXISTS PobierzInformacjeOUżytkowniku;
GO
CREATE PROCEDURE PobierzInformacjeOUżytkowniku
    @UserID INT
AS
BEGIN
    SELECT U.*, D.DataUrodzenia, D.NumerTelefonu
    FROM Użytkownicy U
    JOIN DaneOsobowe D ON U.IDDaneOsobowe = D.IDDaneOsobowe
    WHERE U.IDUżytkownika = @UserID;
END;
GO

-- Procedura do pobierania informacji o użytkowniku na podstawie adresu e-mail
DROP PROCEDURE IF EXISTS PobierzInformacjeOUżytkownikuPoEmail
GO
CREATE PROCEDURE PobierzInformacjeOUżytkownikuPoEmail
    @Email NVARCHAR(50)
AS
BEGIN
    SELECT U.*, D.DataUrodzenia, D.NumerTelefonu
    FROM Użytkownicy U
    JOIN DaneOsobowe D ON U.IDDaneOsobowe = D.IDDaneOsobowe
    WHERE U.[E-mail] = @Email;
END;
GO

-- Procedura do tworzenia nowego użytkownika
DROP PROCEDURE IF EXISTS DodajNowegoUżytkownika;
GO
CREATE PROCEDURE DodajNowegoUżytkownika
    @Imię NVARCHAR(50),
    @Nazwisko NVARCHAR(50),
    @Email NVARCHAR(100),
    @DataUrodzenia DATE,
    @NumerTelefonu NVARCHAR(20)
AS
BEGIN
    DECLARE @DaneOsoboweID INT;
    
    INSERT INTO DaneOsobowe (DataUrodzenia, NumerTelefonu) VALUES (@DataUrodzenia, @NumerTelefonu);
    SET @DaneOsoboweID = SCOPE_IDENTITY();
    
    INSERT INTO Użytkownicy (Imię, Nazwisko, [E-mail], IDDaneOsobowe) VALUES (@Imię, @Nazwisko, @Email, @DaneOsoboweID);
END;
GO

-- Procedura do edycji danych użytkownika
DROP PROCEDURE IF EXISTS EdytujInformacjeOUżytkowniku;
GO
CREATE PROCEDURE EdytujInformacjeOUżytkowniku
    @UserID INT,
    @NewImię NVARCHAR(50),
    @NewNazwisko NVARCHAR(50),
    @NewEmail NVARCHAR(50),
    @NewDataUrodzenia DATE,
    @NewNumerTelefonu NVARCHAR(20)
AS
BEGIN
	DECLARE @DaneOsoboweID INT;
    SELECT @DaneOsoboweID = IDDaneOsobowe FROM Użytkownicy WHERE IDUżytkownika = @UserID;

    UPDATE Użytkownicy 
    SET Imię = @NewImię, 
        Nazwisko = @NewNazwisko, 
        [E-mail] = @NewEmail
    WHERE IDUżytkownika = @UserID;
    
    UPDATE DaneOsobowe
    SET DataUrodzenia = @NewDataUrodzenia,
        NumerTelefonu = @NewNumerTelefonu
    WHERE IDDaneOsobowe = @UserID;
END;
GO


-- Procedura do dodawania nowego wydarzenia
DROP PROCEDURE IF EXISTS DodajWydarzenie
GO
CREATE PROCEDURE DodajWydarzenie
    @NazwaWydarzenia NVARCHAR(100),
    @IDKategorii INT,
    @Data DATE,
    @Lokalizacja NVARCHAR(50),
    @Opis NVARCHAR(100)
AS
BEGIN
    INSERT INTO Wydarzenia (NazwaWydarzenia, IDKategorii, Data, Lokalizacja, Opis)
    VALUES (@NazwaWydarzenia, @IDKategorii, @Data, @Lokalizacja, @Opis);
END;
GO


-- Procedura do edytowania wydarzenia
DROP PROCEDURE IF EXISTS EdytujWydarzenie;
GO
CREATE PROCEDURE EdytujWydarzenie
    @IDWydarzenia INT,
    @NazwaWydarzenia NVARCHAR(100),
    @IDKategorii INT,
    @Data DATE,
    @Lokalizacja NVARCHAR(50),
    @Opis NVARCHAR(100)
AS
BEGIN
    -- Sprawdzenie czy wydarzenie istnieje
    IF NOT EXISTS (SELECT 1 FROM Wydarzenia WHERE IDWydarzenia = @IDWydarzenia)
    BEGIN
        RAISERROR('Wydarzenie o podanym ID nie istnieje.', 16, 1);
        RETURN;
    END;

    -- Sprawdzenie poprawności daty wydarzenia
    IF @Data < GETDATE()
    BEGIN
        RAISERROR('Data wydarzenia nie może być wcześniejsza niż bieżąca data.', 16, 1);
        RETURN;
    END;

    -- Aktualizacja wydarzenia
    UPDATE Wydarzenia
    SET NazwaWydarzenia = @NazwaWydarzenia,
        IDKategorii = @IDKategorii,
        Data = @Data,
        Lokalizacja = @Lokalizacja,
        Opis = @Opis
    WHERE IDWydarzenia = @IDWydarzenia;
END;
GO



--Widok pokazujący szczegóły rezerwacji
DROP VIEW IF EXISTS SzczegolyRezerwacji;
GO
CREATE VIEW SzczegolyRezerwacji AS
SELECT 
    r.IDRezerwacji,
    u.Imię,
    u.Nazwisko,
    w.NazwaWydarzenia,
    b.TypBiletu,
    r.DataRezerwacji,
    p.DataPłatności,
    p.KwotaPłatności
FROM Rezerwacje r
JOIN Użytkownicy u ON r.IDUżytkownika = u.IDUżytkownika
JOIN Bilety b ON r.IDBiletu = b.IDBiletu
JOIN Wydarzenia w ON b.IDWydarzenia = w.IDWydarzenia
LEFT JOIN Płatności p ON r.IDRezerwacji = p.IDRezerwacji;
GO


--Widok pokazujący listę nadchodzących wydarzeń
DROP VIEW IF EXISTS NadchodzaceWydarzenia;
GO
CREATE VIEW NadchodzaceWydarzenia AS
SELECT 
    w.IDWydarzenia,
    w.NazwaWydarzenia,
    w.Data,
    w.Lokalizacja,
    w.Opis,
    k.NazwaKategorii
FROM Wydarzenia w
JOIN KategorieWydarzeń k ON w.IDKategorii = k.IDKategorii
WHERE w.Data >= GETDATE()
ORDER BY w.Data
OFFSET 0 ROWS;
GO


-- Widok pokazujący dostępne bilety na wydarzenia
DROP VIEW IF EXISTS DostepneBilety;
GO
CREATE VIEW DostepneBilety AS
SELECT 
    b.IDBiletu,
    w.NazwaWydarzenia,
    b.TypBiletu,
    b.Cena,
    b.Dostępność
FROM Bilety b
JOIN Wydarzenia w ON b.IDWydarzenia = w.IDWydarzenia
WHERE b.Dostępność > 0;
GO


-- Widok pokazujący szczegóły użytkowników i ich dane osobowe
DROP VIEW IF EXISTS SzczegolyUzytkownikow
GO
CREATE VIEW SzczegolyUzytkownikow AS
SELECT 
    u.IDUżytkownika,
    u.Imię,
    u.Nazwisko,
    u.[E-mail],
    d.DataUrodzenia,
    d.NumerTelefonu
FROM Użytkownicy u
JOIN DaneOsobowe d ON u.IDDaneOsobowe = d.IDDaneOsobowe;
GO



-- Widok pokazujący sumę płatności dla każdego użytkownika
DROP VIEW IF EXISTS SumaPlatnosciUzytkownikow;
GO
CREATE VIEW SumaPlatnosciUzytkownikow AS
SELECT 
    p.IDUżytkownika,
    u.Imię,
    u.Nazwisko,
    SUM(p.KwotaPłatności) AS SumaPłatności
FROM Płatności p
JOIN Użytkownicy u ON p.IDUżytkownika = u.IDUżytkownika
GROUP BY p.IDUżytkownika, u.Imię, u.Nazwisko;
GO


