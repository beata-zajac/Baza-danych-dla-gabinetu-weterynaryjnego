USE master;
GO
IF DB_ID (N'GabinetWeterynaryjny') IS NOT NULL
DROP DATABASE GabinetWeterynaryjny; -- usuniêcie bazy danych jeœli istnieje

CREATE DATABASE GabinetWeterynaryjny -- utworzenie bazy danych z nadaniem odpowiednim Collate
COLLATE Polish_100_CI_AS; 
GO

USE [GabinetWeterynaryjny]
--tworzymy tabele

	CREATE TABLE [dbo].[Klienci](
	[ID] [int] PRIMARY KEY IDENTITY,
	[Imie] [nvarchar] (50) NOT NULL,
	[Nazwisko] [nvarchar] (100) NOT NULL,
	[Email] [nvarchar] (250) NULL,
	[Telefon] [nvarchar] (20) NOT NULL,
	[Adres] [nvarchar] (1000) NULL)

	CREATE TABLE [dbo].[Zwierzeta](
	[ID] [int] PRIMARY KEY IDENTITY,
	[Imie] [nvarchar] (50) NOT NULL,
	[DataUrodzenia] [datetime] NOT NULL,
	[Rodzaj] [nvarchar] (250) NOT NULL,
	[KlientID] [int] NOT NULL FOREIGN KEY REFERENCES KLIENCI (ID),
	[NrChip] [nvarchar] (15) NULL)


	CREATE TABLE [dbo].[Personel](
	[ID] [int] PRIMARY KEY IDENTITY,
	[Imie] [nvarchar] (50) NOT NULL,
	[Nazwisko] [nvarchar] (100) NOT NULL,
	[Stanowisko] [nvarchar] (100) NOT NULL,
	[Telefon] [nvarchar] (20) NOT NULL)

	CREATE TABLE [dbo].[RezerwacjeWizyt](
	[ID] [int] PRIMARY KEY IDENTITY,
	[KlientID] [int] NOT NULL FOREIGN KEY REFERENCES Klienci (ID),
	[DataRezerwacji] [datetime] NOT NULL,
	[DataPlanowanejWizyty] [datetime] NOT NULL,
	[Powod] [nvarchar] (1000) NULL)

	CREATE TABLE [dbo].[Uslugi](
	[ID] [int] PRIMARY KEY IDENTITY,
	[Nazwa] [nvarchar] (1000) NOT NULL,
	[Cena] [decimal] (8,2))

	CREATE TABLE [dbo].[Statusy](
	[ID] [int] PRIMARY KEY IDENTITY,
	[Nazwa] [nvarchar] (250) UNIQUE NOT NULL)

	CREATE TABLE [dbo].[Asortyment](
	[ID] [int] PRIMARY KEY IDENTITY,
	[Nazwa] [nvarchar] (1000) NOT NULL,
	[IloscNaStanie] [int] NULL,
	[RodzajProduktu] [nvarchar] (500) NULL)

	CREATE TABLE [dbo].[Wizyta](
	[ID] [int] PRIMARY KEY IDENTITY,
	[ZwierzeID] [int] NOT NULL FOREIGN KEY REFERENCES Zwierzeta (ID),
	[KlientID] [int] NOT NULL FOREIGN KEY REFERENCES Klienci (ID),
	[DataWizyty] [datetime] NOT NULL,
	[PowodWizyty] [nvarchar] (1000) NOT NULL,
	[LekarzID] [int] NULL FOREIGN KEY REFERENCES Personel (ID),
	[UslugaID] [int] NULL FOREIGN KEY REFERENCES Uslugi (ID),
	[StatusID] [int] NOT NULL FOREIGN KEY REFERENCES Statusy (ID))

	CREATE TABLE [dbo].[Hospitalizacja](
	[ID] [int] PRIMARY KEY IDENTITY,
	[ZwierzeID] [int] NOT NULL FOREIGN KEY REFERENCES Zwierzeta (ID),
	[DataPrzyjecia] [datetime] NOT NULL,
	[DataWypisu] [datetime] NOT NULL,
	[PowodHospitalizacji] [nvarchar] (500) NULL)

	CREATE TABLE [dbo].[PlanowaneZabiegi](
	[ID] [int] PRIMARY KEY IDENTITY,
	[ZwierzeID] [int] NOT NULL FOREIGN KEY REFERENCES Zwierzeta (ID),
	[NazwaZabiegu] [nvarchar] (500) NOT NULL,
	[DataZabiegu] [datetime] NOT NULL)

--uzupelniamy tabele danymi

INSERT INTO Uslugi (Nazwa, Cena)
VALUES ('Wizyta profilaktyczna', 50),
('Badanie krwi', 75),
('Badanie moczu', 40),
('Szczepienie', 30),
('Obciêcie pazurów',15)


