



'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'	NAME: 		CreateXMLSimple
'	DESCRIPTION:	Creates XML for basic graph (horizontal bar chart) 
'	ATTRIBUTES:	releaseName	-	name of current release
'			sql		-	query to execute
'			outputXML	-	location for XML file
'			customJIRAQuery	-	common component of JIRA query
'			graphTitle	-	title to give graph
'			xTitle		-	title for x-axis
'			yTitle		-	title for y-axis
'
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Public Function CreateXMLSimple(byVal releaseName, byVal sql, byVal outputXML, byVal customJIRAQuery, byVal graphTitle, byVal xTitle, byVal yTitle)

	Dim oCon, oRs, fileObject, arrValues, newFile, colCounter, url

	Set oCon = WScript.CreateObject("ADODB.Connection")
	Set oRs = WScript.CreateObject("ADODB.Recordset")

	'	Open db connection
	oCon.Open GetSQLConnectionDetails

	'	Execute SQL
	Set oRs = oCon.Execute(sql)
	arrValues = oRs.GetRows()

	Set fileObject = CreateObject("Scripting.FileSystemObject")

	Set newFile = FileObject.CreateTextFile(outputXML, True)

	newFile.WriteLine("<chart caption='" & releaseName & " " & graphTitle & "'")
	newFile.WriteLine("  bgColor='FFFFFF' showBorder='0' canvasbgColor='FFFFFF'")
	newFile.WriteLine("  canvasBorderColor='CDC8B1' showAlternateVGridColor='1'")
	newFile.WriteLine("   xAxisName='" & xTitle & "' yAxisName='" & yTitle & "'>")

	For colCounter = 0 to UBound(arrValues, 2)	
		
		url = GetURLValue(graphTitle, arrValues(0, colCounter), customJIRAQuery)
		newFile.WriteLine("    <set label='" & RemoveCharacters(arrValues(0, colCounter), "'") & "' value='"& arrValues(1, colCounter) &"' " & url & "/>")
	Next

	newFile.WriteLine("</chart>")
	newFile.Close

	Set outputFile = nothing
	Set newFile = nothing
	
	Set oRs = nothing
	oCon.Close
	Set oCon = Nothing

End Function




'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'	NAME: 		CreateXMLSimpleWithCustomFields
'	DESCRIPTION:	Creates XML for basic graph (horizontal bar chart) 
'	ATTRIBUTES:	releaseName	-	name of current release
'			sql		-	query to execute
'			outputXML	-	location for XML file
'			customJIRAQuery	-	common component of JIRA query
'			graphTitle	-	title to give graph
'			xTitle		-	title for x-axis
'			yTitle		-	title for y-axis
'
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Public Function CreateXMLSimpleWithCustomFields(byVal releaseName, byVal sql, byVal outputXML, byVal customJIRAQuery, byVal graphTitle, byVal xTitle, byVal yTitle)

	Dim oCon, oRs, fileObject, arrValues, newFile, colCounter, url
	Dim fieldNames()

	Set oCon = WScript.CreateObject("ADODB.Connection")
	Set oRs = WScript.CreateObject("ADODB.Recordset")

	'	Open db connection
	oCon.Open GetSQLConnectionDetails

	'	Execute SQL
	Set oRs = oCon.Execute(sql)

	Set fileObject = CreateObject("Scripting.FileSystemObject")

	Set newFile = FileObject.CreateTextFile(outputXML, True)

	newFile.WriteLine("<chart caption='" & releaseName & " " & graphTitle & "'")
	newFile.WriteLine("  bgColor='FFFFFF' showBorder='0' canvasbgColor='FFFFFF'")
	newFile.WriteLine("  canvasBorderColor='CDC8B1' showAlternateVGridColor='1'")
	newFile.WriteLine("   xAxisName='" & xTitle & "' yAxisName='" & yTitle & "'>")
	
	Select Case UCase(RemoveCharacters(graphTitle, " -/"))

		Case "ISSUESINFLIGHT"
		
			newFile.WriteLine("    <set label='Inflight' Value='" & oRs.Fields(0).Value & "' " & customJIRAQuery & "status%20!=%20Closed%20and%20type%20=%20Bug" & "' />")
			newFile.WriteLine("    <set label='Closed' Value='" & oRs.Fields(1).Value & "' " & customJIRAQuery & "status%20=%20Closed%20and%20type%20=%20Bug" & "' />")
		
		Case "UNRESOLVEDISSUESEVERITY"
		
			newFile.WriteLine("    <set label='Low' Value='" & oRs.Fields(0).Value & "' " & customJIRAQuery & "status%20!=%20Closed%20and%20type%20=%20Bug%20AND%20cf[11405]%20=%20Low" & "' />")			
			newFile.WriteLine("    <set label='Medium' Value='" & oRs.Fields(1).Value & "' " & customJIRAQuery & "status%20!=%20Closed%20and%20type%20=%20Bug%20AND%20cf[11405]%20=%20Med" & "' />")
			newFile.WriteLine("    <set label='High' Value='" & oRs.Fields(2).Value & "' " & customJIRAQuery & "status%20!=%20Closed%20and%20type%20=%20Bug%20AND%20cf[11405]%20=%20High" & "' />")
	
	End Select		

	newFile.WriteLine("</chart>")
	newFile.Close

	Set outputFile = nothing
	Set newFile = nothing
	
	Set oRs = nothing
	oCon.Close
	Set oCon = Nothing

