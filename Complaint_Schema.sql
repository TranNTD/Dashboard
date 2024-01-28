/*==============================================================*/
/* DBMS name:      PostgreSQL 14.x                              */
/* Created on:     11.12.2023 13:51:54                          */
/*==============================================================*/


drop index ASSOCIATION_3_FK;

drop index ASSOCIATION_2_FK;

drop index CASE_PK;

drop table "Case";

drop index CHILDSEAT_PK;

drop table ChildSeat;

drop index ASSOCIATION_1_FK;

drop index COMPLAINTID_PK;

drop table ComplaintID;

drop index DEALER_PK;

drop table Dealer;

drop index EQUIPMENT_PK;

drop table Equipment;

drop index FAILPLACE_PK;

drop table FailPlace;

drop index TIRE_PK;

drop table Tire;

drop index VEHICLE_PK;

drop table Vehicle;

/*==============================================================*/
/* Table: "Case"                                                */
/*==============================================================*/
create table "Case" (
   ODINO                integer              not null,
   DEALER_NAME          varchar(40),
   DEALER_ZIP           integer,
   CITY                 varchar(30),
   STATE                varchar(2),
   MFR_NAME             varchar,
   MAKETXT              varchar,
   MODELTXT             varchar,
   YEARTXT              integer,
   CRASH                boolean,
   FAILDATE             date,
   FIRE                 boolean,
   INJURED              integer,
   DEATHS               integer,
   DATEA                date,
   LDATE                date,
   OCCURENCES           integer,
   CDESCR               varchar,
   MEDICAL_ATTN         boolean,
   POLICE_RPT_YN        boolean,
   PURCH_DT             date,
   constraint PK_CASE primary key (ODINO)
);

/*==============================================================*/
/* Index: CASE_PK                                               */
/*==============================================================*/
create unique index CASE_PK on "Case" (
ODINO
);

/*==============================================================*/
/* Index: ASSOCIATION_2_FK                                      */
/*==============================================================*/
create  index ASSOCIATION_2_FK on "Case" (
DEALER_NAME,
DEALER_ZIP
);

/*==============================================================*/
/* Index: ASSOCIATION_3_FK                                      */
/*==============================================================*/
create  index ASSOCIATION_3_FK on "Case" (
CITY,
STATE
);

/*==============================================================*/
/* Table: ChildSeat                                             */
/*==============================================================*/
create table ChildSeat (
   ODINO                integer              not null,
   CMPLID               integer              not null,
   RESTRAINT_TYPE       varchar(4),
   MANUF_DT             date,
   SEAT_TYPE            varchar(4),
   constraint PK_CHILDSEAT primary key (ODINO, CMPLID)
);

/*==============================================================*/
/* Index: CHILDSEAT_PK                                          */
/*==============================================================*/
create unique index CHILDSEAT_PK on ChildSeat (
ODINO,
CMPLID
);

/*==============================================================*/
/* Table: ComplaintID                                           */
/*==============================================================*/
create table ComplaintID (
   ODINO                integer              not null,
   CMPLID               integer              not null,
   COMPDESC             varchar(254),
   PROD_TYPE            char(1),
   constraint PK_COMPLAINTID primary key (ODINO, CMPLID)
);

/*==============================================================*/
/* Index: COMPLAINTID_PK                                        */
/*==============================================================*/
create unique index COMPLAINTID_PK on ComplaintID (
ODINO,
CMPLID
);

/*==============================================================*/
/* Index: ASSOCIATION_1_FK                                      */
/*==============================================================*/
create  index ASSOCIATION_1_FK on ComplaintID (
ODINO
);

/*==============================================================*/
/* Table: Dealer                                                */
/*==============================================================*/
create table Dealer (
   DEALER_NAME          varchar(40)          not null,
   DEALER_TEL           varchar(20),
   DEALER_CITY          varchar(30)          not null,
   DEALER_STATE         varchar(2)           not null,
   DEALER_ZIP           integer              not null,
   constraint PK_DEALER primary key (DEALER_NAME, DEALER_ZIP)
);

/*==============================================================*/
/* Index: DEALER_PK                                             */
/*==============================================================*/
create unique index DEALER_PK on Dealer (
DEALER_NAME,
DEALER_ZIP
);

