Class QUINIELA.Message.TrainRequest Extends QUINIELA.Message.OperationRequest
{

/// Name of the model
Property ModelName As %String;

Storage Default
{
<Data name="TrainRequestDefaultData">
<Subscript>"TrainRequest"</Subscript>
<Value name="1">
<Value>ModelName</Value>
</Value>
</Data>
<DefaultData>TrainRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
