USE AIRWAY_BOOKING;


/*Q1 Data entry into tables that you have created.*/
SELECT * FROM AIRCRAFT;
SELECT * FROM AIRLINE;
SELECT * FROM BOOKING;
SELECT * FROM FLIGHT;
SELECT * FROM GATE;
SELECT * FROM PASSENGER;
SELECT * FROM PASSENGER_INFO;
SELECT * FROM PAYMENT_ACCOUNT;
SELECT * FROM ROUTE;
SELECT * FROM ROUTE_GROUP;
SELECT * FROM ROUTE_GROUP_DETAIL;
SELECT * FROM TERMINAL;
SELECT * FROM TICKET;

/*Q2 Travel history of a specific passenger*/
/*Performing: All flights that passenger_id 000002 has flied*/
SELECT p.passenger_id, T.flight_id
FROM PASSENGER AS P INNER JOIN TICKET AS T ON P.passenger_id = T.passenger_id
	INNER JOIN FLIGHT AS F ON T.flight_id = F.flight_id
WHERE p.passenger_id = '000002';


/*Q3 total hours that a specific aircarft has served during a specific time interval*/
/*Performing: Total hours aircraft_if BR002 has served from Nov 26th 2019 to Dec 11th 2019*/
SELECT SUM(DATEDIFF(HH,depart_date,arrive_date)) AS 'Total Hours'
FROM FLIGHT
WHERE flight_id IN 
	(SELECT F.flight_id
	FROM AIRCRAFT AS AC INNER JOIN FLIGHT AS F ON AC.aircraft_id = F.aircraft_id
	WHERE (F.aircraft_id = 'BR002' AND F.depart_date BETWEEN '2019-11-26 00:00:00' AND '2019-12-11 00:00:00'));

/*Q4 number of aircarfts belong to a specific airline*/
/*Performing: Total aircraft that Philipines Airline(2P) possessing*/
SELECT COUNT(aircraft_name) AS 'Total aircarfts'     
FROM AIRCRAFT WHERE airline_id = '2P';



/*Q5 total hours that a specific passenger has travel during a specific time interval*/
/*Performing: Total hours passesger_if 000007 has traveled during the period of Nov 26th 219 - Dec 11th 2019*/
SELECT SUM(DATEDIFF(HH,depart_date,arrive_date)) AS 'Total Hours'
FROM FLIGHT
WHERE flight_id IN 
	(SELECT f.flight_id
	FROM PASSENGER AS P INNER JOIN TICKET AS T ON P.passenger_id = T.passenger_id
	INNER JOIN FLIGHT AS F ON T.flight_id = F.flight_id
	WHERE (P.passenger_id = '000007' AND F.depart_date BETWEEN '2019-11-26 00:00:00' AND '2019-12-11 00:00:00'));


/*Q6 Total number of hours that a specific airline has been running during a specific time interval*/
/*Performing: Total number of hours that Eva Airline has been running between Nov 26 2019 and Dec 11 2019*/
SELECT SUM(DATEDIFF(HH,depart_date,arrive_date)) AS 'Total Hours'
FROM FLIGHT
WHERE flight_id IN 
	(SELECT F.flight_id
	FROM AIRCRAFT AS AC INNER JOIN AIRLINE AS AL 
	ON AC.airline_id = AL.airline_id
	INNER JOIN FLIGHT AS F ON AC.aircraft_id = F.aircraft_id
	WHERE AL.airline_id = 'BR' AND F.depart_date BETWEEN '2019-11-26 00:00:00' AND '2019-12-11 00:00:00');


/*Q7 List of all passengers who flew to a specific city during a specific time interval*/
/*Performing: List all passgener who flew to Hong Kong between Nov 26 2019 and Dec 11 2019*/
SELECT P.passenger_id, P_I.passport_number, P_I.name, P_I.phone, P_I.email, P_I.date_of_birth 
FROM PASSENGER_INFO AS P_I INNER JOIN PASSENGER AS P ON P_I.passport_number = P.passport_number
WHERE P.passenger_id IN
				(SELECT T.passenger_id
				FROM TICKET AS T INNER JOIN FLIGHT AS F ON T.flight_id = F.flight_id
				INNER JOIN ROUTE AS R ON F.route_id = R.route_id				
				INNER JOIN AIRPORT AS APD ON R.destination_airport_id = APD.airport_id
				WHERE (APD.city = 'HONG KONG' AND F.arrive_date BETWEEN '2019-11-26 00:00:00' AND '2019-12-11 00:00:00'));
				


