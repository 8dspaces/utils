Dim qc As TDConnection
Dim QCUserName As String
Dim QCDomain As String
Dim QCProject As String
Dim TargetTestSetFolder As String
Dim TargetTestSet As String
Dim wStartCell As Range
Dim QCPassword As String

Const SettingCount As Integer = 5
Const QCUrl As String = "====qc link====="




Sub ChangeStatus()
    
    If QCLogin = True Then
    
        StatusHandler "ChangeStatus"
    Else
        Exit Sub
    End If
    
End Sub

Sub ResetStatus()
    
    
    If QCLogin = True Then
        
        StatusHandler "ResetStatus"
    Else
        Exit Sub
    End If
        
End Sub

Sub GetStatus()
    
    If QCLogin = True Then
        StatusHandler "GetStatus"
    Else
        Exit Sub
    End If

    
End Sub

Sub RunConfig()
    
    Application.StatusBar = "Get Config settings......"
    
    Set wStartCell = QCStart.Range("C1")
    For i = 1 To SettingCount
        If Trim(wStartCell.Offset(i, 0).Value) = "" Then
            Application.StatusBar = "Please Check your settings!"
            Exit Sub
        End If
    Next
    QCUserName = wStartCell.Offset(1, 0).Value
    QCDomain = wStartCell.Offset(2, 0).Value
    QCProject = wStartCell.Offset(3, 0).Value
    TargetTestSetFolder = wStartCell.Offset(4, 0).Value
    TargetTestSet = wStartCell.Offset(5, 0).Value
    
End Sub


Sub End_QC()

    If Not qc Is Nothing Then
       
       qc.Disconnect
       qc.ReleaseConnection
       Set qc = Nothing
    End If
    
End Sub


Sub SetPassword(str As String)

    QCPassword = str

End Sub
Function QCLogin()

    'Run Config to Get the Expected Setting value
    RunConfig
    
    Set qc = New TDConnection
    
    dlgPass.Caption = "Please Enter Password for:" & QCUserName
    dlgPass.txtPass.Text = ""
    dlgPass.Show
    
    If QCPassword = "" Then
        Application.StatusBar = "Get Password Warning!"
        QCLogin = False
        Exit Function
    End If
    'QCPassword = InputBox("Enter QC Password for " & QCUserName, "Password", "PASSWORD")
    
    qc.InitConnectionEx QCUrl
    
    Application.StatusBar = "Login with User " & QCUserName & "..."
    qc.Login QCUserName, QCPassword
    
    If Not qc.LoggedIn Then
        Application.StatusBar = "Login Failed..."
        QCLogin = False
        Exit Function
    End If
    
    Application.StatusBar = "Connect to specific Domain " & QCDomain & "\" & QCProject & "..."
    qc.Connect QCDomain, QCProject
    
    If Not qc.Connected Then
        Application.StatusBar = "Connect Failed..."
        QCLogin = False
        Exit Function
    End If
    QCLogin = True
    Application.StatusBar = "Login QC successfully!"
End Function


