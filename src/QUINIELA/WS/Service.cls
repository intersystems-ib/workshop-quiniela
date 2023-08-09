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
       	
        set status = instance.OnProcessInput(newRequest, .response)
        
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
        
        set newRequest = ##class(QUINIELA.Message.OperationRequest).%New()
        set newRequest.Operation = operation
        
        set status = ##class(Ens.Director).CreateBusinessService("QUINIELA.BS.FromWSBS", .instance)
       	
        set status = instance.OnProcessInput(newRequest, .response)
        
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
        
        set newRequest = ##class(QUINIELA.Message.OperationRequest).%New()
        set newRequest.Operation = "Prepare"

        set status = ##class(Ens.Director).CreateBusinessService("QUINIELA.BS.FromWSBS", .instance)
       	
        set status = instance.OnProcessInput(newRequest, .response)
        
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
        
        set newRequest = ##class(QUINIELA.Message.OperationRequest).%New()
        set newRequest.Operation = "Train"

        set status = ##class(Ens.Director).CreateBusinessService("QUINIELA.BS.FromWSBS", .instance)
       	
        set status = instance.OnProcessInput(newRequest, .response)
        
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
        
        set newRequest = ##class(QUINIELA.Message.OperationRequest).%New()
        set newRequest.Operation = "GetReferees"
        
        set status = ##class(Ens.Director).CreateBusinessService("QUINIELA.BS.FromWSBS", .instance)
       	
        set status = instance.OnProcessInput(newRequest, .response)
        
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
        
        set newRequest = ##class(QUINIELA.Message.OperationRequest).%New()
        set newRequest.Operation = "GetTeams"
        
        set status = ##class(Ens.Director).CreateBusinessService("QUINIELA.BS.FromWSBS", .instance)
       	
        set status = instance.OnProcessInput(newRequest, .response)
        
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
        set status = ##class(Ens.Director).CreateBusinessService("QUINIELA.BS.SaveMatchBS", .instance)
       	
        #dim response as QUINIELA.Message.MatchResponse

        // Invocation of BS with person data
        set status = instance.OnProcessInput(bodyJson, .response)
        
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
