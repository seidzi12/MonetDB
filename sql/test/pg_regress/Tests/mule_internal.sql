drop table ��ג�������ђ��;
create table ��ג�������ђ�� (��ђ�� text, �ʬ������������ varchar, ������1A������ char(16));
create index ��ג�������ђ��index1 on ��ג�������ђ�� using btree (��ђ��);
create index ��ג�������ђ��index2 on ��ג�������ђ�� using hash (�ʬ������������);
insert into ��ג�������ђ�� values('������Ԓ�咡������ǒ�������ג�쒥�','���A01���');
insert into ��ג�������ђ�� values('������Ԓ�咡���������钥Ւ����Ò�����','�ʬB10���');
insert into ��ג�������ђ�� values('������Ԓ�咡������ג�풥���钥ޒ��','���Z01���');
--vacuum ��ג�������ђ��;
select * from ��ג�������ђ��;
select * from ��ג�������ђ�� where �ʬ������������ = '���Z01���';
select * from ��ג�������ђ�� where �ʬ������������ ~* '���z01���';
select * from ��ג�������ђ�� where �ʬ������������ like '_Z01_';
select * from ��ג�������ђ�� where �ʬ������������ like '_Z%';
select * from ��ג�������ђ�� where ��ђ�� ~ '������Ԓ�咡����[��ǒ��]';
select * from ��ג�������ђ�� where ��ђ�� ~* '������Ԓ�咡����[��ǒ��]';
select *,character_length(��ђ��) from ��ג�������ђ��;
select *,octet_length(��ђ��) from ��ג�������ђ��;
select *,position('���' in ��ђ��) from ��ג�������ђ��;
select *,substring(��ђ�� from 10 for 4) from ��ג�������ђ��;
drop table ��Ƒ�㑻�������;
create table ��Ƒ�㑻�������(������ text, ��֑����� varchar, ����ע1A char(16));
create index ��Ƒ�㑻�������index1 on ��Ƒ�㑻������� using btree(������);
create index ��Ƒ�㑻�������index2 on ��Ƒ�㑻������� using btree(��֑�����);
insert into ��Ƒ�㑻������� values('����ԑ�ԑʾ���','���A01���');
insert into ��Ƒ�㑻������� values('����ԑͼ���','���B01���');
insert into ��Ƒ�㑻������� values('����ԑ�̑��Ա','���Z01���');
--vacuum ��Ƒ�㑻�������;
select * from ��Ƒ�㑻�������;
select * from ��Ƒ�㑻������� where ��֑����� = '���Z01���';
select * from ��Ƒ�㑻������� where ��֑����� ~* '���z01���';
select * from ��Ƒ�㑻������� where ��֑����� like '_Z01_';
select * from ��Ƒ�㑻������� where ��֑����� like '_Z%';
select * from ��Ƒ�㑻������� where ������ ~ '�����[��ԑͼ]';
select * from ��Ƒ�㑻������� where ������ ~* '�����[��ԑͼ]';
select *,character_length(������) from ��Ƒ�㑻�������;
select *,octet_length(������) from ��Ƒ�㑻�������;
select *,position('���' in ������) from ��Ƒ�㑻�������;
select *,substring(������ from 3 for 4) from ��Ƒ�㑻�������;
drop table �ͪ�ߩ�Ѧ��듾�;
create table �ͪ�ߩ�Ѧ��듾� (��듾� text, ��׾��ړ�� varchar, ����1A��󓱸 char(16));
create index �ͪ�ߩ�Ѧ��듾�index1 on �ͪ�ߩ�Ѧ��듾� using btree (��듾�);
create index �ͪ�ߩ�Ѧ��듾�index2 on �ͪ�ߩ�Ѧ��듾� using hash (��׾��ړ��);
insert into �ͪ�ߩ�Ѧ��듾� values('��ēǻ��͓�𓽺��Ó�����', '�ѦA01�߾');
insert into �ͪ�ߩ�Ѧ��듾� values('��ēǻ��͓�ד����ȓ��', '���B10���');
insert into �ͪ�ߩ�Ѧ��듾� values('��ēǻ��͓����Γ�ד�����', '���Z01���');
--vacuum �ͪ�ߩ�Ѧ��듾�;
select * from �ͪ�ߩ�Ѧ��듾�;
select * from �ͪ�ߩ�Ѧ��듾� where ��׾��ړ�� = '���Z01���';
select * from �ͪ�ߩ�Ѧ��듾� where ��׾��ړ�� ~* '���z01���';
select * from �ͪ�ߩ�Ѧ��듾� where ��׾��ړ�� like '_Z01_';
select * from �ͪ�ߩ�Ѧ��듾� where ��׾��ړ�� like '_Z%';
select * from �ͪ�ߩ�Ѧ��듾� where ��듾� ~ '��ēǻ���[����]';
select * from �ͪ�ߩ�Ѧ��듾� where ��듾� ~* '��ēǻ���[����]';
select *,character_length(��듾�) from �ͪ�ߩ�Ѧ��듾�;
select *,octet_length(��듾�) from �ͪ�ߩ�Ѧ��듾�;
select *,position('���' in ��듾�) from �ͪ�ߩ�Ѧ��듾�;
select *,substring(��듾� from 3 for 4) from �ͪ�ߩ�Ѧ��듾�;
drop table test;
create table test (t text);
insert into test values('ENGLISH');
insert into test values('FRAN��AIS');
insert into test values('ESPA��OL');
insert into test values('��SLENSKA');
insert into test values('ENGLISH FRAN��AIS ESPA��OL ��SLENSKA');
--vacuum test;
select * from test;
select * from test where t = 'ESPA��OL';
select * from test where t ~* 'espa��ol';
select *,character_length(t) from test;
select *,octet_length(t) from test;
select *,position('L' in t) from test;
select *,substring(t from 3 for 4) from test;
