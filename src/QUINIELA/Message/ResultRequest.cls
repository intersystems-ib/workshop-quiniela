Class QUINIELA.Message.ResultRequest Extends QUINIELA.Message.OperationRequest
{

/// Description
Property JSON As %String(MAXLEN = 2000);

Storage Default
{
<Data name="ResultRequestDefaultData">
<Subscript>"ResultRequest"</Subscript>
<Value name="1">
<Value>JSON</Value>
</Value>
</Data>
<DefaultData>ResultRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
