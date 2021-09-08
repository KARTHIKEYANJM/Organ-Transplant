CREATE DATABASE Org_Trans;
USE Org_Trans;

CREATE TABLE login(
    username VARCHAR(30) NOT NULL,
    password VARCHAR(20) NOT NULL
);

INSERT INTO login VALUES ('admin','admin');

#table 1
CREATE TABLE User(
    User_ID int NOT NULL,
    Name varchar(30) NOT NULL,
    Date_of_Birth date NOT NULL,
    Medical_insurance int,
    Medical_history varchar(50),
    Street varchar(100),
    City varchar(30),
    State varchar(30),
    PRIMARY KEY(User_ID)
);

#table 2
CREATE TABLE User_phone_no(
    User_ID int NOT NULL,
    phone_no varchar(15),
    FOREIGN KEY(User_ID) REFERENCES User(User_ID) ON DELETE CASCADE
);

#table 3
CREATE TABLE Organization(
  Organization_ID int NOT NULL,
  Organization_name varchar(30) NOT NULL,
  Location varchar(40),
  Government_approved int, # 0 or 1
  PRIMARY KEY(Organization_ID)
);

#table 4
CREATE TABLE Doctor(
  Doctor_ID int NOT NULL,
  Doctor_Name varchar(30) NOT NULL,
  Department_Name varchar(30) NOT NULL,
  organization_ID int NOT NULL,
  FOREIGN KEY(organization_ID) REFERENCES Organization(organization_ID) ON DELETE CASCADE,
  PRIMARY KEY(Doctor_ID)
);

#table 5
CREATE TABLE Patient(
    Patient_ID int NOT NULL,
    organ_req varchar(40) NOT NULL,
    reason_of_procurement varchar(100),
    Doctor_ID int NOT NULL,
    User_ID int NOT NULL,
    FOREIGN KEY(User_ID) REFERENCES User(User_ID) ON DELETE CASCADE,
    FOREIGN KEY(Doctor_ID) REFERENCES Doctor(Doctor_ID) ON DELETE CASCADE,
    PRIMARY KEY(Patient_Id, organ_req)
);

#table 6
CREATE TABLE Donor(
  Donor_ID int NOT NULL,
  organ_donated varchar(40) NOT NULL,
  reason_of_donation varchar(100),
  Organization_ID int NOT NULL,
  User_ID int NOT NULL,
  FOREIGN KEY(User_ID) REFERENCES User(User_ID) ON DELETE CASCADE,
  FOREIGN KEY(Organization_ID) REFERENCES Organization(Organization_ID) ON DELETE CASCADE,
  PRIMARY KEY(Donor_ID, organ_donated)
);

#table 7
CREATE TABLE Organ_available(
  Organ_ID int NOT NULL AUTO_INCREMENT,
  Organ_name varchar(50) NOT NULL,
  Donor_ID int NOT NULL,
  FOREIGN KEY(Donor_ID) REFERENCES Donor(Donor_ID) ON DELETE CASCADE,
  PRIMARY KEY(Organ_ID)
);

#table 8
CREATE TABLE Transaction(
  Patient_ID int NOT NULL,
  Organ_ID int NOT NULL,
  Donor_ID int NOT NULL,
  Date_of_transaction date NOT NULL,
  Status int NOT NULL, #0 or 1
  FOREIGN KEY(Patient_ID) REFERENCES Patient(Patient_ID) ON DELETE CASCADE,
  FOREIGN KEY(Donor_ID) REFERENCES Donor(Donor_ID) ON DELETE CASCADE,
  PRIMARY KEY(Patient_ID,Organ_ID)
);

#table 9
CREATE TABLE Organization_phone_no(
  Organization_ID int NOT NULL,
  Phone_no varchar(15),
  FOREIGN KEY(Organization_ID) REFERENCES Organization(Organization_ID) ON DELETE CASCADE
);

#table 10
CREATE TABLE Doctor_phone_no(
  Doctor_ID int NOT NULL,
  Phone_no varchar(15),
  FOREIGN KEY(Doctor_ID) REFERENCES Doctor(Doctor_ID) ON DELETE CASCADE
);

#table 11
CREATE TABLE Organization_head(
  Organization_ID int NOT NULL,
  Employee_ID int NOT NULL,
  Name varchar(20) NOT NULL,
  Date_of_joining date NOT NULL,
  Term_length int NOT NULL,
  FOREIGN KEY(Organization_ID) REFERENCES Organization(Organization_ID) ON DELETE CASCADE,
  PRIMARY KEY(Organization_ID,Employee_ID)
);

