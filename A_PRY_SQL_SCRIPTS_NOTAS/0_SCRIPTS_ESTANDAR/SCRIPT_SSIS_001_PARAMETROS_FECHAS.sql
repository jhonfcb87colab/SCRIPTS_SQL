

/*			PARAMETROS DE PROYECTO
DiaIni						INT32		11						Dias atras si la fecha es 1900-01-01
FULL_FACH_FIN				String		1900-01-01				Se agrega un dia a la fecha deseada, en caso de proceso normal se debe de dejar la fecha 1900-01-01
FULL_FACH_INI				String		1900-01-01				Se agrega un dia a la fecha deseada, en caso de proceso normal se debe de dejar la fecha 1900-01-01
*/



---------------------------------------------------------->VARIABLES DEL PAQUETE 
----------------------------->Dias_Ant
INT32
@[$Project::DiaIni]

FechaFin
DATETIME
(DT_DATE) @[$Project::FULL_FACH_FIN] == (DT_DATE) "1900-01-01"?
(DT_DATE)((DT_WSTR,4)YEAR(DATEADD("DD", 1 ,GETDATE()))+"-"+RIGHT("0"+(DT_WSTR,2)MONTH(DATEADD("DD",1,GETDATE())),2)+"-"+RIGHT("0"+(DT_WSTR,2)DAY(DATEADD("DD",1,GETDATE())),2))
: (DT_DATE) @[$Project::FULL_FACH_FIN]


----------------------------->FechaIni
DATETIME
(DT_DATE)   @[$Project::FULL_FACH_INI]    == (DT_DATE) "1900-01-01"? 
(DT_DATE)((DT_WSTR,4)YEAR(DATEADD("DD", -@[$Project::DiaIni], GETDATE()))+"-"
+RIGHT("0"+(DT_WSTR,2)MONTH(DATEADD("DD",-@[$Project::DiaIni],GETDATE() )),2)+"-"
+RIGHT("0"+(DT_WSTR,2)DAY(DATEADD("DD", -@[$Project::DiaIni],GETDATE() )),2))
: (DT_DATE) @[$Project::FULL_FACH_INI]


----------------------------->STR_FechaFin
STRING
(DT_WSTR, 10)
( 
	(
		(
			(  YEAR( @[User::FechaFin] )*100 )   
			+
			(  MONTH( @[User::FechaFin] )  )
		)*100
	)+ DAY( @[User::FechaFin] )
)

----------------------------->STR_FechaIni
STRING
(DT_WSTR, 10)
( 
	(
		(
			(  YEAR( @[User::FechaIni]  )*100 )   
			+
			(  MONTH( @[User::FechaIni] )  )
		)*100
	)+ DAY( @[User::FechaIni] )
)





@[$Project::REPOBLAR] == "NO" ?
(DT_STR,4,1252)DATEPART( "yyyy" , DATEADD("day", @[$Project::NUM_DIAS_ATRAAS] ,GETDATE())  ) + "-"+
RIGHT("0" + (DT_STR,4,1252)DATEPART( "mm" , DATEADD("day", @[$Project::NUM_DIAS_ATRAAS] ,GETDATE())  ), 2) +"-"+
RIGHT("0" + (DT_STR,4,1252)DATEPART( "dd" , DATEADD("day", @[$Project::NUM_DIAS_ATRAAS] ,GETDATE())  ), 2)
:
(DT_STR,4,1252)DATEPART( "yyyy" , @[$Project::datFechaInicio]  ) + "-"+
RIGHT("0" + (DT_STR,4,1252)DATEPART( "mm" , @[$Project::datFechaInicio]), 2) +"-"+
RIGHT("0" + (DT_STR,4,1252)DATEPART( "dd" , @[$Project::datFechaInicio]), 2)


@[$Project::REPOBLAR] == "NO" ?
(DT_STR,4,1252)DATEPART( "yyyy" , DATEADD("day", @[$Project::NUM_DIAS_ADELANTE] ,GETDATE())  ) + "-"+
RIGHT("0" + (DT_STR,4,1252)DATEPART( "mm" , DATEADD("day", @[$Project::NUM_DIAS_ADELANTE] ,GETDATE())  ), 2) +"-"+
RIGHT("0" + (DT_STR,4,1252)DATEPART( "dd" , DATEADD("day", @[$Project::NUM_DIAS_ADELANTE] ,GETDATE())  ), 2)
:
(DT_STR,4,1252)DATEPART( "yyyy" , @[$Project::datFechaFin]  ) + "-"+
RIGHT("0" + (DT_STR,4,1252)DATEPART( "mm" , @[$Project::datFechaFin] ), 2) +"-"+
RIGHT("0" + (DT_STR,4,1252)DATEPART( "dd" , @[$Project::datFechaFin] ), 2)