INSERT INTO Statusy (Nazwa)
VALUES ('Zrealizowana'),
('Planowana'),
('Anulowana')

INSERT INTO Klienci (Imie, Nazwisko, Email, Telefon, Adres)
VALUES ('Klaudia', 'Bik', 'klaudia.bik12@gmail.com', '354227943', 'Kraków ul.Kobierzyñska 20/6'),
('Barbara', 'Kres', 'barbara0420@gmail.com', '198737294', 'Kraków ul.Kluczborska 10/4'),
('Daniel', 'Dudziak', 'danieldudziak@gmail.com', '339786454', 'Kraków ul.Kluczborska 17/7'),
('Bogdan', 'Bryndza', 'bogdan32@gmail.com', '243533664', 'Kraków ul.Jana Kochanowskiego 10/8'),
('Julia', 'Zych', 'julka.zych@gmail.com', '332338796', 'Kraków ul.Narciarska 10'),
('Danuta', 'Bogusz', 'danusia490@gmail.com', '738023409', 'Kraków ul.Pychowicka 18/3')



INSERT INTO Zwierzeta (Imie, DataUrodzenia, Rodzaj, KlientID, NrChip)
VALUES ('Azor', '2017-04-01', 'pies', 2, NULL),
('Basia', '2015-06-10', 'kot', 3, '888039421748327'),
('Hachi', '2020-07-14', 'pies', 1, '794305724331824'),
('Floki', '2018-04-16', 'kot', 4, NULL),
('Torvi', '2021-08-20', 'kot', 4, NULL),
('Per³a', '2020-05-09', 'pies', 5, NULL),
('Bruno', '2021-07-09', 'pies', 6, '483950234768354')



INSERT INTO Personel (Imie, Nazwisko, Stanowisko, Telefon)
VALUES ('Katarzyna', 'Piech', 'Recepcjonistka', '448532954'),
('Jola', 'Szach', 'Lekarz', '737104983'),
('Ma³gorzata', 'Lech', 'Lekarz', '322040390'),
('Danuta', 'Piech', 'Sprz¹taczka', '290667540')

INSERT INTO RezerwacjeWizyt (KlientID, DataRezerwacji, DataPlanowanejWizyty, Powod)
VALUES (4, '2022-01-05', '2022-01-10', 'Szczepienie kota'),
(1, '2021-11-10', '2021-11-20', 'Szczepienie'),
(5, '2021-12-01', '2021-12-13', 'Kontrolne badanie krwi'),
(3, '2021-12-05', '2021-12-13', 'Obciêcie pazurów'),
(5, '2022-02-10', '2022-02-10', 'Badanie moczu'),
(4, '2022-02-01', '2022-02-15', 'Wizyta profilaktyczna')


INSERT INTO Asortyment(Nazwa, IloscNaStanie, RodzajProduktu)
VALUES ('Pi³ka dla psa', 15, 'Akcesoria dla psa'),
('Drapak dla kota', 10, 'Akcesoria dla kota'),
('Pi³eczki dla kota', 20, NULL),
('Mokra karma dla psa', 50, NULL),
('Sucha karma dla psa', 54, NULL),
('Smycz dla psa i kota', 70, NULL)


INSERT INTO Wizyta (ZwierzeID, KlientID, DataWizyty, PowodWizyty, LekarzID, UslugaID, StatusID)
VALUES (1, 2, '2022-01-05', 'Niepokoj¹ce objawy', 3, 1, 1),
(4, 4, '2022-01-10', 'Szczepienie', 3, 4, 1),
(6, 5, '2021-12-13', 'Kontrolne badanie krwi', 2, 2, 1),
(2, 3, '2021-12-13', 'Obciêcie pazurów', 2, 5, 3),
(3, 1, '2021-11-20', 'Szczepienie', 3, 4, 1),
(6, 5, '2022-02-10', 'Kontrolne badanie moczu', 2, 3, 2),
(5, 4, '2022-02-15', 'Ogólna wizyta', 2, 1, 2)


INSERT INTO Hospitalizacja (ZwierzeID, DataPrzyjecia, DataWypisu, PowodHospitalizacji)
VALUES (7, '2022-01-18', '2022-01-21', 'Wyciêcie guza'),
(3, '2021-04-20', '2021-04-21', 'Kastracja'),
(6, '2021-12-27', '2021-12-30', 'Operacja ³apy')