End Function




'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'	NAME: 		CreateXMLStackedBar
'	DESCRIPTION:	Creates XML for stacked graph (horizontal bar chart) 
'	ATTRIBUTES:	releaseName	-	name of current release
'			sql		-	query to execute
'			outputXML	-	location for XML file
'			customJIRAQuery	-	common component of JIRA query
'			graphTitle	-	title to give graph
'			xTitle		-	title for x-axis
'			yTitle		-	title for y-axis
'			valueType	-	sub-sections title (e.g. Status)
'			valuesList	-	list of sub-sections (e.g. Status values)
'
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Public Function CreateXMLStackedBar(byVal releaseName, byVal sql, byVal outputXML, byVal customJIRAQuery, byVal graphTitle, byVal xTitle, byVal yTitle, byVal valueType, byVal valuesList)

	Dim oCon, oRs, fileObject, arrValues, newFile, colCounter, url, catCounter, arrStatus, numCategories, currCategory

	'	Initialise variables
	arrStatus = split(valuesList, "*")
	numCategories = 0

	Set oCon = WScript.CreateObject("ADODB.Connection")
	Set oRs = WScript.CreateObject("ADODB.Recordset")

	'	Open db connection
	oCon.Open GetSQLConnectionDetails

	'	Execute SQL
	Set oRs = oCon.Execute(sql)
	arrValues = oRs.GetRows()

	Set fileObject = CreateObject("Scripting.FileSystemObject")

	Set newFile = FileObject.CreateTextFile(outputXML, True)

	newFile.WriteLine("<chart caption='" & releaseName & " " & graphTitle & "'")
	newFile.WriteLine("  bgColor='FFFFFF' showBorder='0' canvasbgColor='FFFFFF'")
	newFile.WriteLine("  canvasBorderColor='CDC8B1' showAlternateVGridColor='1' showSum='1' showValues='0'")
	newFile.WriteLine("   xAxisName='" & xTitle & "' yAxisName='" & yTitle & "'>")

	'	Write values for categories
	newFile.WriteLine("<categories>")

	prevCategory = arrValues(0,0)

	'	Loop through each category
	For catCounter = 0 to UBound(arrValues, 2)	
		
		currCategory = arrValues(0, catCounter)

		if catCounter = 0 OR prevCategory <> currCategory Then
			newFile.WriteLine("<category label='" & currCategory & "'/>")
			numCategories = numCategories + 1
		End If

		prevCategory = currCategory
	Next

	newFile.WriteLine("</categories>")

	'	Write values for datasets
	'	Loop through each status value
	For statusCounter = 0 to UBound(arrStatus, 1)	

		newFile.WriteLine("<dataset seriesName='" & arrStatus(statusCounter) & "'>")

		prevCategory = arrValues(0,0)
		matchFound = False
		
		'	Loop through each row
		For catCounter = 0 to UBound(arrValues, 2)	
		
			'	Check if status value matches
			currCategory = arrValues(0, catCounter)
			
			'	If moved to new Category, set matchFound = False and write out results for previous
			If prevCategory <> currCategory Then
				'	If no match found, print out 0
				If matchFound = False Then
				
					'	Get URL
					url = GetURLValue(graphTitle, xTitle & "*" & currCategory & "*" & valueType & "*" & arrStatus(statusCounter), customJIRAQuery)
					newFile.WriteLine("    <set value='0' " & url & "/>")	

				'	Match was already found, line was already printed - set matchFound to False for next category
				Else
					matchFound = False
				End If	
			End If

			
			if matchFound = False AND arrValues(1, catCounter) = arrStatus(statusCounter) Then 
				'	Get URL
				url = GetURLValue(graphTitle, xTitle & "*" & currCategory & "*" & valueType & "*" & arrStatus(statusCounter), customJIRAQuery)
				newFile.WriteLine("    <set value='" & RemoveCharacters(arrValues(2, catCounter), "'") &"' " & url & "/>")		
				matchFound = True
			End If

			prevCategory = currCategory
		Next
	
		newFile.WriteLine("</dataset>")
	Next


	newFile.WriteLine("</chart>")
	newFile.Close

	Set outputFile = nothing
	Set newFile = nothing
	
	Set oRs = nothing
	oCon.Close
	Set oCon = Nothing

