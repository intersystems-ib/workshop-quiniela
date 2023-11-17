/// 
Class QUINIELA.BP.ImportBPL Extends Ens.BusinessProcessBPL
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='QUINIELA.Message.ImportRequest' response='QUINIELA.Message.ImportResponse' height='4100' width='2000' >
<context>
<property name='prepareRequest' type='QUINIELA.Message.PrepareRequest' instantiate='1' />
<property name='prepareResponse' type='QUINIELA.Message.PrepareResponse' instantiate='0' />
<property name='importFirstRequest' type='QUINIELA.Message.ImportRequest' instantiate='1' />
<property name='importFirstResponse' type='QUINIELA.Message.ImportResponse' instantiate='0' />
<property name='importSecondRequest' type='QUINIELA.Message.ImportRequest' instantiate='1' />
<property name='importSecondResponse' type='QUINIELA.Message.ImportResponse' instantiate='0' />
<property name='dictionaryTeamRequest' type='QUINIELA.Message.DictionaryTeamRequest' instantiate='1' />
<property name='dictionaryTeamResponse' type='QUINIELA.Message.DictionaryTeamResponse' instantiate='0' />
<property name='dictionaryRefereeRequest' type='QUINIELA.Message.DictionaryRefereeRequest' instantiate='1' />
<property name='dictionaryRefereeResponse' type='QUINIELA.Message.DictionaryRefereeResponse' instantiate='0' />
<property name='error' type='%String' initialexpression='"false"' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='importPrimeiraRequest' type='QUINIELA.Message.ImportRequest' instantiate='1' />
<property name='importPrimeiraResponse' type='QUINIELA.Message.ImportResponse' instantiate='1' />
<property name='importPremierRequest' type='QUINIELA.Message.ImportRequest' instantiate='1' />
<property name='importPremierResponse' type='QUINIELA.Message.ImportResponse' instantiate='1' />
<property name='importSerieARequest' type='QUINIELA.Message.ImportRequest' instantiate='1' />
<property name='importSerieAResponse' type='QUINIELA.Message.ImportResponse' instantiate='1' />
<property name='importLigue1Request' type='QUINIELA.Message.ImportRequest' instantiate='1' />
<property name='importLigue1Response' type='QUINIELA.Message.ImportResponse' instantiate='1' />
<property name='importBundesligaRequest' type='QUINIELA.Message.ImportRequest' instantiate='1' />
<property name='importBundesligaResponse' type='QUINIELA.Message.ImportResponse' instantiate='1' />
<property name='importBrasilRequest' type='QUINIELA.Message.ImportRequest' instantiate='1' />
<property name='importBrasilResponse' type='QUINIELA.Message.ImportResponse' instantiate='1' />
<property name='importArgentinaRequest' type='QUINIELA.Message.ImportRequest' instantiate='1' />
<property name='importArgentinaResponse' type='QUINIELA.Message.ImportResponse' instantiate='1' />
<property name='importEredivisieRequest' type='QUINIELA.Message.ImportRequest' instantiate='1' />
<property name='importEredivisieResponse' type='QUINIELA.Message.ImportResponse' instantiate='1' />
<property name='import1RFEFRequest' type='QUINIELA.Message.ImportRequest' instantiate='1' />
<property name='import1RFEFResponse' type='QUINIELA.Message.ImportResponse' instantiate='1' />
<property name='importEurocupRequest' type='QUINIELA.Message.ImportRequest' instantiate='1' />
<property name='importEurocupResponse' type='QUINIELA.Message.ImportResponse' instantiate='1' />
</context>
<sequence xend='200' yend='3850' >
<scope xpos='200' ypos='250' xend='200' yend='3650' >
<assign name="Set operation" property="context.prepareRequest.Operation" value="&quot;Preparation of data&quot;" action="set" xpos='200' ypos='350' />
<call name='Prepare tables' target='QUINIELA.BO.ImportBO' async='0' xpos='200' ypos='450' >
<request type='QUINIELA.Message.PrepareRequest' >
<assign property="callrequest" value="context.prepareRequest" action="set" />
</request>
<response type='QUINIELA.Message.PrepareResponse' >
<assign property="context.prepareResponse" value="callresponse" action="set" />
</response>
</call>
<if name='Check preparation' condition='context.prepareResponse.Status = "Prepared"' xpos='200' ypos='550' xend='200' yend='3300' >
<true>
<assign name="Get First Division" property="context.importFirstRequest.Operation" value="&quot;First&quot;" action="set" xpos='335' ypos='700' />
<call name='Read First Division' target='QUINIELA.BO.ImportBO' async='1' xpos='335' ypos='800' >
<request type='QUINIELA.Message.ImportRequest' >
<assign property="callrequest" value="context.importFirstRequest" action="set" />
</request>
<response type='QUINIELA.Message.ImportResponse' >
<assign property="context.importFirstResponse" value="callresponse" action="set" />
</response>
</call>
<assign name="Get Second Division" property="context.importSecondRequest.Operation" value="&quot;Second&quot;" action="set" xpos='335' ypos='900' />
<call name='Read Second Division' target='QUINIELA.BO.ImportBO' async='1' xpos='335' ypos='1000' >
<request type='QUINIELA.Message.ImportRequest' >
<assign property="callrequest" value="context.importSecondRequest" action="set" />
</request>
<response type='QUINIELA.Message.ImportResponse' >
<assign property="context.importSecondResponse" value="callresponse" action="set" />
</response>
</call>
<assign name="Get Primeira" property="context.importPrimeiraRequest.Operation" value="&quot;Primeira&quot;" action="set" xpos='335' ypos='1100' />
<call name='Read Primeira Division' target='QUINIELA.BO.ImportBO' async='1' xpos='335' ypos='1200' >
<request type='QUINIELA.Message.ImportRequest' >
<assign property="callrequest" value="context.importPrimeiraRequest" action="set" />
</request>
<response type='QUINIELA.Message.ImportResponse' >
<assign property="context.importPrimeiraResponse" value="callresponse" action="set" />
</response>
</call>
<assign name="Get Premier" property="context.importPremierRequest.Operation" value="&quot;Premier&quot;" action="set" xpos='335' ypos='1300' />
<call name='Read Premier Division' target='QUINIELA.BO.ImportBO' async='1' xpos='335' ypos='1400' >
<request type='QUINIELA.Message.ImportRequest' >
<assign property="callrequest" value="context.importPremierRequest" action="set" />
</request>
<response type='QUINIELA.Message.ImportResponse' >
<assign property="context.importPremierResponse" value="callresponse" action="set" />
</response>
</call>
<assign name="Get Serie A" property="context.importSerieARequest.Operation" value="&quot;SerieA&quot;" action="set" xpos='335' ypos='1500' />
<call name='Read Serie A' target='QUINIELA.BO.ImportBO' async='1' xpos='335' ypos='1600' >
<request type='QUINIELA.Message.ImportRequest' >
<assign property="callrequest" value="context.importSerieARequest" action="set" />
</request>
<response type='QUINIELA.Message.ImportResponse' >
<assign property="context.importSerieAResponse" value="callresponse" action="set" />
</response>
</call>
<assign name="Get Ligue 1" property="context.importLigue1Request.Operation" value="&quot;Ligue1&quot;" action="set" xpos='335' ypos='1700' />
<call name='Read Ligue 1' target='QUINIELA.BO.ImportBO' async='1' xpos='335' ypos='1800' >
<request type='QUINIELA.Message.ImportRequest' >
<assign property="callrequest" value="context.importLigue1Request" action="set" />
</request>
<response type='QUINIELA.Message.ImportResponse' >
<assign property="context.importLigue1Response" value="callresponse" action="set" />
</response>
</call>
<assign name="Get Bundesliga" property="context.importBundesligaRequest.Operation" value="&quot;Bundesliga&quot;" action="set" xpos='335' ypos='1900' />
<call name='Read Bundesliga' target='QUINIELA.BO.ImportBO' async='1' xpos='335' ypos='2000' >
<request type='QUINIELA.Message.ImportRequest' >
<assign property="callrequest" value="context.importBundesligaRequest" action="set" />
</request>
<response type='QUINIELA.Message.ImportResponse' >
<assign property="context.importBundesligaResponse" value="callresponse" action="set" />
</response>
</call>
<assign name="Get Brasileirao" property="context.importBrasilRequest.Operation" value="&quot;Brasil&quot;" action="set" xpos='335' ypos='2100' />
<call name='Read Brasileirao' target='QUINIELA.BO.ImportBO' async='1' xpos='335' ypos='2200' >
<request type='QUINIELA.Message.ImportRequest' >
<assign property="callrequest" value="context.importBrasilRequest" action="set" />
</request>
<response type='QUINIELA.Message.ImportResponse' >
<assign property="context.importBrasilResponse" value="callresponse" action="set" />
</response>
</call>
<assign name="Get Argentina" property="context.importArgentinaRequest.Operation" value="&quot;Argentina&quot;" action="set" xpos='335' ypos='2300' />
<call name='Read Argentina' target='QUINIELA.BO.ImportBO' async='1' xpos='335' ypos='2400' >
<request type='QUINIELA.Message.ImportRequest' >
<assign property="callrequest" value="context.importArgentinaRequest" action="set" />
</request>
<response type='QUINIELA.Message.ImportResponse' >
<assign property="context.importArgentinaResponse" value="callresponse" action="set" />
</response>
</call>
<assign name="Get Eredivisie" property="context.importEredivisieRequest.Operation" value="&quot;Eredivisie&quot;" action="set" xpos='335' ypos='2500' />
<call name='Read Eredivisie' target='QUINIELA.BO.ImportBO' async='1' xpos='335' ypos='2600' >
<request type='QUINIELA.Message.ImportRequest' >
<assign property="callrequest" value="context.importEredivisieRequest" action="set" />
</request>
<response type='QUINIELA.Message.ImportResponse' >
<assign property="context.importEredivisieResponse" value="callresponse" action="set" />
</response>
</call>
<assign name="Get 1ª RFEF" property="context.import1RFEFRequest.Operation" value="&quot;1RFEF&quot;" action="set" xpos='335' ypos='2700' />
<call name='Read 1ª RFEF' target='QUINIELA.BO.ImportBO' async='1' xpos='335' ypos='2800' >
<request type='QUINIELA.Message.ImportRequest' >
<assign property="callrequest" value="context.import1RFEFRequest" action="set" />
</request>
<response type='QUINIELA.Message.ImportResponse' >
<assign property="context.import1RFEFResponse" value="callresponse" action="set" />
</response>
</call>
<assign name="Get Eurocup" property="context.importEurocupRequest.Operation" value="&quot;Eurocup&quot;" action="set" xpos='615' ypos='2691' />
<call name='Read Eurocup' target='QUINIELA.BO.ImportBO' async='1' xpos='688' ypos='2405' >
<request type='QUINIELA.Message.ImportRequest' >
<assign property="callrequest" value="context.importEurocupRequest" action="set" />
</request>
<response type='QUINIELA.Message.ImportResponse' >
<assign property="context.importEurocupResponse" value="callresponse" action="set" />
</response>
</call>
<sync name='Wait for calls' calls='Read First Division,Read Second Division,Read Primeira Division,Read Premier Division,Read Serie A,Read Ligue 1,Read Bundesliga,Read Brasileirao,Read Argentina,Read Eredivisie,Read Eurocup' type='all' xpos='335' ypos='2900' />
<call name='Create Team Dictionary' target='QUINIELA.BO.ImportBO' async='1' xpos='335' ypos='3000' >
<request type='QUINIELA.Message.DictionaryTeamRequest' >
<assign property="callrequest" value="context.dictionaryTeamRequest" action="set" />
</request>
<response type='QUINIELA.Message.DictionaryTeamResponse' >
<assign property="context.dictionaryTeamResponse" value="callresponse" action="set" />
</response>
</call>
<call name='Create Referee Dictionary' target='QUINIELA.BO.ImportBO' async='1' xpos='335' ypos='3100' >
<request type='QUINIELA.Message.DictionaryRefereeRequest' >
<assign property="callrequest" value="context.dictionaryRefereeRequest" action="set" />
</request>
<response type='QUINIELA.Message.DictionaryRefereeResponse' >
<assign property="context.dictionaryRefereeResponse" value="callresponse" action="set" />
</response>
</call>
<sync name='Wait for calls' calls='Create Team Dictionary,Create Referee Dictionary' type='all' xpos='335' ypos='3200' />
</true>
</if>
<empty name='BPL Finished' xpos='200' ypos='3400' />
<faulthandlers>
<catchall name='Check error' xpos='200' ypos='3500' xend='200' yend='350' >
<code name='Save error' xpos='200' ypos='250' >
<![CDATA[ set context.error = $System.Status.GetErrorCodes(..%Context.%LastError)]]>
</code>
</catchall>
</faulthandlers>
</scope>
<code name='Generate response' xpos='200' ypos='3750' >
<![CDATA[ set importResponse = ##class(QUINIELA.Message.ImportResponse).%New()
 set importResponse.Operation = "Import"
 if (context.error '= "false")
 {
   set importResponse.Status = "Finished"
 }
 else
 {
   set importResponse.Status = "Error"
 }
 set importResponse.Result = context.error
 do importResponse.%Save()]]>
</code>
</sequence>
</process>
}

}