INSERT INTO PlanowaneZabiegi(ZwierzeID, NazwaZabiegu, DataZabiegu)
VALUES (7, 'Wyciêcie guza', '2022-01-18' ),
(3, 'Kastracja', '2021-04-20' ),
(1, 'Usuniêcie zmiany w uchu', '2021-08-19'),
(6, 'Operacja przedniej ³apy', '2021-12-30')


	select * from Klienci
	select * from Zwierzeta
	select * from Wizyta
	select * from Personel
	select * from RezerwacjeWizyt
	select * from Statusy
	select * from Uslugi
	select * from Asortyment
	select * from Hospitalizacja
	select * from PlanowaneZabiegi



--Widoki

	--Widok za pomoc¹ którego dostaniesz informacjê o Zwierzêciu (Imie, DataUrodzenia, NrChip), które najd³u¿ej by³o hospitalizowane

	create view v_ZwierzetaHospitalizacja
	as
	select TOP 1 With ties Imie, DataUrodzenia, NrChip from Zwierzeta as Z
	join Hospitalizacja H on  H.ZwierzeID = Z.ID
	order by DATEDIFF(day, DataPrzyjecia, DataWypisu) desc

	select * from v_ZwierzetaHospitalizacja

	--Widok, który zwróci nam informacje o: imieniu i nazwisku klientów, imieniu ich zwierzêcia.
	
	create view v_NowyWidok
	as
	select Klienci.Imie + ' ' + Klienci.Nazwisko as ImieNazwisko,
	Zwierzeta.Imie as ImieZwierzecia
	from Klienci
	left join Zwierzeta on Klienci.ID = Zwierzeta.KlientID

	select * from v_NowyWidok

--Procedury

	--Procedura do zasilania tabeli Asortyment
	
	CREATE PROCEDURE DodajPrzedmiot
		@Nazwa nvarchar (1000),
		@IloscNaStanie int,
		@RodzajProduktu nvarchar (500)
	AS
	BEGIN
		INSERT Asortyment
		VALUES (@Nazwa, @IloscNaStanie, @RodzajProduktu)
	END

	select * from Asortyment

	EXECUTE DodajPrzedmiot 'Mokra karma dla kota 500g', '35', 'Pokarm dla kota'
	EXECUTE DodajPrzedmiot 'Obcinaczki dla kota', '10', 'Akcesoria dla kota'
	EXECUTE DodajPrzedmiot 'Transporter dla zwierzêcia do 5kg', '22', NULL
	EXECUTE DodajPrzedmiot 'Gryzak dla psa roz. S', '65', 'Akcesoria dla psa'

	select * from Asortyment

	-- Procedura dodaj¹ca nowych klientów do bazy

	CREATE PROCEDURE DodajKlienta
		@Imie nvarchar (50),
		@Nazwisko nvarchar (50),
		@Email nvarchar (250),
		@Telefon nvarchar (20),
		@Adres nvarchar (1000)
	AS
	BEGIN
		INSERT Klienci
		VALUES (@Imie, @Nazwisko, @Email, @Telefon, @Adres)
	END

	select * from Klienci

	EXECUTE DodajKlienta 'Kuba', 'Jagoda', 'krzys231@gmail.com', '882143093', 'Kraków ul.Pychowicka 22'
	EXECUTE DodajKlienta 'Ola', 'Mak', 'olamak@gmail.com', '926448571', 'Kraków ul.Centralna 29'
	
	select * from Klienci

	--Procedura umo¿liwiaj¹ca dodanie nowego zwierzêcia do tabeli Zwierzeta

	CREATE PROCEDURE DodajZwierze
		@Imie nvarchar (50),
		@DataUrodzenia datetime,
		@Rodzaj nvarchar (250),
		@KlientID int,
		@NrChip nvarchar (15)
	AS
	BEGIN
		INSERT Zwierzeta
		VALUES (@Imie, @DataUrodzenia, @Rodzaj, @KlientID, @NrChip)
	END

	select * from Zwierzeta

	EXECUTE DodajZwierze 'Bolek', '2015-04-09', 'Pies', '8', NULL 
	EXECUTE DodajZwierze 'Lola', '2016-08-20', 'Kot', '8', NULL
	EXECUTE DodajZwierze 'Hugo', '2014-09-12', 'Pies', '7', '348379420935930'
	EXECUTE DodajZwierze 'Pola', '2019-10-03', 'Kot', '4', '354687545765413'

	select * from Zwierzeta


	