-- -- delimiter //
-- -- create trigger ADD_DONOR
-- -- after insert
-- -- on Donor
-- -- for each row
-- -- begin
-- -- insert into Organ_available(Organ_name, Donor_ID)
-- -- values (new.organ_donated, new.Donor_ID);
-- -- end//
-- -- delimiter ;
-- -- --
-- -- delimiter //
-- -- create trigger REMOVE_ORGAN
-- -- after insert
-- -- on Transaction
-- -- for each row
-- -- begin
-- -- delete from Organ_available
-- -- where Organ_ID = new.Organ_ID;
-- -- end//
-- -- delimiter ;

create table log (
  querytime datetime,
  comment varchar(255)
);

delimiter //
create trigger ADD_DONOR_LOG
after insert
on Donor
for each row
begin
insert into log values
(now(), concat("Inserted new Donor", cast(new.Donor_Id as char)));
end //

create trigger UPD_DONOR_LOG
after update
on Donor
for each row
begin
insert into log values
(now(), concat("Updated Donor Details", cast(new.Donor_Id as char)));
end //

delimiter //
create trigger DEL_DONOR_LOG
after delete
on Donor
for each row
begin
insert into log values
(now(), concat("Deleted Donor ", cast(old.Donor_Id as char)));
end //

create trigger ADD_PATIENT_LOG
after insert
on Patient
for each row
begin
insert into log values
(now(), concat("Inserted new Patient ", cast(new.Patient_Id as char)));
end //

create trigger UPD_PATIENT_LOG
after update
on Patient
for each row
begin
insert into log values
(now(), concat("Updated Patient Details ", cast(new.Patient_Id as char)));
end //

create trigger DEL_PATIENT_LOG
after delete
on Donor
for each row
begin
insert into log values
(now(), concat("Deleted Patient ", cast(old.Donor_Id as char)));
end //

create trigger ADD_TRASACTION_LOG
after insert
on Transaction
for each row
begin
insert into log values
(now(), concat("Added Transaction :: Patient ID : ", cast(new.Patient_ID as char), "; Donor ID : " ,cast(new.Donor_ID as char)));
end //


-- -- User values
insert into user values(1,'Karthi','2000-12-08',1,'NIL','313,Thambu Chetty Street','Chennai','TamilNadu'); 
insert into user values(2,'Kiran','2001-11-22',0,'NIL','32,Mount Road Street','Chennai','TamilNadu');

-- commit;
-- -- User phone values
insert into  User_phone_no values (1,'8939212290');
insert into  User_phone_no values (2,'9939212295');

-- -- Organization values
insert into Organization values(1, 'New World','New Delhi',1);
insert into Organization values(2, 'Heritage','Chennai',0);

-- -- Doctor values
insert into doctor values(1,'Suresh','Oncology',1);
insert into doctor values(2,'Ganesh','Dermatology',2);

-- -- Patient values
insert into patient values(1,'Kidney','Needed for transplant surgery',1,2);
insert into patient values(2,'Heart','Since needed for transplant ',2,1);

-- -- Donor values
insert into donor values(1,'Heart','Brain death',2,1);
insert into donor values(2,'Kidney','Brain death',1,2);


-- -- Organ_available
insert into organ_available values(1,'Heart',1);
insert into organ_available values(2,'Kidney',2);


-- -- Transaction
insert into Transaction values(1,2,2,'2014-9-19',1);
insert into Transaction values(2,1,1,'2018-9-19',0);


-- -- Organization_phone_no
insert into Organization_phone_no values(1,'7389002810');
insert into Organization_phone_no values(2,'7389452810');

-- -- Doctor_phone_no
insert into Doctor_phone_no values(1,'8898201238');
insert into Doctor_phone_no values(2,'9898201234');

-- -- Organization_head
insert into Organization_head values(1,1,'Sainath','2000-12-08',19);
insert into Organization_head values(2,2,'Kavin','2010-12-08',5);

-- login
INSERT INTO login VALUES ('admin','admin');
INSERT INTO login VALUES ('Karthi','1245');
Insert into login values('Keyan','Jm08');

-- OUTPUTS
select * from Organization_head;
select * from User;
select * from Doctor;
select * from Patient;
select * from Donor;
select * from Organization;
select * from User_phone_no;
select * from organ_available;
select * from Organization_phone_no;
select * from Transaction ;
select * from Doctor_phone_no;
select * from login;
commit;

-- SET SQL_SAFE_UPDATES = 0;
-- delete from user;
-- delete from User_phone_no;
-- delete from Organization;
-- delete from doctor;
-- delete from patient;
-- delete from donor;
-- delete from organ_available;
-- delete from Transaction;
-- delete from Organization_phone_no;
-- delete from Doctor_phone_no;
-- delete from  Organization_head;

