
'QC connection parameters
dim qc, URL, Domain, Project, UserID, Password
set qc = nothing
URL = "https://qc.nam.nsroot.net:450/qcbin"
Domain = "EQUITIES"
Project = "Derivatives_QA"
UserId = "xxxxxx"
Password = "xxxxx"

'---------------------------------------------------------------------------------------------------
' FUNCTION: QC_Start
' DESCRIPTION:
' start a connection with QC
' return true is succeed, otherwise false
'---------------------------------------------------------------------------------------------------
function QC_Start()
  'OLE object name: TDAPIOLELib.TDConnection does not work
  'TDAPIOLE80.TDConnection.1 need to be used
  set qc = CreateObject("TDAPIOLE80.TDConnection.1")
  qc.InitConnectionEx Url

  qc.Login UserID, Password
  if not qc.LoggedIn then
    QC_Start = false
    exit function
  end if

  qc.Connect Domain, Project
  if not qc.Connected then
    QC_Start = false
    exit function
  end if

  QC_Start = true
end function

'---------------------------------------------------------------------------------------------------
' FUNCTION: QC_Start
' DESCRIPTION:
' end a connection with QC
'---------------------------------------------------------------------------------------------------
sub QC_End
  if not qc is nothing then
    qc.Disconnect
  end if
end sub

'---------------------------------------------------------------------------------------------------
'global array to store tc count
'---------------------------------------------------------------------------------------------------
'each element will be an array[name,count]
redim TCCount(0,0)

