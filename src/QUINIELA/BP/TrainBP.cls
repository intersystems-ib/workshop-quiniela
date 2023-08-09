Class QUINIELA.BP.TrainBP Extends Ens.BusinessProcess
{

Method OnRequest(pRequest As QUINIELA.Message.TrainRequest, pResponse As QUINIELA.Message.TrainResponse) As %Status
{
        set pResponse = ##class(QUINIELA.Message.TrainResponse).%New()
        set pResponse.Operation = pRequest.Operation
        set pResponse.Status = "In Process"
        set sc = pResponse.%Save()

        set sc = ..SendRequestSync("QUINIELA.BO.TrainBO", pRequest, .pResponse)

        Quit $$$OK
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
