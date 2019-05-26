--人格面具-墨丘利
if not pcall(function() require("expansions/script/c15873611") end) then require("script/c15873611") end
local m=15873623
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsphh.SetCode(c,true)
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(rsphh.mset),1)
	local e1=rsphh.ImmueFun(c,ATTRIBUTE_EARTH)
	local e2=rsphh.EndPhaseFun(c,15873613)  
	local e3=rsef.I(c,{m,0},1,"rec","ptg",LOCATION_MZONE,nil,nil,cm.rectg,cm.recop)
end
function cm.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(rscf.FilterFaceUp(Card.IsAttribute,ATTRIBUTE_EARTH),tp,0,LOCATION_MZONE,nil)	
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000+ct*500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000+ct*500)
end
function cm.recop(e,tp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local ct=Duel.GetMatchingGroupCount(rscf.FilterFaceUp(Card.IsAttribute,ATTRIBUTE_EARTH),p,0,LOCATION_MZONE,nil)
	Duel.Recover(p,1000+ct*500,REASON_EFFECT)
end
