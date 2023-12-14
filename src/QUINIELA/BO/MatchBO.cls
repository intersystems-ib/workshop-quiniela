Class QUINIELA.BO.MatchBO Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Method SaveMatch(pRequest As QUINIELA.Message.MatchRequest, Output pResponse As QUINIELA.Message.MatchResponse) As %Status
{
    set sc = $$$OK

    set pResponse = ##class(QUINIELA.Message.MatchResponse).%New()
    set pResponse.Operation = pRequest.Operation

    set dynEntity = {}.%FromJSON(pRequest.JSON)
    
    set newMatch = ##class(QUINIELA.Object.MatchPredicted).%New()
    set newMatch.LocalTeam = dynEntity.LocalTeam
    set newMatch.VisitorTeam = dynEntity.VisitorTeam
    set horval=$zdateh(dynEntity.Day,3)
    set newMatch.Day = horval
    set newMatch.Referee = dynEntity.Referee
    set newMatch.Journey = dynEntity.Journey
    set newMatch.Division = dynEntity.Division
    set newMatch.IntDay = $REPLACE(dynEntity.Day,"-","")
    set sc = newMatch.%Save()

    set sqlUpdateLocalStreak = "UPDATE QUINIELA_Object.MatchPredicted SET QUINIELA_Object.MatchPredicted.LocalStreak = "_
        "(SELECT SUM(CASE Result WHEN 1 THEN 3 WHEN 0 THEN 1 ELSE 0 END) FROM "_
        "(SELECT TOP 3 SubMatch.IntDay, Result "_
        "FROM (SELECT IntDay, Result, LocalTeam, VisitorTeam FROM QUINIELA_Object.MatchTrain WHERE LocalTeam = ?) AS SubMatch "_
        "WHERE "_
        "SubMatch.IntDay < QUINIELA_Object.MatchPredicted.IntDay "_
        "ORDER BY SubMatch.IntDay DESC)) "_
        "WHERE QUINIELA_Object.MatchPredicted.ID = ? "
    set statementUpdateLocalStreak = ##class(%SQL.Statement).%New()
    set statusUpdateLocalStreak = statementUpdateLocalStreak.%Prepare(sqlUpdateLocalStreak)
    if ($$$ISOK(statusUpdateLocalStreak)) {
        set resultSetUpdateLocalStreak = statementUpdateLocalStreak.%Execute(newMatch.LocalTeam, newMatch.%Id())
        if (resultSetUpdateLocalStreak.%SQLCODE = 0) {
            set sqlUpdateVisitorStreak = "UPDATE QUINIELA_Object.MatchPredicted SET QUINIELA_Object.MatchPredicted.VisitorStreak = "_
                "(SELECT SUM(CASE Result WHEN 2 THEN 3 WHEN 0 THEN 1 ELSE 0 END) FROM "_
                "(SELECT TOP 3 SubMatch.IntDay, Result "_
                "FROM (SELECT IntDay, Result, LocalTeam, VisitorTeam FROM QUINIELA_Object.MatchTrain WHERE VisitorTeam = ?) AS SubMatch "_
                "WHERE "_
                "SubMatch.IntDay < QUINIELA_Object.MatchPredicted.IntDay "_
                "ORDER BY SubMatch.IntDay DESC)) "_
                "WHERE QUINIELA_Object.MatchPredicted.ID = ? "
            set statementUpdateVisitorStreak = ##class(%SQL.Statement).%New()
            set statusUpdateVisitorStreak = statementUpdateVisitorStreak.%Prepare(sqlUpdateVisitorStreak)
            if ($$$ISOK(statusUpdateVisitorStreak)) {
                set resultSetUpdateVisitorStreak = statementUpdateVisitorStreak.%Execute(newMatch.VisitorTeam, newMatch.%Id())
                if (resultSetUpdateVisitorStreak.%SQLCODE = 0) {                    
                    set sqlUpdatePredictionStreak = "UPDATE QUINIELA_Object.MatchPredicted SET QUINIELA_Object.MatchPredicted.PredictionStreak = "_
                        "CASE WHEN QUINIELA_Object.MatchPredicted.LocalStreak = QUINIELA_Object.MatchPredicted.VisitorStreak THEN '0' "_
                        "WHEN QUINIELA_Object.MatchPredicted.LocalStreak > QUINIELA_Object.MatchPredicted.VisitorStreak THEN '1' "_
                        "ELSE '2' END "_
                        "WHERE QUINIELA_Object.MatchPredicted.ID = ? "
                    set statementUpdatePredictionStreak = ##class(%SQL.Statement).%New()
                    set statusUpdatePredictionStreak = statementUpdatePredictionStreak.%Prepare(sqlUpdatePredictionStreak)
                    if ($$$ISOK(statusUpdatePredictionStreak)) {
                        set resultSetUpdatePredictionStreak = statementUpdatePredictionStreak.%Execute(newMatch.%Id())
                        set sc = statusUpdatePredictionStreak
                        if (resultSetUpdatePredictionStreak.%SQLCODE = 0) {
                            set sqlPredict = "UPDATE QUINIELA_Object.MatchPredicted mp set mp.PredictedResult = (SELECT PREDICT(QuinielaModel) AS PredictedResult FROM QUINIELA_Object.MatchPredicted mpr WHERE mpr.%Id = mp.%Id), "_
                                "mp.Probability1 = (SELECT ROUND(PROBABILITY(QuinielaModel FOR '1')*100,2) FROM QUINIELA_Object.MatchPredicted mpr1 WHERE mpr1.%Id = mp.%Id), "_
                                "mp.ProbabilityX = (SELECT ROUND(PROBABILITY(QuinielaModel FOR '0')*100,2) FROM QUINIELA_Object.MatchPredicted mprX WHERE mprX.%Id = mp.%Id), "_
                                "mp.Probability2 = (SELECT ROUND(PROBABILITY(QuinielaModel FOR '2')*100,2) FROM QUINIELA_Object.MatchPredicted mpr2 WHERE mpr2.%Id = mp.%Id) "_
                                "WHERE mp.%Id = ?"
                            set statementPredict = ##class(%SQL.Statement).%New(), statementPredict.%ObjectSelectMode = 1
                            set statusPredict = statementPredict.%Prepare(sqlPredict)
                            if ($$$ISOK(statusPredict)) {                        
                                set resultSetPredict = statementPredict.%Execute(newMatch.%Id())                        
                            }
                            else {
                                set tSC = statusPredict
                            }
                        }
                    }
                    else {
                        set sc = statusUpdatePredictionStreak
                    }                     
                }
            }
            else {
                set sc = statusUpdateVisitorStreak
            }
        }
    }
    else {
        set sc = statusUpdateLocalStreak
    }

    set pResponse.Status = "Finished"

    Quit sc
}

