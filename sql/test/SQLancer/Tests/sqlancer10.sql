START TRANSACTION;
CREATE TABLE "sys"."t0" ("c0" BOOLEAN NOT NULL,"c2" INTEGER,CONSTRAINT "t0_c0_pkey" PRIMARY KEY ("c0"));
INSERT INTO "sys"."t0" VALUES (true, 0);

CREATE TABLE "sys"."t2" ("c0" DOUBLE NOT NULL,CONSTRAINT "t2_c0_pkey" PRIMARY KEY ("c0"),CONSTRAINT "t2_c0_unique" UNIQUE ("c0"));
COPY 6 RECORDS INTO "sys"."t2" FROM stdin USING DELIMITERS E'\t',E'\n','"';
8
1
-139590671
542699836
0.852979835289385
0.9886505493437159

create view v1(vc0, vc1, vc2, vc3) as ((select 10, 7, 'n', 2 where false)
union (select 2, -0.18, 'a', 2 from t2 as l0t2 join (values (0.23), (-0.24)) as sub0 on false)) with check option;

select 1 from v1, t2, t0 join (select false) as sub0 on true where cast(t0.c0 as clob) between lower(v1.vc0) and v1.vc2;
ROLLBACK;
