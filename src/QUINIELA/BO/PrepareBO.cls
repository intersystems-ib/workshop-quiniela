Class QUINIELA.BO.PrepareBO Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Method PrepareData(pRequest As QUINIELA.Message.PrepareRequest, pResponse As QUINIELA.Message.PrepareResponse) As %Status
{
    Set sc = $$$OK
    set pResponse = ##class(QUINIELA.Message.PrepareResponse).%New()
    set pResponse.Operation = pRequest.Operation
    
    set sqlTruncateTrain = "TRUNCATE TABLE QUINIELA_Object.MatchTrain"
    set statementTruncateTrain = ##class(%SQL.Statement).%New()
    set statusTruncateTrain = statementTruncateTrain.%Prepare(sqlTruncateTrain)
    if ($$$ISOK(statusTruncateTrain)) {
        set resultSetTruncateTrain = statementTruncateTrain.%Execute()
        if (resultSetTruncateTrain.%SQLCODE = 0) {
            set sqlMatchTrain = "INSERT INTO QUINIELA_Object.MatchTrain (Day, Division, Journey, LocalTeam, Referee, Result, VisitorTeam, IntDay) "_
                "SELECT "_
                "TO_DATE(RM.Day,'DD/MM/YYYY') AS DayTransformed, "_
                "RM.Division, "_
                "RM.Journey, "_
                "LT.ID as LocalTeam, "_
                "R.ID as Referee, "_
                "CASE WHEN CAST(RM.GoalsLocal As INTEGER) > CAST(RM.GoalsVisitor As INTEGER) THEN 1 WHEN CAST(RM.GoalsLocal As INTEGER) < CAST(RM.GoalsVisitor As INTEGER) THEN 2 ELSE 0 END as Result, "_
                "VT.ID as VisitorTeam, "_
                "CAST({fn CONCAT({fn CONCAT(SUBSTR(RM.Day,7,4),SUBSTR(RM.Day,4,2))},SUBSTR(RM.Day,1,2))} As INTEGER) as IntDay "_
                "FROM "_
                "QUINIELA_Object.RawMatch RM "_
                "LEFT JOIN QUINIELA_Object.Team LT ON UPPER(RM.LocalTeam) = UPPER(LT.Name) "_
                "LEFT JOIN QUINIELA_Object.Team VT ON UPPER(RM.VisitorTeam) = UPPER(VT.Name) "_
                "LEFT JOIN QUINIELA_Object.Referee R ON UPPER(RM.Referee) = UPPER(R.Name)"
            set statementMatchTrain = ##class(%SQL.Statement).%New()
            set statusMatchTrain = statementMatchTrain.%Prepare(sqlMatchTrain)
            if ($$$ISOK(statusMatchTrain)) {
                set resultSetMatchTrain = statementMatchTrain.%Execute()
                if (resultSetMatchTrain.%SQLCODE = 0) {
                    set sqlUpdateLocalStreak = "UPDATE QUINIELA_Object.MatchTrain SET QUINIELA_Object.MatchTrain.LocalStreak = "_
                        "(SELECT SUM(CASE Result WHEN 1 THEN 3 WHEN 0 THEN 1 ELSE 0 END) FROM "_
                        "(SELECT TOP 3 SubMatch.IntDay, Result "_
                        "FROM QUINIELA_Object.MatchTrain AS SubMatch "_
                        "WHERE "_
                        "UPPER(SubMatch.LocalTeam) = UPPER(QUINIELA_Object.MatchTrain.LocalTeam) "_
                        "AND SubMatch.IntDay < QUINIELA_Object.MatchTrain.IntDay "_
                        "ORDER BY SubMatch.IntDay DESC)) "
                    set statementUpdateLocalStreak = ##class(%SQL.Statement).%New()
                    set statusUpdateLocalStreak = statementUpdateLocalStreak.%Prepare(sqlUpdateLocalStreak)
                    if ($$$ISOK(statusUpdateLocalStreak)) {
                        set resultSetUpdateLocalStreak = statementUpdateLocalStreak.%Execute()
                        if (resultSetUpdateLocalStreak.%SQLCODE = 0) {
                            set sqlUpdateVisitorStreak = "UPDATE QUINIELA_Object.MatchTrain SET QUINIELA_Object.MatchTrain.VisitorStreak = "_
                                "(SELECT SUM(CASE Result WHEN 2 THEN 3 WHEN 0 THEN 1 ELSE 0 END) FROM "_
                                "(SELECT TOP 3 SubMatch.IntDay, Result "_
                                "FROM QUINIELA_Object.MatchTrain AS SubMatch "_
                                "WHERE "_
                                "UPPER(SubMatch.VisitorTeam) = UPPER(QUINIELA_Object.MatchTrain.VisitorTeam) "_
                                "AND SubMatch.IntDay < QUINIELA_Object.MatchTrain.IntDay "_
                                "ORDER BY SubMatch.IntDay DESC)) "
                            set statementUpdateVisitorStreak = ##class(%SQL.Statement).%New()
                            set statusUpdateVisitorStreak = statementUpdateVisitorStreak.%Prepare(sqlUpdateVisitorStreak)
                            if ($$$ISOK(statusUpdateVisitorStreak)) {
                                set resultSetUpdateVisitorStreak = statementUpdateVisitorStreak.%Execute()
                                set sc = statusUpdateVisitorStreak
                                if (resultSetUpdateVisitorStreak.%SQLCODE = 0) {
                                    set sqlUpdatePredictionStreak = "UPDATE QUINIELA_Object.MatchTrain SET QUINIELA_Object.MatchTrain.PredictionStreak = "_
                                        "CASE WHEN QUINIELA_Object.MatchTrain.LocalStreak < QUINIELA_Object.MatchTrain.VisitorStreak THEN '2' "_
                                        "WHEN QUINIELA_Object.MatchTrain.LocalStreak > QUINIELA_Object.MatchTrain.VisitorStreak THEN '1' "_
                                        "ELSE '0' END"
                                    set statementUpdatePredictionStreak = ##class(%SQL.Statement).%New()
                                    set statusUpdatePredictionStreak = statementUpdatePredictionStreak.%Prepare(sqlUpdatePredictionStreak)
                                    if ($$$ISOK(statusUpdatePredictionStreak)) {
                                        set resultSetUpdatePredictionStreak = statementUpdatePredictionStreak.%Execute()
                                        set sc = statusUpdatePredictionStreak
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
                }
            }
            else {
                set sc = statusMatchTrain
            }
        }
    }
    
    set pResponse.Status = "Finished"

    Return sc
}

XData MessageMap
{
<MapItems>
  <MapItem MessageType="QUINIELA.Message.PrepareRequest">
    <Method>PrepareData</Method>
  </MapItem>
</MapItems>
}

}