/*Q8 Most visited city during the last month.*/
/*Performing: Show the city was visited the most in the period from Nov 26 2019 to Dec 11 2019*/
SELECT TOP(1) *
FROM 
	(SELECT AP.city, COUNT(AP.city) AS 'Visited times'
	FROM FLIGHT AS F INNER JOIN ROUTE AS R ON F.route_id = R.route_id
	INNER JOIN AIRPORT AS AP ON R.destination_airport_id = AP.airport_id
	WHERE F.arrive_date BETWEEN '2019-11-26 00:00:00' AND '2019-12-11 00:00:00'
	GROUP BY AP.city) AS C
ORDER BY C.[Visited times] DESC;


/*Q9 9.	List of aircrafts that have not been in used from a specific source location*/
/*Performing: List of all aircrafts that not been in used in Tan Son Nhat Airport (SGN)*/
SELECT DISTINCT aircraft_id FROM FLIGHT 
	WHERE route_id IN 
		(SELECT route_id FROM ROUTE WHERE source_airport_id != 'SGN');



/*Q10 List of airlines that run flight from a specific source to a destination.*/
/*Performing: List of all airlines have the flight from DEL (Delhi City) to TPE (TAIWAN)*/
SELECT AL.airline_name
FROM AIRLINE AS AL INNER JOIN AIRCRAFT AS AC ON AL.airline_id = AC.airline_id
	INNER JOIN FLIGHT AS F ON AC.aircraft_id = F.aircraft_id
WHERE F.flight_id IN 
	(SELECT flight_id
	 FROM FLIGHT
	 WHERE route_id = 
		(SELECT route_id 
		 FROM ROUTE 
		 WHERE source_airport_id = 'DEL' AND destination_airport_id = 'TPE'));


/*Q11 The list of all options that a passenger can have when travelling from a source to a destination. 
This includes a connecting flight, for instance, a passenger is travelling from Toronto to Dehli and there is no 
direct flight, therefore, you have to find the options for this passenger.*/
/*Performing: List all in-direct flights from SGN(Ho Chi Minh City) to YYZ(Toronto)*/
SELECT RGD.route_group_id,F.flight_id, F.route_id, AP1.city AS 'Depart', AP2.city AS 'Arrive', f.depart_date, f.arrive_date
FROM FLIGHT AS F INNER JOIN ROUTE AS R ON F.route_id = R.route_id
INNER JOIN AIRPORT AS AP1 ON R.source_airport_id = AP1.airport_id
INNER JOIN AIRPORT AS AP2 ON R.destination_airport_id = AP2.airport_id
INNER JOIN ROUTE_GROUP_DETAIL AS RGD ON R.route_id = RGD.route_id
WHERE RGD.route_group_id IN 
		(SELECT route_group_id
		FROM ROUTE_GROUP
		WHERE source_airport_id = 'SGN' AND destination_airport_id = 'YYZ')
ORDER BY RGD.route_group_id, F.depart_date;



/*Q12 What is the minimum number of hours that it will take for a passenger to travel from a source city to a 
destination city. Again, consider the connecting flights as mentioned in item number 9, e.g. travelling from 
Toronto to Dehli.*/
/*Performing: Amount of minimum hour it takes for flying from SGN to YYZ*/
SELECT MIN(B.Total_hours) AS 'Minimum number of hours'
FROM
	(SELECT STR(CAST(SUM(DATEDIFF(MINUTE,C.depart_date,C.arrive_date)) AS DECIMAL(10,2))/60,10,2) AS 'Total_hours'
	FROM 
		(SELECT RGD.route_group_id,F.flight_id, F.route_id, F.arrive_date, F.depart_date
		FROM FLIGHT AS F INNER JOIN ROUTE AS R ON F.route_id = R.route_id
		INNER JOIN AIRPORT AS AP1 ON R.source_airport_id = AP1.airport_id
		INNER JOIN AIRPORT AS AP2 ON R.destination_airport_id = AP2.airport_id
		INNER JOIN ROUTE_GROUP_DETAIL AS RGD ON R.route_id = RGD.route_id
		WHERE RGD.route_group_id IN 
				(SELECT route_group_id
				FROM ROUTE_GROUP
				WHERE source_airport_id = 'SGN' AND destination_airport_id = 'YYZ')
		) AS C
	GROUP BY C.route_group_id) AS B;

