Class QUINIELA.Object.RawMatch Extends %Persistent
{

/// Local team
Property LocalTeam As %String;

/// Visitor team
Property VisitorTeam As %String;

/// Day
Property Day As %String;

/// Goals local
Property GoalsLocal As %String;

/// Goals visitor
Property GoalsVisitor As %String;

/// Referee
Property Referee As %String;

/// Division
Property Division As %String;

/// Journey
Property Journey As %String;

Storage Default
{
<Data name="RawMatchDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LocalTeam</Value>
</Value>
<Value name="3">
<Value>VisitorTeam</Value>
</Value>
<Value name="4">
<Value>Day</Value>
</Value>
<Value name="5">
<Value>GoalsLocal</Value>
</Value>
<Value name="6">
<Value>GoalsVisitor</Value>
</Value>
<Value name="7">
<Value>Referee</Value>
</Value>
<Value name="8">
<Value>Division</Value>
</Value>
<Value name="9">
<Value>Journey</Value>
</Value>
</Data>
<DataLocation>^QUINIELA.Object.RawMatchD</DataLocation>
<DefaultData>RawMatchDefaultData</DefaultData>
<IdLocation>^QUINIELA.Object.RawMatchD</IdLocation>
<IndexLocation>^QUINIELA.Object.RawMatchI</IndexLocation>
<StreamLocation>^QUINIELA.Object.RawMatchS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
