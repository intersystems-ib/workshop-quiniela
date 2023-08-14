Class QUINIELA.Message.OperationResponse Extends (Ens.Response, %XML.Adaptor, %JSON.Adaptor)
{

/// Description
Property Operation As %String;

/// Description
Property Status As %String;

/// Description
Property Result As %String(MAXLEN = "");

Storage Default
{
<Data name="OperationResponseDefaultData">
<Subscript>"OperationResponse"</Subscript>
<Value name="1">
<Value>Operation</Value>
</Value>
<Value name="2">
<Value>Status</Value>
</Value>
<Value name="3">
<Value>Result</Value>
</Value>
</Data>
<DefaultData>OperationResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
