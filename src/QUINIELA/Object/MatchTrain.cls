Class QUINIELA.Object.MatchTrain Extends (%Persistent, %JSON.Adaptor) [ DdlAllowed ]
{

/// Day of the match
Property Day As %Date;

/// Local Team
Property LocalTeam As %String;

/// Visitor Team
Property VisitorTeam As %String;

/// Local Streak
Property LocalStreak As %Integer;

/// Visitor Streak
Property VisitorStreak As %Integer;

/// Referee
Property Referee As %String;

/// Result
Property Result As %String;

/// Division
Property Division As %String;

/// Journey
Property Journey As %String;

/// Integer day
Property IntDay As %Integer;

/// Local Points
Property LocalPoints As %Integer;

/// Visitor Streak
Property VisitorPoints As %Integer;

// Index LocalStreakIDX On (LocalTeam, IntDay);

// Index VisitorStreakIDX On (VisitorTeam, IntDay);

Storage Default
{
<Data name="MatchTrainDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Day</Value>
</Value>
<Value name="3">
<Value>LocalTeam</Value>
</Value>
<Value name="4">
<Value>VisitorTeam</Value>
</Value>
<Value name="5">
<Value>LocalStreak</Value>
</Value>
<Value name="6">
<Value>VisitorStreak</Value>
</Value>
<Value name="7">
<Value>Referee</Value>
</Value>
<Value name="8">
<Value>Result</Value>
</Value>
<Value name="9">
<Value>Division</Value>
</Value>
<Value name="10">
<Value>Journey</Value>
</Value>
<Value name="11">
<Value>IntDay</Value>
</Value>
<Value name="12">
<Value>LocalPoints</Value>
</Value>
<Value name="13">
<Value>VisitorPoints</Value>
</Value>
</Data>
<DataLocation>^QUINIELA.Object.MatchTrainD</DataLocation>
<DefaultData>MatchTrainDefaultData</DefaultData>
<IdLocation>^QUINIELA.Object.MatchTrainD</IdLocation>
<IndexLocation>^QUINIELA.Object.MatchTrainI</IndexLocation>
<StreamLocation>^QUINIELA.Object.MatchTrainS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
