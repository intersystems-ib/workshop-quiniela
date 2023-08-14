Class QUINIELA.Object.MatchPredicted Extends QUINIELA.Object.MatchTrain
{

/// Result
Property PredictedResult As %Integer;

Property LocalGoals As %Integer;

Property VisitorGoals As %Integer;

Storage Default
{
<Data name="MatchPredictedDefaultData">
<Subscript>"MatchPredicted"</Subscript>
<Value name="1">
<Value>PredictedResult</Value>
</Value>
<Value name="2">
<Value>LocalGoals</Value>
</Value>
<Value name="3">
<Value>VisitorGoals</Value>
</Value>
</Data>
<DefaultData>MatchPredictedDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