--Funkcje

	--Funkcja tabelaryczna, która na podstawie ID zwierzêcia bêdzie nam zwracaæ informacjê takie jak: imie i nazwisko klienta posiadaj¹cego to zwierzê i w jakim terminie odby³a siê wizyta.
	
	create function NowaFunkcjaTabelaryczna
		(@ZwierzeID int)
	returns table 
	as
	return

		select Klienci.Imie,
			   Klienci.Nazwisko,
			   Wizyta.DataWizyty,
			   Wizyta.ZwierzeID
		from Wizyta
		JOIN Zwierzeta ON Wizyta.ZwierzeID = Zwierzeta.ID
		JOIN Klienci ON Wizyta.KlientID = Klienci.ID 
		where
		Wizyta.ZwierzeID = @ZwierzeID
		
		select * from NowaFunkcjaTabelaryczna('2')

	--Funkcja skalarna, która zwróci imiê zwierzêcia, które mia³o planowany zabieg wskazuj¹c datê zabiegu.

		create function NowaFunkcjaSkalarna
			(@DataZabiegu datetime)
		returns nvarchar (300)
		as
		begin
			
			declare @ImieZwierzecia nvarchar (300)
			set @ImieZwierzecia =	(
					select top 1 Zwierzeta.Imie
					from PlanowaneZabiegi
					JOIN Zwierzeta ON PlanowaneZabiegi.ZwierzeID = Zwierzeta.ID 
					where DataZabiegu = @DataZabiegu
					order by PlanowaneZabiegi.DataZabiegu desc
				)
			return @ImieZwierzecia
			end

		select  dbo.NowaFunkcjaSkalarna('2022-01-18')

	--Funkcja tabelaryczna, która na podstawie ID klienta bêdzie nam zwracaæ informacjê o zwierzêciu (Imiê, jego date urodzenia) i powodzie odbytej wizyty.
	
	create function NowaFunkcjaTabelaryczna2
		(@KlientID int)
	returns table 
	as
	return

		select Zwierzeta.Imie,
			   Zwierzeta.DataUrodzenia,
			   Wizyta.PowodWizyty
		from Wizyta
		JOIN Zwierzeta ON Wizyta.ZwierzeID = Zwierzeta.ID
		JOIN Klienci ON Wizyta.KlientID = Klienci.ID 
		where
		Wizyta.KlientID = @KlientID
		
		select * from NowaFunkcjaTabelaryczna2('5')

--Instrukcje

	--Wyszukaj wizyty, które odby³y siê do 2022-01-01

	select * from Wizyta where DataWizyty <= '2022-01-01'

	--Wyszukaj zwierzêta, które nie posiadaj¹ nrchip i posortuj je wed³ug daty urodzenia od najm³odszego

	select * from Zwierzeta where NrChip is NULL
	order by DataUrodzenia desc

	--Wyœwietl z tabeli "Wizyta" powod wizyty, ID kotów, które by³y na wizycie u dr Joli Szach

	select ZwierzeID, PowodWizyty, LekarzID from Wizyta where LekarzID = 2

	--Wyœwietl informacje o wizytach, które siê odby³y, posortuj je od najstarszej

	select * from Wizyta where StatusID = 1 order by DataWizyty asc

	--Wyœwietl informacje o zwierzêtach i powód planowanej wizyty

	select  Z.*, W.PowodWizyty from Zwierzeta as Z
	inner join  Wizyta W ON Z.ID = W.ZwierzeID
	where StatusID = 2

	--Wyœwietl wizyty, których powodem by³y kontrolne badania 

	select * from Wizyta where PowodWizyty LIKE '%Kontrolne%'

	--Wyœwietl œredni¹ d³ugoœæ hospitalizacji na podstawie tabeli Hospitalizacja w podziale na zwierzê

	select ZwierzeID, AVG(DATEDIFF(DAY, DataPrzyjecia, DataWypisu)) AS SredniaDlugoscPobytu from Hospitalizacja
	group by ZwierzeID

	--Wyszukaj cenê za wizytê zwierzêcia, wyœwietl ZwierzeID, PowodWizyty oraz cenê

	select KlientID, PowodWizyty, Cena from Wizyta as W
	join Uslugi U on W.UslugaID = U.ID

	--Wyœwietl informacje o klientach, którzy posiadaj¹ wiêcej ni¿ 1 zwierzê

	select K.*, COUNT(Z.KlientID)AS IloscZwierzat from Klienci AS K
	join Zwierzeta Z on K.ID = Z.KlientID
	group by K.ID, K.Imie, K.Nazwisko, K.Email, K.Telefon, K.Adres
	having COUNT(KlientID) > 1 
	order by IloscZwierzat desc

	--Wyœwietl Imie, DateUrodzenia i DatePrzyjecia zwierz¹t, które by³y hospitalizowane i posortuj od najstarszej daty przyjêcia

	select Z.Imie, Z.DataUrodzenia, H.DataPrzyjecia from Zwierzeta as Z
	right join Hospitalizacja H on Z.ID = H.ZwierzeID
	order by DataPrzyjecia asc