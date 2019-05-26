--人格面具-须佐之男
if not pcall(function() require("expansions/script/c15873611") end) then require("script/c15873611") end
local m=15873626
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsphh.SetCode(c,true)
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(rsphh.mset),1)
	local e1=rsphh.ImmueFun(c,ATTRIBUTE_FIRE)
	local e2=rsphh.EndPhaseFun(c,15873615)  
	local e3=rsef.QO(c,nil,{m,0},1,"des,dis","tg",LOCATION_MZONE,nil,rscost.cost(Card.IsDiscardable,"dish",LOCATION_HAND),rstg.target2(cm.fun,aux.disfilter1,"des",0,LOCATION_MZONE,1,2),cm.disop)   
end
function cm.fun(g,e,tp)
	local dg=g:Filter(rscf.FilterFaceUp(Card.IsAttribute,ATTRIBUTE_FIRE),nil) 
	if #dg>0 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,#dg,1-tp,LOCATION_MZONE)
	end
end
function cm.disop(e,tp)
	local c=e:GetHandler()
	local g=rsgf.GetTargetGroup(aux.disfilter1)
	if #g<=0 then return end
	for tc in aux.Next(g) do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1,e2=rsef.SV_LIMIT({c,tc},"dis,dise",nil,nil,rsreset.est_pend)
	end
	local dg=g:Filter(rscf.FilterFaceUp(Card.IsAttribute,ATTRIBUTE_FIRE),nil) 
	if #dg>0 then
		Duel.Destroy(dg,REASON_EFFECT)
	end
end