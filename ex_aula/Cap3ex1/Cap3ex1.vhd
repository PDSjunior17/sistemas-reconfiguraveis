ENTITY Cap3ex1 IS 
	PORT (
		a,b	: IN BIT;
		x,y,z : OUT BIT
	);
END ENTITY;

-----------------------
ARCHITECTURE arch OF Cap3ex1 IS 
BEGIN
	x <= a AND b;
	y <= a OR b;
	z <= a XOR b;
END arch;
