Class QUINIELA.Object.Team Extends %Persistent
{

/// Description
Property Name As %String;

Index NameTeamIDX On Name;

Storage Default
{
<Data name="TeamDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>^QUINIELA.Object.TeamD</DataLocation>
<DefaultData>TeamDefaultData</DefaultData>
<IdLocation>^QUINIELA.Object.TeamD</IdLocation>
<IndexLocation>^QUINIELA.Object.TeamI</IndexLocation>
<StreamLocation>^QUINIELA.Object.TeamS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
