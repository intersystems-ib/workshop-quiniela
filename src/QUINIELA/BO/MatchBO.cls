Class QUINIELA.BO.MatchBO Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Method SaveMatch(pRequest As QUINIELA.Message.MatchRequest, pResponse As QUINIELA.Message.MatchResponse) As %Status
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
        "(SELECT SUM(CASE WHEN IsVictory = 1 THEN 4-%VID ELSE 0 END) FROM "_
        "(SELECT TOP 3 SubMatch.IntDay, "_
        "CASE WHEN Result = 1 THEN 1 ELSE 0 END AS IsVictory "_
        "FROM QUINIELA_Object.MatchTrain AS SubMatch "_
        "WHERE "_
        "UPPER(SubMatch.LocalTeam) = UPPER(QUINIELA_Object.MatchPredicted.LocalTeam) "_
        "AND SubMatch.IntDay < QUINIELA_Object.MatchPredicted.IntDay "_
        "ORDER BY SubMatch.IntDay DESC)) "_
        "WHERE QUINIELA_Object.MatchPredicted.ID = ? "
    set statementUpdateLocalStreak = ##class(%SQL.Statement).%New()
    set statusUpdateLocalStreak = statementUpdateLocalStreak.%Prepare(sqlUpdateLocalStreak)
    if ($$$ISOK(statusUpdateLocalStreak)) {
        set resultSetUpdateLocalStreak = statementUpdateLocalStreak.%Execute(newMatch.%Id())
        if (resultSetUpdateLocalStreak.%SQLCODE = 0) {
            set sqlUpdateVisitorStreak = "UPDATE QUINIELA_Object.MatchPredicted SET QUINIELA_Object.MatchPredicted.VisitorStreak = "_
                "(SELECT SUM(CASE WHEN IsVictory = 1 THEN 4-%VID ELSE 0 END) FROM "_
                "(SELECT TOP 3 SubMatch.IntDay, "_
                "CASE WHEN Result = 2 THEN 1 ELSE 0 END AS IsVictory "_
                "FROM QUINIELA_Object.MatchTrain AS SubMatch "_
                "WHERE "_
                "UPPER(SubMatch.VisitorTeam) = UPPER(QUINIELA_Object.MatchPredicted.VisitorTeam) "_
                "AND SubMatch.IntDay < QUINIELA_Object.MatchPredicted.IntDay "_
                "ORDER BY SubMatch.IntDay DESC)) "_
                "WHERE QUINIELA_Object.MatchPredicted.ID = ? "
            set statementUpdateVisitorStreak = ##class(%SQL.Statement).%New()
            set statusUpdateVisitorStreak = statementUpdateVisitorStreak.%Prepare(sqlUpdateVisitorStreak)
            if ($$$ISOK(statusUpdateVisitorStreak)) {
                set resultSetUpdateVisitorStreak = statementUpdateVisitorStreak.%Execute(newMatch.%Id())
                if (resultSetUpdateVisitorStreak.%SQLCODE = 0) {
                    set sqlPredict = "UPDATE QUINIELA_Object.MatchPredicted mp set mp.PredictedResult = (SELECT PREDICT(QuinielaModel) AS PredictedResult FROM QUINIELA_Object.MatchPredicted mpr WHERE mpr.%Id = mp.%Id) WHERE mp.%Id = ?"
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

Method GetMatches(pRequest As QUINIELA.Message.OperationRequest, pResponse As QUINIELA.Message.OperationResponse) As %Status
{
    Set sc = $$$OK
    set pResponse = ##class(QUINIELA.Message.DictionaryRefereeResponse).%New()
    set pResponse.Operation = pRequest.Operation
    
    set refereeArray = ##class(%DynamicArray).%New()
    set sqlMatches = "SELECT top 21 mp.Id, Day, Division, Journey, "_
        "lt.Name, vt.Name, CASE WHEN PredictedResult = 0 THEN 'X' ELSE PredictedResult END, "_
        "ROUND(PROBABILITY(QuinielaModel FOR '1')*100,2), "_
        "ROUND(PROBABILITY(QuinielaModel FOR '0')*100,2), "_
        "ROUND(PROBABILITY(QuinielaModel FOR '2')*100,2), "_
        "mp.LocalGoals, "_
        "mp.VisitorGoals "_
        "FROM QUINIELA_Object.MatchPredicted mp left join QUINIELA_Object.Team lt on mp.LocalTeam = lt.Id "_
        "left join QUINIELA_Object.Team vt on mp.VisitorTeam = vt.Id "_
        "order by Day DESC"
    set statementMatches = ##class(%SQL.Statement).%New(), statementMatches.%ObjectSelectMode = 1
    set statusMatches = statementMatches.%Prepare(sqlMatches)
    if ($$$ISOK(statusMatches)) {
        set resultSetMatches = statementMatches.%Execute()
        if (resultSetMatches.%SQLCODE = 0) {
            while (resultSetMatches.%Next() '= 0) {
                do refereeArray.%Push({"id":(resultSetMatches.%GetData(1)), "day": ($ZDATE(resultSetMatches.%GetData(2),4)), 
                "division": (resultSetMatches.%GetData(3)), "journey": (resultSetMatches.%GetData(4)), 
                "local": (resultSetMatches.%GetData(5)), "visitor": (resultSetMatches.%GetData(6)),
                "predictedResult": (resultSetMatches.%GetData(7)), "probability1": (resultSetMatches.%GetData(8)),
                "probabilityX": (resultSetMatches.%GetData(9)), "probability2": (resultSetMatches.%GetData(10)),
                "localGoals": (resultSetMatches.%GetData(11)), "visitorGoals": (resultSetMatches.%GetData(11))})
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

Method SaveResult(pRequest As QUINIELA.Message.ResultRequest, pResponse As QUINIELA.Message.ResultResponse) As %Status
{
    set sc = $$$OK

    set pResponse = ##class(QUINIELA.Message.ResultResponse).%New()
    set pResponse.Operation = pRequest.Operation

    set dynEntity = {}.%FromJSON(pRequest.JSON)
    
    set match = ##class(QUINIELA.Object.MatchPredicted).%OpenId(dynEntity.MatchId)
    set match.LocalGoals = dynEntity.LocalGoals
    set match.VisitorGoal = dynEntity.VisitorGoals
    if (match.LocalGoals > match.VisitorGoals)
    {
        set match.Result = 1
    }
    elseif (match.LocalGoals < match.VisitorGoals)
    {
        set match.Result = 2
    }
    else
    {
        set match.Result = 0
    }
    set sc = match.%Save()

    Quit sc
}

XData MessageMap
{
<MapItems>
  <MapItem MessageType="QUINIELA.Message.MatchRequest">
    <Method>SaveMatch</Method>
  </MapItem>
  <MapItem MessageType="QUINIELA.Message.OperationRequest">
    <Method>GetMatches</Method>
  </MapItem>
  <MapItem MessageType="QUINIELA.Message.ResultRequest">
    <Method>SaveResult</Method>
  </MapItem>
</MapItems>
}

}
