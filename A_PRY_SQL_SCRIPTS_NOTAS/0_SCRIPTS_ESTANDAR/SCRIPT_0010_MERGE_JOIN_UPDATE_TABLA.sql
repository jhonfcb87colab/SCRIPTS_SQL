MERGE 
target_table AS target  -- TABLA OBJETIVO (TABLA PARA INSERTAR DATOS)
USING 	source_table AS source ---TABLA FUENTE (TABLA TEMPORAL)
	ON target.columna_clave = source.columna_clave		------COLUMNAS LLAVE
WHEN MATCHED 
		AND target.columna_condicion = 'valor_condicion'    --- OPCIONAL SI SE NECESITAN MAS CONDICIONES
		THEN        
	UPDATE SET target.columna1 = source.valor1, target.columna2 = source.valor2 
WHEN NOT MATCHED THEN    
	INSERT (columna_clave, columna1, columna2)    
	VALUES (source.columna_clave, source.valor1, source.valor2);