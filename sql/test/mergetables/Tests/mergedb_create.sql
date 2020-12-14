-- create a small database with Partitioned data
-- used in sqlsmith testing
START TRANSACTION;
CREATE TABLE R1 ( x integer primary key, y integer, z string);
COPY 4 RECORDS INTO R1 FROM stdin USING DELIMITERS ' ',E'\n';
0 0 hello
1 0 hello
2 1 world
3 1 world

CREATE TABLE R2 ( x integer primary key, y integer, z string);
COPY 4 RECORDS INTO R2 FROM stdin USING DELIMITERS ' ',E'\n';
5 0 hello
6 0 hello
7 1 world
8 1 world

CREATE TABLE R3 ( x integer primary key, y integer, z string);
COPY 4 RECORDS INTO R3 FROM stdin USING DELIMITERS ' ',E'\n';
10 0 hello
11 0 hello
12 1 world
13 1 world

CREATE MERGE TABLE R ( x integer primary key, y integer, z string);
ALTER TABLE R ADD TABLE R1;
ALTER TABLE R ADD TABLE R2;
ALTER TABLE R ADD TABLE R3;

SELECT * FROM R;

CREATE TABLE S1 ( x integer primary key, y integer, z string);
COPY 7 RECORDS INTO S1 FROM stdin USING DELIMITERS ' ',E'\n';
0 0 hello
1 0 hello
2 1 world
3 1 world
4 1 bye
5 0 hello
6 0 hello

CREATE TABLE S2 ( x integer primary key, y integer, z string);
COPY 7 RECORDS INTO S2 FROM stdin USING DELIMITERS ' ',E'\n';
7 1 world
8 1 world
9 1 bye
10 0 hello
11 0 hello
12 1 world
13 1 world

CREATE MERGE TABLE S ( x integer primary key, y integer, z string);
ALTER TABLE S ADD TABLE S1;
ALTER TABLE S ADD TABLE S2;

SELECT * FROM S;

select
  ref_2.y as c0,
  cast(coalesce(ref_2.z,
    ref_2.z) as clob) as c1,
  ref_2.z as c2,
  case when ref_2.y is NULL then subq_0.c0 else subq_0.c0 end
     as c3,
  ref_2.y as c4,
  cast(coalesce(subq_0.c0,
    ref_2.z) as clob) as c5,
  ref_2.x as c6
from
  sys.r2 as ref_2,
  lateral (select
        ref_2.z as c0
      from
        sys.netcdf_vardim as ref_3
      where ref_3.dim_id is NULL) as subq_0
where EXISTS (
  select
      case when false then ref_9.z else ref_9.z end
         as c0,
      subq_2.c5 as c1,
      subq_0.c0 as c2,
      ref_2.z as c3,
      subq_2.c5 as c4
    from
      (select
                ref_2.y as c0,
                ref_4.type as c1,
                subq_0.c0 as c2,
                ref_2.y as c3
              from
                sys.keys as ref_4
              where ref_2.z is NULL) as subq_1
          left join (select
                ref_5.gr_name as c0,
                ref_5.att_name as c1,
                ref_2.z as c2,
                subq_0.c0 as c3,
                44 as c4,
                subq_0.c0 as c5,
                ref_2.y as c6,
                ref_2.x as c7,
                ref_2.y as c8
              from
                sys.netcdf_attrs as ref_5
              where false) as subq_2
          on (subq_1.c2 = subq_2.c2 )
        right join sys.r as ref_9
        on (subq_2.c4 = ref_9.x )
    where ref_9.x is not NULL)
limit 64;

select
  cast(coalesce(cast(coalesce(subq_0.c0,
      subq_0.c0) as clob),
    subq_0.c0) as clob) as c0,
  subq_0.c3 as c1,
  subq_0.c1 as c2,
  subq_0.c2 as c3,
  subq_0.c1 as c4,
  subq_0.c2 as c5,
  subq_0.c1 as c6,
  subq_0.c2 as c7,
  subq_0.c0 as c8,
  subq_0.c2 as c9,
  subq_0.c3 as c10
from
  (select
        ref_0.z as c0,
        ref_0.x as c1,
        case when false then ref_0.x else ref_0.x end
           as c2,
        case when EXISTS (
            select
                ref_0.x as c0,
                ref_1.type as c1,
                ref_0.y as c2,
                ref_0.y as c3,
                44 as c4,
                ref_0.z as c5,
                ref_0.y as c6,
                ref_1.id as c7
              from
                sys.tables as ref_1
              where EXISTS (
                select

                    ref_0.y as c0,
                    ref_2.login_id as c1,
                    ref_2.login_id as c2
                  from
                    sys.user_role as ref_2
                  where ref_0.x is NULL)) then ref_0.y else ref_0.y end
           as c3
      from
        sys.r2 as ref_0
      where ref_0.y is NULL
      limit 72) as subq_0
where case when 86 is NULL then subq_0.c1 else subq_0.c1 end
     is NULL;

select  
  cast(nullif(subq_0.c3,
    subq_0.c3) as int) as c0