/*==============================================================*/
/* Table: Equipment                                             */
/*==============================================================*/
create table Equipment (
   ODINO                integer              not null,
   CMPLID               integer              not null,
   ORIG_OWNER_YN        boolean,
   constraint PK_EQUIPMENT primary key (ODINO, CMPLID)
);

/*==============================================================*/
/* Index: EQUIPMENT_PK                                          */
/*==============================================================*/
create unique index EQUIPMENT_PK on Equipment (
ODINO,
CMPLID
);

/*==============================================================*/
/* Table: FailPlace                                             */
/*==============================================================*/
create table FailPlace (
   CITY                 varchar(30)          not null,
   STATE                varchar(2)           not null,
   constraint PK_FAILPLACE primary key (CITY, STATE)
);

/*==============================================================*/
/* Index: FAILPLACE_PK                                          */
/*==============================================================*/
create unique index FAILPLACE_PK on FailPlace (
CITY,
STATE
);

/*==============================================================*/
/* Table: Tire                                                  */
/*==============================================================*/
create table Tire (
   ODINO                integer              not null,
   CMPLID               integer              not null,
   DOT                  varchar(20),
   TIRE_SIZE            varchar(30),
   LOC_OF_TIRE          varchar(4),
   TIRE_FAIL_TYPE       varchar(4),
   REPAIRED_YN          boolean,
   constraint PK_TIRE primary key (ODINO, CMPLID)
);

/*==============================================================*/
/* Index: TIRE_PK                                               */
/*==============================================================*/
create unique index TIRE_PK on Tire (
ODINO,
CMPLID
);

/*==============================================================*/
/* Table: Vehicle                                               */
/*==============================================================*/
create table Vehicle (
   ODINO                integer              not null,
   CMPLID               integer              not null,
   VIN                  varchar(11),
   MILES                integer,
   ANTI_BRAKES_YN       boolean,
   CRUISE_CONT_YN       boolean,
   NUM_CYLS             integer,
   DRIVE_TRAIN          varchar(4),
   FUEL_SYS             varchar(4),
   FUEL_TYPE            varchar(4),
   TRANS_TYPE           varchar(4),
   VEH_SPEED            integer,
   VEHICLES_TOWED_YN    boolean,
   constraint PK_VEHICLE primary key (ODINO, CMPLID)
);

/*==============================================================*/
/* Index: VEHICLE_PK                                            */
/*==============================================================*/
create unique index VEHICLE_PK on Vehicle (
ODINO,
CMPLID
);

alter table "Case"
   add constraint FK_CASE_ASSOCIATI_DEALER foreign key (DEALER_NAME, DEALER_ZIP)
      references Dealer (DEALER_NAME, DEALER_ZIP)
      on delete restrict on update restrict;

alter table "Case"
   add constraint FK_CASE_ASSOCIATI_FAILPLAC foreign key (CITY, STATE)
      references FailPlace (CITY, STATE)
      on delete restrict on update restrict;

alter table ChildSeat
   add constraint FK_CHILDSEA_GENERALIZ_COMPLAIN foreign key (ODINO, CMPLID)
      references ComplaintID (ODINO, CMPLID)
      on delete restrict on update restrict;

alter table ComplaintID
   add constraint FK_COMPLAIN_ASSOCIATI_CASE foreign key (ODINO)
      references "Case" (ODINO)
      on delete restrict on update restrict;

alter table Equipment
   add constraint FK_EQUIPMEN_GENERALIZ_COMPLAIN foreign key (ODINO, CMPLID)
      references ComplaintID (ODINO, CMPLID)
      on delete restrict on update restrict;

alter table Tire
   add constraint FK_TIRE_GENERALIZ_COMPLAIN foreign key (ODINO, CMPLID)
      references ComplaintID (ODINO, CMPLID)
      on delete restrict on update restrict;

alter table Vehicle
   add constraint FK_VEHICLE_GENERALIZ_COMPLAIN foreign key (ODINO, CMPLID)
      references ComplaintID (ODINO, CMPLID)
      on delete restrict on update restrict;

