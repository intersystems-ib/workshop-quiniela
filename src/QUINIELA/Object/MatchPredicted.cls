Class QUINIELA.Object.MatchPredicted Extends QUINIELA.Object.MatchTrain
{

/// Result
Property PredictedResult As %String;

Property LocalGoals As %Integer;

Property VisitorGoals As %Integer;

Property Probability1 As %Decimal;

Property ProbabilityX As %Decimal;

Property Probability2 As %Decimal;

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
<Value name="4">
<Value>Probability1</Value>
</Value>
<Value name="5">
<Value>ProbabilityX</Value>
</Value>
<Value name="6">
<Value>Probability2</Value>
</Value>
</Data>
<DefaultData>MatchPredictedDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
