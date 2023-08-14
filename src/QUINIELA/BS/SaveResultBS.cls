Class QUINIELA.BS.SaveResultBS Extends Ens.BusinessService
{

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As QUINIELA.Message.MatchResponse) As %Status
{
	Try {
        #Dim matchSaveRequest As QUINIELA.Message.MatchRequest
        set matchSaveRequest = ##class(QUINIELA.Message.ResultRequest).%New()
        set matchSaveRequest.JSON = pInput

        Set tSC = ..SendRequestSync("QUINIELA.BO.MatchBO", matchSaveRequest, .pOutput)
     
        } 
    Catch (ex) {
	    	set error = ex.DisplayString()            
            // set pOutput.errormessage = error
        }
	Quit $$$OK
}

}
