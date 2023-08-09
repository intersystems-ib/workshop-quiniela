Class QUINIELA.BO.ImportBO Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Method PrepareData(pRequest As QUINIELA.Message.PrepareRequest, pResponse As QUINIELA.Message.PrepareResponse) As %Status
{
    Set sc = $$$OK
    set sqlTruncateRaw = "TRUNCATE TABLE QUINIELA_Object.RawMatch"
    set statementTruncateRaw = ##class(%SQL.Statement).%New()
    set statusTruncateRaw = statementTruncateRaw.%Prepare(sqlTruncateRaw)
    if ($$$ISOK(statusTruncateRaw)) {
        set resultSetTruncateRaw = statementTruncateRaw.%Execute()   
    }
    set sc = statusTruncateRaw
    set pResponse = ##class(QUINIELA.Message.PrepareResponse).%New()
    set pResponse.Status = "Prepared"
    set pResponse.Operation = pRequest.Operation
    Return sc
}

Method ImportData(pRequest As QUINIELA.Message.ImportRequest, pResponse As QUINIELA.Message.ImportResponse) As %Status
{
    Set sc = $$$OK
    set pResponse = ##class(QUINIELA.Message.ImportResponse).%New()
    set pResponse.Status = "In process"
    set pResponse.Operation = pRequest.Operation
    set sc = pResponse.%Save()

    if (pRequest.Operation = "Import")
    {
      set sc = ..ImportFromWeb("1")
    }
    else
    {
      set sc = ..ImportFromWeb("2")
    }
    set pResponse.Status = "Finished"
    Return sc
}

Method CreateDictionaryReferee(pRequest As QUINIELA.Message.DictionaryRefereeRequest, pResponse As QUINIELA.Message.DictionaryRefereeResponse) As %Status
{
    Set sc = $$$OK
    set sqlTruncateReferee = "TRUNCATE TABLE QUINIELA_Object.Referee"
    set statementTruncateReferee = ##class(%SQL.Statement).%New()
    set statusTruncateReferee = statementTruncateReferee.%Prepare(sqlTruncateReferee)
    if ($$$ISOK(statusTruncateReferee)) {
        set resultSetTruncateReferee = statementTruncateReferee.%Execute()
        if (resultSetTruncateReferee.%SQLCODE = 0) {
            set sqlInsertReferee = "INSERT INTO QUINIELA_Object.Referee (Name) SELECT DISTINCT(Referee) FROM QUINIELA_Object.RawMatch"
            set statementInsertReferee = ##class(%SQL.Statement).%New()
            set statusInsertReferee = statementInsertReferee.%Prepare(sqlInsertReferee)
            if ($$$ISOK(statusInsertReferee)) {
                set resultSetInsertReferee = statementInsertReferee.%Execute()
                if (resultSetInsertReferee.%SQLCODE = 0) {
                    set sc = statusInsertReferee
                }
            }
            else {
                set sc = statusInsertReferee
            }
        }
    }
    else {
        set sc = statusTruncateReferee
    }
    set pResponse = ##class(QUINIELA.Message.DictionaryRefereeResponse).%New()
    set pResponse.Status = "Referee dictionary finished"
    set pResponse.Operation = pRequest.Operation
    Return sc
}

Method CreateDictionaryTeam(pRequest As QUINIELA.Message.DictionaryTeamRequest, pResponse As QUINIELA.Message.DictionaryTeamResponse) As %Status
{
    Set sc = $$$OK
    set sqlTruncateTeam = "TRUNCATE TABLE QUINIELA_Object.Team"
    set statementTruncateTeam = ##class(%SQL.Statement).%New()
    set statusTruncateTeam = statementTruncateTeam.%Prepare(sqlTruncateTeam)
    if ($$$ISOK(statusTruncateTeam)) {
        set resultSetTruncateTeam = statementTruncateTeam.%Execute()
        if (resultSetTruncateTeam.%SQLCODE = 0) {
            set sqlInsertTeam = "INSERT INTO QUINIELA_Object.Team (Name) SELECT DISTINCT(LocalTeam) FROM QUINIELA_Object.RawMatch"
            set statementInsertTeam = ##class(%SQL.Statement).%New()
            set statusInsertTeam = statementInsertTeam.%Prepare(sqlInsertTeam)
            if ($$$ISOK(statusInsertTeam)) {
                set resultSetInsertTeam = statementInsertTeam.%Execute()
                if (resultSetInsertTeam.%SQLCODE = 0) {
                    set sc = statusInsertTeam
                }
            }
            else {
                set sc = statusInsertTeam
            }
        }
    }
    else {
        set sc = statusTruncateTeam
    }
    set pResponse = ##class(QUINIELA.Message.DictionaryTeamResponse).%New()
    set pResponse.Status = "Team dictionary finished"
    set pResponse.Operation = pRequest.Operation
    Return sc
}

ClassMethod ImportFromWeb(division As %String) As %String [ Language = python ]
{
  from os import path
  from pathlib import PurePath
  import sys

  from bs4 import BeautifulSoup
  import requests

  import iris

  directory = '/shared/files/urls'+division+'.txt'
  responses = 1

  with open(directory.replace('\\', '\\\\'), 'r') as fh:
      urls = fh.readlines()
      urls = [url.strip() for url in urls]  # strip `\n`

      for url in urls:
          file_name = PurePath(url).name
          file_path = path.join('.', file_name)
          raw_html = ''

          try:
              response = requests.get(url)
              if response.ok:                        
                  raw_html = response.text
                  html = BeautifulSoup(raw_html, 'html.parser')
                  for match in html.body.find_all('tr', 'jornadai'):                            
                      count = 0
                      matchObject = iris.cls('QUINIELA.Object.RawMatch')._New()
                      matchObject.Journey = match.get('data-jornada')
                      for specificMatch in match.children:                                                                
                          if specificMatch.name is not None and specificMatch.name == 'td' and len(specificMatch.contents) > 0:
                              match count:
                                  case 0:
                                      matchObject.Day = specificMatch.contents[0].text
                                  case 1:
                                      matchObject.LocalTeam = specificMatch.contents[0].text
                                  case 2:
                                      matchObject.GoalsLocal = specificMatch.div.a.contents[0].text
                                      matchObject.GoalsVisitor = specificMatch.div.a.contents[1].text
                                  case 3:
                                      matchObject.VisitorTeam = specificMatch.contents[0].text
                                  case 5:
                                      matchObject.Referee = specificMatch.contents[0].text
                              matchObject.Division = division                                    
                              count = count + 1
                      if (matchObject.Day != ''):
                          status = matchObject._Save()
          except requests.exceptions.ConnectionError as exc:
              print(exc)
              return exc
  return responses
}

XData MessageMap
{
<MapItems>
  <MapItem MessageType="QUINIELA.Message.PrepareRequest">
    <Method>PrepareData</Method>
  </MapItem>
  <MapItem MessageType="QUINIELA.Message.ImportRequest">
    <Method>ImportData</Method>
  </MapItem>
  <MapItem MessageType="QUINIELA.Message.DictionaryRefereeRequest">
    <Method>CreateDictionaryReferee</Method>
  </MapItem>
  <MapItem MessageType="QUINIELA.Message.DictionaryTeamRequest">
    <Method>CreateDictionaryTeam</Method>
  </MapItem>
</MapItems>
}

}