'---------------------------------------------------------------------------------------------------
' FUNCTION: Set_TCCount
' DESCRIPTION:
' set global array TCCount
' with the test case count calculation
' by the test plan folder path
'---------------------------------------------------------------------------------------------------
function Set_TCCount(TestPlanPath)
  set tree = qc.TreeManager
  set folder = tree.NodeByPath("Subject\" + TestPlanPath)
  
  rootCount = getTCCount(folder, false)
  
  if folder.count = 0 and rootCount = 0 then
    Set_TCCount = false
    exit function
  end if

  prjDim = folder.count - 1
  if rootCount > 0 then prjDim = prjDim + 1
  redim TCCount(prjDim, 1)
  
  prjIndex = 0
  if rootCount > 0 then
    TCCount(prjIndex, 0) = "To be allocated"
    TCCount(prjIndex, 1) = rootCount
    prjIndex = prjIndex + 1
  end if
  
  for i = 1 to folder.Count
    set child = folder.Child(i)
    TCCount(prjIndex, 0) = child.name
    TCCount(prjIndex, 1) = getTCCount(child, true)
    prjIndex = prjIndex + 1
  next
  Set_TCCount = true
end function

function getTCCount(nodeFolder, includeChilds)
  set tf = nodeFolder.TestFactory
  set l = tf.NewList("")
  result = l.Count
  if includeChilds then
    for i = 1 to nodeFolder.Count
      set c = nodeFolder.Child(i)
      result = result + getTCCount(c, true)
    next
  end if
  getTCCount = result
end function

'---------------------------------------------------------------------------------------------------
'global variables to store tc creation count
'---------------------------------------------------------------------------------------------------
'each element will be an array[name,count-by-interval(3m,6m,12m,24m,72)]
redim TCCountCreation(0,0)
dim TCCountCreationSeries(4)
TCCountCreationSeries(0) = "3 Months"
TCCountCreationSeries(1) = "6 Months"
TCCountCreationSeries(2) = "12 Months"
TCCountCreationSeries(3) = "24 Months"
TCCountCreationSeries(4) = "72 Months"
Dim result3m, result6m, result12m, result24m, result72m
Dim month3, month6, month12, month24, month72
month3 = DateAdd ("m", -3, Date)
month6 = DateAdd ("m", -6, Date)
month12 = DateAdd ("m", -12, Date)
month24 = DateAdd ("m", -24, Date)
month72 = DateAdd ("m", -72, Date)

'variables for last execution count for test cases
Dim tcNeverExecuted
redim TCCountExecution(0,0)
dim TCCountExecutionSeries(5)
TCCountExecutionSeries(0) = "3 Months"
TCCountExecutionSeries(1) = "6 Months"
TCCountExecutionSeries(2) = "12 Months"
TCCountExecutionSeries(3) = "24 Months"
TCCountExecutionSeries(4) = "72 Months"
TCCountExecutionSeries(5) = "Never Executed"

'---------------------------------------------------------------------------------------------------
' FUNCTION: Set_TCCountCreation
' DESCRIPTION:
' set global array TCCountCreation
' with the test case count by time interval (3m,6m,12m,24m,72m) calculation
' by the test plan folder path
'---------------------------------------------------------------------------------------------------
function Set_TCCountCreation(TestPlanPath)
  set tree = qc.TreeManager
  set folder = tree.NodeByPath("Subject\" + TestPlanPath)
  
  getTCCountCreationStart
  getTCCountCreation folder, false
  
  if folder.count = 0 and result3m = 0 and result6m = 0 and result12m = 0 and result24m = 0 and result72m = 0 then
    Set_TCCountCreation = false
    exit function
  end if

  prjDim = folder.count - 1
  if result3m > 0 or result6m > 0 or result12m > 0 or result24m > 0 or result72m > 0 then prjDim = prjDim + 1
  redim TCCountCreation(prjDim, 5)
  
  prjIndex = 0
  if result3m > 0 or result6m > 0 or result12m > 0 or result24m > 0 or result72m > 0 then
    TCCountCreation(prjIndex, 0) = "To be allocated"
    TCCountCreation(prjIndex, 1) = result3m
    TCCountCreation(prjIndex, 2) = result6m
    TCCountCreation(prjIndex, 3) = result12m
    TCCountCreation(prjIndex, 4) = result24m
    TCCountCreation(prjIndex, 5) = result72m
    prjIndex = prjIndex + 1
  end if
  
  for i = 1 to folder.Count
    set child = folder.Child(i)
    TCCountCreation(prjIndex, 0) = child.name
    getTCCountCreationStart
    getTCCountCreation child, true
    TCCountCreation(prjIndex, 1) = result3m
    TCCountCreation(prjIndex, 2) = result6m
    TCCountCreation(prjIndex, 3) = result12m
    TCCountCreation(prjIndex, 4) = result24m
    TCCountCreation(prjIndex, 5) = result72m
    prjIndex = prjIndex + 1
  next
  Set_TCCountCreation = true
end function

function getTCCountCreationStart()
  result3m = 0
  result6m = 0
  result12m = 0
  result24m = 0
  result72m = 0
  tcNeverExecuted = 0
end function

sub getTCCountCreation(nodeFolder, includeChilds)
  set tf = nodeFolder.TestFactory
  set l = tf.NewList("")
  for i = 1 to l.Count
    createDate = l(i).Field("TS_CREATION_DATE")
	modifyDate = l(i).Field("TS_VTS")
	
	'check if steps have been updated (works only for QC 10 and upwards)
	set desStepsFactory = l(i).DesignStepFactory
	Set desSteps = desStepsFactory.NewList("")
	desDate = "1/1/1999"
	for j=1 to desSteps.Count
		if desSteps(j).Field("DS_VTS") <> "" then
			if DateValue(desSteps(j).Field("DS_VTS")) > DateValue(desDate) then
				desDate = desSteps(j).Field("DS_VTS")
			end if
		end if
	next
	
	if DateValue(desDate) > DateValue(modifyDate) then
		updateDate = desDate
	elseif DateValue(modifyDate) > DateValue (createDate) then
		updateDate = modifyDate
	else
		updateDate = createDate
	end if
	
    if DateDiff("m",DateValue(updateDate),DateValue(month3)) < 3 then
      result3m = result3m + 1
    elseif DateDiff("m",DateValue(updateDate),DateValue(month6)) < 6 then
      result6m = result6m + 1
    elseif DateDiff("m",DateValue(updateDate),DateValue(month12)) < 12 then
      result12m = result12m + 1
    elseif DateDiff("m",DateValue(updateDate),DateValue(month24)) < 24 then
      result24m = result24m + 1
    elseif DateDiff("m",DateValue(updateDate),DateValue(month24)) < 72 then
      result72m = result72m + 1
    end if
  next
  if includeChilds then
    for i = 1 to nodeFolder.Count
      set c = nodeFolder.Child(i)
      getTCCountCreation c, true
    next
  end if
end sub

'---------------------------------------------------------------------------------------------------
' FUNCTION: Transform_TCCreationToPercent
' PRE-REQUISITE: Functions Set_TCCountCreation and Set_TCCount needs to be executed before calling
'                this function
' DESCRIPTION:
' Transforms test case creation count to percentage
' with the test case count percentage by time interval (3m,6m,12m,24m,72m) calculation
' by the test plan folder path
'---------------------------------------------------------------------------------------------------
function Transform_TCCreationToPercent()
    
  if UBound(TCCount) <> UBound (TCCountCreation) then
    Transform_TCCreationToPercent = false
    exit function
  end if
  
  for i =0 to UBound(TCCountCreation)
	if TCCount(i,1) <> 0 then
		for j = 1 to UBound(TCCountCreation, 2)
			TCCountCreation(i,j) = CInt((TCCountCreation(i,j)/TCCount(i,1))*100)
		next
	else
		for j = 1 to UBound(TCCountCreation, 2)
			TCCountCreation(i,j) = 0
		next
	end if
  next

  Transform_TCCreationToPercent = true
end function

'---------------------------------------------------------------------------------------------------
' FUNCTION: Set_TCCountExecution
' DESCRIPTION:
' set global array TCCountExecution
' with the test case count by time interval (3m,6m,12m,24m,72m) calculation
' by the test plan folder path
'---------------------------------------------------------------------------------------------------
function Set_TCCountExecution(TestPlanPath)
  set tree = qc.TreeManager
  set folder = tree.NodeByPath("Subject\" + TestPlanPath)
  
  getTCCountCreationStart
  getTCCountExecution folder, false
  
  if folder.count = 0 and result3m = 0 and result6m = 0 and result12m = 0 and result24m = 0 and result72m = 0 and tcNeverExecuted = 0 then
    Set_TCCountExecution = false
    exit function
  end if

  prjDim = folder.count - 1
  if result3m > 0 or result6m > 0 or result12m > 0 or result24m > 0 or result72m > 0 or tcNeverExecuted > 0 then prjDim = prjDim + 1
  redim TCCountExecution(prjDim, 7)
  
  prjIndex = 0
  if result3m > 0 or result6m > 0 or result12m > 0 or result24m > 0 or result72m > 0 or tcNeverExecuted > 0 then
    TCCountExecution(prjIndex, 0) = "To be allocated"
    TCCountExecution(prjIndex, 1) = result3m
    TCCountExecution(prjIndex, 2) = result6m
    TCCountExecution(prjIndex, 3) = result12m
    TCCountExecution(prjIndex, 4) = result24m
    TCCountExecution(prjIndex, 5) = result72m
	TCCountExecution(prjIndex, 6) = tcNeverExecuted
    prjIndex = prjIndex + 1
  end if
  
  for i = 1 to folder.Count
    set child = folder.Child(i)
    TCCountExecution(prjIndex, 0) = child.name
    getTCCountCreationStart
    getTCCountExecution child, true
    TCCountExecution(prjIndex, 1) = result3m
    TCCountExecution(prjIndex, 2) = result6m
    TCCountExecution(prjIndex, 3) = result12m
    TCCountExecution(prjIndex, 4) = result24m
    TCCountExecution(prjIndex, 5) = result72m
	TCCountExecution(prjIndex, 6) = tcNeverExecuted
    prjIndex = prjIndex + 1
  next
  Set_TCCountExecution = true
end function

sub getTCCountExecution(nodeFolder, includeChilds)
   set tf = nodeFolder.TestFactory
  set l = tf.NewList("")
  for i = 1 to l.Count
    
	execDate = l(i).ExecDate
	
    if Year(execDate) < 1900 then
		tcNeverExecuted = tcNeverExecuted + 1
	elseif DateDiff("m",DateValue(execDate),DateValue(month3)) < 3 then
      result3m = result3m + 1
    elseif DateDiff("m",DateValue(execDate),DateValue(month6)) < 6 then
      result6m = result6m + 1
    elseif DateDiff("m",DateValue(execDate),DateValue(month12)) < 12 then
      result12m = result12m + 1
    elseif DateDiff("m",DateValue(execDate),DateValue(month24)) < 24 then
      result24m = result24m + 1
    elseif DateDiff("m",DateValue(execDate),DateValue(month24)) < 72 then
      result72m = result72m + 1
    end if
  next
  if includeChilds then
    for i = 1 to nodeFolder.Count
      set c = nodeFolder.Child(i)
      getTCCountExecution c, true
    next
  end if
end sub
'---------------------------------------------------------------------------------------------------
' FUNCTION: Transform_TCExecutionToPercent
' PRE-REQUISITE: Functions Set_TCCountExecution and Set_TCCount needs to be executed before calling
'                this function
' DESCRIPTION:
' Transforms test case creation count to percentage
' with the test case count percentage by time interval (3m,6m,12m,24m,72m) calculation
' by the test plan folder path
'---------------------------------------------------------------------------------------------------
function Transform_TCExecutionToPercent()
  
  if UBound(TCCount) <> UBound (TCCountExecution) then
    Transform_TCExecutionToPercent = false
    exit function
  end if
  
  for i =0 to UBound(TCCountExecution)
	if TCCount(i,1) <> 0 then
		for j = 1 to UBound(TCCountExecution, 2)
			TCCountExecution(i,j) = CInt((TCCountExecution(i,j)/TCCount(i,1))*100)
		next
	else
		for j = 1 to UBound(TCCountExecution, 2)
			TCCountExecution(i,j) = 0
		next
	end if
  next

  Transform_TCExecutionToPercent = true
end function

'---------------------------------------------------------------------------------------------------
'global array to store automated tc count
'---------------------------------------------------------------------------------------------------
'each element will be an array[name,count]
redim AutomatedTCCount(0,0)

'---------------------------------------------------------------------------------------------------
' FUNCTION: Set_AutomatedTCCount
' DESCRIPTION:
' set global array AutomatedTCCount
' with the test case automated count calculation
' by the test plan folder path
'---------------------------------------------------------------------------------------------------
Dim FieldName
function Set_AutomatedTCCount(TestPlanPath)
  set tree = qc.TreeManager
  set folder = tree.NodeByPath("Subject\" + TestPlanPath)
  
  FieldName =  GetFieldName("Automation ID", "TEST")
  
  rootCount = getAutomatedTCCount(folder, false)
  prjIndex = 0
  if folder.count = 0 and TCCount(prjIndex, 1) = 0 and TCCount(prjIndex, 0) = "To be allocated" then
    Set_AutomatedTCCount = false
    exit function
  end if

  prjDim = folder.count - 1
  
  if rootCount > 0 OR TCCount(prjIndex, 1) > 0 and TCCount(prjIndex, 0) = "To be allocated" then prjDim = prjDim + 1
  redim AutomatedTCCount(prjDim, 1)
  
  if rootCount > 0 then
    AutomatedTCCount(prjIndex, 0) = "To be allocated"
    AutomatedTCCount(prjIndex, 1) = rootCount
    prjIndex = prjIndex + 1
  elseif TCCount(prjIndex, 1) > 0 and TCCount(prjIndex, 0) = "To be allocated" then 
	AutomatedTCCount(prjIndex, 0) = "To be allocated"
    AutomatedTCCount(prjIndex, 1) = rootCount
    prjIndex = prjIndex + 1
  end if
  
  for i = 1 to folder.Count
    set child = folder.Child(i)
    AutomatedTCCount(prjIndex, 0) = child.name
    AutomatedTCCount(prjIndex, 1) = getAutomatedTCCount(child, true)
    prjIndex = prjIndex + 1
  next
  Set_AutomatedTCCount = true
end function

function getAutomatedTCCount(nodeFolder, includeChilds)
  result = 0
  set tf = nodeFolder.TestFactory
  set l = tf.NewList("")
  for k = 1 to l.Count
    if l(k).Type = "QUICKTEST_TEST" then
      result = result + 1
    elseif FieldName <> "" then
      if l(k).Field(FieldName) <> "" Then
        result = result + 1
      end if
    end if
  next 
  if includeChilds then
    for i = 1 to nodeFolder.Count
      set c = nodeFolder.Child(i)
      result = result + getAutomatedTCCount(c, true)
    next
  end if
  getAutomatedTCCount = result
end function

'---------------------------------------------------------------------------------------------------
' FUNCTION: Transform_TCAutomatedToPercent
' PRE-REQUISITE: Functions Set_AutomatedTCCount and Set_TCCount needs to be executed before calling
'                this function
' DESCRIPTION:
' Transforms test case automated count to percentage by the test plan folder path
' 
'---------------------------------------------------------------------------------------------------
function Transform_TCAutomatedToPercent()
    
  if UBound(TCCount) <> UBound (AutomatedTCCount) then
    Transform_TCAutomatedToPercent = false
    exit function
  end if
  
  for i =0 to UBound(AutomatedTCCount)
	if TCCount(i,1) <> 0 then
		for j = 1 to UBound(AutomatedTCCount, 2)
			AutomatedTCCount(i,j) = CInt((AutomatedTCCount(i,j)/TCCount(i,1))*100)
		next
	else
		for j = 1 to UBound(AutomatedTCCount, 2)
			AutomatedTCCount(i,j) = 0
		next
	end if
  next

  Transform_TCAutomatedToPercent = true
end function

'---------------------------------------------------------------------------------------------------
'global array to store requirements count
'---------------------------------------------------------------------------------------------------
'each element will be an array[name,count]
redim REQCount(0,0)

'---------------------------------------------------------------------------------------------------
' FUNCTION: Set_REQCount
' DESCRIPTION:
' set global array REQCount
' with the requirement count calculation
' by the requirement folder path
'---------------------------------------------------------------------------------------------------
function Set_REQCount(ReqPlanPath)
  set tree = qc.TreeManager
  set folder = tree.NodeByPath("Requirements\" + ReqPlanPath)
  
  rootCount = getTCCount(folder, false)
  
  if folder.count = 0 and rootCount = 0 then
    Set_REQCount = false
    exit function
  end if

  prjDim = folder.count - 1
  if rootCount > 0 then prjDim = prjDim + 1
  redim REQCount(prjDim, 1)
  
  prjIndex = 0
  if rootCount > 0 then
    REQCount(prjIndex, 0) = "To be allocated"
    REQCount(prjIndex, 1) = rootCount
    prjIndex = prjIndex + 1
  end if
  
  for i = 1 to folder.Count
    set child = folder.Child(i)
    REQCount(prjIndex, 0) = child.name
    REQCount(prjIndex, 1) = getTCCount(child, true)
    prjIndex = prjIndex + 1
  next
  Set_REQCount = true
end function


'---------------------------------------------------------------------------------------------------
' FUNCTION: GetFieldName
' DESCRIPTION:
' Returns the Field Name based on the User Label
'---------------------------------------------------------------------------------------------------
function GetFieldName(userLabel, table)
Set fieldList = qc.Fields(table)

For i=1 to fieldList.Count
	If fieldList(i).Property.UserLabel = userLabel Then
		GetFieldName = fieldList.Item(i).Name
		Exit Function
	End If
Next
GetFieldName = ""
end function

'---------------------------------------------------------------------------------------------------
' FUNCTION: CreateXML_Bar2D
' DESCRIPTION:
' create xml data file for Bar2D fusion chart
'---------------------------------------------------------------------------------------------------
Public Sub CreateXML_Bar2D(byVal outputFilename, byVal graphTitle, byVal xTitle, byVal yTitle, byval arrValues)

	Set fso = CreateObject("Scripting.FileSystemObject")

	Set newFile = fso.CreateTextFile(outputFilename, True)

	newFile.WriteLine("<chart caption='" & graphTitle & "'")
	newFile.WriteLine("  bgColor='FFFFFF' showBorder='0' canvasbgColor='FFFFFF'")
	newFile.WriteLine("  canvasBorderColor='CDC8B1' showAlternateVGridColor='1'")
	newFile.WriteLine("   xAxisName='" & xTitle & "' yAxisName='" & yTitle & "' legendPosition='RIGHT'>")

	For i = 0 to UBound(arrValues, 1)	
		newFile.WriteLine("    <set label='" & arrValues(i, 0) & "' value='"& arrValues(i, 1) & "' />")
	Next

	newFile.WriteLine("</chart>")
	newFile.Close

End Sub

'---------------------------------------------------------------------------------------------------
' FUNCTION: CreateXML_StackedBar2D
' DESCRIPTION:
' create xml data file for StackedBar2D fusion chart
'---------------------------------------------------------------------------------------------------
Public Sub CreateXML_StackedBar2D(byVal outputFilename, byVal graphTitle, byVal xTitle, byVal yTitle, byval arrSeries, byval arrValues)

	Set fso = CreateObject("Scripting.FileSystemObject")

	Set newFile = fso.CreateTextFile(outputFilename, True)

	newFile.WriteLine("<chart caption='" & graphTitle & "'")
	newFile.WriteLine("  bgColor='FFFFFF' showBorder='0' canvasbgColor='FFFFFF'")
	'newFile.WriteLine("  canvasBorderColor='CDC8B1' showAlternateVGridColor='1' showSum='1' showValues='0'")
	newFile.WriteLine("  canvasBorderColor='CDC8B1' showAlternateVGridColor='1'")
	newFile.WriteLine("   xAxisName='" & xTitle & "' yAxisName='" & yTitle & "' labelDisplay='ROTATE' slantLabels='1' legendPosition='RIGHT'>")

  newFile.WriteLine("<categories>")
	For i = 0 to UBound(arrValues, 1)	
		newFile.WriteLine("    <category label='" & arrValues(i, 0) & "' />")
	Next
  newFile.WriteLine("</categories>")

  for i = 0 to UBound(arrSeries, 1)	
    newFile.WriteLine("<dataset seriesName='" & arrSeries(i) & "'>")
    For j = 0 to UBound(arrValues, 1)	
      newFile.WriteLine("    <set value='" & arrValues(j, i+1) & "' />")
    Next
    newFile.WriteLine("</dataset>")
  next
  
	newFile.WriteLine("</chart>")
	newFile.Close

End Sub

'---------------------------------------------------------------------------------------------------
' FUNCTION: CreateDatestampHTML
' DESCRIPTION:
' create html file with the date stamp
'---------------------------------------------------------------------------------------------------
Public Sub CreateDatestampHTML(byVal outputFilename)

	Dim arrDays, minutes

	'	Get date/time in correct format
	arrDays = Array("","Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday")

	'	Format minutes
	minutes = Minute(time)

	if (Len(minutes) = 1) Then
		minutes = "0" & minutes
	End If

	dateStamp = "Generated on " & arrDays(Weekday(now)) & " " & MonthName(month(now)) & " " & Day(now) & " at " & Hour(time) & ":" & minutes & " GMT / " & Int(Hour(time) - 5) & ":" & minutes & " EST"


	Set fso = CreateObject("Scripting.FileSystemObject")

	Set newFile = fso.CreateTextFile(outputFilename)

	newFile.WriteLine("<font size='2' face=""Verdana""><I></br>")
	newFile.WriteLine(dateStamp)
	newFile.WriteLine("</I></font>")

	newFile.Close
End Sub

'---------------------------------------------------------------------------------------------------
' FUNCTION: CreateDatestampHTML
' DESCRIPTION:
' create html file with the date stamp
'---------------------------------------------------------------------------------------------------
Public Sub CreateSourceFeedHTML(byVal outputFilename, byVal AppDomain, byval AppProject, byval AppTestPlanPath)

	Set fso = CreateObject("Scripting.FileSystemObject")

	Set newFile = fso.CreateTextFile(outputFilename)

	newFile.WriteLine("<font size='2' face=""Verdana""><I></br>")
	newFile.WriteLine("QC Source: Domain='" & AppDomain & "' Project='" & AppProject & "' TestPlan='Subject\" & AppTestPlanPath & "'")
	newFile.WriteLine("</I></font>")

	newFile.Close
End Sub
