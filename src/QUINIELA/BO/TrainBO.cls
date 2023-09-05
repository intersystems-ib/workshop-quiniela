Class QUINIELA.BO.TrainBO Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

/// Description
Method CreateAndTrainModel(pRequest As QUINIELA.Message.TrainRequest, pResponse As QUINIELA.Message.TrainResponse) As %Status
{
        Set tSC = $$$OK

        set pResponse = ##class(QUINIELA.Message.TrainResponse).%New()
        set pResponse.Operation = pRequest.Operation
        set pResponse.Status = "In Process"
        
        set sql = "SELECT MODEL_NAME FROM INFORMATION_SCHEMA.ML_MODELS WHERE MODEL_NAME = 'QuinielaModel'"
        set statement = ##class(%SQL.Statement).%New()
        set status = statement.%Prepare(sql)
        $$$TRACE(status)
        if ($$$ISOK(status)) {
            set resultSet = statement.%Execute()
            $$$TRACE(resultSet.%SQLCODE)
            if (resultSet.%SQLCODE = 0) {
                while (resultSet.%Next() '= 0) {
                    if (resultSet.%GetData(1) '= "") {
                        set sqlDrop = "DROP MODEL QuinielaModel"
                        set statementDrop = ##class(%SQL.Statement).%New()
                        set statusDrop = statementDrop.%Prepare(sqlDrop)
                        if ($$$ISOK(statusDrop)) {
                            set resultSetDrop = statementDrop.%Execute()
                            if (resultSetDrop.%SQLCODE = 0) {
                                set tSC = statusDrop                                                                
                            }
                        }
                    }
                }
            }            
        }
        $$$TRACE("Creating model")
        set sqlCreate = "CREATE MODEL QuinielaModel PREDICTING (Result) FROM QUINIELA_Object.MatchTrain"
        set statementCreate = ##class(%SQL.Statement).%New()
        set statusCreate = statementCreate.%Prepare(sqlCreate)
        if ($$$ISOK(statusCreate)) {
            $$$TRACE("Model created")
            set resultSetCreate = statementCreate.%Execute()
            if (resultSetCreate.%SQLCODE = 0) {
                set tSC = statusCreate                                
            }
        }
        else
        {
            set tSC = statusDrop
        }

        $$$TRACE("Training model")
        set sqlTrain = "TRAIN MODEL QuinielaModel"
        set statementTrain = ##class(%SQL.Statement).%New()
        set statusTrain = statementTrain.%Prepare(sqlTrain)
        if ($$$ISOK(statusTrain)) {
            set resultSetTrain = statementTrain.%Execute()
            if (resultSetTrain.%SQLCODE = 0) {
                // VALIDATION OF THE MODEL WITH THE PRE-LOADED MATCHES
                set sqlValidate = "VALIDATE MODEL QuinielaModel FROM QUINIELA_Object.MatchTrain"                                
                set statementValidate = ##class(%SQL.Statement).%New()
                set statusValidate = statementValidate.%Prepare(sqlValidate)
                set resultSetValidate = statementValidate.%Execute()
                set tSC = statusValidate                                    
            }
        }
        else {
            set tSC = statusTrain
        }
        
        set pResponse.Status = "Finished"

        Return tSC
}

XData MessageMap
{
<MapItems>
  <MapItem MessageType="QUINIELA.Message.TrainRequest">
    <Method>CreateAndTrainModel</Method>
  </MapItem>
</MapItems>
}

}
