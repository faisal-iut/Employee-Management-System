
create table salary_type(
type_id number(4,0),
type_name varchar2(10),
basic number(10,5),
housing number(10,5),
transport number(10,5),
constraints pk_salary_type primary key(type_id)
);

create table tax_type(
tax_type_id number(4,0),
type_name varchar2(10),
earn_max number(20,5),
earn_low number(20,5),
percent number(10,5),
constraints pk_tax_type primary key(tax_type_id)
);

create table citizen_sal(
citizen_id number(20,10),
dob date,
sal_type number(4,0),
joining_date date,
resigning_date date,
constraints pk_cit_sal primary key(citizen_id),
constraints fk_salary_type foreign key (sal_type) references salary_type on delete cascade
);



create table salary_transaction(
salary_trans_id varchar2(30),
citizen_id number(20,10),
transaction_salary number(10,3),
salary_month date,
sal_trans_time date,
constraints pk_sal_trans_id primary key(salary_trans_id),
constraints fk_citizen_sal foreign key (citizen_id) references citizen_sal on delete cascade
);



create table tax_transaction(
tax_trans_id varchar2(30),
citizen_id number(20,10),
tax_year varchar2(10),
total_earn number(20,3),
transaction_tax number(20,3),
tax_trans_time date,
constraints pk_tax_trans_id primary key(tax_trans_id),
constraints fk_citizen_tax foreign key (citizen_id) references citizen_sal on delete cascade
);




insert into citizen_sal values(100001,date '1990-1-11',1,date '2015-1-1','','jisan');
insert into citizen_sal values(100002,date '1990-2-10',2,date '2015-1-2','','faisal');
insert into citizen_sal values(100003,date '1980-1-11',3,date '2015-2-11','','ak');
insert into citizen_sal values(100004,date '1989-1-1',4,date '2015-2-1','','jk');
insert into citizen_sal values(100005,date '1990-1-6',1,date '2015-2-4','','tk');
insert into citizen_sal values(100006,date '1991-1-5',2,date '2015-3-11','','mk');
insert into citizen_sal values(100007,date '1985-5-11',3,date '2015-1-10','','ck');
insert into citizen_sal values(100008,date '1987-1-1',4,date '2015-1-23','','ljh');
insert into citizen_sal values(100009,date '1990-3-12',2,date '2015-1-1','','arup');
insert into citizen_sal values(100010,date '1990-4-3',1,date '2015-3-3','','sajal');
insert into citizen_sal values(100011,date '1990-1-2',1,date '2015-1-11','','kaisar');








--============================================================================
----insert into salary type

CREATE  OR REPLACE PROCEDURE salary_type_insert(typid IN NUMBER,bas in number)
AS 

typname varchar2(10);
house number;
trans number;
BEGIN

typname:='s'||to_char(typid);



house:=(bas*50)/100;
trans:=(bas*10)/100;

dbms_output.put_line(typid || ' ' || typname || ' ' || bas || ' ' || house  || ' ' || trans );
 

INSERT INTO salary_type (type_id,type_name,basic,housing,transport)
        VALUES (typid,typname,bas,house,trans);


END;
/


-----------
BEGIN
salary_type_insert(1,10000);
salary_type_insert(2,15000);
salary_type_insert(3,20000);
salary_type_insert(4,30000);

END;
/
-------------------==========================================================================
----insert into tax type




CREATE  OR REPLACE PROCEDURE tax_type_insert(typid IN NUMBER,ermax in number,erlow in number,pers in number)
AS 

typname varchar2(10);
BEGIN

typname:='t'||to_char(typid);


INSERT INTO tax_type (tax_type_id,type_name,earn_max,earn_low,percent)
        VALUES (typid,typname,ermax,erlow,pers);


END;
/

begin

tax_type_insert(1,40000,0,0);
tax_type_insert(2,100000,40001,5);
tax_type_insert(3,400000,100001,10);
tax_type_insert(4,1000000,400001,20);


end;
/


-------------------==============================================================================
------------ID GENERATE


DECLARE
id varchar2(30);
BEGIN

id:=id_generator(100001,'sal',to_date('150303023232','yymmddhhmiss'));

dbms_output.put_line(id);
END;
/


create or replace  function id_generator(citid in number,trans_type in varchar2,sys date)
return varchar2
as 
id varchar2(30);
temporary number;
trans_time date;
begin


		id:=trans_type||to_char(sys,'yymmddhhmiss')||to_char(citid);

return id;
end;
/

--=================================================================================================================


--==============================   SALARY TRANSACTION PART  =======================================================




----====================================================================================
-----PASS ID , TRANSACTION TIME, MONTH FOR SALARY


