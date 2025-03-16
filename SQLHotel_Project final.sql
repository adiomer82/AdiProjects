

create table Hotels
(
           HotelNumber int Primary Key,  /* îôúç øàùé*/
           HotelName varchar (50) not null,
           Country varchar (50) null,
           City varchar (50) null,
           PhoneNumber Bigint null,
           Grade int null,
           Restaurants varchar (50) null,	
           SwimmingPools int null

 )


 /* äåñôú òøëé äîìåðåú */


INSERT INTO Hotels
(
           HotelNumber, 
           HotelName,
           Country,
           City,
           PhoneNumber,
           Grade,
           Restaurants,
           SwimmingPools
)


   VALUES
   
            (1,'Le Meridien Ibom Hotel & Golf Resort','Nigeria','Uyo',23409991449,2,5,0),
            (2,'Katikies Santorini','Greece','Santorini',30578555,0,4,0),
            (7,'Morrison House Old','United States','Alexandria',1087444336,0,4,2),
            (9,'Taj Holiday Village Resort&Spa','India','Goa',9178005466,3,5,3),
            (12,'Sheraton Greece','Greece','Athens',30578925,1,4,0),
	    (13,'Pana Bariloche','Albania','Albanien',356788412,1,3,1),
            (15,'Bahiaxdia Saavedra','Argentina','Bahia Blanca',5688897410,1,5,4),
            (16,'Sheraton Vancouver Wall Centre','Canada','Vancouver',77865432108,3,4,0),
            (22,'Sheraton Hsinchu Hotel - Zhubei City','Taiwan','Zhubei City',886797901125,4,5,3),
            (32,'San Ysidro Ranch','United States','Santa Barbara',1455678255,1,5,1),
            (33,'LErmitage Beverly Hills','United States','Beverly Hills',1221365850,2,NULL,2),
            (50,'Rosewood Castiglion del Bosco','Italy','Montalcino',3977758155,0,3,0),
            (51,'Hotel Savoy','Italy','Florence',397255856,0,4,0),
            (52,'Krabi La Playa Resort-SHA Plus','Thailan','Ao Nang Beach',6697902580,0,1,0),
            (59,'Aloft Yancheng','Chine','Yancheng',86988880124,1,4,1),
            (65,'Panamericano Bariloche','Argentina','Bariloche',56888002154,0,1,0),
            (66,'KC Beach Club & Pool Villas','Thailand','Chaweng City Center',6687952549,2,5,3),
            (70,'Sheraton Bodh Gaya Hotel - Bodhgaya','India','Bodhgaya',9125800312,2,5,4),
            (77,'FuramaXclusive Sathorn','Thailand','Bangkok Bang Rak',6677952549,0,3,1),
            (78,'Rawai VIP Villas & Kids Park','Thailand','Rawai Beach',6687123549,2,2,2),
            (88,'Riggs Washington D.C.','United States','Washington',11433688812,1,5,1),
            (90,'De Paris Hotel','Albania','Albanien',355444582,0,4,0)




GO





create table RoomType
(
             HotelRoomType varchar(50) Primary Key,   
             RoomName varchar(50),
             RoomTypePrice money 
  )
 


 

 insert into RoomType
 (           HotelRoomType,    
             RoomName,
	     RoomTypePrice
 )


 VALUES 
              ('ConnectionRm','DoubleBed',160),
              ('Deluxe','QueenBed',250),
              ('FamilyRoom','DBExtraBad',200),
              ('Penthouse','VIPRM',500),
              ('Standard','DoubleBed',160),
              ('Studio','SingleBed',100),
              ('Suite','KingBedExtraSof',320),
              ('Family1','Dblplus1',220),
              ('Studio2','DBL',300),
              ('Apartment','APRT',800),
              ('Twin Room','TWN',160),
              ('Triple Room','TRL',227),
              ('Single','SGL',100),
              ('Junior Suite','JNS',450),
              ('Presidential Suite','PRS',1000),
              ('Accessible Room','WCH',160),
              ('Cabana','CBN',370),
              ('Villa','VIL',450),
              ('Connecting Rooms','CCN',230),
              ('Honeymoon Suite','HNY',999),
              ('Business Room','BSN',230)
			  
GO



