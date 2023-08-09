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
        $$$TRACE("Local streak updated")
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
                $$$TRACE("Visitor streak updated")
                set resultSetUpdateVisitorStreak = statementUpdateVisitorStreak.%Execute(newMatch.%Id())
                set sc = statusUpdateVisitorStreak
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

XData MessageMap
{
<MapItems>
  <MapItem MessageType="QUINIELA.Message.MatchRequest">
    <Method>SaveMatch</Method>
  </MapItem>
</MapItems>
}

}