End Function


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'	NAME: 		CreateXMLLine
'	DESCRIPTION:	Creates XML for basic graph (line chart) 
'	ATTRIBUTES:	releaseName	-	name of current release
'			sql		-	query to execute
'			outputXML	-	location for XML file
'			customJIRAQuery	-	common component of JIRA query
'			graphTitle	-	title to give graph
'			xTitle		-	title for x-axis
'			yTitle		-	title for y-axis
'
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Public Function CreateXMLLine(byVal releaseName, byVal sql, byVal outputXML, byVal customJIRAQuery, byVal graphTitle, byVal xTitle, byVal yTitle)

	Dim oCon, oRs, fileObject, arrValues, newFile, colCounter, firstCategory, currCategory, dataSetCounter

	Set oCon = CreateObject("ADODB.Connection")
	Set oRs = CreateObject("ADODB.Recordset")

	'	Open db connection
	oCon.Open GetSQLConnectionDetails

	'	Execute SQL
	Set oRs = oCon.Execute(sql)
	arrValues = oRs.GetRows()

	Set fileObject = CreateObject("Scripting.FileSystemObject")

	Set newFile = FileObject.CreateTextFile(outputXML, True)

	newFile.WriteLine("<chart caption='" & releaseName & " " & graphTitle & "'")
	newFile.WriteLine("  bgColor='FFFFFF' showBorder='0' canvasbgColor='FFFFFF'")
	newFile.WriteLine("  canvasBorderColor='CDC8B1' showAlternateVGridColor='1'")
	newFile.WriteLine("   xAxisName='" & xTitle & "' yAxisName='" & yTitle & "'>")

	'	Write values for categories
	newFile.WriteLine("<categories>")

	'	Get first category value
	firstCategory = arrValues(1,0)

	'	Loop through each release
	For catCounter = 0 to UBound(arrValues, 2)

		currCategory = arrValues(1, catCounter)

		'	Check if match for first category (stop writing out categories)
		If currCategory = firstCategory Then
			If catCounter = 0 Then
				newFile.WriteLine("<category label='" & currCategory & "'/>")
				numCategories = numCategories + 1
			Else
				Exit For
			End If
		Else
			newFile.WriteLine("<category label='" & currCategory & "'/>")
			numCategories = numCategories + 1
		End If

	Next

	newFile.WriteLine("</categories>")

	'	Get all Dataset values
	dataSetCounter = 1

	For lineValues = 0 to UBound(arrValues, 2) Step numCategories

		'	Write out each data set series name
		newFile.WriteLine("<dataset seriesName='" & arrValues(0, lineValues) & "'>")

		'	Write out each data set value
		For valueCounter = 0 + lineValues to (dataSetCounter * numCategories) - 1
			newFile.WriteLine("<set value='" & arrValues(2, valueCounter) & "'/>")
		Next

		newFile.WriteLine("</dataset>")

		dataSetCounter = dataSetCounter + 1
	Next

	newFile.WriteLine("</chart>")
	newFile.Close

	Set outputFile = nothing
	Set newFile = nothing
	
	Set oRs = nothing
	oCon.Close
	Set oCon = Nothing