create table RoomView
(
             ViewType varchar (50) Primary Key,   
             ViewName varchar (50)
 )
 


 

 insert into RoomView
 (           ViewType, 
             ViewName 
 )


 VALUES 

 	
            
             ('S','Sea View'),
             ('C','City View'),
             ('PK','Park View'),
             ('M','Mountain View'),
             ('P','Pool View'),
             ('CS','Countryside View'),
             ('B','Beach View'),
             ('G','Ocean View'),
             ('L','Lake View'),
             ('R','River View'),
             ('F','Forest View'),
             ('D','Desert View'),
             ('SK','Skyline View'),
             ('T','Courtyard View'),
             ('MV','Marina View'),
             ('GF','Golf Course View'),
             ('RV','Resort View'),
             ('HV','Historic View'),
             ('NN','No View'),
             ('AV','Atrium View')


GO



CREATE TABLE Rooms
(
             HotelNumber INT NOT NULL,
             RoomNumber INT NOT NULL,
             HotelRoomType VARCHAR(50),
             ViewType VARCHAR(50) NOT NULL,
             RoomSize INT NULL,
             Balcony BIT NOT NULL DEFAULT 0                                 
	     PRIMARY KEY (HotelNumber, RoomNumber),                         
             FOREIGN KEY (HotelNumber) REFERENCES Hotels(HotelNumber),       
             FOREIGN KEY (HotelRoomType) REFERENCES RoomType(HotelRoomType), 
             FOREIGN KEY (ViewType) REFERENCES RoomView(ViewType)          
)


 

 insert into Rooms
 (           
             HotelNumber,
             RoomNumber,
             HotelRoomType,
	     ViewType, 
             RoomSize,
             Balcony
 )

VALUES 
               (1,100,'STANDARD','C',22,1),
               (2,101,'STANDARD','C',22,1),
               (7,102,'STANDARD','P',22,1),
               (9,103,'STANDARD','M',22,0),
               (12,105,'FamilyRoom','M',32,1),
	       (13,502,'Suite','S',36,1),
               (15,106,'Twin Room','MV',19,1),
               (16,109,'Studio','CS',17,1),
               (22,110,'Studio','PK',17,0),
               (32,190,'Suite','S',25,1),
	       (33,200,'STANDARD','C',22,1),
               (50,201,'STANDARD','C',22,1),
               (51,202,'STANDARD','P',22,1),
               (52,202,'Studio2','S',20,0),
               (59,203,'STANDARD','M',22,1),
               (65,300,'STANDARD','C',22,1),
               (66,301,'STANDARD','C',22,1),
               (70,400,'Deluxe','B',27,1),
               (77,401,'Deluxe','G',27,1),
               (78,402,'Deluxe','C',27,1),
               (88,406,'FamilyRoom','C',32,1),
               (90,407,'FamilyRoom','S',32,1)
               
     GO     
	 