Method GetMatches(pRequest As QUINIELA.Message.OperationRequest, Output pResponse As QUINIELA.Message.OperationResponse) As %Status
{
    Set sc = $$$OK
    set pResponse = ##class(QUINIELA.Message.OperationResponse).%New()
    set pResponse.Operation = pRequest.Operation
    set division = $PIECE(pRequest.Operation,"_",2)
    
    set refereeArray = ##class(%DynamicArray).%New()
    set sqlMatches = "SELECT top 21 mp.Id, Day, Division, Journey, "_
        "lt.Name, vt.Name, CASE WHEN PredictedResult = 0 THEN 'X' ELSE PredictedResult END, "_
        "Probability1, "_
        "ProbabilityX, "_
        "Probability2, "_
        "mp.LocalGoals, "_
        "mp.VisitorGoals, "_
        "CASE WHEN mp.Result = 0 THEN 'X' ELSE mp.Result END "_
        "FROM QUINIELA_Object.MatchPredicted mp LEFT JOIN QUINIELA_Object.Team lt on mp.LocalTeam = lt.Id "_
        "LEFT JOIN QUINIELA_Object.Team vt on mp.VisitorTeam = vt.Id "_
        "WHERE mp.Division = ? "_
        "ORDER BY Day DESC"
    set statementMatches = ##class(%SQL.Statement).%New(), statementMatches.%ObjectSelectMode = 1
    set statusMatches = statementMatches.%Prepare(sqlMatches)
    if ($$$ISOK(statusMatches)) {
        set resultSetMatches = statementMatches.%Execute(division)
        if (resultSetMatches.%SQLCODE = 0) {
            while (resultSetMatches.%Next() '= 0) {
                do refereeArray.%Push({"id":(resultSetMatches.%GetData(1)), "day": ($ZDATE(resultSetMatches.%GetData(2),4)), 
                "division": (resultSetMatches.%GetData(3)), "journey": (resultSetMatches.%GetData(4)), 
                "local": (resultSetMatches.%GetData(5)), "visitor": (resultSetMatches.%GetData(6)),
                "predictedResult": (resultSetMatches.%GetData(7)), "probability1": (resultSetMatches.%GetData(8)),
                "probabilityX": (resultSetMatches.%GetData(9)), "probability2": (resultSetMatches.%GetData(10)),
                "localGoals": (resultSetMatches.%GetData(11)), "visitorGoals": (resultSetMatches.%GetData(12)),
                "result": (resultSetMatches.%GetData(13))})
            }            
            set pResponse.Status = "Finished" 
            set pResponse.Result = refereeArray.%ToJSON()
        }
    }
    else {
        set sc = statusMatches
        set pResponse.Status = "Error" 
    }
    return sc
}

