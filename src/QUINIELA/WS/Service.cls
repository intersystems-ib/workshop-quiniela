Class QUINIELA.WS.Service Extends %CSP.REST
{

Parameter HandleCorsRequest = 0;

Parameter CHARSET = "utf-8";

XData UrlMap [ XMLNamespace = "https://www.intersystems.com/urlmap" ]
{
<Routes>
	<Route Url="/getPrediction" Method="GET" Call="GetPrediction" />
    <Route Url="/import" Method="GET" Call="ImportRawMatches" />
    <Route Url="/getStatus/:operation" Method="GET" Call="GetStatus" />
    <Route Url="/prepare" Method="GET" Call="PrepareData" />
    <Route Url="/train" Method="GET" Call="TrainData" />
    <Route Url="/getReferees" Method="GET" Call="GetReferees" />
    <Route Url="/getTeams" Method="GET" Call="GetTeams" />
	<Route Url="/saveMatch" Method="POST" Call="SaveMatch" />
    <Route Url="/deleteMatch/:matchId" Method="DELETE" Call="DeleteMatch" />
    <Route Url="/saveResult" Method="POST" Call="SaveResult" />
    <Route Url="/getMatches/:division" Method="GET" Call="GetMatches" />
</Routes>
}

ClassMethod OnHandleCorsRequest(url As %String) As %Status
{
	set url = %request.GetCgiEnv("HTTP_REFERER")
    set origin = $p(url,"/",1,3) // origin = "http(s)://origin.com:port"

    // here you can check specific origins
    // otherway, it will allow all origins (useful while developing only)

	do %response.SetHeader("Access-Control-Allow-Credentials","true")
	do %response.SetHeader("Access-Control-Allow-Methods","GET,POST,PUT,DELETE,OPTIONS")
	do %response.SetHeader("Access-Control-Allow-Origin",origin)
	do %response.SetHeader("Access-Control-Allow-Headers","Access-Control-Allow-Origin, Origin, X-Requested-With, Content-Type, Accept, Authorization, Cache-Control")
	quit $$$OK
}

ClassMethod GetPrediction() As %Status
{
    Try {
        Do ##class(%REST.Impl).%SetContentType("application/json")
        If '##class(%REST.Impl).%CheckAccepts("application/json") Do ##class(%REST.Impl).%ReportRESTError(..#HTTP406NOTACCEPTABLE,$$$ERROR($$$RESTBadAccepts)) Quit
        
        Do ##class(%REST.Impl).%SetStatusCode("200")	
        
    } Catch (ex) {
        Do ##class(%REST.Impl).%SetStatusCode("400")
        return ex.DisplayString()
    }
    Quit $$$OK
}

ClassMethod ImportRawMatches() As %DynamicObject
{
    Try {
        Do ##class(%REST.Impl).%SetContentType("application/json")
        If '##class(%REST.Impl).%CheckAccepts("application/json") Do ##class(%REST.Impl).%ReportRESTError(..#HTTP406NOTACCEPTABLE,$$$ERROR($$$RESTBadAccepts)) Quit
        
        set newRequest = ##class(QUINIELA.Message.OperationRequest).%New()
        set newRequest.Operation = "Import"
        
        set status = ##class(Ens.Director).CreateBusinessService("QUINIELA.BS.FromWSBS", .instance)
       	set response = ##class(QUINIELA.Message.ImportResponse).%New()
        set response.Status = "In Process"
        set response.Operation = "Import"
        set status = instance.SendRequestAsync("QUINIELA.BP.ImportBPL", newRequest, .response)
        
        if $ISOBJECT(response) {	        
            Do ##class(%REST.Impl).%SetStatusCode("200")
            return response.%JSONExport()
		}		
        
    } Catch (ex) {
        Do ##class(%REST.Impl).%SetStatusCode("400")
        return ex.DisplayString()
    }
}

ClassMethod GetStatus(operation As %String) As %DynamicObject
{
    Try {
        Do ##class(%REST.Impl).%SetContentType("application/json")
        If '##class(%REST.Impl).%CheckAccepts("application/json") Do ##class(%REST.Impl).%ReportRESTError(..#HTTP406NOTACCEPTABLE,$$$ERROR($$$RESTBadAccepts)) Quit	

        set pRequest = ##class(QUINIELA.Message.OperationRequest).%New()        
        
        if (operation = "CheckImport")
        {
            set pRequest = ##class(QUINIELA.Message.ImportRequest).%New()
            set pRequest.Operation = operation
            
        }
        elseif (operation = "CheckPrepare")
        {
            set pRequest = ##class(QUINIELA.Message.PrepareRequest).%New()
            set pRequest.Operation = operation
        }
        elseif (operation = "GetDataCount")
        {
            set pRequest = ##class(QUINIELA.Message.OperationRequest).%New()
            set pRequest.Operation = operation
        }
        elseif (operation = "CheckTrain")
        {
            set pRequest = ##class(QUINIELA.Message.TrainRequest).%New()
            set pRequest.Operation = operation
        }
        else {
             Do ##class(%REST.Impl).%SetStatusCode("400")
             return "Method not found"
        }

        set status = ##class(Ens.Director).CreateBusinessService("QUINIELA.BS.FromWSBS", .instance)
        set status = instance.SendRequestSync("QUINIELA.BO.StatusBO", pRequest, .response)

        if $ISOBJECT(response) {	        
            Do ##class(%REST.Impl).%SetStatusCode("200")
            return response.%JSONExport()
        }

    } Catch (ex) {
        Do ##class(%REST.Impl).%SetStatusCode("400")
        return ex.DisplayString()
    }
}

ClassMethod PrepareData() As %DynamicObject
{
    Try {
        Do ##class(%REST.Impl).%SetContentType("application/json")
        If '##class(%REST.Impl).%CheckAccepts("application/json") Do ##class(%REST.Impl).%ReportRESTError(..#HTTP406NOTACCEPTABLE,$$$ERROR($$$RESTBadAccepts)) Quit
        
        set newRequest = ##class(QUINIELA.Message.PrepareRequest).%New()
        set newRequest.Operation = "Prepare"

        set status = ##class(Ens.Director).CreateBusinessService("QUINIELA.BS.FromWSBS", .instance)
        set response = ##class(QUINIELA.Message.PrepareResponse).%New()
        set response.Status = "In Process"
        set response.Operation = "Prepare"

        set status = instance.SendRequestAsync("QUINIELA.BP.PrepareBP", newRequest, .response)
       	      
        if $ISOBJECT(response) {	        
        	Do ##class(%REST.Impl).%SetStatusCode("200")
            return response.%JSONExport()
		}	        	
        
    } Catch (ex) {
        Do ##class(%REST.Impl).%SetStatusCode("400")
        return ex.DisplayString()
    }
}

ClassMethod TrainData() As %DynamicObject
{
    Try {
        Do ##class(%REST.Impl).%SetContentType("application/json")
        If '##class(%REST.Impl).%CheckAccepts("application/json") Do ##class(%REST.Impl).%ReportRESTError(..#HTTP406NOTACCEPTABLE,$$$ERROR($$$RESTBadAccepts)) Quit
        
        set newRequest = ##class(QUINIELA.Message.TrainRequest).%New()
        set newRequest.Operation = "Train"

        set status = ##class(Ens.Director).CreateBusinessService("QUINIELA.BS.FromWSBS", .instance)
        
        set response = ##class(QUINIELA.Message.TrainResponse).%New()
        set response.Status = "In Process"
        set response.Operation = "Train"

        set status = instance.SendRequestAsync("QUINIELA.BP.TrainBP", newRequest, .response)
       	        
        if $ISOBJECT(response) {	        
        	Do ##class(%REST.Impl).%SetStatusCode("200")
            return response.%JSONExport()
		}	        	
        
    } Catch (ex) {
        Do ##class(%REST.Impl).%SetStatusCode("400")
        return ex.DisplayString()
    }
}

ClassMethod GetReferees() As %DynamicObject
{
    Try {
        Do ##class(%REST.Impl).%SetContentType("application/json")
        If '##class(%REST.Impl).%CheckAccepts("application/json") Do ##class(%REST.Impl).%ReportRESTError(..#HTTP406NOTACCEPTABLE,$$$ERROR($$$RESTBadAccepts)) Quit
        
        set newRequest = ##class(QUINIELA.Message.DictionaryRefereeRequest).%New()
        set newRequest.Operation = "GetReferees"
        
        set status = ##class(Ens.Director).CreateBusinessService("QUINIELA.BS.FromWSBS", .instance)
        set status = instance.SendRequestSync("QUINIELA.BO.UtilsBO", newRequest, .response)
       	
        if $ISOBJECT(response) {	        
            Do ##class(%REST.Impl).%SetStatusCode("200")
            return response.%JSONExport()          
		}		
        
    } Catch (ex) {
        Do ##class(%REST.Impl).%SetStatusCode("400")
        return ex.DisplayString()
    }
}

ClassMethod GetTeams() As %DynamicObject
{
    Try {
        Do ##class(%REST.Impl).%SetContentType("application/json")
        If '##class(%REST.Impl).%CheckAccepts("application/json") Do ##class(%REST.Impl).%ReportRESTError(..#HTTP406NOTACCEPTABLE,$$$ERROR($$$RESTBadAccepts)) Quit
        
        set newRequest = ##class(QUINIELA.Message.DictionaryTeamRequest).%New()
        set newRequest.Operation = "GetTeams"
        
        set status = ##class(Ens.Director).CreateBusinessService("QUINIELA.BS.FromWSBS", .instance)
       	
        set status = instance.SendRequestSync("QUINIELA.BO.UtilsBO", newRequest, .response)
        
        if $ISOBJECT(response) {	        
            Do ##class(%REST.Impl).%SetStatusCode("200")
            return response.%JSONExport()          
		}		
        
    } Catch (ex) {
        Do ##class(%REST.Impl).%SetStatusCode("400")
        return ex.DisplayString()
    }
}

// Class method to receive person data to persist in our database

ClassMethod SaveMatch() As %Status
{
    Try {
        Do ##class(%REST.Impl).%SetContentType("application/json")
        If '##class(%REST.Impl).%CheckAccepts("application/json") Do ##class(%REST.Impl).%ReportRESTError(..#HTTP406NOTACCEPTABLE,$$$ERROR($$$RESTBadAccepts)) Quit
        
        // Reading the body of the http call with the person data
        set bodyJson = %request.Content.Read()
        
        // Creation of BS instance
        set status = ##class(Ens.Director).CreateBusinessService("QUINIELA.BS.FromWSBS", .instance)

        #Dim matchSaveRequest As QUINIELA.Message.MatchRequest
        set matchSaveRequest = ##class(QUINIELA.Message.MatchRequest).%New()
        set matchSaveRequest.Operation = "SaveMatch"
        set matchSaveRequest.JSON = bodyJson

        Set tSC = instance.SendRequestSync("QUINIELA.BO.MatchBO", matchSaveRequest, .response)

        if $ISOBJECT(response) {	        
            Do ##class(%REST.Impl).%SetStatusCode("200")
            return response.%JSONExport()          
		}	
        
    } Catch (ex) {
        Do ##class(%REST.Impl).%SetStatusCode("400")
        return ex.DisplayString()
    }
}

ClassMethod SaveResult() As %Status
{
    Try {
        Do ##class(%REST.Impl).%SetContentType("application/json")
        If '##class(%REST.Impl).%CheckAccepts("application/json") Do ##class(%REST.Impl).%ReportRESTError(..#HTTP406NOTACCEPTABLE,$$$ERROR($$$RESTBadAccepts)) Quit
        
        // Reading the body of the http call with the person data
        set bodyJson = %request.Content.Read()
        
        // Creation of BS instance
        set status = ##class(Ens.Director).CreateBusinessService("QUINIELA.BS.FromWSBS", .instance)

        #Dim resultSaveRequest As QUINIELA.Message.ResultRequest
        set resultSaveRequest = ##class(QUINIELA.Message.ResultRequest).%New()
        set resultSaveRequest.Operation = "SaveResult"
        set resultSaveRequest.JSON = bodyJson

        Set tSC = instance.SendRequestSync("QUINIELA.BO.MatchBO", resultSaveRequest, .response)
        
        if $ISOBJECT(response) {	        
            Do ##class(%REST.Impl).%SetStatusCode("200")
            return response.%JSONExport()          
		}	
        
    } Catch (ex) {
        Do ##class(%REST.Impl).%SetStatusCode("400")
        return ex.DisplayString()
    }
}

ClassMethod GetMatches(division As %String) As %DynamicObject
{
    Try {
        Do ##class(%REST.Impl).%SetContentType("application/json")
        If '##class(%REST.Impl).%CheckAccepts("application/json") Do ##class(%REST.Impl).%ReportRESTError(..#HTTP406NOTACCEPTABLE,$$$ERROR($$$RESTBadAccepts)) Quit
        
        set newRequest = ##class(QUINIELA.Message.OperationRequest).%New()
        set newRequest.Operation = "GetMatches_"_division
        
        set status = ##class(Ens.Director).CreateBusinessService("QUINIELA.BS.FromWSBS", .instance)

        set status = instance.SendRequestSync("QUINIELA.BO.MatchBO", newRequest, .response)
        
        if $ISOBJECT(response) {	        
            Do ##class(%REST.Impl).%SetStatusCode("200")
            return response.%JSONExport()          
		}		
        
    } Catch (ex) {
        Do ##class(%REST.Impl).%SetStatusCode("400")
        return ex.DisplayString()
    }
}

ClassMethod DeleteMatch(matchId As %String) As %DynamicObject
{
    Try {
        Do ##class(%REST.Impl).%SetContentType("application/json")
        If '##class(%REST.Impl).%CheckAccepts("application/json") Do ##class(%REST.Impl).%ReportRESTError(..#HTTP406NOTACCEPTABLE,$$$ERROR($$$RESTBadAccepts)) Quit
        
        set newRequest = ##class(QUINIELA.Message.DeleteRequest).%New()
        set newRequest.Operation = "DeleteMatch"
        set newRequest.MatchId = matchId
        
        set status = ##class(Ens.Director).CreateBusinessService("QUINIELA.BS.FromWSBS", .instance)

        set status = instance.SendRequestSync("QUINIELA.BO.MatchBO", newRequest, .response)
        
        if $ISOBJECT(response) {	        
            Do ##class(%REST.Impl).%SetStatusCode("200")
            return response.%JSONExport()          
		}		
        
    } Catch (ex) {
        Do ##class(%REST.Impl).%SetStatusCode("400")
        return ex.DisplayString()
    }
}

}
