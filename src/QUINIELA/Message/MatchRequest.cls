Class QUINIELA.Message.MatchRequest Extends QUINIELA.Message.OperationRequest
{

/// Description
Property JSON As %String(MAXLEN = 2000);

Storage Default
{
<Data name="MatchRequestDefaultData">
<Subscript>"MatchRequest"</Subscript>
<Value name="1">
<Value>JSON</Value>
</Value>
</Data>
<DefaultData>MatchRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