Sub StatusHandler(strType As String)
    
    On Error GoTo ErrHandler:
    
    'Dim TestSetFact As TestSetFactory
    Dim TSTestFact As TSTestFactory
    Dim theTestSet As TestSet
    Dim theTSTest As TSTest
    Dim TSTestsList As List, TestSetsList As List
    Dim tsTreeMgr As TestSetTreeManager
    Dim tSetFolder As TestSetFolder


    'Set TestSetFact = qc.TestSetFactory
    ' Get the test set tree manager from the test set factory.
    Set tsTreeMgr = qc.TestSetTreeManager
    ' Get the test set folder.
    Set tSetFolder = tsTreeMgr.NodeByPath(TargetTestSetFolder)
    
    ' Because we are searching for the full name,
    ' the list will have only one entry.
    Set TestSetsList = tSetFolder.FindTestSets(TargetTestSet)
    Set theTestSet = TestSetsList.Item(1)
        
    ' Get the TSTest factory and list of TSTests.
    Set TSTestFact = theTestSet.TSTestFactory
    Set TSTestsList = TSTestFact.NewList("")

    Dim runFact As RunFactory
    Dim theRun As Run
    Dim stepFact As StepFactory
    Dim stepsList As List
    Dim step As step
    Dim runName$
    Dim forcePass As String
    runName = ""
    
    If strType = "ChangeStatus" Then
            For Each theTSTest In TSTestsList
                
                Application.StatusBar = "Running on --" & theTSTest.Name
                forcePass = LCase(Trim(QCStart.Range("C15").Text))
                
                    Set runFact = theTSTest.RunFactory
                    If theTSTest.Status = "No Run" Then
                        
                        
                        runName = "Run-" & DateTime.Date & "-" & DateTime.Time
                        Set theRun = runFact.AddItem(runName)
                        theRun.CopyDesignSteps
                        Set stepFact = theRun.StepFactory
                        Set stepsList = stepFact.NewList("")
                        For Each step In stepsList
                            step.Status = "Passed"
                            step.Post
                        Next
                        theRun.Status = "Passed"
                        
                        For i = 6 To 10
                            If Trim(wStartCell.Offset(i, 0).Value) <> "" Then
                                theRun.Field(wStartCell.Offset(i, -1).Value) = wStartCell.Offset(i, 0).Value
                            End If
                        Next
                        
                        theRun.Post
                        theTSTest.Post
                    ElseIf theTSTest.Status <> "No Run" And theTSTest.Status <> "Passed" Then
                        Dim tempCount As Integer
                        Dim runList2 As List
                        Set runList2 = runFact.NewList("")
                        tempCount = runList2.Count
                        
                        If forcePass = "yes" And tempCount > 0 Then
                        
                            Set theRun = runList2.Item(tempCount)
                            Set stepFact = theRun.StepFactory
                            Set stepsList = stepFact.NewList("")
                            For Each step In stepsList
                                step.Status = "Passed"
                                
                                ' set the actual result for step
                                step.Field("ST_ACTUAL") = "work as expected"
                                step.Post
                            Next
                            theRun.Status = "Passed"
                            theRun.Post
                        End If
                    
                
                End If
            Next theTSTest
    ElseIf strType = "GetStatus" Then
            
            Dim countPass As Integer
            Dim countFail As Integer
            Dim countNoRun As Integer
            Dim countNotCompleted As Integer
            Dim countOther As Integer
            Dim countTotal As Integer
            
            For Each theTSTest In TSTestsList
                Application.StatusBar = "Running on --" & theTSTest.Name
                countTotal = countTotal + 1
                
                If LCase(theTSTest.Status) = "no nun" Then
                    countNoRun = countNoRun + 1
                ElseIf LCase(theTSTest.Status) = "passed" Then
                    countPass = countPass + 1
                ElseIf LCase(theTSTest.Status) = "failed" Then
                    countFail = countFail + 1
                ElseIf LCase(theTSTest.Status) = "not completed" Then
                    countNotCompleted = countNotCompleted + 1
                Else
                    countOther = countOther + 1
                End If
            
            Next theTSTest
            
            ' Write the Status for project
            Dim w_start As Range
            Set w_start = QCStart.Range("B18")
            QCStart.Range("B19:C24").Clear
            'For i = 1 To 6
            w_start.Offset(1, 0).Value = "No Run"
            w_start.Offset(1, 1).Value = countNoRun
            w_start.Offset(2, 0).Value = "Passed"
            w_start.Offset(2, 1).Value = countPass
            w_start.Offset(3, 0).Value = "Failed"
            w_start.Offset(3, 1).Value = countFail
            w_start.Offset(4, 0).Value = "Not Completed"
            w_start.Offset(4, 1).Value = countNotCompleted
            w_start.Offset(5, 0).Value = "N/A"
            w_start.Offset(5, 1).Value = countOther
            w_start.Offset(6, 0).Value = "Total"
            w_start.Offset(6, 1).Value = countTotal
            'Next
        '===========Not Work for Permission=======================
        'Used to Reset All Testcase Status to No Run for a TestSet
    ElseIf strType = "ResetStatus" Then
        
            Dim runList As List
            For Each theTSTest In TSTestsList
                If theTSTest.Status <> "No Run" Then

                    Set runFact = theTSTest.RunFactory
                    Set runList = runFact.NewList("")

                    'No permission to delete Run item
                    For i = 0 To runList.Count - 1
                        runFact.RemoveItem (i)
                    Next

                    theTSTest.Post
                End If
            Next theTSTest
            
            'There are another function, not work for Permission
            'theTestSet.PurgeExecutions
    End If
    'Status changed, disconnect the QC connection
    Application.StatusBar = ""
    End_QC
    
