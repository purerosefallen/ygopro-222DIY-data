--人格面具-亚森
if not pcall(function() require("expansions/script/c15873611") end) then require("script/c15873611") end
local m=15873622
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsphh.SetCode(c,true)
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(rsphh.mset),1)
	local e1=rsef.QO(c,nil,{m,0},1,"tg","tg",LOCATION_MZONE,nil,nil,rstg.target(Card.IsAbleToGrave,"tg",0,LOCATION_ONFIELD),cm.tgop)
	local e2,e3=rsef.FV_UPDATE(c,"atk,def",800,aux.TargetBoolFunction(Card.IsCode,15873611),{LOCATION_MZONE,0})
	local e4=rsef.RegisterClone(c,e2,"code",EFFECT_INDESTRUCTABLE_BATTLE,"value",1)
	local e5=rsphh.EndPhaseFun(c,15873611)
end
function cm.tgop(e,tp)
	local tc=rscf.GetTargetCard()
	if tc then Duel.SendtoGrave(tc,REASON_EFFECT) end
end