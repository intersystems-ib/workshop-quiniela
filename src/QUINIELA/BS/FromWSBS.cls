Class QUINIELA.BS.FromWSBS Extends Ens.BusinessService
{

Method OnProcessInput(pInput As QUINIELA.Message.OperationRequest, Output pOutput As QUINIELA.Message.OperationResponse) As %Status
{
	Try {
        if (pInput.Operation = "CheckImport")
        {
            set pRequest = ##class(QUINIELA.Message.ImportRequest).%New()
            set pRequest.Operation = pInput.Operation

            set status = ..SendRequestSync("QUINIELA.BO.StatusBO", pRequest, .pOutput)
        }
        elseif (pInput.Operation = "CheckPrepare")
        {
            set pRequest = ##class(QUINIELA.Message.PrepareRequest).%New()
            set pRequest.Operation = pInput.Operation

            set status = ..SendRequestSync("QUINIELA.BO.StatusBO", pRequest, .pOutput)
        }
        elseif (pInput.Operation = "GetDataCount")
        {
            set status = ..SendRequestSync("QUINIELA.BO.StatusBO", pInput, .pOutput)
        }
        elseif (pInput.Operation = "CheckTrain")
        {
            set pRequest = ##class(QUINIELA.Message.TrainRequest).%New()
            set pRequest.Operation = pInput.Operation

            set status = ..SendRequestSync("QUINIELA.BO.StatusBO", pRequest, .pOutput)
        }
        elseif (pInput.Operation = "Import")
        {
            set pRequest = ##class(QUINIELA.Message.ImportRequest).%New()
            set pRequest.Operation = pInput.Operation

            set pOutput = ##class(QUINIELA.Message.ImportResponse).%New()
            set pOutput.Status = "In process"
            set pOutput.Operation = "Import"
            set status = ..SendRequestAsync("QUINIELA.BP.ImportBPL", pRequest, .pOutput)
        }
        elseif (pInput.Operation = "Prepare")
        {
            set pRequest = ##class(QUINIELA.Message.PrepareRequest).%New()
            set pRequest.Operation = pInput.Operation

            set pOutput = ##class(QUINIELA.Message.PrepareResponse).%New()
            set pOutput.Status = "In process"
            set pOutput.Operation = "Prepare"

            set status = ..SendRequestAsync("QUINIELA.BP.PrepareBP", pRequest, .pOutput)
        }
        elseif (pInput.Operation = "Train")
        {
            set pRequest = ##class(QUINIELA.Message.TrainRequest).%New()
            set pRequest.Operation = pInput.Operation

            set pOutput = ##class(QUINIELA.Message.TrainResponse).%New()
            set pOutput.Status = "In process"
            set pOutput.Operation = "Train"

            set status = ..SendRequestAsync("QUINIELA.BP.TrainBP", pRequest, .pOutput)
        }
        elseif (pInput.Operation = "GetReferees")
        {
            set pRequest = ##class(QUINIELA.Message.DictionaryRefereeRequest).%New()
            set pRequest.Operation = pInput.Operation

            set status = ..SendRequestSync("QUINIELA.BO.UtilsBO", pRequest, .pOutput)
        }
        elseif (pInput.Operation = "GetTeams")
        {
            set pRequest = ##class(QUINIELA.Message.DictionaryTeamRequest).%New()
            set pRequest.Operation = pInput.Operation

            set status = ..SendRequestSync("QUINIELA.BO.UtilsBO", pRequest, .pOutput)
        }
        elseif (pInput.Operation = "GetMatches")
        {
            set pRequest = ##class(QUINIELA.Message.OperationRequest).%New()
            set pRequest.Operation = pInput.Operation

            set status = ..SendRequestSync("QUINIELA.BO.MatchBO", pRequest, .pOutput)
        }

        } 
    Catch (ex) {
	    	set error = ex.DisplayString()            
            set pOutput.Status = error
        }
	Quit $$$OK
}

}