ErrHandler:
    If Err.Number <> 0 Then
        Application.StatusBar = "Sorry, Get Error:" & Err.Description
    End If
    End_QC
End Sub





'===========Not Work for Permission=======================
'Used to Reset All Testcase Status to No Run for a TestSet
Sub ResetAllStatus()
    
    Dim TestSetFact As TestSetFactory
    Dim TSTestFact As TSTestFactory
    Dim theTestSet As TestSet
    Dim theTSTest As TSTest
    Dim TSTestsList As List, TestSetsList As List
    Dim tsTreeMgr As TestSetTreeManager
    Dim tSetFolder As TestSetFolder


    Set TestSetFact = qc.TestSetFactory
    ' Get the test set tree manager from the test set factory.
    Set tsTreeMgr = qc.TestSetTreeManager
    ' Get the test set folder.
    Set tSetFolder = tsTreeMgr.NodeByPath(TargetTestSetFolder)
    
    ' Because we are searching for the full name,
    ' the list will have only one entry.
    Set TestSetsList = tSetFolder.FindTestSets(TargetTestSet)
    Set theTestSet = TestSetsList.Item(1)
    
    
    ' Get the TSTest factory and list of TSTests.
    Set TSTestFact = theTestSet.TSTestFactory
    Set TSTestsList = TSTestFact.NewList("")

    Dim runFact As RunFactory
    Dim theRun As Run
    Dim stepFact As StepFactory
    Dim stepsList As List
    Dim step As step
    Dim runList As List
    
    
    For Each theTSTest In TSTestsList
        If theTSTest.Status <> "No Run" Then
        
            Set runFact = theTSTest.RunFactory
            Set runList = runFact.NewList("")
            
            'No permission to delete Run item
            For i = 0 To runList.Count - 1
                runFact.RemoveItem (i)
            Next
            
            theTSTest.Post
        End If
    Next theTSTest
    
    Application.StatusBar = ""
    End_QC
End Sub

Sub TestSQL_Bug()

    QCLogin
    
    Dim com As Command
    Dim records As Recordset
    Dim ColCnt As Integer
    
    Set com = qc.Command
    
    'com.CommandText = "select top 10 * from BUG"
    com.CommandText = "select * from TEST where TS_USER_06 = 'Dividend Renovation' "

    Set records = com.Execute
    
    Debug.Print records.RecordCount
    
'    ColCnt = records.ColCount
'    For i = 0 To ColCnt - 1
'        Debug.Print "Column name and value: " _
'            & records.ColName(i) & ", " & records.FieldValue(i)
'    Next i
  
    
'    Set records = com.Execute
    
    
'    ColCnt = records.ColCount
    
'    For i = 0 To ColCnt - 1
'        Debug.Print "Column name and value: " _
'            & records.ColName(i) & ", " & records.FieldValue(i)
'    Next i
   

End Sub

