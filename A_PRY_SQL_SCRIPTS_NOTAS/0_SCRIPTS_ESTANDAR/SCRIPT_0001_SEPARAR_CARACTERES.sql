



declare @variable varchar(100)= '123456789-987654321';
SELECT 
CHARINDEX('-', @variable)+1 AS _CHARINDEX,
SUBSTRING(@variable,1,CHARINDEX('-', @variable)) AS DANE_ORIGEN,
SUBSTRING(@variable,CHARINDEX('-', @variable)+1,len(@variable)) AS DANE_DESTINO





