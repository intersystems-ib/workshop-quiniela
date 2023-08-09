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
<process language='objectscript' request='QUINIELA.Message.ImportRequest' response='QUINIELA.Message.ImportResponse' height='2150' width='2000' >
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
</context>
<sequence xend='200' yend='1900' >
<assign name="Set operation" property="context.prepareRequest.Operation" value="&quot;Preparation of data&quot;" action="set" xpos='200' ypos='250' />
<call name='Prepare tables' target='QUINIELA.BO.ImportBO' async='0' xpos='200' ypos='350' >
<request type='QUINIELA.Message.PrepareRequest' >
<assign property="callrequest" value="context.prepareRequest" action="set" />
</request>
<response type='QUINIELA.Message.PrepareResponse' >
<assign property="context.prepareResponse" value="callresponse" action="set" />
</response>
</call>
<if name='Check preparation' condition='context.prepareResponse.Status = "Prepared"' xpos='200' ypos='450' xend='200' yend='1400' >
<true>
<assign name="Get First Division" property="context.importFirstRequest.Operation" value="&quot;First&quot;" action="set" xpos='335' ypos='600' />
<call name='Read First Division' target='QUINIELA.BO.ImportBO' async='1' xpos='335' ypos='700' >
<request type='QUINIELA.Message.ImportRequest' >
<assign property="callrequest" value="context.importFirstRequest" action="set" />
</request>
<response type='QUINIELA.Message.ImportResponse' >
<assign property="context.importFirstResponse" value="callresponse" action="set" />
</response>
</call>
<assign name="Get Second Division" property="context.importSecondRequest.Operation" value="&quot;Second&quot;" action="set" xpos='335' ypos='800' />
<call name='Read Second Division' target='QUINIELA.BO.ImportBO' async='1' xpos='335' ypos='900' >
<request type='QUINIELA.Message.ImportRequest' >
<assign property="callrequest" value="context.importSecondRequest" action="set" />
</request>
<response type='QUINIELA.Message.ImportResponse' >
<assign property="context.importSecondResponse" value="callresponse" action="set" />
</response>
</call>
<sync name='Wait for calls' calls='Read First Division,Read Second Division' type='all' xpos='335' ypos='1000' />
<call name='Create Team Dictionary' target='QUINIELA.BO.ImportBO' async='1' xpos='335' ypos='1100' >
<request type='QUINIELA.Message.DictionaryTeamRequest' >
<assign property="callrequest" value="context.dictionaryTeamRequest" action="set" />
</request>
<response type='QUINIELA.Message.DictionaryTeamResponse' >
<assign property="context.dictionaryTeamResponse" value="callresponse" action="set" />
</response>
</call>
<call name='Create Referee Dictionary' target='QUINIELA.BO.ImportBO' async='1' xpos='335' ypos='1200' >
<request type='QUINIELA.Message.DictionaryRefereeRequest' >
<assign property="callrequest" value="context.dictionaryRefereeRequest" action="set" />
</request>
<response type='QUINIELA.Message.DictionaryRefereeResponse' >
<assign property="context.dictionaryRefereeResponse" value="callresponse" action="set" />
</response>
</call>
<sync name='Wait for calls' calls='Create Team Dictionary,Create Referee Dictionary' type='all' xpos='335' ypos='1300' />
</true>
</if>
<empty name='BPL Finished' xpos='200' ypos='1500' />
<code name='Generate response' xpos='200' ypos='1800' >
<![CDATA[ set importResponse = ##class(QUINIELA.Message.ImportRequest).%New()
 set importResponse.Operation = "Import"
 set importResponse.Status = "Finished"
 do importResponse.%Save()]]>
</code>
</sequence>
</process>
}

}