from 
  (select  
        ref_0.x as c0, 
        ref_0.y as c1, 
        ref_0.z as c2, 
        ref_0.x as c3, 
        ref_0.y as c4
      from 
        sys.s2 as ref_0
      where (ref_0.z is NULL) 
        and (EXISTS (
          select  
              ref_1.role_id as c0, 
              ref_0.z as c1, 
              ref_1.role_id as c2, 
              ref_1.role_id as c3, 
              ref_0.z as c4, 
              ref_1.login_id as c5, 
              ref_0.z as c6, 
              ref_0.y as c7
            from 
              sys.user_role as ref_1
            where (EXISTS (
                select  
                    ref_0.y as c0, 
                    ref_1.login_id as c1, 
                    ref_0.x as c2, 
                    ref_0.x as c3, 
                    ref_0.x as c4, 
                    77 as c5, 
                    ref_1.role_id as c6, 
                    ref_1.login_id as c7, 
                    ref_0.x as c8, 
                    ref_0.x as c9, 
                    ref_2.name as c10, 
                    ref_0.y as c11, 
                    ref_2.file_id as c12, 
                    ref_2.vartype as c13
                  from 
                    sys.netcdf_vars as ref_2
                  where ref_0.x is not NULL)) 
              or (ref_0.y is NULL)))
      limit 109) as subq_0
where (EXISTS (
    select  
        ref_3.z as c0, 
        subq_0.c2 as c1, 
        ref_3.z as c2, 
        ref_3.x as c3, 
        100 as c4, 
        ref_3.x as c5, 
        ref_3.z as c6
      from 
        sys.r as ref_3
      where ref_3.x is not NULL)) 
  or (subq_0.c2 is NULL)
limit 141;

-- simplified version 
select  ref_0.x from sys.s2 as ref_0 
 where 	EXISTS (
          select ref_1.role_id as c0 from sys.user_role as ref_1 
	   where (EXISTS ( select ref_0.y as c0 from sys.netcdf_vars)) or (ref_0.y is NULL)
	);

select
  ref_11.access as c0,
  ref_12.revsorted as c1
from
  sys._tables as ref_11
    inner join sys.statistics as ref_12
    on (((false)
          or (ref_11.id is NULL))
        or (EXISTS (
          select
              ref_13.dim_id as c0,
              ref_11.query as c1
            from
              sys.netcdf_vardim as ref_13,
              lateral (select
                    ref_11.access as c0,
                    ref_13.var_id as c1,
                    ref_11.commit_action as c2,
                    ref_11.system as c3
                  from
                    sys.r2 as ref_14
                  where true) as subq_0
            where ref_13.var_id is not NULL)))
where true;

select
   cast(coalesce(ref_8.name,
     cast(nullif(ref_7.column,
       cast(null as clob)) as clob)) as clob) as c0,
   ref_10.function_id as c1,
   cast(coalesce(ref_6.action,
     ref_6.id) as int) as c2
from
   sys.types as ref_0
     left join sys.netcdf_attrs as ref_1
       inner join sys.keys as ref_6
         inner join sys.storagemodelinput as ref_7
             left join sys.optimizers as ref_8
               inner join sys.users as ref_9
                 right join sys.systemfunctions as ref_10
                 on (ref_9.default_schema = ref_10.function_id )
               on (true)
             on (ref_7.typewidth = ref_9.default_schema )
           inner join sys.systemfunctions as ref_11
           on (ref_9.default_schema = ref_11.function_id )
         on (ref_6.action is NULL)
       on (ref_6.action is not NULL)
     on (ref_0.radix = ref_11.function_id )
where EXISTS (
   select
       case when ref_8.name is NULL then ref_7.count else ref_7.count end
          as c0
     from
       (select
                 ref_8.def as c0,
                 ref_9.fullname as c1
               from
                 sys.r2 as ref_12
               where ref_11.function_id is NULL
               limit 79) as subq_0
           left join tmp._tables as ref_13
             inner join sys.netcdf_vardim as ref_14
             on (ref_14.dimpos is NULL)
           on ((ref_1.att_type is not NULL)
               or (ref_0.id is NULL))
         inner join sys.netcdf_vardim as ref_15
         on (ref_10.function_id is not NULL)
     where ref_0.systemname is NULL)
limit 77;

select
  64 as c0,
  ref_12.y as c1,
  ref_12.y as c2,
  case when true then ref_12.z else ref_12.z end
     as c3,
  cast(coalesce(ref_12.b,
    ref_12.b) as boolean) as c4,
  ref_12.x as c5
from
  sys.s as ref_12
where EXISTS (
  select
      ref_17.keyword as c0,
      subq_0.c5 as c1,
      ref_12.x as c2,
      subq_0.c1 as c3,
      ref_17.keyword as c4,
      subq_0.c6 as c5,
      ref_17.keyword as c6,
      subq_0.c9 as c7,
      ref_12.z as c8,
      ref_12.y as c9,
      23 as c10,
      subq_0.c1 as c11
    from
      sys.keywords as ref_17
        left join (select
              ref_19.y as c0,
              ref_12.x as c1,
              ref_19.z as c2,
              ref_19.y as c3,
              ref_12.z as c4,
              ref_12.y as c5,
              ref_19.y as c6,
              24 as c7,
              ref_12.b as c8,
              ref_12.z as c9
            from
              sys.r2 as ref_19
            where false
            limit 79) as subq_0
        on ((subq_0.c4 is NULL)
            or (subq_0.c2 is NULL))
    where false)
limit 123;

ROLLBACK;