Method SaveResult(pRequest As QUINIELA.Message.ResultRequest, Output pResponse As QUINIELA.Message.ResultResponse) As %Status
{
    set sc = $$$OK

    set pResponse = ##class(QUINIELA.Message.ResultResponse).%New()
    set pResponse.Operation = pRequest.Operation

    set dynEntity = {}.%FromJSON(pRequest.JSON)

    if (dynEntity.LocalGoals > dynEntity.VisitorGoals)
    {
        set dynEntity.Result = 1
    }
    elseif (dynEntity.LocalGoals < dynEntity.VisitorGoals)
    {
        set dynEntity.Result = 2
    }
    else
    {
        set dynEntity.Result = 0
    }
    set sqlUpdateResult = "UPDATE QUINIELA_Object.MatchPredicted SET LocalGoals = ?, "_
        "VisitorGoals = ?, "_
        "Result = ? "_
        "WHERE ID = ? "
    set statementUpdateResult = ##class(%SQL.Statement).%New()
    set statusUpdateResult = statementUpdateResult.%Prepare(sqlUpdateResult)
    if ($$$ISOK(statusUpdateResult)) {
        set resultSetUpdateResult = statementUpdateResult.%Execute(dynEntity.LocalGoals, dynEntity.VisitorGoals, dynEntity.Result, dynEntity.MatchId)
        set sc = statusUpdateResult
    }
    else {
        set sc = statusUpdateResult
    }
    set pResponse.Status = "Finished"

    Quit sc
}

Method DeleteResult(pRequest As QUINIELA.Message.DeleteRequest, Output pResponse As QUINIELA.Message.DeleteResponse) As %Status
{
    set sc = $$$OK

    set pResponse = ##class(QUINIELA.Message.DeleteResponse).%New()
    set pResponse.Operation = pRequest.Operation

    set sqlDeleteResult = "DELETE FROM QUINIELA_Object.MatchPredicted "_
        "WHERE ID = ? "
    set statementDeleteResult = ##class(%SQL.Statement).%New()
    set statusDeleteResult = statementDeleteResult.%Prepare(sqlDeleteResult)
    if ($$$ISOK(statusDeleteResult)) {
        set resultSetDeleteResult = statementDeleteResult.%Execute(pRequest.MatchId)
        set sc = resultSetDeleteResult
    }
    else {
        set sc = statusDeleteResult
    }
    set pResponse.Status = "Finished"

    Quit sc
}

XData MessageMap
{
<MapItems>
  <MapItem MessageType="QUINIELA.Message.MatchRequest">
    <Method>SaveMatch</Method>
  </MapItem>
  <MapItem MessageType="QUINIELA.Message.ResultRequest">
    <Method>SaveResult</Method>
  </MapItem>
  <MapItem MessageType="QUINIELA.Message.DeleteRequest">
    <Method>DeleteResult</Method>
  </MapItem>
  <MapItem MessageType="QUINIELA.Message.OperationRequest">
    <Method>GetMatches</Method>
  </MapItem>
</MapItems>
}

}
