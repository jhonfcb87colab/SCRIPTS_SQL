


USE SISCliNet;	
SELECT        
	Id, 
	NombreFormato, 
	Descripcion, 
	FechaCrea, 
	UserCrea, 
	FechaActualiza, 
	UserActualiza, 
	Estado
FROM DBO.Sert_FormatosImpresionGuia WITH (NOLOCK)
WHERE Estado=1