create table HotelGuests
(           
        PassportCountry varchar (20) not null,
        PassportNumber varchar (20)  not null,
	FirstName varchar (20) not null,
	LastName varchar (20) not null,
	Nickname varchar (20) null,
	Country varchar (20) null,
	City varchar (20) null, 
	Street varchar (50) null,
	MobilePhone  varchar (20) not null, 
      CHECK (MobilePhone NOT LIKE '%[^0-9]%' AND LEN(MobilePhone) > 0),  /* (constraint)   
Primary Key ( PassportCountry,PassportNumber)     

)




INSERT INTO HotelGuests
(       PassportCountry,
        PassportNumber,
	FirstName,
	LastName,
	Nickname,
	Country,
	City,
	Street,
	MobilePhone 
)
   VALUES
   
          ('MA',88895611,'Eivett','Batitto','Eav','Morocco','Marrakech','Allastreet 12',212212342094),
          ('HK',77773320,'John','Chou','Chouiee','Hong Kong','Sha Tin New Town','Chong Monk 4',8529056342093),
          ('IL',76708822,'Yuval','Omer','Yuvi','Israel','Rishon Le Zion','Hazaz 77',972526342093),
          ('GR',70555598,'Gregos','Santos','GOOLY','Greece','Athens','Ellindon 201',307684443133),
          ('CU',70012312,'Gabriella','Gonsales','Gabbi','Cuba','Havanna','Gosh Rowd 23',537666342090),
          ('US',65550912,'Omer','Jullyane','Omer','United States','Hagorim','Kormann89',1143700333123),
          ('IL',65550911,'Omer','Adam','Omer','Israel','Hagor','34 Rachel',972000333123),
          ('AR',58799330,'Hecktor','Mercedes','','Argentina','Buenos aires','Del port 66',557786756433),
          ('IL',56470224,'Benjamin','Levi','Benny','Israel','Jerusalem','Menachem Begin 100',972526579801),
          ('IL',56366116,'Orly','Nagar','Orly','Israel','Hadera','Ehud Manor 5',972526579801),
          ('DK',56111002,'Jonas','Mikkel','Mikkel','Denmark','Copenhagen','Copenhagen Main 2',456666332091),
          ('DE',55478999,'Eduard','Sea','Eddi','Germany','Berlin','Nauen 77',318886540334),
          ('BE',44390123,'Gynn','Dom','Gy','Belgium','Arlon','Bogata 6',326666342093),
          ('US',43501132,'George','Rosh','George','New York','Manhattan','Bit towers 16',415573420945),
          ('IL',40028353,'Gili','Shauli','Gili','Israel','Holon','Sokolov 2',396666342097),
          ('UA',34498831,'Vladislav','Putin','Vadim','Ukraine','Kiev','Druska 80',380887336033),
          ('IL',33810358,'Tal','Pizanti','Tali','Israel','Hod Hasharon','Nathan Yehonathan 9',972508220333),
          ('US',32001298,'Brad ','Pitt','','California','Las Vegas','Erea 51',112646342093),
          ('US',24799901,'Mason','Smith','Mass','United States','Atlanta','Piedmont Avenue 1',11435550987532),
          ('PT',24399901,'Benjamin','Cohen','ben ','Portugal','Atlantauot',' Avenue 12',35855094532),
          ('IL',24378901,'Yomtov','Hochstein','Yotti','Germany','Frankfurt ','Zeil 7',340166342093),
          ('PT',17666900,'Shawn','Nicht','Shawn','Germany','Frankfurt ','The Zeil 29',396666342093)
          
   GO         
			


create table HotelReservations

(       ReservationNumber int Primary Key,    
        PassportCountry varchar (20) not null,
	PassportNumber varchar (20) not null,
	HotelNumber int not null,
	RoomNumber int not null,
	ArrivalDate date not null,
        RoomNights int not null,
	NumberofGuests numeric not null, 
	TotalPrice Money not null, 
 FOREIGN KEY (PassportCountry,PassportNumber) REFERENCES HotelGuests(PassportCountry,PassportNumber),   
 FOREIGN KEY (HotelNumber) REFERENCES Hotels(HotelNumber),                                              
 FOREIGN KEY (HotelNumber, RoomNumber) REFERENCES Rooms(HotelNumber, RoomNumber)                       

)




 /* äåñôú òøëé äæîðåú*/


INSERT INTO HotelReservations
(
            ReservationNumber,
            PassportCountry,
			PassportNumber,
		    HotelNumber,
			RoomNumber,
			ArrivalDate,
			RoomNights,
			NumberofGuests, 
		    TotalPrice 
)


   VALUES
   
       (79972,'US',65550912,2,101,'2024-05-05',3,3,3500),
      (81174,'MA',88895611,7,102,'2025-02-12',5,2,2400),
      (82977,'UA',34498831,9,103,'2025-02-05',3,1,1290),
      (75565,'GR',70555598,12,105,'2024-03-12',3,1,1224),
      (84781,'US',24799901,15,106,'2024-03-08',5,2,970),
      (82376,'PT',24399901,16,109,'2025-06-11',2,1,1601),
      (84179,'US',32001298,22,110,'2025-10-12',3,2,1600),
      (75564,'DK',56111002,32,190,'2024-03-08',3,3,1890),
      (75566,'HK',77773320,33,200,'2024-03-09',1,1,1190),
      (80573,'IL',76708822,50,201,'2025-01-01',4,2,2300),
      (84780,'US',43501132,51,202,'2024-04-12',4,2,2200),
      (77567,'IL',33810358,52,202,'2024-03-10',7,2,10000),
      (81775,'PT',17666900,59,203,'2025-07-08',14,3,13200),
      (75561,'BE',44390123,65,300,'2024-03-05',2,1,1290),
      (75563,'DE',55478999,66,301,'2024-03-07',2,3,1467),
      (75560,'AR',58799330,70,400,'2024-03-04',5,3,2000),
      (78770,'IL',56366116,77,401,'2024-03-08',4,4,5600),
      (79371,'IL',56470224,78,402,'2024-04-01',2,2,2000),
      (77568,'IL',40028353,88,406,'2024-03-10',2,3,1430),
      (75562,'CU',70012312,90,407,'2024-03-06',6,4,5000),
      (83578,'IL',24378901,13,502,'2025-04-10',2,4,4400)
     
   


           
GO
