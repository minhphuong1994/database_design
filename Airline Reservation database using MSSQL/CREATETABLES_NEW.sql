/*CREATE DATABASE AIRWAY_BOOKING;
USE MASTER;
GO
DROP DATABASE AIRWAY_BOOKING;
GO
*/
USE AIRWAY_BOOKING;

CREATE TABLE AIRPORT(
	airport_id CHAR(3) NOT NULL,
	name varchar(50) NOT NULL,
	country varchar(20) NOT NULL,
	city varchar(20) NOT NULL,
	description varchar(10)
	CONSTRAINT AIRPORT_airport_id_pk PRIMARY KEY (airport_id)
	);


CREATE TABLE TERMINAL(
	terminal_id smallint NOT NULL,
	airport_id char(3) NOT NULL,
	terminal_name char(3) NOT NULL,
	description varchar(10),
	CONSTRAINT TERMINAL_terminal_id_pk PRIMARY KEY (terminal_id), 
	CONSTRAINT TERMINAL_airport_id_fk FOREIGN KEY (airport_id) 
	REFERENCES AIRPORT(airport_id)
	);


CREATE TABLE GATE(
	gate_id smallint NOT NULL,
	terminal_id smallint NOT NULL,	
	gate_name varchar(10) NOT NULL,
	CONSTRAINT GATE_gate_id_pk PRIMARY KEY (gate_id),
	CONSTRAINT GATE_terminal_id_fk FOREIGN KEY (terminal_id) 
	REFERENCES TERMINAL(terminal_id)
	);


CREATE TABLE AIRLINE(
	airline_id CHAR(2) NOT NULL,
	airline_name varchar(50) NOT NULL,
	description varchar(50),
	CONSTRAINT AIRLINE_airline_id_pk PRIMARY KEY (airline_id)
	);


CREATE TABLE AIRCRAFT(
	aircraft_id varchar(10) NOT NULL,
	airline_id char(2) NOT NULL,
	aircraft_name varchar(50) NOT NULL,
	number_eco_seat smallint NOT NULL,
	number_bus_seat smallint NOT NULL,
	description varchar(50),
	CONSTRAINT AIRCRAFT_aircraft_id_pk PRIMARY KEY (aircraft_id),
	CONSTRAINT AIRCREAFT_airline_id_fk FOREIGN KEY (airline_id) 
	REFERENCES AIRLINE(airline_id)	
	);


CREATE TABLE ROUTE(
	route_id varchar(10) NOT NULL,
	source_airport_id char(3) NOT NULL,
	destination_airport_id char(3) NOT NULL,
	CONSTRAINT ROUTE_route_id_pk PRIMARY KEY (route_id),
	CONSTRAINT ROUTE_source_airport_id_fk FOREIGN KEY (source_airport_id) 
	REFERENCES AIRPORT(airport_id),
	CONSTRAINT ROUTE_destination_airport_id_fk FOREIGN KEY (destination_airport_id) 
	REFERENCES AIRPORT(airport_id)	
	);


CREATE TABLE ROUTE_GROUP(
	route_group_id varchar(10) NOT NULL,
	source_airport_id char(3) NOT NULL,
	destination_airport_id char(3) NOT NULL,
	CONSTRAINT ROUTE_GROUP_route_group_id_pk PRIMARY KEY (route_group_id),
	CONSTRAINT ROUTE_GROUP_source_airport_id_fk FOREIGN KEY (source_airport_id) 
	REFERENCES AIRPORT(airport_id),
	CONSTRAINT ROUTE_GROUP_destination_airport_id_fk FOREIGN KEY (destination_airport_id) 
	REFERENCES AIRPORT(airport_id)
	);


CREATE TABLE ROUTE_GROUP_DETAIL(
	route_id varchar(10) NOT NULL,
	route_group_id varchar(10) NOT NULL,
	CONSTRAINT ROUTE_GROUP_DETAIL_route_group_id_pk PRIMARY KEY (route_group_id,route_id),
	CONSTRAINT ROUTE_GROUP_DETAIL_route_group_id_fk FOREIGN KEY (route_group_id) 
	REFERENCES ROUTE_GROUP(route_group_id),
	CONSTRAINT ROUTE_GROUP_DETAIL_route_id_fk FOREIGN KEY (route_id) 
	REFERENCES ROUTE(route_id)
	);


