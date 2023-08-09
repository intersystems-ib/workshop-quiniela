Class QUINIELA.BO.UtilsBO Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Method GetTeams(pRequest As QUINIELA.Message.DictionaryTeamRequest, pResponse As QUINIELA.Message.DictionaryTeamResponse) As %Status
{
    Set sc = $$$OK
    set pResponse = ##class(QUINIELA.Message.DictionaryTeamResponse).%New()
    set pResponse.Operation = pRequest.Operation

    set teamArray = ##class(%DynamicArray).%New()
    set sqlTeam = "SELECT %ID, Name FROM QUINIELA_Object.Team ORDER BY Name ASC"
    set statementTeam = ##class(%SQL.Statement).%New(), statementTeam.%ObjectSelectMode = 1
    set statusTeam = statementTeam.%Prepare(sqlTeam)
    if ($$$ISOK(statusTeam)) {        
        set resultSetTeam = statementTeam.%Execute()
        if (resultSetTeam.%SQLCODE = 0) {
            while (resultSetTeam.%Next() '= 0) {
                set team = ##class(%DynamicObject).%New()
                set team.id = resultSetTeam.%GetData(1)
                set team.name = resultSetTeam.%GetData(2)
                do teamArray.%Push({"id":(resultSetTeam.%GetData(1)), "name": (resultSetTeam.%GetData(2))})
            }
            set pResponse.Status = "Finished"    
            set pResponse.Result = teamArray.%ToJSON()
        }
    }
    else {
        set sc = statusTeam
        set pResponse.Status = "Error" 
    }
    return sc
}

Method GetReferees(pRequest As QUINIELA.Message.DictionaryRefereeRequest, pResponse As QUINIELA.Message.DictionaryRefereeResponse) As %Status
{
    Set sc = $$$OK
    set pResponse = ##class(QUINIELA.Message.DictionaryRefereeResponse).%New()
    set pResponse.Operation = pRequest.Operation
    
    set refereeArray = ##class(%DynamicArray).%New()
    set sqlReferee = "SELECT %ID, Name FROM QUINIELA_Object.Referee ORDER BY Name ASC"
    set statementReferee = ##class(%SQL.Statement).%New(), statementReferee.%ObjectSelectMode = 1
    set statusReferee = statementReferee.%Prepare(sqlReferee)
    if ($$$ISOK(statusReferee)) {
        set resultSetReferee = statementReferee.%Execute()
        if (resultSetReferee.%SQLCODE = 0) {
            while (resultSetReferee.%Next() '= 0) {
                do refereeArray.%Push({"id":(resultSetReferee.%GetData(1)), "name": (resultSetReferee.%GetData(2))})
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
  <MapItem MessageType="QUINIELA.Message.DictionaryTeamRequest">
    <Method>GetTeams</Method>
  </MapItem>
  <MapItem MessageType="QUINIELA.Message.DictionaryRefereeRequest">
    <Method>GetReferees</Method>
  </MapItem>
</MapItems>
}

}
