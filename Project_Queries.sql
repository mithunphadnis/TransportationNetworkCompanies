# Passenger Preference(Uber or Lyft)				
select Passenger.Pstate, Driver.Drivercompany, count(Passenger.PassengerID)
from Passenger, Driver, Ridehistory
where Driver.DriverID = Ridehistory.DriverID and 
Passenger.PassengerID = RideHistory.PassengerID 
group by Passenger.Pstate, Driver.Drivercompany;	
	
#Which are the busiest states?				
select d.driverstate,count(bi.driverID) from driver d, bookinginformation bi
where d.driverid = bi.driverid
group by (d.driverstate) order by count(bi.driverID) desc;

#What are the average rating of Drivers per state?				
select d.driverstate,avg(R.DRating)				
	from rating R,driver d,bookinginformation bi		
where d.driverid = bi.driverid and bi.bookingid = r.bookingid			
group by d.driverstate order by avg(R.DRating) desc	;	

				
#What are the average rating of Passengers per state?				
select p.Pstate,avg(R.PRating)				
	from rating R,passenger p,bookinginformation bi		
where p.PassengerID = bi.PassengerID and bi.bookingid = r.bookingid			
group by p.pstate order by avg(R.PRating) desc	;

# Top 5 Drivers and Passengers 
(select p.PassengerID as ID, p.PFirstName as Name,avg(R.PRating) as Rating				
	from rating R,passenger p,bookinginformation bi		
where p.PassengerID = bi.PassengerID and bi.bookingid = r.bookingid			
group by p.PassengerID order by avg(R.PRating) desc limit 5,5)	
union
(select d.DriverID as ID, d.driverfirstname as Name,avg(R.DRating) as Rating				
	from rating R,driver d,bookinginformation bi		
where d.driverid = bi.driverid and bi.bookingid = r.bookingid			
group by d.driverid order by avg(R.DRating) desc limit 5,5)	;				
				
#Average Male and Female Rating
select d.drivergender,d.driverstate,avg(drating) 
from driver d, bookinginformation bi, rating r
where r.BookingID = bi.BookingID and bi.DriverID = d.DriverID
group by d.driverstate,d.drivergender;

# No of users using Lyft or Uber Per state
select d.driverstate ,d.drivercompany,count(rh.bookingid) 
from driver d, ridehistory rh
where d.driverid = rh.DriverID
group by d.DriverState, d.drivercompany;

# Drivers working for Uber and Lyft
select * from driver where drivercompany = 'Uber' and 
driverid in (select driverid from driver where drivercompany = 'Lyft');

# Price variation during rush hour and non rush hours
select z.state, pi.rate_per_mile , pi.TimeOfDay,pi.TypeOfCar
from zone z , pricinginformation pi
where z.TrafficDensityPartition = pi.zone
order by pi.Rate_per_Mile;

#cost for each ride during RushHour
select bi.PassengerID,bi.PickUpLoc, bi.droploc, d.DriverState,pi.rate_per_mile * bi.distance 
as Cost,pi.TimeOfDay
from bookinginformation bi,pricinginformation pi,zone z,driver d, carinfo ci
where d.DriverState = z.State and
d.DriverID = bi.DriverID and
z.TrafficDensityPartition = pi.Zone and
d.DriverID = ci.DriverID and
pi.typeofcar = ci.cartype and
pi.TimeOfDay = 'RushHour'
and (bi.BookingID in (select bookingid from ridehistory))
group by bi.bookingID,PickUpLoc, bi.droploc;

# Details of drivers with rating <= 3
Select Distinct Driver.DriverID,Driver.Driverfirstname,Driver.Driverlastname, Rating.Drating
from Driver, Bookinginformation, Rating
where Driver.driverID = Bookinginformation.DriverID and
Bookinginformation.BookingID = Rating.BookingID and 
Rating.DRating <= 3
order by Rating.DRating;

# Details of Cancelled Rides
select * from bookinginformation
where bookinginformation.BookingID not in 
(select BookingID from ridehistory)
order by Passengerid;



