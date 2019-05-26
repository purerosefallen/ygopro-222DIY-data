--心之怪盗团-拉雯妲
if not pcall(function() require("expansions/script/c15873611") end) then require("script/c15873611") end
local m=15873641
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsphh.SetCode(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(rscf.CheckLinkSetCard,"PhantomThievesOfHearts"),2,2,cm.gfilter)
	local e1=rsef.I(c,{m,0},{1,m},"sp",nil,LOCATION_MZONE,nil,rscost.cost(cm.cfilter,"rm",LOCATION_GRAVE),rstg.target(rsop.list(cm.spfilter,"sp",LOCATION_HAND)),cm.spop)
end
function cm.gfilter(g)
	return g:IsExists(aux.FilterEqualFunction(Card.GetOriginalCode,15873629),1,nil)
end
function cm.cfilter(c)
	return rsphh.set(c) and c:IsAbleToRemoveAsCost()
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and (rsphh.set(c) or rsphh.set2(c))
end
function cm.atkfilter(c)
	return c:IsFaceup() and (rsphh.set(c) or rsphh.set2(c))
end
function cm.spop(e,tp)
	rsof.SelectHint(tp,"sp")
	local sg=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #sg>0 and rssf.SpecialSummon(sg)>0 then
		local g=Duel.GetMatchingGroup(cm.atkfilter,tp,LOCATION_MZONE,0,nil)
		for tc in aux.Next(g) do
			local e1,e2=rsef.SV_UPDATE({e:GetHandler(),tc},"atk,def",500,nil,rsreset.est)
		end
	end
end