CREATE  OR REPLACE procedure salary_trans(ctid IN NUMBER,sal_mon date,trans_time date)
AS 


total_row number(4,0);

BEGIN

select count(citizen_id) into total_row
from salary_transaction
where citizen_id=ctid
and salary_month=sal_mon;

dbms_output.put_line(total_row);

if total_row=0 then now_insert(ctid,sal_mon,trans_time);
else dbms_output.put_line('invalid');

end if;


END;
/


--=====================================================================
-----AFTER CHECKING ABOVE INSERT AND UPDATE VALUE HERE


CREATE  OR REPLACE procedure now_insert(ctid IN NUMBER,sal_mon date,trans_time date)--
as
id varchar2(30);
bas number;
house number;

joini date;
resigne date;
month date;
sal number;
transp number;
tot_sal number;
trans_sal number(10,2);
cur number(4,0);
join_diff number(4,0);
last_diff number(4,0);
total_row number(4,0);
join_month number(4,0);
give_month number(4,0);
cur_month number(4,0);
join_day number(4,0);
give_day number(4,0);
cur_day number(4,0);
join_exact number(4,0);
cur_exact number(4,0);
--trans_time date;----
k date;
t varchar2(5);
s date;

begin
--select sysdate into trans_time from dual;---
dbms_output.put_line(ctid  || ' ' || trans_time || ' ' || sal_mon);

SELECT sal_type,joining_date,resigning_date into sal,joini,resigne
FROM citizen_sal
WHERE citizen_id=ctid;
dbms_output.put_line(sal  || ' ' || joini || ' ' || resigne);

SELECT basic,housing,transport into bas,house,transp
FROM salary_type
WHERE type_id=sal;
dbms_output.put_line(bas  || ' ' || house || ' ' || transp);






id:=id_generator(ctid,'sal',trans_time);
tot_sal:=bas+house+transp;

SELECT LAST_DAY(to_date(sal_mon,'yy-mm-dd')) into k FROM DUAL;

	t:=to_char(k,'dd');
    give_day:=TO_NUMBER(t);

    t:=to_char(k,'mm');
    give_month:=TO_NUMBER(t);

SELECT LAST_DAY(to_date(joini,'yy-mm-dd')) into k FROM DUAL;

	t:=to_char(k,'dd');
    join_day:=TO_NUMBER(t);

    t:=to_char(k,'mm');
    join_month:=TO_NUMBER(t);

     t:=to_char(joini,'dd');
    join_exact:=TO_NUMBER(t);

 SELECT LAST_DAY(to_date(trans_time,'yy-mm-dd')) into k FROM DUAL;

	t:=to_char(k,'dd');
    cur_day:=TO_NUMBER(t);

    t:=to_char(k,'mm');
    cur_month:=TO_NUMBER(t); 

    t:=to_char(trans_time,'dd');
    cur_exact:=TO_NUMBER(t);      


   if(give_month=join_month) then  trans_sal:=(tot_sal*(join_day-join_exact +1))/30;
    elsif(give_month!=join_month and give_month!=cur_month) then  trans_sal:=(tot_sal*(give_day))/30;
    elsif(give_month!=join_month and give_month=cur_month) then  trans_sal:=(tot_sal*(cur_exact))/30;
   end if;

     



dbms_output.put_line(join_month);

dbms_output.put_line(give_month);

dbms_output.put_line(cur_month);

dbms_output.put_line(trans_sal);

if(cur_month>=give_month) then


--update citizen_sal set resigning_date=resigne where citizen_id=ctid;
    
dbms_output.put_line(id || ' ' || ctid  || ' ' || trans_sal || ' ' || sal_mon);

INSERT INTO salary_transaction (salary_trans_id,citizen_id,transaction_salary,salary_month,sal_trans_time)
      VALUES (id,ctid,trans_sal,sal_mon,trans_time);
 
else dbms_output.put_line('invalid');
end if;

end;
/




begin
salary_trans(100001,to_date('15-01','yy-mm'),to_date('15-02-01','yy-mm-dd'));
end;
/

select * from salary_transaction;



--===================================================================



--=====================================================================
--GIVE SALARY TO ALL CITIZEN FOR A SPECIFIC MONTH

create or replace procedure give_this_month_sal(transdate in date,sal_month date)

	as
    loop_count number(4,0);
   
    c_id citizen_sal.citizen_id%type;

    cursor total_cit is
    select citizen_id 
    from citizen_sal 
    where (joining_date<transdate and RESIGNING_DATE is null) or (joining_date<transdate and JOINING_DATE>RESIGNING_DATE);
	begin
    open total_cit;

    loop
    fetch total_cit into c_id;
    exit when total_cit%notfound;
    salary_trans(c_id,sal_month,transdate);
    end loop;

    close total_cit;

	end;
	/
  


	begin
   
    give_this_month_sal(to_date('15-02-01','yy-mm-dd'),to_date('15-01','yy-mm'));

    end;
    /
    
  
 --=========================================================================================


