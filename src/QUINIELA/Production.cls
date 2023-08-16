Class QUINIELA.Production Extends Ens.Production [ Not ProcedureBlock ]
{

XData ProductionDefinition
{
<Production Name="QUINIELA.Production" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>1</ActorPoolSize>
  <Item Name="QUINIELA.BO.ImportBO" Category="" ClassName="QUINIELA.BO.ImportBO" PoolSize="5" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="QUINIELA.BP.ImportBPL" Category="" ClassName="QUINIELA.BP.ImportBPL" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="QUINIELA.BO.StatusBO" Category="" ClassName="QUINIELA.BO.StatusBO" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="QUINIELA.BS.FromWSBS" Category="" ClassName="QUINIELA.BS.FromWSBS" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="QUINIELA.BO.PrepareBO" Category="" ClassName="QUINIELA.BO.PrepareBO" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="QUINIELA.BO.TrainBO" Category="" ClassName="QUINIELA.BO.TrainBO" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="QUINIELA.BP.PrepareBP" Category="" ClassName="QUINIELA.BP.PrepareBP" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="QUINIELA.BP.TrainBP" Category="" ClassName="QUINIELA.BP.TrainBP" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="QUINIELA.BO.UtilsBO" Category="" ClassName="QUINIELA.BO.UtilsBO" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="QUINIELA.BO.MatchBO" Category="" ClassName="QUINIELA.BO.MatchBO" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
</Production>
}

}
