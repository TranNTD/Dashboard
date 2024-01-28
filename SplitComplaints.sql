/*==============================================================*/
/* DBMS name:      PostgreSQL 14.x                              */
/* Created on:     08.01.2024 20:50:03                          */
/*==============================================================*/


drop index if exists CAR_PK CASCADE;

drop table if exists Car CASCADE;

drop index if exists ASSOCIATION_4_FK CASCADE;

drop index if exists ASSOCIATION_3_FK CASCADE;

drop index if exists ASSOCIATION_2_FK CASCADE;

drop index if exists CASE_PK CASCADE;

drop table if exists "Case" CASCADE;

drop index if exists CHILDSEAT_PK CASCADE;

drop table if exists ChildSeat CASCADE;

drop index if exists ASSOCIATION_1_FK CASCADE;

drop index if exists COMPLAINTID_PK CASCADE;

drop table if exists ComplaintID CASCADE;

drop index if exists DEALER_PK CASCADE;

drop table if exists Dealer CASCADE;

drop index if exists EQUIPMENT_PK CASCADE;

drop table if exists Equipment CASCADE;

drop index if exists FAILPLACE_PK CASCADE;

drop table if exists FailPlace CASCADE;

drop index if exists TIRE_PK CASCADE;

drop table if exists Tire CASCADE;

drop index if exists VEHICLE_PK CASCADE;

drop table if exists Vehicle CASCADE;

/*==============================================================*/
/* Table: Car                                                   */
/*==============================================================*/
create table Car (
   MAKETXT              varchar(254)         not null,
   MODELTXT             text		         not null,
   YEARTXT              integer              not null,
   MFR_NAME             varchar(254),
   constraint PK_CAR primary key (MAKETXT, MODELTXT, YEARTXT)
);

/*==============================================================*/
/* Index: CAR_PK                                                */
/*==============================================================*/
create unique index CAR_PK on Car (
MAKETXT,
MODELTXT,
YEARTXT
);

/*==============================================================*/
/* Table: "Case"                                                */
/*==============================================================*/
create table "Case" (
   ODINO                integer              not null,
   DEALER_NAME          varchar(254),
   DEALER_ZIP           varchar(254),
   MAKETXT              varchar(254)         not null,
   MODELTXT             text		         not null,
   YEARTXT              integer              not null,
   CITY                 varchar(254),
   "STATE"              varchar(254),
   CRASH                boolean,
   FAILDATE             date,
   FIRE                 boolean,
   INJURED              integer,
   DEATHS               integer,
   DATEA                date,
   LDATE                date,
   OCCURENCES           double precision,
   COMPDESC             varchar(254),
   CDESCR               text,
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
"STATE"
);

/*==============================================================*/
/* Index: ASSOCIATION_4_FK                                      */
/*==============================================================*/
create  index ASSOCIATION_4_FK on "Case" (
MAKETXT,
MODELTXT,
YEARTXT
);

/*==============================================================*/
/* Table: ChildSeat                                             */
/*==============================================================*/
create table ChildSeat (
   ODINO                integer              not null,
   CMPLID               integer              not null,
   RESTRAINT_TYPE       text,
   MANUF_DT             date,
   SEAT_TYPE            varchar(254),
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
   PROD_TYPE            text,
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
   DEALER_NAME          varchar(254)         not null,
   DEALER_TEL           varchar(254),
   DEALER_CITY          varchar(254)         not null,
   DEALER_STATE         varchar(254)         not null,
   DEALER_ZIP           text          		 not null,
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
   CITY                 text              not null,
   "STATE"              text              not null,
   constraint PK_FAILPLACE primary key (CITY, "STATE")
);

/*==============================================================*/
/* Index: FAILPLACE_PK                                          */
/*==============================================================*/
create unique index FAILPLACE_PK on FailPlace (
CITY,
"STATE"
);

/*==============================================================*/
/* Table: Tire                                                  */
/*==============================================================*/
create table Tire (
   ODINO                integer              not null,
   CMPLID               integer              not null,
   DOT                  varchar(254),
   TIRE_SIZE            varchar(254),
   LOC_OF_TIRE          varchar(254),
   TIRE_FAIL_TYPE       varchar(254),
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
   VIN                  varchar(254),
   MILES                double precision,
   ANTI_BRAKES_YN       boolean,
   CRUISE_CONT_YN       boolean,
   NUM_CYLS             integer,
   DRIVE_TRAIN          varchar(254),
   FUEL_SYS             varchar(254),
   FUEL_TYPE            varchar(254),
   TRANS_TYPE           varchar(254),
   VEH_SPEED            double precision,
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
   add constraint FK_CASE_ASSOCIATI_FAILPLAC foreign key (CITY, "STATE")
      references FailPlace (CITY, "STATE")
      on delete restrict on update restrict;

alter table "Case"
   add constraint FK_CASE_ASSOCIATI_CAR foreign key (MAKETXT, MODELTXT, YEARTXT)
      references Car (MAKETXT, MODELTXT, YEARTXT)
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


Alter Table public.complaints Alter Column "CRASH" TYPE boolean USING "CRASH"::boolean;
Alter Table public.complaints Alter Column "FIRE" TYPE boolean USING "FIRE"::boolean;
Alter Table public.complaints Alter Column "POLICE_RPT_YN" TYPE boolean USING "POLICE_RPT_YN"::boolean;
Alter Table public.complaints Alter Column "ORIG_OWNER_YN" TYPE boolean USING "ORIG_OWNER_YN"::boolean;
Alter Table public.complaints Alter Column "ANTI_BRAKES_YN" TYPE boolean USING "ANTI_BRAKES_YN"::boolean;
Alter Table public.complaints Alter Column "CRUISE_CONT_YN" TYPE boolean USING "CRUISE_CONT_YN"::boolean;
Alter Table public.complaints Alter Column "ORIG_EQUIP_YN" TYPE boolean USING "ORIG_EQUIP_YN"::boolean;
Alter Table public.complaints Alter Column "REPAIRED_YN" TYPE boolean USING "REPAIRED_YN"::boolean;
Alter Table public.complaints Alter Column "VEHICLE_TOWED_YN" TYPE boolean USING "VEHICLE_TOWED_YN"::boolean;
Alter Table public.complaints Alter Column "MEDICAL_ATTN" TYPE boolean USING "MEDICAL_ATTN"::boolean;



INSERT INTO "Case"
SELECT DISTINCT "ODINO", "DEALER_NAME", "DEALER_ZIP", "MAKETXT", "MODELTXT", "YEARTXT", "CITY", "STATE", "CRASH", "FAILDATE", "FIRE", "INJURED",
				"DEATHS", "DATEA", "LDATE", "OCCURENCES", "COMPDESC", "CDESCR", "MEDICAL_ATTN", "POLICE_RPT_YN", "PURCH_DT"
FROM complaints;