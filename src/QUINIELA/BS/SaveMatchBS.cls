Class QUINIELA.BS.SaveMatchBS Extends Ens.BusinessService
{

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As QUINIELA.Message.MatchResponse) As %Status
{
	Try {
        #Dim matchSaveRequest As QUINIELA.Message.MatchRequest
        set matchSaveRequest = ##class(QUINIELA.Message.MatchRequest).%New()
        set matchSaveRequest.JSON = pInput

        set pOutput = ##class(QUINIELA.Message.MatchResponse).%New()
        set pOutput.Status = "In process"
        set pOutput.Operation = "Save Match"

        Set tSC = ..SendRequestSync("QUINIELA.BO.MatchBO", matchSaveRequest, .pResponse)
        if $ISOBJECT(pResponse) {
            set pOutput = pResponse
        }        
        } 
    Catch (ex) {
	    	set error = ex.DisplayString()            
            // set pOutput.errormessage = error
        }
	Quit $$$OK
}

}
