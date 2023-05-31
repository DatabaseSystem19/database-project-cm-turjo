--1.check basic info and store them into variables and print them

SET SERVEROUTPUT ON

DECLARE

name1 CUSTOMER_DETAILS.name%TYPE;

EMAIL1 CUSTOMER_DETAILS.EMAIL_ID%TYPE;

MOBILE1 CUSTOMER_DETAILS.MOBILE%TYPE;

BEGIN

select name, email_id, mobile into name1,email1,mobile1 from customer_details where nid =101136854;

dbms_output.put_line('NAME IS: '||name1 ||' Mobile is: '||MOBILE1||' email is : '||email1);

end;
/



--2.Checking Rowtype and fetching data from table

declare

insu dest_DETAILS%rowtype;

begin

select dest_id, dest_name,dest_address into insu.dest_id, insu.dest_name ,insu.dest_address from dest_details where dest_id=1004;
dbms_output.put_line('Dest ID: '||insu.dest_id||' DEST_Name : '||insu.dest_name||' DEST_Address : '||insu.DEST_ADDRESS);
end;
/


--3.Check Status of attribute using case statement


declare
   v_nid  customer_details.nid%TYPE;
   v_name customer_details.name%TYPE;
   v_status VARCHAR2(20);
begin
   -- Set the customer NID and retrieve the customer name
   v_nid := 101136854;
   
   SELECT name INTO v_name
   FROM customer_details
   WHERE nid = v_nid;
   
   -- Use a case statement to determine the customer status
   CASE v_nid
      WHEN 101136285 THEN
         v_status := 'Active';
      WHEN 102567892 THEN
         v_status := 'Inactive';
      WHEN 103895742 THEN
         v_status := 'Active';
      ELSE
         v_status := 'Unknown';
   END CASE;
   
  
   dbms_output.put_line('Customer Name: ' || v_name);
   dbms_output.put_line('Customer Status: ' || v_status);
   
END;
/



--4.Getting car model name using cursor and %found 


declare

cursor car_cursor is 
select model_name from car_details;

v_model_name car_details.model_name%type;

begin

open car_cursor;

fetch car_cursor into v_model_name;

if car_cursor%found then
dbms_output.put_line('Car Model Name: '||v_model_name);
else
dbms_output.put_line('No Customer Found.');

end if;
close car_cursor;
end;
/

--5 getting car details using contraints and loops


CREATE OR REPLACE PROCEDURE DISPLAY as

 v_car car_details%rowtype;

begin

for car_rec in(select * from car_details)
loop
v_car.reg_no:=car_rec.reg_no;

v_car.engine_no:=car_rec.engine_no;
v_car.model_name:=car_rec.model_name;
v_car.model_year:=car_rec.model_year;
v_car.mileage:=car_rec.mileage;
v_car.condition:=car_rec.condition;

if v_car.model_year>2010 then
      dbms_output.put_line('Registration Number: ' || v_car.reg_no);
      dbms_output.put_line('Engine Number: ' || v_car.engine_no);
      dbms_output.put_line('Model Name: ' || v_car.model_name);
      dbms_output.put_line('Model Year: ' || v_car.model_year);
      
   end if;
   end loop;
   end;
 /
 
 begin
 display;
 end;
 /


--6.Using function to check which has maximum due amount


create or replace function get_name(var1 in number) return varchar2 as

value customer_details.name%type;

begin

select name into value from customer_details join booking_details using(nid) where booking_details.paid_amount =var1;


return value;

end;

/

declare
name_value varchar2(100);


begin
name_value:=get_name(9000);

dbms_output.put_line('The Name is: '|| name_value );

end;
/



--7 Using array to display all coverage type using loop



declare 

counter number;
coverage INS_DETAILS.COVERAGE_TYPE%type;

type namearray is varray(10) of ins_details.coverage_type%type;

a_name namearray:=namearray();


begin

counter:=1;

for x in 4001..4010

loop
select coverage_type into coverage from INS_DETAILS where ins_code=x;
a_name.extend();
a_name(counter):=coverage;
counter:=counter+1;

end loop;

counter:=1;

while counter<=a_name.count

loop

dbms_output.put_line(a_name(counter));

counter:=counter+1;

end loop;
end;
/

--8 using without extend function



declare 

counter number;
coverage INS_DETAILS.COVERAGE_TYPE%type;

type namearray is varray(10) of ins_details.coverage_type%type;

a_name namearray:=namearray('ins_details 1','ins_details 2','ins_details 3','ins_details 4','ins_details 5','ins_details 6','ins_details 7','ins_details 8','ins_details 9','ins_details 10');


begin

counter:=1;

for x in 4001..4010

loop
select coverage_type into coverage from INS_DETAILS where ins_code=x;

a_name(counter):=coverage;
counter:=counter+1;

end loop;

counter:=1;

while counter<=a_name.count

loop

dbms_output.put_line(a_name(counter));

counter:=counter+1;

end loop;
end;
/
   