End Function


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'	NAME: 		CreateXMLStackedChart
'	DESCRIPTION:	Creates XML for stacked bar chart (vertical)
'	ATTRIBUTES:	releaseName	-	name of current release
'			sql		-	query to execute
'			outputXML	-	location for XML file
'			customJIRAQuery	-	common component of JIRA query
'			graphTitle	-	title to give graph
'			xTitle		-	title for x-axis
'			yTitle		-	title for y-axis
'
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Public Function CreateXMLStackedChart(byVal releaseName, byVal sql, byVal outputXML, byVal customJIRAQuery, byVal graphTitle, byVal xTitle, byVal yTitle)

	Dim oCon, oRs, fileObject, arrValues, newFile, colCounter, firstCategory, currCategory, dataSetCounter, dataSetSubCounter

	Set oCon = CreateObject("ADODB.Connection")
	Set oRs = CreateObject("ADODB.Recordset")

	'	Open db connection
	oCon.Open GetSQLConnectionDetails

	'	Execute SQL
	Set oRs = oCon.Execute(sql)
	arrValues = oRs.GetRows()

	Set fileObject = CreateObject("Scripting.FileSystemObject")

	Set newFile = FileObject.CreateTextFile(outputXML, True)

	newFile.WriteLine("<chart caption='" & releaseName & " " & graphTitle & "'")
	newFile.WriteLine("  bgColor='FFFFFF' showBorder='0' canvasbgColor='FFFFFF'")
	newFile.WriteLine("  canvasBorderColor='CDC8B1' showAlternateVGridColor='1' showValues='0'")
	newFile.WriteLine("   xAxisName='" & xTitle & "' yAxisName='" & yTitle & "'>")

	'	Write values for categories
	newFile.WriteLine("<categories>")

	'	Get first category value
	firstCategory = arrValues(1,0)

	'	Loop through each release
	For catCounter = 0 to UBound(arrValues, 2)

		currCategory = arrValues(1, catCounter)

		'	Check if match for first category (stop writing out categories)
		If currCategory = firstCategory Then
			If catCounter = 0 Then
				newFile.WriteLine("<category label='" & currCategory & "'/>")
				numCategories = numCategories + 1
			Else
				Exit For
			End If
		Else
			newFile.WriteLine("<category label='" & currCategory & "'/>")
			numCategories = numCategories + 1
		End If

	Next

	newFile.WriteLine("</categories>")

	'	Get count of dataset values
	dataSetCounter = 1
	prevDataSetValue = arrValues(2, 0)

	For counter = 0 to UBound(arrValues, 2)

		nextDataSetValue = arrValues(2, counter)

		If nextDataSetValue <> prevDataSetValue Then
			dataSetCounter = dataSetCounter + 1
		End If

		prevDataSetValue = nextDataSetValue
	Next

	'	Get all Dataset values

	dataSetSubCounter = 1

	'	Loop for each header dataset
'	For dataSetCounter = 0 to dataSetCounter


	'	Loop through each data set sub value
	For lineValues = 0 to UBound(arrValues, 2) Step numCategories

		'	Write out data set header
		If (lineValues) Mod (2*numCategories) = 0 Then
			newFile.WriteLine("<dataset>")
		End If
		
		'	Check for even/odd dataset counter
		If (lineValues Mod (2*numCategories)) = 0 Then
			colorVal = "015887"
		Else
			colorVal = "DA3608"
		End If

		'	Write out each data set series name
		newFile.WriteLine("<dataset seriesName='" & arrValues(2, lineValues) & " (" & arrValues(0, lineValues) & ")' color='" & colorVal & "'>")

		'	Write out each data set value
		For valueCounter = 0 + lineValues to (dataSetSubCounter * numCategories) - 1
			newFile.WriteLine("<set value='" & arrValues(3, valueCounter) & "'/>")
		Next

		newFile.WriteLine("</dataset>")

		dataSetSubCounter = dataSetSubCounter + 1

		'	Write out data set end
		If (lineValues) Mod (2*numCategories) <> 0 Then			
			newFile.WriteLine("</dataset>")
		End If
	Next

'	Next

	newFile.WriteLine("</chart>")
	newFile.Close

	Set outputFile = nothing
	Set newFile = nothing
	
	Set oRs = nothing
	oCon.Close
	Set oCon = Nothing

