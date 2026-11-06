<Batch xmlns="http://schemas.microsoft.com/analysisservices/2003/engine">
  <ErrorConfiguration xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ddl2="http://schemas.microsoft.com/analysisservices/2003/engine/2" xmlns:ddl2_2="http://schemas.microsoft.com/analysisservices/2003/engine/2/2" xmlns:ddl100_100="http://schemas.microsoft.com/analysisservices/2008/engine/100/100" xmlns:ddl200="http://schemas.microsoft.com/analysisservices/2010/engine/200" xmlns:ddl200_200="http://schemas.microsoft.com/analysisservices/2010/engine/200/200" xmlns:ddl300="http://schemas.microsoft.com/analysisservices/2011/engine/300" xmlns:ddl300_300="http://schemas.microsoft.com/analysisservices/2011/engine/300/300" xmlns:ddl400="http://schemas.microsoft.com/analysisservices/2012/engine/400" xmlns:ddl400_400="http://schemas.microsoft.com/analysisservices/2012/engine/400/400" xmlns:ddl500="http://schemas.microsoft.com/analysisservices/2013/engine/500" xmlns:ddl500_500="http://schemas.microsoft.com/analysisservices/2013/engine/500/500">
    <KeyErrorLimit>-1</KeyErrorLimit>
    <KeyNotFound>IgnoreError</KeyNotFound>
    <NullKeyNotAllowed>IgnoreError</NullKeyNotAllowed>
  </ErrorConfiguration>
  <Parallel>

  	  <!--
  **********************************************************************************************************************
  -->
	  <Process xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ddl2="http://schemas.microsoft.com/analysisservices/2003/engine/2" xmlns:ddl2_2="http://schemas.microsoft.com/analysisservices/2003/engine/2/2" xmlns:ddl100_100="http://schemas.microsoft.com/analysisservices/2008/engine/100/100" xmlns:ddl200="http://schemas.microsoft.com/analysisservices/2010/engine/200" xmlns:ddl200_200="http://schemas.microsoft.com/analysisservices/2010/engine/200/200" xmlns:ddl300="http://schemas.microsoft.com/analysisservices/2011/engine/300" xmlns:ddl300_300="http://schemas.microsoft.com/analysisservices/2011/engine/300/300" xmlns:ddl400="http://schemas.microsoft.com/analysisservices/2012/engine/400" xmlns:ddl400_400="http://schemas.microsoft.com/analysisservices/2012/engine/400/400" xmlns:ddl500="http://schemas.microsoft.com/analysisservices/2013/engine/500" xmlns:ddl500_500="http://schemas.microsoft.com/analysisservices/2013/engine/500/500">
		  <Object>
			  <DatabaseID>SIG_COL_LOGISTICA</DatabaseID>
			  <CubeID>MOVIMIENTO_POR_PROCESO_VEHICULO</CubeID>
			  <MeasureGroupID>MOV POR PROCESO VEHICULO</MeasureGroupID>
			  <PartitionID>MOV POR PROCESO VEHICULO 2022 01</PartitionID>
		  </Object>
		  <Type>ProcessFull</Type>
		  <WriteBackTableCreation>UseExisting</WriteBackTableCreation>
	  </Process>
	  <Process xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ddl2="http://schemas.microsoft.com/analysisservices/2003/engine/2" xmlns:ddl2_2="http://schemas.microsoft.com/analysisservices/2003/engine/2/2" xmlns:ddl100_100="http://schemas.microsoft.com/analysisservices/2008/engine/100/100" xmlns:ddl200="http://schemas.microsoft.com/analysisservices/2010/engine/200" xmlns:ddl200_200="http://schemas.microsoft.com/analysisservices/2010/engine/200/200" xmlns:ddl300="http://schemas.microsoft.com/analysisservices/2011/engine/300" xmlns:ddl300_300="http://schemas.microsoft.com/analysisservices/2011/engine/300/300" xmlns:ddl400="http://schemas.microsoft.com/analysisservices/2012/engine/400" xmlns:ddl400_400="http://schemas.microsoft.com/analysisservices/2012/engine/400/400" xmlns:ddl500="http://schemas.microsoft.com/analysisservices/2013/engine/500" xmlns:ddl500_500="http://schemas.microsoft.com/analysisservices/2013/engine/500/500">
		  <Object>
			  <DatabaseID>SIG_COL_LOGISTICA</DatabaseID>
			  <CubeID>MOVIMIENTO_POR_PROCESO_VEHICULO</CubeID>
			  <MeasureGroupID>MOV POR PROCESO VEHICULO 1</MeasureGroupID>
			  <PartitionID>MOV POR PROCESO VEHICULO 2022 01</PartitionID>
		  </Object>
		  <Type>ProcessFull</Type>
		  <WriteBackTableCreation>UseExisting</WriteBackTableCreation>
	  </Process>
	  <!--
  **********************************************************************************************************************
  -->
	  <Process xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ddl2="http://schemas.microsoft.com/analysisservices/2003/engine/2" xmlns:ddl2_2="http://schemas.microsoft.com/analysisservices/2003/engine/2/2" xmlns:ddl100_100="http://schemas.microsoft.com/analysisservices/2008/engine/100/100" xmlns:ddl200="http://schemas.microsoft.com/analysisservices/2010/engine/200" xmlns:ddl200_200="http://schemas.microsoft.com/analysisservices/2010/engine/200/200" xmlns:ddl300="http://schemas.microsoft.com/analysisservices/2011/engine/300" xmlns:ddl300_300="http://schemas.microsoft.com/analysisservices/2011/engine/300/300" xmlns:ddl400="http://schemas.microsoft.com/analysisservices/2012/engine/400" xmlns:ddl400_400="http://schemas.microsoft.com/analysisservices/2012/engine/400/400" xmlns:ddl500="http://schemas.microsoft.com/analysisservices/2013/engine/500" xmlns:ddl500_500="http://schemas.microsoft.com/analysisservices/2013/engine/500/500">
		  <Object>
			  <DatabaseID>SIG_COL_LOGISTICA</DatabaseID>
			  <CubeID>MOVIMIENTO_POR_PROCESO_VEHICULO</CubeID>
			  <MeasureGroupID>MOV POR PROCESO VEHICULO</MeasureGroupID>
			  <PartitionID>MOV POR PROCESO VEHICULO 2022 02</PartitionID>
		  </Object>
		  <Type>ProcessFull</Type>
		  <WriteBackTableCreation>UseExisting</WriteBackTableCreation>
	  </Process>
	  <Process xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ddl2="http://schemas.microsoft.com/analysisservices/2003/engine/2" xmlns:ddl2_2="http://schemas.microsoft.com/analysisservices/2003/engine/2/2" xmlns:ddl100_100="http://schemas.microsoft.com/analysisservices/2008/engine/100/100" xmlns:ddl200="http://schemas.microsoft.com/analysisservices/2010/engine/200" xmlns:ddl200_200="http://schemas.microsoft.com/analysisservices/2010/engine/200/200" xmlns:ddl300="http://schemas.microsoft.com/analysisservices/2011/engine/300" xmlns:ddl300_300="http://schemas.microsoft.com/analysisservices/2011/engine/300/300" xmlns:ddl400="http://schemas.microsoft.com/analysisservices/2012/engine/400" xmlns:ddl400_400="http://schemas.microsoft.com/analysisservices/2012/engine/400/400" xmlns:ddl500="http://schemas.microsoft.com/analysisservices/2013/engine/500" xmlns:ddl500_500="http://schemas.microsoft.com/analysisservices/2013/engine/500/500">
		  <Object>
			  <DatabaseID>SIG_COL_LOGISTICA</DatabaseID>
			  <CubeID>MOVIMIENTO_POR_PROCESO_VEHICULO</CubeID>
			  <MeasureGroupID>MOV POR PROCESO VEHICULO 1</MeasureGroupID>
			  <PartitionID>MOV POR PROCESO VEHICULO 2022 02</PartitionID>
		  </Object>
		  <Type>ProcessFull</Type>
		  <WriteBackTableCreation>UseExisting</WriteBackTableCreation>
	  </Process>
	  <!--
  **********************************************************************************************************************
  -->
	  <Process xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ddl2="http://schemas.microsoft.com/analysisservices/2003/engine/2" xmlns:ddl2_2="http://schemas.microsoft.com/analysisservices/2003/engine/2/2" xmlns:ddl100_100="http://schemas.microsoft.com/analysisservices/2008/engine/100/100" xmlns:ddl200="http://schemas.microsoft.com/analysisservices/2010/engine/200" xmlns:ddl200_200="http://schemas.microsoft.com/analysisservices/2010/engine/200/200" xmlns:ddl300="http://schemas.microsoft.com/analysisservices/2011/engine/300" xmlns:ddl300_300="http://schemas.microsoft.com/analysisservices/2011/engine/300/300" xmlns:ddl400="http://schemas.microsoft.com/analysisservices/2012/engine/400" xmlns:ddl400_400="http://schemas.microsoft.com/analysisservices/2012/engine/400/400" xmlns:ddl500="http://schemas.microsoft.com/analysisservices/2013/engine/500" xmlns:ddl500_500="http://schemas.microsoft.com/analysisservices/2013/engine/500/500">
		  <Object>
			  <DatabaseID>SIG_COL_LOGISTICA</DatabaseID>
			  <CubeID>MOVIMIENTO_POR_PROCESO_VEHICULO</CubeID>
			  <MeasureGroupID>MOV POR PROCESO VEHICULO</MeasureGroupID>
			  <PartitionID>MOV POR PROCESO VEHICULO 2022 03</PartitionID>
		  </Object>
		  <Type>ProcessFull</Type>
		  <WriteBackTableCreation>UseExisting</WriteBackTableCreation>
	  </Process>
	  <Process xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ddl2="http://schemas.microsoft.com/analysisservices/2003/engine/2" xmlns:ddl2_2="http://schemas.microsoft.com/analysisservices/2003/engine/2/2" xmlns:ddl100_100="http://schemas.microsoft.com/analysisservices/2008/engine/100/100" xmlns:ddl200="http://schemas.microsoft.com/analysisservices/2010/engine/200" xmlns:ddl200_200="http://schemas.microsoft.com/analysisservices/2010/engine/200/200" xmlns:ddl300="http://schemas.microsoft.com/analysisservices/2011/engine/300" xmlns:ddl300_300="http://schemas.microsoft.com/analysisservices/2011/engine/300/300" xmlns:ddl400="http://schemas.microsoft.com/analysisservices/2012/engine/400" xmlns:ddl400_400="http://schemas.microsoft.com/analysisservices/2012/engine/400/400" xmlns:ddl500="http://schemas.microsoft.com/analysisservices/2013/engine/500" xmlns:ddl500_500="http://schemas.microsoft.com/analysisservices/2013/engine/500/500">
		  <Object>
			  <DatabaseID>SIG_COL_LOGISTICA</DatabaseID>
			  <CubeID>MOVIMIENTO_POR_PROCESO_VEHICULO</CubeID>
			  <MeasureGroupID>MOV POR PROCESO VEHICULO 1</MeasureGroupID>
			  <PartitionID>MOV POR PROCESO VEHICULO 2022 03</PartitionID>
		  </Object>
		  <Type>ProcessFull</Type>
		  <WriteBackTableCreation>UseExisting</WriteBackTableCreation>
	  </Process>	  
	  
	  
	  
	  
	  <!--
  **********************************************************************************************************************
  -->	  
    <Process xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ddl2="http://schemas.microsoft.com/analysisservices/2003/engine/2" xmlns:ddl2_2="http://schemas.microsoft.com/analysisservices/2003/engine/2/2" xmlns:ddl100_100="http://schemas.microsoft.com/analysisservices/2008/engine/100/100" xmlns:ddl200="http://schemas.microsoft.com/analysisservices/2010/engine/200" xmlns:ddl200_200="http://schemas.microsoft.com/analysisservices/2010/engine/200/200" xmlns:ddl300="http://schemas.microsoft.com/analysisservices/2011/engine/300" xmlns:ddl300_300="http://schemas.microsoft.com/analysisservices/2011/engine/300/300" xmlns:ddl400="http://schemas.microsoft.com/analysisservices/2012/engine/400" xmlns:ddl400_400="http://schemas.microsoft.com/analysisservices/2012/engine/400/400" xmlns:ddl500="http://schemas.microsoft.com/analysisservices/2013/engine/500" xmlns:ddl500_500="http://schemas.microsoft.com/analysisservices/2013/engine/500/500">
      <Object>
        <DatabaseID>SIG_COL_LOGISTICA</DatabaseID>
        <CubeID>MOVIMIENTO_POR_PROCESO_VEHICULO</CubeID>
        <MeasureGroupID>MOV POR PROCESO VEHICULO</MeasureGroupID>
        <PartitionID>MOV POR PROCESO VEHICULO 2022 04</PartitionID>
      </Object>
      <Type>ProcessFull</Type>
      <WriteBackTableCreation>UseExisting</WriteBackTableCreation>
    </Process>
	  <Process xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ddl2="http://schemas.microsoft.com/analysisservices/2003/engine/2" xmlns:ddl2_2="http://schemas.microsoft.com/analysisservices/2003/engine/2/2" xmlns:ddl100_100="http://schemas.microsoft.com/analysisservices/2008/engine/100/100" xmlns:ddl200="http://schemas.microsoft.com/analysisservices/2010/engine/200" xmlns:ddl200_200="http://schemas.microsoft.com/analysisservices/2010/engine/200/200" xmlns:ddl300="http://schemas.microsoft.com/analysisservices/2011/engine/300" xmlns:ddl300_300="http://schemas.microsoft.com/analysisservices/2011/engine/300/300" xmlns:ddl400="http://schemas.microsoft.com/analysisservices/2012/engine/400" xmlns:ddl400_400="http://schemas.microsoft.com/analysisservices/2012/engine/400/400" xmlns:ddl500="http://schemas.microsoft.com/analysisservices/2013/engine/500" xmlns:ddl500_500="http://schemas.microsoft.com/analysisservices/2013/engine/500/500">
		  <Object>
			  <DatabaseID>SIG_COL_LOGISTICA</DatabaseID>
			  <CubeID>MOVIMIENTO_POR_PROCESO_VEHICULO</CubeID>
			  <MeasureGroupID>MOV POR PROCESO VEHICULO 1</MeasureGroupID>
			  <PartitionID>MOV POR PROCESO VEHICULO 2022 04</PartitionID>
		  </Object>
		  <Type>ProcessFull</Type>
		  <WriteBackTableCreation>UseExisting</WriteBackTableCreation>
	  </Process>
  <!--
  **********************************************************************************************************************
  -->
	  <Process xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ddl2="http://schemas.microsoft.com/analysisservices/2003/engine/2" xmlns:ddl2_2="http://schemas.microsoft.com/analysisservices/2003/engine/2/2" xmlns:ddl100_100="http://schemas.microsoft.com/analysisservices/2008/engine/100/100" xmlns:ddl200="http://schemas.microsoft.com/analysisservices/2010/engine/200" xmlns:ddl200_200="http://schemas.microsoft.com/analysisservices/2010/engine/200/200" xmlns:ddl300="http://schemas.microsoft.com/analysisservices/2011/engine/300" xmlns:ddl300_300="http://schemas.microsoft.com/analysisservices/2011/engine/300/300" xmlns:ddl400="http://schemas.microsoft.com/analysisservices/2012/engine/400" xmlns:ddl400_400="http://schemas.microsoft.com/analysisservices/2012/engine/400/400" xmlns:ddl500="http://schemas.microsoft.com/analysisservices/2013/engine/500" xmlns:ddl500_500="http://schemas.microsoft.com/analysisservices/2013/engine/500/500">
		  <Object>
			  <DatabaseID>SIG_COL_LOGISTICA</DatabaseID>
			  <CubeID>MOVIMIENTO_POR_PROCESO_VEHICULO</CubeID>
			  <MeasureGroupID>MOV POR PROCESO VEHICULO</MeasureGroupID>
			  <PartitionID>MOV POR PROCESO VEHICULO 2022 05</PartitionID>
		  </Object>
		  <Type>ProcessFull</Type>
		  <WriteBackTableCreation>UseExisting</WriteBackTableCreation>
	  </Process>
	  <Process xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ddl2="http://schemas.microsoft.com/analysisservices/2003/engine/2" xmlns:ddl2_2="http://schemas.microsoft.com/analysisservices/2003/engine/2/2" xmlns:ddl100_100="http://schemas.microsoft.com/analysisservices/2008/engine/100/100" xmlns:ddl200="http://schemas.microsoft.com/analysisservices/2010/engine/200" xmlns:ddl200_200="http://schemas.microsoft.com/analysisservices/2010/engine/200/200" xmlns:ddl300="http://schemas.microsoft.com/analysisservices/2011/engine/300" xmlns:ddl300_300="http://schemas.microsoft.com/analysisservices/2011/engine/300/300" xmlns:ddl400="http://schemas.microsoft.com/analysisservices/2012/engine/400" xmlns:ddl400_400="http://schemas.microsoft.com/analysisservices/2012/engine/400/400" xmlns:ddl500="http://schemas.microsoft.com/analysisservices/2013/engine/500" xmlns:ddl500_500="http://schemas.microsoft.com/analysisservices/2013/engine/500/500">
		  <Object>
			  <DatabaseID>SIG_COL_LOGISTICA</DatabaseID>
			  <CubeID>MOVIMIENTO_POR_PROCESO_VEHICULO</CubeID>
			  <MeasureGroupID>MOV POR PROCESO VEHICULO 1</MeasureGroupID>
			  <PartitionID>MOV POR PROCESO VEHICULO 2022 05</PartitionID>
		  </Object>
		  <Type>ProcessFull</Type>
		  <WriteBackTableCreation>UseExisting</WriteBackTableCreation>
	  </Process>
	  <!--
  **********************************************************************************************************************
  -->
	  <Process xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ddl2="http://schemas.microsoft.com/analysisservices/2003/engine/2" xmlns:ddl2_2="http://schemas.microsoft.com/analysisservices/2003/engine/2/2" xmlns:ddl100_100="http://schemas.microsoft.com/analysisservices/2008/engine/100/100" xmlns:ddl200="http://schemas.microsoft.com/analysisservices/2010/engine/200" xmlns:ddl200_200="http://schemas.microsoft.com/analysisservices/2010/engine/200/200" xmlns:ddl300="http://schemas.microsoft.com/analysisservices/2011/engine/300" xmlns:ddl300_300="http://schemas.microsoft.com/analysisservices/2011/engine/300/300" xmlns:ddl400="http://schemas.microsoft.com/analysisservices/2012/engine/400" xmlns:ddl400_400="http://schemas.microsoft.com/analysisservices/2012/engine/400/400" xmlns:ddl500="http://schemas.microsoft.com/analysisservices/2013/engine/500" xmlns:ddl500_500="http://schemas.microsoft.com/analysisservices/2013/engine/500/500">
		  <Object>
			  <DatabaseID>SIG_COL_LOGISTICA</DatabaseID>
			  <CubeID>MOVIMIENTO_POR_PROCESO_VEHICULO</CubeID>
			  <MeasureGroupID>MOV POR PROCESO VEHICULO</MeasureGroupID>
			  <PartitionID>MOV POR PROCESO VEHICULO 2022 06</PartitionID>
		  </Object>
		  <Type>ProcessFull</Type>
		  <WriteBackTableCreation>UseExisting</WriteBackTableCreation>
	  </Process>
	  <Process xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ddl2="http://schemas.microsoft.com/analysisservices/2003/engine/2" xmlns:ddl2_2="http://schemas.microsoft.com/analysisservices/2003/engine/2/2" xmlns:ddl100_100="http://schemas.microsoft.com/analysisservices/2008/engine/100/100" xmlns:ddl200="http://schemas.microsoft.com/analysisservices/2010/engine/200" xmlns:ddl200_200="http://schemas.microsoft.com/analysisservices/2010/engine/200/200" xmlns:ddl300="http://schemas.microsoft.com/analysisservices/2011/engine/300" xmlns:ddl300_300="http://schemas.microsoft.com/analysisservices/2011/engine/300/300" xmlns:ddl400="http://schemas.microsoft.com/analysisservices/2012/engine/400" xmlns:ddl400_400="http://schemas.microsoft.com/analysisservices/2012/engine/400/400" xmlns:ddl500="http://schemas.microsoft.com/analysisservices/2013/engine/500" xmlns:ddl500_500="http://schemas.microsoft.com/analysisservices/2013/engine/500/500">
		  <Object>
			  <DatabaseID>SIG_COL_LOGISTICA</DatabaseID>
			  <CubeID>MOVIMIENTO_POR_PROCESO_VEHICULO</CubeID>
			  <MeasureGroupID>MOV POR PROCESO VEHICULO 1</MeasureGroupID>
			  <PartitionID>MOV POR PROCESO VEHICULO 2022 06</PartitionID>
		  </Object>
		  <Type>ProcessFull</Type>
		  <WriteBackTableCreation>UseExisting</WriteBackTableCreation>
	  </Process>


	  <!--
  **********************************************************************************************************************
  -->
	  <Process xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ddl2="http://schemas.microsoft.com/analysisservices/2003/engine/2" xmlns:ddl2_2="http://schemas.microsoft.com/analysisservices/2003/engine/2/2" xmlns:ddl100_100="http://schemas.microsoft.com/analysisservices/2008/engine/100/100" xmlns:ddl200="http://schemas.microsoft.com/analysisservices/2010/engine/200" xmlns:ddl200_200="http://schemas.microsoft.com/analysisservices/2010/engine/200/200" xmlns:ddl300="http://schemas.microsoft.com/analysisservices/2011/engine/300" xmlns:ddl300_300="http://schemas.microsoft.com/analysisservices/2011/engine/300/300" xmlns:ddl400="http://schemas.microsoft.com/analysisservices/2012/engine/400" xmlns:ddl400_400="http://schemas.microsoft.com/analysisservices/2012/engine/400/400" xmlns:ddl500="http://schemas.microsoft.com/analysisservices/2013/engine/500" xmlns:ddl500_500="http://schemas.microsoft.com/analysisservices/2013/engine/500/500">
		  <Object>
			  <DatabaseID>SIG_COL_LOGISTICA</DatabaseID>
			  <CubeID>MOVIMIENTO_POR_PROCESO_VEHICULO</CubeID>
			  <MeasureGroupID>MOV POR PROCESO VEHICULO</MeasureGroupID>
			  <PartitionID>MOV POR PROCESO VEHICULO 2022 07</PartitionID>
		  </Object>
		  <Type>ProcessFull</Type>
		  <WriteBackTableCreation>UseExisting</WriteBackTableCreation>
	  </Process>
	  <Process xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ddl2="http://schemas.microsoft.com/analysisservices/2003/engine/2" xmlns:ddl2_2="http://schemas.microsoft.com/analysisservices/2003/engine/2/2" xmlns:ddl100_100="http://schemas.microsoft.com/analysisservices/2008/engine/100/100" xmlns:ddl200="http://schemas.microsoft.com/analysisservices/2010/engine/200" xmlns:ddl200_200="http://schemas.microsoft.com/analysisservices/2010/engine/200/200" xmlns:ddl300="http://schemas.microsoft.com/analysisservices/2011/engine/300" xmlns:ddl300_300="http://schemas.microsoft.com/analysisservices/2011/engine/300/300" xmlns:ddl400="http://schemas.microsoft.com/analysisservices/2012/engine/400" xmlns:ddl400_400="http://schemas.microsoft.com/analysisservices/2012/engine/400/400" xmlns:ddl500="http://schemas.microsoft.com/analysisservices/2013/engine/500" xmlns:ddl500_500="http://schemas.microsoft.com/analysisservices/2013/engine/500/500">
		  <Object>
			  <DatabaseID>SIG_COL_LOGISTICA</DatabaseID>
			  <CubeID>MOVIMIENTO_POR_PROCESO_VEHICULO</CubeID>
			  <MeasureGroupID>MOV POR PROCESO VEHICULO 1</MeasureGroupID>
			  <PartitionID>MOV POR PROCESO VEHICULO 2022 07</PartitionID>
		  </Object>
		  <Type>ProcessFull</Type>
		  <WriteBackTableCreation>UseExisting</WriteBackTableCreation>
	  </Process>
	  <!--
  **********************************************************************************************************************
  -->
	  <Process xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ddl2="http://schemas.microsoft.com/analysisservices/2003/engine/2" xmlns:ddl2_2="http://schemas.microsoft.com/analysisservices/2003/engine/2/2" xmlns:ddl100_100="http://schemas.microsoft.com/analysisservices/2008/engine/100/100" xmlns:ddl200="http://schemas.microsoft.com/analysisservices/2010/engine/200" xmlns:ddl200_200="http://schemas.microsoft.com/analysisservices/2010/engine/200/200" xmlns:ddl300="http://schemas.microsoft.com/analysisservices/2011/engine/300" xmlns:ddl300_300="http://schemas.microsoft.com/analysisservices/2011/engine/300/300" xmlns:ddl400="http://schemas.microsoft.com/analysisservices/2012/engine/400" xmlns:ddl400_400="http://schemas.microsoft.com/analysisservices/2012/engine/400/400" xmlns:ddl500="http://schemas.microsoft.com/analysisservices/2013/engine/500" xmlns:ddl500_500="http://schemas.microsoft.com/analysisservices/2013/engine/500/500">
		  <Object>
			  <DatabaseID>SIG_COL_LOGISTICA</DatabaseID>
			  <CubeID>MOVIMIENTO_POR_PROCESO_VEHICULO</CubeID>
			  <MeasureGroupID>MOV POR PROCESO VEHICULO</MeasureGroupID>
			  <PartitionID>MOV POR PROCESO VEHICULO 2022 08</PartitionID>
		  </Object>
		  <Type>ProcessFull</Type>
		  <WriteBackTableCreation>UseExisting</WriteBackTableCreation>
	  </Process>
	  <Process xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ddl2="http://schemas.microsoft.com/analysisservices/2003/engine/2" xmlns:ddl2_2="http://schemas.microsoft.com/analysisservices/2003/engine/2/2" xmlns:ddl100_100="http://schemas.microsoft.com/analysisservices/2008/engine/100/100" xmlns:ddl200="http://schemas.microsoft.com/analysisservices/2010/engine/200" xmlns:ddl200_200="http://schemas.microsoft.com/analysisservices/2010/engine/200/200" xmlns:ddl300="http://schemas.microsoft.com/analysisservices/2011/engine/300" xmlns:ddl300_300="http://schemas.microsoft.com/analysisservices/2011/engine/300/300" xmlns:ddl400="http://schemas.microsoft.com/analysisservices/2012/engine/400" xmlns:ddl400_400="http://schemas.microsoft.com/analysisservices/2012/engine/400/400" xmlns:ddl500="http://schemas.microsoft.com/analysisservices/2013/engine/500" xmlns:ddl500_500="http://schemas.microsoft.com/analysisservices/2013/engine/500/500">
		  <Object>
			  <DatabaseID>SIG_COL_LOGISTICA</DatabaseID>
			  <CubeID>MOVIMIENTO_POR_PROCESO_VEHICULO</CubeID>
			  <MeasureGroupID>MOV POR PROCESO VEHICULO 1</MeasureGroupID>
			  <PartitionID>MOV POR PROCESO VEHICULO 2022 08</PartitionID>
		  </Object>
		  <Type>ProcessFull</Type>
		  <WriteBackTableCreation>UseExisting</WriteBackTableCreation>
	  </Process>
	  <!--
  **********************************************************************************************************************
  -->
	  <Process xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ddl2="http://schemas.microsoft.com/analysisservices/2003/engine/2" xmlns:ddl2_2="http://schemas.microsoft.com/analysisservices/2003/engine/2/2" xmlns:ddl100_100="http://schemas.microsoft.com/analysisservices/2008/engine/100/100" xmlns:ddl200="http://schemas.microsoft.com/analysisservices/2010/engine/200" xmlns:ddl200_200="http://schemas.microsoft.com/analysisservices/2010/engine/200/200" xmlns:ddl300="http://schemas.microsoft.com/analysisservices/2011/engine/300" xmlns:ddl300_300="http://schemas.microsoft.com/analysisservices/2011/engine/300/300" xmlns:ddl400="http://schemas.microsoft.com/analysisservices/2012/engine/400" xmlns:ddl400_400="http://schemas.microsoft.com/analysisservices/2012/engine/400/400" xmlns:ddl500="http://schemas.microsoft.com/analysisservices/2013/engine/500" xmlns:ddl500_500="http://schemas.microsoft.com/analysisservices/2013/engine/500/500">
		  <Object>
			  <DatabaseID>SIG_COL_LOGISTICA</DatabaseID>
			  <CubeID>MOVIMIENTO_POR_PROCESO_VEHICULO</CubeID>
			  <MeasureGroupID>MOV POR PROCESO VEHICULO</MeasureGroupID>
			  <PartitionID>MOV POR PROCESO VEHICULO 2022 09</PartitionID>
		  </Object>
		  <Type>ProcessFull</Type>
		  <WriteBackTableCreation>UseExisting</WriteBackTableCreation>
	  </Process>
	  <Process xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ddl2="http://schemas.microsoft.com/analysisservices/2003/engine/2" xmlns:ddl2_2="http://schemas.microsoft.com/analysisservices/2003/engine/2/2" xmlns:ddl100_100="http://schemas.microsoft.com/analysisservices/2008/engine/100/100" xmlns:ddl200="http://schemas.microsoft.com/analysisservices/2010/engine/200" xmlns:ddl200_200="http://schemas.microsoft.com/analysisservices/2010/engine/200/200" xmlns:ddl300="http://schemas.microsoft.com/analysisservices/2011/engine/300" xmlns:ddl300_300="http://schemas.microsoft.com/analysisservices/2011/engine/300/300" xmlns:ddl400="http://schemas.microsoft.com/analysisservices/2012/engine/400" xmlns:ddl400_400="http://schemas.microsoft.com/analysisservices/2012/engine/400/400" xmlns:ddl500="http://schemas.microsoft.com/analysisservices/2013/engine/500" xmlns:ddl500_500="http://schemas.microsoft.com/analysisservices/2013/engine/500/500">
		  <Object>
			  <DatabaseID>SIG_COL_LOGISTICA</DatabaseID>
			  <CubeID>MOVIMIENTO_POR_PROCESO_VEHICULO</CubeID>
			  <MeasureGroupID>MOV POR PROCESO VEHICULO 1</MeasureGroupID>
			  <PartitionID>MOV POR PROCESO VEHICULO 2022 09</PartitionID>
		  </Object>
		  <Type>ProcessFull</Type>
		  <WriteBackTableCreation>UseExisting</WriteBackTableCreation>
	  </Process>	  
	  
	  
	  
	  
	  <!--
  **********************************************************************************************************************
  -->	  
    <Process xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ddl2="http://schemas.microsoft.com/analysisservices/2003/engine/2" xmlns:ddl2_2="http://schemas.microsoft.com/analysisservices/2003/engine/2/2" xmlns:ddl100_100="http://schemas.microsoft.com/analysisservices/2008/engine/100/100" xmlns:ddl200="http://schemas.microsoft.com/analysisservices/2010/engine/200" xmlns:ddl200_200="http://schemas.microsoft.com/analysisservices/2010/engine/200/200" xmlns:ddl300="http://schemas.microsoft.com/analysisservices/2011/engine/300" xmlns:ddl300_300="http://schemas.microsoft.com/analysisservices/2011/engine/300/300" xmlns:ddl400="http://schemas.microsoft.com/analysisservices/2012/engine/400" xmlns:ddl400_400="http://schemas.microsoft.com/analysisservices/2012/engine/400/400" xmlns:ddl500="http://schemas.microsoft.com/analysisservices/2013/engine/500" xmlns:ddl500_500="http://schemas.microsoft.com/analysisservices/2013/engine/500/500">
      <Object>
        <DatabaseID>SIG_COL_LOGISTICA</DatabaseID>
        <CubeID>MOVIMIENTO_POR_PROCESO_VEHICULO</CubeID>
        <MeasureGroupID>MOV POR PROCESO VEHICULO</MeasureGroupID>
        <PartitionID>MOV POR PROCESO VEHICULO 2022 10</PartitionID>
      </Object>
      <Type>ProcessFull</Type>
      <WriteBackTableCreation>UseExisting</WriteBackTableCreation>
    </Process>
	  <Process xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ddl2="http://schemas.microsoft.com/analysisservices/2003/engine/2" xmlns:ddl2_2="http://schemas.microsoft.com/analysisservices/2003/engine/2/2" xmlns:ddl100_100="http://schemas.microsoft.com/analysisservices/2008/engine/100/100" xmlns:ddl200="http://schemas.microsoft.com/analysisservices/2010/engine/200" xmlns:ddl200_200="http://schemas.microsoft.com/analysisservices/2010/engine/200/200" xmlns:ddl300="http://schemas.microsoft.com/analysisservices/2011/engine/300" xmlns:ddl300_300="http://schemas.microsoft.com/analysisservices/2011/engine/300/300" xmlns:ddl400="http://schemas.microsoft.com/analysisservices/2012/engine/400" xmlns:ddl400_400="http://schemas.microsoft.com/analysisservices/2012/engine/400/400" xmlns:ddl500="http://schemas.microsoft.com/analysisservices/2013/engine/500" xmlns:ddl500_500="http://schemas.microsoft.com/analysisservices/2013/engine/500/500">
		  <Object>
			  <DatabaseID>SIG_COL_LOGISTICA</DatabaseID>
			  <CubeID>MOVIMIENTO_POR_PROCESO_VEHICULO</CubeID>
			  <MeasureGroupID>MOV POR PROCESO VEHICULO 1</MeasureGroupID>
			  <PartitionID>MOV POR PROCESO VEHICULO 2022 10</PartitionID>
		  </Object>
		  <Type>ProcessFull</Type>
		  <WriteBackTableCreation>UseExisting</WriteBackTableCreation>
	  </Process>
  <!--
  **********************************************************************************************************************
  -->
	  <Process xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ddl2="http://schemas.microsoft.com/analysisservices/2003/engine/2" xmlns:ddl2_2="http://schemas.microsoft.com/analysisservices/2003/engine/2/2" xmlns:ddl100_100="http://schemas.microsoft.com/analysisservices/2008/engine/100/100" xmlns:ddl200="http://schemas.microsoft.com/analysisservices/2010/engine/200" xmlns:ddl200_200="http://schemas.microsoft.com/analysisservices/2010/engine/200/200" xmlns:ddl300="http://schemas.microsoft.com/analysisservices/2011/engine/300" xmlns:ddl300_300="http://schemas.microsoft.com/analysisservices/2011/engine/300/300" xmlns:ddl400="http://schemas.microsoft.com/analysisservices/2012/engine/400" xmlns:ddl400_400="http://schemas.microsoft.com/analysisservices/2012/engine/400/400" xmlns:ddl500="http://schemas.microsoft.com/analysisservices/2013/engine/500" xmlns:ddl500_500="http://schemas.microsoft.com/analysisservices/2013/engine/500/500">
		  <Object>
			  <DatabaseID>SIG_COL_LOGISTICA</DatabaseID>
			  <CubeID>MOVIMIENTO_POR_PROCESO_VEHICULO</CubeID>
			  <MeasureGroupID>MOV POR PROCESO VEHICULO</MeasureGroupID>
			  <PartitionID>MOV POR PROCESO VEHICULO 2022 11</PartitionID>
		  </Object>
		  <Type>ProcessFull</Type>
		  <WriteBackTableCreation>UseExisting</WriteBackTableCreation>
	  </Process>
	  <Process xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ddl2="http://schemas.microsoft.com/analysisservices/2003/engine/2" xmlns:ddl2_2="http://schemas.microsoft.com/analysisservices/2003/engine/2/2" xmlns:ddl100_100="http://schemas.microsoft.com/analysisservices/2008/engine/100/100" xmlns:ddl200="http://schemas.microsoft.com/analysisservices/2010/engine/200" xmlns:ddl200_200="http://schemas.microsoft.com/analysisservices/2010/engine/200/200" xmlns:ddl300="http://schemas.microsoft.com/analysisservices/2011/engine/300" xmlns:ddl300_300="http://schemas.microsoft.com/analysisservices/2011/engine/300/300" xmlns:ddl400="http://schemas.microsoft.com/analysisservices/2012/engine/400" xmlns:ddl400_400="http://schemas.microsoft.com/analysisservices/2012/engine/400/400" xmlns:ddl500="http://schemas.microsoft.com/analysisservices/2013/engine/500" xmlns:ddl500_500="http://schemas.microsoft.com/analysisservices/2013/engine/500/500">
		  <Object>
			  <DatabaseID>SIG_COL_LOGISTICA</DatabaseID>
			  <CubeID>MOVIMIENTO_POR_PROCESO_VEHICULO</CubeID>
			  <MeasureGroupID>MOV POR PROCESO VEHICULO 1</MeasureGroupID>
			  <PartitionID>MOV POR PROCESO VEHICULO 2022 11</PartitionID>
		  </Object>
		  <Type>ProcessFull</Type>
		  <WriteBackTableCreation>UseExisting</WriteBackTableCreation>
	  </Process>
	  <!--
  **********************************************************************************************************************
  -->
	  <Process xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ddl2="http://schemas.microsoft.com/analysisservices/2003/engine/2" xmlns:ddl2_2="http://schemas.microsoft.com/analysisservices/2003/engine/2/2" xmlns:ddl100_100="http://schemas.microsoft.com/analysisservices/2008/engine/100/100" xmlns:ddl200="http://schemas.microsoft.com/analysisservices/2010/engine/200" xmlns:ddl200_200="http://schemas.microsoft.com/analysisservices/2010/engine/200/200" xmlns:ddl300="http://schemas.microsoft.com/analysisservices/2011/engine/300" xmlns:ddl300_300="http://schemas.microsoft.com/analysisservices/2011/engine/300/300" xmlns:ddl400="http://schemas.microsoft.com/analysisservices/2012/engine/400" xmlns:ddl400_400="http://schemas.microsoft.com/analysisservices/2012/engine/400/400" xmlns:ddl500="http://schemas.microsoft.com/analysisservices/2013/engine/500" xmlns:ddl500_500="http://schemas.microsoft.com/analysisservices/2013/engine/500/500">
		  <Object>
			  <DatabaseID>SIG_COL_LOGISTICA</DatabaseID>
			  <CubeID>MOVIMIENTO_POR_PROCESO_VEHICULO</CubeID>
			  <MeasureGroupID>MOV POR PROCESO VEHICULO</MeasureGroupID>
			  <PartitionID>MOV POR PROCESO VEHICULO 2022 12</PartitionID>
		  </Object>
		  <Type>ProcessFull</Type>
		  <WriteBackTableCreation>UseExisting</WriteBackTableCreation>
	  </Process>
	  <Process xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ddl2="http://schemas.microsoft.com/analysisservices/2003/engine/2" xmlns:ddl2_2="http://schemas.microsoft.com/analysisservices/2003/engine/2/2" xmlns:ddl100_100="http://schemas.microsoft.com/analysisservices/2008/engine/100/100" xmlns:ddl200="http://schemas.microsoft.com/analysisservices/2010/engine/200" xmlns:ddl200_200="http://schemas.microsoft.com/analysisservices/2010/engine/200/200" xmlns:ddl300="http://schemas.microsoft.com/analysisservices/2011/engine/300" xmlns:ddl300_300="http://schemas.microsoft.com/analysisservices/2011/engine/300/300" xmlns:ddl400="http://schemas.microsoft.com/analysisservices/2012/engine/400" xmlns:ddl400_400="http://schemas.microsoft.com/analysisservices/2012/engine/400/400" xmlns:ddl500="http://schemas.microsoft.com/analysisservices/2013/engine/500" xmlns:ddl500_500="http://schemas.microsoft.com/analysisservices/2013/engine/500/500">
		  <Object>
			  <DatabaseID>SIG_COL_LOGISTICA</DatabaseID>
			  <CubeID>MOVIMIENTO_POR_PROCESO_VEHICULO</CubeID>
			  <MeasureGroupID>MOV POR PROCESO VEHICULO 1</MeasureGroupID>
			  <PartitionID>MOV POR PROCESO VEHICULO 2022 12</PartitionID>
		  </Object>
		  <Type>ProcessFull</Type>
		  <WriteBackTableCreation>UseExisting</WriteBackTableCreation>
	  </Process>

	  <!--
  **********************************************************************************************************************
  -->

  </Parallel>
</Batch>






