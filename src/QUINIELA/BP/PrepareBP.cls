Class QUINIELA.BP.PrepareBP Extends Ens.BusinessProcess
{

Method OnRequest(pRequest As QUINIELA.Message.PrepareRequest, pResponse As QUINIELA.Message.PrepareResponse) As %Status
{
        set pResponse = ##class(QUINIELA.Message.PrepareResponse).%New()
        set pResponse.Operation = pRequest.Operation
        set pResponse.Status = "In Process"
        set sc = pResponse.%Save()

        set sc = ..SendRequestSync("QUINIELA.BO.PrepareBO", pRequest, .pResponse)

        Quit $$$OK
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