End Function


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'	NAME: 		GetURLValue
'	DESCRIPTION:	Gets the value of the URL, if it exists 
'	ATTRIBUTES:	graphTitle	-	graph which URL is for
'			valueToCheck	-	reference for the URL
'			customJIRAQuery	-	first section of query (common to project)
'
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Public Function GetURLValue(byVal graphTitle, byVal valueToCheck, byVal customJIRAQuery)

	Select Case UCase(RemoveCharacters(graphTitle, " -/()"))

		Case "INFLIGHTDEFECTSBYASSIGNEE", "INFLIGHTISSUESBYASSIGNEE"

			SOEID = GetSOEID(valueToCheck)

			'	If SOEID is known for user, return URL, if SOEID is unassigned, return URL, otherwise return blank string
			Select Case (SOEID)

				Case "UNASSIGNED"
					GetURLValue = customJIRAQuery & "assignee+is+EMPTY+AND+status+not+in+%28Closed%29'"

				Case ""
					GetURLValue = ""

				Case Else
					GetURLValue = customJIRAQuery & "assignee+%3D+" & SOEID & "+AND+status+not+in+%28Closed%29'"

			End Select

		Case "INFLIGHTDEFECTSBYASSIGNEEBLOCKER"

			SOEID = GetSOEID(valueToCheck)

			'	If SOEID is known for user, return URL, if SOEID is unassigned, return URL, otherwise return blank string
			Select Case (SOEID)

				Case "UNASSIGNED"
					GetURLValue = customJIRAQuery & "assignee+is+EMPTY+AND+priority+%3D+Blocker+AND+status+not+in+%28Closed%29'"

				Case ""
					GetURLValue = ""

				Case Else
					GetURLValue = customJIRAQuery & "assignee+%3D+" & SOEID & "+AND+priority+%3D+Blocker+AND+status+not+in+%28Closed%29'"

			End Select	

		Case "ISSUEOWNER"

			SOEID = GetSOEID(valueToCheck)

			'	If SOEID is known for user, return URL, if SOEID is unassigned, return URL, otherwise return blank string
			Select Case (SOEID)

				Case ""
					GetURLValue = ""

				Case Else
					GetURLValue = customJIRAQuery & "%22Issue+Owner%22+%3D+" & SOEID & "'"

			End Select

		Case "ISSUESTATUS"
			valueToCheck = Replace(valueToCheck, " ", "+")
			GetURLValue = customJIRAQuery & "status+%3D+%22" & valueToCheck & "%22'"

		Case "ISSUETYPE"
			valueToCheck = Replace(valueToCheck, " ", "+")
			GetURLValue = customJIRAQuery & "issuetype+%3D+%22" & valueToCheck & "%22'"

		Case "UNRESOLVEDPRIORITY", "UNRESOLVEDISSUEPRIORITY2"
			valueToCheck = Replace(valueToCheck, " ", "+")
			GetURLValue = customJIRAQuery & "priority+%3D+" & valueToCheck & "+AND+status+in+%28Open%2C+%22In+Progress%22%2C+Reopened%2C+Blocked%2C+%22Pending+Development%22%2C+%22Work+In+Progress%22%29'"

		Case "ROOTCAUSE"
			valueToCheck = Replace(valueToCheck, " ", "+")
			GetURLValue = customJIRAQuery & "%22*Root+Cause%22+%3D+%22" & valueToCheck & "%22'"

		Case "ISSUECOMPONENTSTATUS"
			valueToCheck = Replace(valueToCheck, " ", "+")
			arrValues = split(valueToCheck, "*")
			GetURLValue = customJIRAQuery & arrValues(0) & "+%3D+%22" & arrValues(1) & "%22+AND+" & arrValues(2) & "+%3D+%22" & arrValues(3) & "%22'"

		Case "UNRESOLVEDISSUEPRIORITY"
			valueToCheck = Replace(valueToCheck, " ", "+")
			arrValues = split(valueToCheck, "*")
			GetURLValue = customJIRAQuery & arrValues(0) & "+%3D+%22" & arrValues(1) & "%22+AND+" & arrValues(2) & "+%3D+%22" & arrValues(3) & "%22'"

		Case "CLOSEDISSUESBYOWNERSINCE0812"

			SOEID = GetSOEID(valueToCheck)

			'	If SOEID is known for user, return URL, if SOEID is unassigned, return URL, otherwise return blank string
			Select Case (SOEID)

				Case "UNASSIGNED"
					GetURLValue = customJIRAQuery & "issuetype=Bug+AND+status=Closed+AND+cf[18371]+is+EMPTY'"

				Case ""
					GetURLValue = ""

				Case Else
					GetURLValue = customJIRAQuery & "issuetype=Bug+AND+status=Closed+AND+cf[18371]=" & SOEID & "'"

			End Select

	End Select

