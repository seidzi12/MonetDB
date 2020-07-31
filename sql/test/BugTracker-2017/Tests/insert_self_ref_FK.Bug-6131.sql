CREATE TABLE test101(
  A INT NOT NULL PRIMARY KEY,
  B INT NOT NULL,
  C INT NOT NULL,
  CONSTRAINT "fC" FOREIGN KEY (C) REFERENCES test101(A)
);

INSERT INTO test101 VALUES (101, 101, 101);
-- INSERT INTO: FOREIGN KEY constraint 'test101.fC' violated


ALTER TABLE test101 ALTER C SET NULL;

INSERT INTO test101 VALUES (100, 100, NULL);

INSERT INTO test101 VALUES (102, 102, 102);
-- INSERT INTO: FOREIGN KEY constraint 'test101.fC' violated

INSERT INTO test101 VALUES (103, 103, 101);

UPDATE test101 SET C = 100 WHERE C IS NULL;

select * from test101;


ALTER TABLE test101 ALTER C SET NOT NULL;

INSERT INTO test101 VALUES (104, 104, 104);
-- INSERT INTO: FOREIGN KEY constraint 'test101.fC' violated
 
DROP TABLE test101;

-- SQLancer just reproduced this bug
CREATE TABLE "sys"."t1" ("c0" DOUBLE,CONSTRAINT "t1_c0_unique" UNIQUE ("c0"),CONSTRAINT "t1_c0_fkey" FOREIGN KEY ("c0") REFERENCES "sys"."t1" ("c0"));
COPY 9 RECORDS INTO "sys"."t1" FROM stdin USING DELIMITERS E'\t',E'\n','"';
0.21248182395969406
0.6307796692265083
2059310235
-6.5457821e+08
0.743704157497456
0.4001718453135127
0.3935743494971655
0.5299192301063729
0.7609386265982908

ROLLBACK;