CREATE TABLE FLIGHT(
	flight_id varchar(10) NOT NULL,
	aircraft_id varchar(10) NOT NULL,
	route_id varchar(10) NOT NULL,
	gate_id smallint NOT NULL,	
	depart_date datetime NOT NULL,	
	arrive_date datetime NOT NULL,
	eco_class_price float(15) NOT NULL,
	bus_class_price float(15) NOT NULL,
	status varchar(15) NOT NULL,
	CONSTRAINT FLIGHT_flight_id_pk PRIMARY KEY (flight_id),
	CONSTRAINT FLIGHT_aircraft_id_fk FOREIGN KEY (aircraft_id) 
	REFERENCES AIRCRAFT(aircraft_id),	
	CONSTRAINT FLIGHT_gate_id_fk FOREIGN KEY (gate_id) 
	REFERENCES GATE(gate_id),	
	CONSTRAINT FLIGHT_route_id_fk FOREIGN KEY (route_id) 
	REFERENCES ROUTE(route_id)	
	);


CREATE TABLE PASSENGER_INFO(
	passport_number varchar(20) NOT NULL,
	name varchar(30) NOT NULL,
	phone char(10) NOT NULL,
	date_of_birth date NOT NULL,
	address varchar(50) NOT NULL,
	email varchar(30) NOT NULL,
	CONSTRAINT PASSENGER_INFO_passport_number_pk PRIMARY KEY (passport_number),
	);


CREATE TABLE PASSENGER(
	passenger_id varchar(20) NOT NULL,
	passport_number varchar(20) NOT NULL,
	CONSTRAINT PASSENGER_passenger_id_pk PRIMARY KEY (passenger_id),
	CONSTRAINT PASSENGER_passport_number_fk FOREIGN KEY (passport_number) 
	REFERENCES PASSENGER_INFO(passport_number)	
	);


CREATE TABLE PAYMENT_ACCOUNT(
	card_id varchar(20) NOT NULL,
	name varchar(30) NOT NULL DEFAULT 'NONE',
	password smallint NOT NULL,
	expire_date date NOT NULL,
	CONSTRAINT PAYMENT_ACCOUNT_card_id_pk PRIMARY KEY (card_id)
	);


CREATE TABLE BOOKING(
	booking_id varchar(20) NOT NULL,
	card_id varchar(20) NOT NULL,
	status varchar(10) NOT NULL,
	discount float(4) NOT NULL DEFAULT 0.0,
	issued_date datetime NOT NULL,
	CONSTRAINT BOOKING_booking_id_pk PRIMARY KEY(booking_id),
	CONSTRAINT BOOKING_card_id_fk FOREIGN KEY (card_id)
	REFERENCES PAYMENT_ACCOUNT(card_id)
	);


CREATE TABLE TICKET(
	ticket_id varchar(20) NOT NULL,
	booking_id varchar(20) NOT NULL,
	passenger_id varchar(20) NOT NULL,
	flight_id varchar(10) NOT NULL,
	class varchar(5) NOT NULL DEFAULT 'ECO',
	seat_number varchar(3),
	status varchar(10) NOT NULL,
	issued_date datetime NOT NULL
	CONSTRAINT TICKET_ticket_id_pk PRIMARY KEY(ticket_id),
	CONSTRAINT TICKET_booking_id_fk FOREIGN KEY(booking_id)
	REFERENCES BOOKING(booking_id),
	CONSTRAINT TICKET_passenger_id_fk FOREIGN KEY(passenger_id)
	REFERENCES PASSENGER(passenger_id),
	CONSTRAINT TICKET_flight_id_fk FOREIGN KEY(flight_id)
	REFERENCES FLIGHT(flight_id)
	);