End Function





'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'	NAME: 		GetReleaseInfo
'	DESCRIPTION:	Gets release info in correct format for reporting
'	ATTRIBUTES:	release (in format Release 2.0.4)
'
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Public Function GetReleaseInfo(byVal release,  byVal formatRequired)

	Select Case UCase(formatRequired)

		Case "JIRAQUERY"
			'	Get from "Release 2.0.4" to "Release+2.0.5"
			If InStr(UCase(release), "CURRENT") > 0 Then
				GetReleaseInfo = "_" & "CurrentRelease" & "_"
			Else			
				GetReleaseInfo = Replace(release, " ", "+")
			End If

		Case "XMLPATH"
			'	Get from "Release 2.0.4" to "_2_0_4_"
			
			If InStr(UCase(release), "CURRENT") > 0 Then
				GetReleaseInfo = "_" & "CurrentRelease" & "_"
			Else
				GetReleaseInfo = "_" & Replace(Right(release, 5), ".", "_") & "_"
			End If

		Case "HTMLPATH"
			'	Get from "Release 2.0.4" to "2_0_4"
			If InStr(UCase(release), "CURRENT") > 0 Then
				GetReleaseInfo = "CurrentRelease"
			Else			
				GetReleaseInfo = Replace(Right(release, 5), ".", "_")		
			End If

	End Select



End Function


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'	NAME: 		GetSQLConnectionDetails
'	DESCRIPTION:	Gets Connection Details for SQL
'	ATTRIBUTES:	None
'
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Public Function GetSQLConnectionDetails()

	GetSQLConnectionDetails = "Driver={Microsoft ODBC for Oracle}; " & _
         "CONNECTSTRING=(DESCRIPTION=" & _
         "(ADDRESS=(PROTOCOL=TCP)" & _
         "(HOST=mwdpdb01c.nam.nsroot.net)(PORT=1722))" & _
         "(CONNECT_DATA=(SID=steorac1))); Uid=XXXX;Pwd=XXXX;"

End Function





'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'	NAME: 		GetYesterday
'	DESCRIPTION:	Gets yesterday's date in the DD/MM/YYYY format
'	ATTRIBUTES:	None
'
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Public Function GetYesterday()

	yesterday = DateAdd("d", "-1", Now)


	'	Check if yesterday was a weekend day
	'	Sunday
	If Weekday(yesterday) = 1 Then
		yesterday = DateAdd("d", "-3", Now)
	End If

	'	Saturday
	If Weekday(yesterday) = 7 Then
		yesterday = DateAdd("d", "-2", Now)
	End If
 
'	msgbox(Day(yesterday) & "/" & Month(yesterday) & "/" & Year(yesterday))

'	GetYesterday = Day(yesterday) & "/" & Month(yesterday) & "/" & Year(yesterday)

	GetYesterday = Month(yesterday) & "/" & Day(yesterday) & "/" & Year(yesterday)


End Function

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'	NAME: 		GetTimeDateStamp
'	DESCRIPTION:	Script to generate Time Date Stamp string 
'	ATTRIBUTES: 	-
'
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Public Function GetTimeDateStamp

	Dim arrDays, minutes

	'	Get date/time in correct format
	arrDays = Array("","Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday")

	'	Format minutes
	minutes = Minute(time)

	if (Len(minutes) = 1) Then
		minutes = "0" & minutes
	End If

	GetTimeDateStamp = "Generated on " & arrDays(Weekday(now)) & " " & MonthName(month(now)) & " " & Day(now) & " at " & Hour(time) & ":" & minutes & " GMT / " & Int(Hour(time) - 5) & ":" & minutes & " EST"

