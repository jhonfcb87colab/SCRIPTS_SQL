


-----SIG RETAL
---				RetailWebR4
---				LSTSSRET,9960

SELECT * FROM GUIDE WITH(NOLOCK)
WHERE NUMBER=9187592506



SELECT G.NUMBER,
ID.PaymentFormId,
FP.[NOMBRE_FORMAPAGO]
	FROM [RetailWebR4].[dbo].INVOICE AS I WITH(NOLOCK)
	INNER JOIN [RetailWebR4].[dbo].InvoiceDetail AS ID WITH(NOLOCK) ON ID.InvoiceId = I.Id
	INNER JOIN [RetailWebR4].[dbo].Guide AS G WITH(NOLOCK) ON G.InvoiceDetailId = ID.Id
	INNER JOIN [RetailWebR4].[dbo].Shipping AS S WITH(NOLOCK) ON S.GuideId = g.ID
	inner join [RetailWebR4].[dbo].[Piece] AS PIE WITH(NOLOCK) ON PIE.[ShippingId]=S.Id
	LEFT JOIN PARAMETROS.[dbo].[FORMAPAGO] FP (NOLOCK) ON FP.ID_PAIS=1 AND FP.ID_FORMAPAGO=ID.PaymentFormId 
	WHERE g.NUMBER=9187592506
		and ID.PaymentFormId!=2 and I.[state]=1 AND S.[ReceiverCountryId] = 1






