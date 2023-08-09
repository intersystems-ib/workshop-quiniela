Class QUINIELA.Object.Referee Extends %Persistent
{

/// Description
Property Name As %String;

Index NameRefereeIDX On Name;

Storage Default
{
<Data name="RefereeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>^QUINIELA.Object.RefereeD</DataLocation>
<DefaultData>RefereeDefaultData</DefaultData>
<IdLocation>^QUINIELA.Object.RefereeD</IdLocation>
<IndexLocation>^QUINIELA.Object.RefereeI</IndexLocation>
<StreamLocation>^QUINIELA.Object.RefereeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
