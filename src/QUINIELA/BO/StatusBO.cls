Class QUINIELA.BO.StatusBO Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Method CheckPreparation(pRequest As QUINIELA.Message.PrepareRequest, pResponse As QUINIELA.Message.PrepareResponse) As %Status
{
    Set sc = $$$OK
    set pResponse = ##class(QUINIELA.Message.PrepareResponse).%New()
    set sqlCheck = "SELECT TOP 1 Status, Operation FROM QUINIELA_Message.PrepareResponse ORDER BY ID DESC"
    set statementCheck = ##class(%SQL.Statement).%New(), statementCheck.%ObjectSelectMode = 1
    set statusCheck = statementCheck.%Prepare(sqlCheck)
    if ($$$ISOK(statusCheck)) {
        set resultSetCheck = statementCheck.%Execute()
        if (resultSetCheck.%SQLCODE = 0) {
            while (resultSetCheck.%Next() '= 0) {
                set pResponse.Status = resultSetCheck.%GetData(1)
                set pResponse.Operation = resultSetCheck.%GetData(2)
            }
        }
    }
    else {
        set sc = statusCheck
    }
    
    Return sc
}

Method CheckImport(pRequest As QUINIELA.Message.ImportRequest, pResponse As QUINIELA.Message.ImportResponse) As %Status
{
    Set sc = $$$OK
    set pResponse = ##class(QUINIELA.Message.ImportResponse).%New()
    set sqlImport = "SELECT TOP 1 Status, Operation FROM QUINIELA_Message.ImportResponse ORDER BY ID DESC"
    set statementImport = ##class(%SQL.Statement).%New(), statementImport.%ObjectSelectMode = 1
    set statusImport = statementImport.%Prepare(sqlImport)
    if ($$$ISOK(statusImport)) {
        set resultSetImport = statementImport.%Execute()
        if (resultSetImport.%SQLCODE = 0) {
            while (resultSetImport.%Next() '= 0) {
                set pResponse.Status = resultSetImport.%GetData(1)
                set pResponse.Operation = resultSetImport.%GetData(2)
            }
        }
    }
    else {
        set sc = statusImport
    }
    
    Return sc
}

Method CheckTrain(pRequest As QUINIELA.Message.TrainRequest, pResponse As QUINIELA.Message.TrainResponse) As %Status
{
    Set sc = $$$OK
    set pResponse = ##class(QUINIELA.Message.TrainResponse).%New()
    set sqlTrain = "SELECT TOP 1 Status, Operation FROM QUINIELA_Message.TrainResponse ORDER BY ID DESC"
    set statementTrain = ##class(%SQL.Statement).%New(), statementTrain.%ObjectSelectMode = 1
    set statusTrain = statementTrain.%Prepare(sqlTrain)
    if ($$$ISOK(statusTrain)) {
        set resultSetTrain = statementTrain.%Execute()
        if (resultSetTrain.%SQLCODE = 0) {
            while (resultSetTrain.%Next() '= 0) {
                set pResponse.Status = resultSetTrain.%GetData(1)
                set pResponse.Operation = resultSetTrain.%GetData(2)
            }
        }
    }
    else {
        set sc = statusTrain
    }
    
    Return sc
}

Method GetDataCount(pRequest As QUINIELA.Message.OperationRequest, pResponse As QUINIELA.Message.OperationResponse) As %Status
{
    Set sc = $$$OK
    set pResponse = ##class(QUINIELA.Message.DictionaryRefereeResponse).%New()
    set pResponse.Operation = pRequest.Operation
    
    set refereeArray = ##class(%DynamicArray).%New()
    set sqlReferee = "SELECT 'RawData', count(*) As RawData FROM QUINIELA_Object.RawMatch UNION SELECT 'TrainedData', count(*) As PreparedData FROM QUINIELA_Object.MatchTrain"
    set statementReferee = ##class(%SQL.Statement).%New(), statementReferee.%ObjectSelectMode = 1
    set statusReferee = statementReferee.%Prepare(sqlReferee)
    if ($$$ISOK(statusReferee)) {
        set resultSetReferee = statementReferee.%Execute()
        if (resultSetReferee.%SQLCODE = 0) {
            while (resultSetReferee.%Next() '= 0) {
                do refereeArray.%Push({"type":(resultSetReferee.%GetData(1)), "count": (resultSetReferee.%GetData(2))})
            }            
            set pResponse.Status = "Finished" 
            set pResponse.Result = refereeArray.%ToJSON()
        }
    }
    else {
        set sc = statusReferee
        set pResponse.Status = "Error" 
    }
    return sc
}

XData MessageMap
{
<MapItems>
  <MapItem MessageType="QUINIELA.Message.PrepareRequest">
    <Method>CheckPreparation</Method>
  </MapItem>
  <MapItem MessageType="QUINIELA.Message.ImportRequest">
    <Method>CheckImport</Method>
  </MapItem>
    <MapItem MessageType="QUINIELA.Message.TrainRequest">
    <Method>CheckTrain</Method>
  </MapItem>
  <MapItem MessageType="QUINIELA.Message.OperationRequest">
    <Method>GetDataCount</Method>
  </MapItem>
</MapItems>
}

}
