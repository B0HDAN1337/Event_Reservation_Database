-- Wstawianie danych do tabeli DaneOsobowe
INSERT INTO [DaneOsobowe] ([DataUrodzenia], [NumerTelefonu])
VALUES
    ('1990-05-15', '+48123456789'),
    ('1985-08-20', '+48987654321'),
    ('1988-12-10', '+48765432109');


-- Wstawianie danych do tabeli Użytkownicy
INSERT INTO [Użytkownicy] ([IDDaneOsobowe], [Imię], [Nazwisko], [E-mail])
VALUES
    (1, 'Jan', 'Kowalski', 'jan.kowalski@example.com'),
    (2, 'Anna', 'Nowak', 'anna.nowak@example.com'),
    (3, 'Piotr', 'Wiśniewski', 'piotr.wisniewski@example.com');


-- Wstawianie danych do tabeli KategorieWydarzeń
INSERT INTO [KategorieWydarzeń] ([OpisKategorii], [NazwaKategorii])
VALUES
    ('Koncerty muzyczne', 'Koncerty'),
    ('Sztuka sceniczna', 'Teatr'),
    ('Pokazy i widowiska', 'Widowiska');


-- Wstawianie danych do tabeli Wydarzenia
INSERT INTO [Wydarzenia] ([IDKategorii], [NazwaWydarzenia], [Data], [Lokalizacja], [Opis])
VALUES
    (1, 'Koncert rockowy', '2024-06-15', 'Hala Widowiskowa', 'Najnowsze hity rockowe'),
    (2, 'Występ teatralny', '2024-06-20', 'Teatr Miejski', 'Spektakl dramatyczny'),
    (3, 'Pokaz sztucznych ogni', '2024-07-04', 'Plaża Miejska', 'Wspaniałe widowisko pirotechniczne');


-- Wstawianie danych do tabeli Bilety
INSERT INTO [Bilety] ([IDWydarzenia], [IDUsługi], [TypBiletu], [Cena], [Dostępność])
VALUES
    (1, NULL, 'Normalny', 50.00, 100),
    (1, NULL, 'Ulgowy', 30.00, 50),
    (2, NULL, 'Normalny', 40.00, 80),
    (3, NULL, 'Normalny', 20.00, 200);

-- Wstawianie danych do tabeli Rezerwacje
INSERT INTO [Rezerwacje] ([IDBiletu], [IDUżytkownika], [DataRezerwacji])
VALUES
    (1, 1, '2024-06-10'),
    (2, 2, '2024-06-12'),
    (3, 3, '2024-06-14');

-- Wstawianie danych do tabeli Płatności
INSERT INTO [Płatności] ([IDRezerwacji], [IDUżytkownika], [DataPłatności], [MetodaPłatności], [KwotaPłatności])
VALUES
    (1, 1, '2024-06-12', 'Karta kredytowa', 50.00),
    (2, 2, '2024-06-14', 'Gotówka', 30.00),
    (3, 3, '2024-06-16', 'Przelew bankowy', 20.00);

-- Wstawianie danych do tabeli Opinie
INSERT INTO [Opinie] ([IDUżytkownika], [IDWydarzenia], [Komentarz], [DataDodania], [Ocena])
VALUES
    (1, 1, 'Bardzo fajny koncert!', '2024-06-16', 5),
    (2, 2, 'Świetny występ aktorski.', '2024-06-21', 4),
    (3, 3, 'Fantastyczne sztuczne ognie!', '2024-07-05', 5);



-- Wstawianie danych do tabeli UsługiDodatkowe
INSERT INTO [UsługiDodatkowe] ([NazwaUsługi], [Cena], [Opis])
VALUES
    ('Bufet', 20.00, 'Zestaw przekąsek i napojów'),
    ('Parking', 10.00, 'Miejsce parkingowe na wydarzeniu'),
    ('Przewodnik', 30.00, 'Usługa przewodnika po wydarzeniu');


	select * from DaneOsobowe;
	select * from Użytkownicy;
	select * from KategorieWydarzeń;
	select * from Wydarzenia;
	select * from Bilety;
	select * from Rezerwacje;
	select * from Płatności;
	select * from Opinie;
	select * from UsługiDodatkowe;

	

-- Test procedury DodajRezerwacje
EXEC DodajRezerwacje @IDUżytkownika = 1, @IDBiletu = 1, @DataRezerwacji = '2024-06-10';

-- Test procedury PrzetworzPlatnosc
EXEC PrzetworzPlatnosc @IDRezerwacji = 1, @IDUżytkownika = 1, @DataPłatności = '2024-06-10', @MetodaPłatności = 'Karta kredytowa', @KwotaPłatności = 50.00;

-- Test procedury DodajOpinie
EXEC DodajOpinie @IDUżytkownika = 1, @IDWydarzenia = 1, @Komentarz = 'Bardzo fajne wydarzenie!', @DataDodania = '2024-06-10', @Ocena = 5;

-- Test procedury EdytujOpinie
EXEC EdytujOpinie @IDOpinii = 1, @Komentarz = 'Bardzo fajne wydarzenie, polecam!', @Ocena = 4;

-- Test procedury PobierzInformacjeOUżytkowniku
EXEC PobierzInformacjeOUżytkowniku @UserID = 1;

-- Test procedury PobierzInformacjeOUżytkownikuPoEmail
EXEC PobierzInformacjeOUżytkownikuPoEmail @Email = 'example@example.com';

-- Test procedury DodajNowegoUżytkownika
EXEC DodajNowegoUżytkownika @Imię = 'Jan', @Nazwisko = 'Kowalski', @Email = 'jan.kowalski@example.com', @DataUrodzenia = '1990-01-01', @NumerTelefonu = '+123456789';

-- Test procedury EdytujInformacjeOUżytkowniku
EXEC EdytujInformacjeOUżytkowniku @UserID = 1, @NewImię = 'Nowe Imię', @NewNazwisko = 'Nowe Nazwisko', @NewEmail = 'nowy.email@example.com', @NewDataUrodzenia = '1980-01-01', @NewNumerTelefonu = '+987654321';

-- Test procedury DodajWydarzenie
EXEC DodajWydarzenie @NazwaWydarzenia = 'Nowe wydarzenie', @IDKategorii = 1, @Data = '2024-06-15', @Lokalizacja = 'Nowa lokalizacja', @Opis = 'Nowe wydarzenie opis';

-- Test procedury EdytujWydarzenie
EXEC EdytujWydarzenie @IDWydarzenia = 1, @NazwaWydarzenia = 'Zaktualizowane wydarzenie', @IDKategorii = 2, @Data = '2024-06-16', @Lokalizacja = 'Zaktualizowana lokalizacja', @Opis = 'Zaktualizowany opis';


-- Testy widoków
-- Test widoku SzczegolyRezerwacji
SELECT * FROM SzczegolyRezerwacji;

-- Test widoku NadchodzaceWydarzenia
SELECT * FROM NadchodzaceWydarzenia;

-- Test widoku DostepneBilety
SELECT * FROM DostepneBilety;

-- Test widoku SzczegolyUzytkownikow
SELECT * FROM SzczegolyUzytkownikow;



