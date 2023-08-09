Class QUINIELA.Message.OperationRequest Extends (Ens.Request, %XML.Adaptor, %JSON.Adaptor)
{

/// Description
Property Operation As %String;

Storage Default
{
<Data name="OperationRequestDefaultData">
<Subscript>"OperationRequest"</Subscript>
<Value name="1">
<Value>Operation</Value>
</Value>
</Data>
<DefaultData>OperationRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