Sub TestSQL_Run()
    
    If QCLogin = True Then
        Dim com As Command
        Dim RecSet As Recordset
        Dim RecCnt As Integer
        
        Set com = qc.Command
        com.CommandText = "select RN_RUN_ID, RN_RUN_NAME,RN_TESTER_NAME,RN_STATUS from RUN where RN_STATUS = 'Passed' and RN_CYCLE_ID = 11764"
        
        Set RecSet = com.Execute
        RecCnt = RecSet.RecordCount
        
        For i = 1 To RecCnt
            Debug.Print RecSet.ColName(1) & ": " & RecSet.FieldValue(1)
            Debug.Print RecSet.ColName(2) & ": " & RecSet.FieldValue(2)
            Debug.Print RecSet.ColName(3) & ": " & RecSet.FieldValue(3)
            RecSet.Next
        Next i
    End If
End Sub

Sub Add_TestCases()
    
    '=== Use for testing, get exist Testset ====
    
'    Dim TargetTestSet As String, TargetTestSetFolder As String
'    TargetTestSetFolder = "Root\Dividend Renovation"
'    TargetTestSet = "TempForTest"

'     Dim tsTreeMgr As TestSetTreeManager
'     Dim tSetFolder As TestSetFolder
'     Dim TestSetsList As List

'    'Set TestSetFact = qc.TestSetFactory
'    'Get the test set tree manager from the test set factory.
'    Set tsTreeMgr = qc.TestSetTreeManager
'    ' Get the test set folder.
'    Set tSetFolder = tsTreeMgr.NodeByPath(TargetTestSetFolder)
'
'    ' Because we are searching for the full name,
'    ' the list will have only one entry.
'    Set TestSetsList = tSetFolder.FindTestSets(TargetTestSet)
'    Set theTestSet = TestSetsList.Item(1)  'Get the test set

       
    
    QCLogin
    
      
    Dim TSTestsList As List    ' for loop item on a TSTest factory
    Dim theTestSet As TestSet  ' testset to be use add test case
    Dim TSTestFact As TSTestFactory  ' use to add/remove TSTest
    Dim theTSTest As TSTest     ' use to run some check on a TSTest
    


    ' Create Testset
     Set theTestSet = Create_TestSet()
        
    ' Get the TSTest factory and list of TSTests.
     Set TSTestFact = theTestSet.TSTestFactory
    

' ======loop Testset to remove all exist items

'    Set TSTestsList = TSTestFact.NewList("")
'
'    For Each theTSTest In TSTestsList
'
'        TSTestFact.RemoveItem (theTSTest.ID)
'
'    Next
    
    '==== Add items from a config sheet's selection
    Dim d As Dictionary
    Set d = Get_TestCasesDic()
    
    For Each Item In d.Items
        TSTestFact.AddItem (Item)
    Next
    

    End_QC
            


End Sub

Function Create_TestSet() 'tFolder As String, tsName As String

    Dim tstSetFolder As TestSetFolder
    ' Dim testSetFolderF As TestSetTreeManager
    Dim testSetF As TestSetFactory
    Dim new_testset As TestSet

    'Set testSetFolderF = qc.TestSetTreeManager
    
    Set tstSetFolder = qc.TestSetTreeManager.NodeByPath("Root\Dividend Renovation\Notification UI") 'use as tFolder
    Set testSetF = tstSetFolder.TestSetFactory
    
    Set new_testset = testSetF.AddItem(Null)
    new_testset.Name = "TempForTest2"  ' use as tsName
    new_testset.Status = "Open"
    new_testset.Post
    
    Set Create_TestSet = new_testset

End Function


Function Get_TestCasesDic()
    
    Dim dic As New Dictionary
    
    
    Dim startCell As Range
    Set startCell = sCases.Range("A1")
     
    For i = 1 To sCases.[A65536].End(xlUp).Row - 1
        
        If startCell.Offset(i, 0).Value <> "" And LCase(startCell.Offset(i, 7).Value) = "yes" Then
                    
            dic.Add i, startCell.Offset(i, 0).Value
            
        End If
    Next
    
    Set Get_TestCasesDic = dic
End Function