--==============================   TAX TRANSACTION PART  ==========================================================



-----CALCULATING TAX FOR A ID.....CALLED FROM YEARLY_TAX

create or replace function tax_calculate(ear_amount in number)
	return number
  	
  	as
  	

  	t_low tax_type.earn_low %type;
    t_max tax_type.earn_max %type;
    t_per tax_type.percent%type;
    total_tax number(20,3);

    
    cursor tax_tp is
    select earn_max,earn_low,percent from tax_type ;
  	
  	begin

    open tax_tp;
  	loop
  	fetch tax_tp into t_max,t_low,t_per;
    if(ear_amount>=t_low and ear_amount<=t_max)
    then total_tax:=(t_per*ear_amount)/100;
     dbms_output.put_line(t_per);
    end if;
    if(ear_amount<=40000)then total_tax:=0;
    end if;
    exit when tax_tp%notfound;
  	end loop;
    close tax_tp;
     
     dbms_output.put_line(total_tax);

     return total_tax;
  	
  	end;
  	/
    
    
  	/
    

--===================================================================================================================
-----YEARLY TAX INSERT INTO TABLE FOR A SPECIFIC ID    

    begin
    yearly_tax(100001,to_date('2016-01-01','yyyy-mm-dd'),to_date('2015-12-31','yyyy-mm-dd'));

    end;
    /




   
    create or replace procedure yearly_tax(ctid in number,tax_trans_time in date,tax_trans_year in date)
    	as
    	year varchar2(30);
    	id varchar2(30);
    	tax_amount number(20,3);
    	ear_amount number(20,3);
    	
        tax_year_st varchar2(20);
        tax_year_end varchar2(20);


    	begin


        year:=to_char(tax_trans_year,'yyyy');
    	id:=id_generator(ctid,'tax',tax_trans_time);

    	  tax_year_st:=year||'-01-01';
          tax_year_end:=year||'-12-31';

    select sum(transaction_salary) into ear_amount
  	from salary_transaction 
  	where citizen_id=ctid
  	and SALARY_MONTH>=TO_DATE(tax_year_st,'yy-mm-dd')and SALARY_MONTH<=TO_DATE(tax_year_end,'yy-mm-dd');

  	dbms_output.put_line(ear_amount);

  	  tax_amount:=tax_calculate(ear_amount);

  	if ear_amount!=0 then  

    delete from tax_transaction where tax_year=year and citizen_id=ctid;  
    INSERT INTO tax_transaction (tax_trans_id,citizen_id,tax_year,total_earn,transaction_tax,tax_trans_time)
      VALUES (id,ctid,year,ear_amount,tax_amount,tax_trans_time);
    
     end if;
  
    	end;
    	/


---=======================================================================================================
-----===CALCULATE AND INSERT TAX FOR ALL CITIZEN..

    create or replace procedure give_this_year_tax(tax_trans_time in date,tax_trans_year in date)

	as
    
   
    c_id citizen_sal.citizen_id%type;

    cursor total_cit is
    select citizen_id 
    from citizen_sal ;
   
	begin
    open total_cit;

    loop
    fetch total_cit into c_id;
    exit when total_cit%notfound;
    yearly_tax(c_id,tax_trans_time,tax_trans_year);
    end loop;

    close total_cit;

	end;
	/


      begin
    give_this_year_tax(to_date('2016-01-01','yyyy-mm-dd'),to_date('2015-12-31','yyyy-mm-dd'));

    end;
    /

--======================================================================================================================

------ID SEQUENCE TRIGGER

CREATE SEQUENCE  id_sequence
 START WITH     100001
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;
 
CREATE OR REPLACE TRIGGER new_id_sequence_trigger
BEFORE INSERT ON citizen_sal
FOR EACH ROW
BEGIN
:NEW.citizen_id := id_sequence.NEXTVAL;
:NEW.joining_date:=sysdate;
:NEW.resigning_date:=NULL;
END;
/

----------------------------------------------------------------
---------------ID INPUT PROCEDURE


create or replace procedure id_insert(name in varchar2,db in date,sal_sch in number)
	as
	begin
	INSERT INTO citizen_sal (citizen_id,dob,sal_type,joining_date,resigning_date,name)
      VALUES ('00',db,sal_sch,'','',name);


	end;
	/



begin
id_insert('asraf',to_date('1967-01-01','yyyy-mm-dd'),1);
end;

/