End Function

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'	NAME: 		UpdateTimeDateStamp 
'	DESCRIPTION:	Script to create  
'	ATTRIBUTES: 	outputHTMLFileLocation	-	location of input/output HTML file
'
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Public Function UpdateTimeDateStamp (byVal outputHTMLFileLocation)
		Dim FileObject, newFile, oldFile, arrDays, timeDateStamp, tempFileLocation

		timeDateStamp = GetTimeDateStamp

		'	Setup temporary file location for copy of existing file
		tempFileLocation = "C:\tempHTML.xml"

		Set FileObject = CreateObject("Scripting.FileSystemObject")
		
		'	Open existing file for reading
		Set oldFile = FileObject.OpenTextFile(outputHTMLFileLocation)

		'	Create temp file for creation of new file
		Set newFile = FileObject.CreateTextFile(tempFileLocation, True)

		'	Loop through each row in the old file
		Do Until oldFile.AtEndOfStream

			'	Get current line from existing file
			valueHolder = oldFile.ReadLine

			If InStr(valueHolder, "Generated") > 0 Then
				NewFile.WriteLine(timeDateStamp)
			Else
				NewFile.WriteLine(valueHolder)
			End If

	Loop

	'	Close file
      NewFile.Close

	  '	Copy file to final location
	  call FileObject.CopyFile(tempFileLocation, outputHTMLFileLocation)

End Function

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'	NAME: 		GetSOEID
'	DESCRIPTION:	Gets the value of the SOEID for that user, if it exists 
'	ATTRIBUTES:	userString -	name of user to get SOEID for
'
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Public Function GetSOEID(byVal userString)

	Dim SOEID
	
	Dim oCon, oRs, arrValues, newFile, colCounter, url

	Set oCon = WScript.CreateObject("ADODB.Connection")
	Set oRs = WScript.CreateObject("ADODB.Recordset")

	'	Open db connection
	oCon.Open GetSQLConnectionDetails

	sql = "SELECT USER_NAME from JIRA.cwd_user where Display_Name = '" & userString & "'"

	'	Execute SQL
	Set oRs = oCon.Execute(sql)	
	
	GetSOEID = oRs.Fields(0).Value	


End Function


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'	NAME: 		GetYesterdayLong
'	DESCRIPTION:	Gets yesterday's date in the DD - MM - YY format
'	ATTRIBUTES:	None
'
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Public Function GetYesterdayLong()

	yesterday = DateAdd("d", "-1", Now)
 
	'	Check if yesterday was a weekend day
	'	Sunday
	If Weekday(yesterday) = 1 Then
		yesterday = DateAdd("d", "-3", Now)
	End If

	'	Saturday
	If Weekday(yesterday) = 7 Then
		yesterday = DateAdd("d", "-2", Now)
	End If

	GetYesterdayLong = Day(yesterday) & "-" & MonthName(Month(yesterday)) & "-" & Right(Year(yesterday), 2)

End Function


''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'		NAME:        RemoveCharacters   
'       DESCRIPTION: Removes the specified characters from the string
'       ATTRIBUTES:  text 				- text to remove specified characters from
'					 charToRemove 		- specified character(s) which are to be removed from the text 
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Public Function RemoveCharacters (byVal strToUpdate, byVal charsToRemove)

	Dim numCharsToRemove, countCharsToRemove, countCharsToCombine, currentCharToRemove, stringArray, newString

	'	Confirm string to be updated is not blank
	If strToUpdate <> "" Then

		'	Find number of characters to be removed (one or many)
		numCharsToRemove = len(charsToRemove)
	
		'	Loop through each character to be removed
		For countCharsToRemove = 1 to numCharsToRemove
	
			'	Determine current character to remove
			If numCharsToRemove = 1 Then
				currentCharToRemove = charsToRemove
			Else
				currentCharToRemove = mid(charsToRemove, countCharsToRemove, 1)
			End If
		
			'	Split string into array of strings, having removed requred character
			stringArray = split(strToUpdate,currentCharToRemove,-1,1)
		
			'	Combine each part without the removed characters
			For countCharsToCombine = 0 To UBound(stringArray)
				newString = newString & stringArray(countCharsToCombine)
			Next
	
			'	update variables
			strToUpdate = newString
			newString = ""
		Next
	
	End If

	'	Return string with required characters removed
	RemoveCharacters = strToUpdate
End Function

