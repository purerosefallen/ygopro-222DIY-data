--新干线的超进化
if not pcall(function() require("expansions/script/c18008001") end) then require("script/c18008001") end
local m=18008011
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsef.ACT(c,EVENT_CHAINING,nil,nil,"neg,sp","dsp,dcal",cm.con,nil,cm.tg,cm.act)
end
cm.rssetcode="Shinkansen"
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_REMOVED,0,nil)
	return rssk.nmcon(e,tp) and g:GetClassCount(Card.GetCode)>=3 and Duel.IsChainNegatable(ev) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function cm.cfilter(c)
	return rssk.set(c) and c:IsFaceup()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceup() and rssk.set(c)
end
function cm.act(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) then
		local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_REMOVED,0,nil,e,tp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			rsof.SelectHint(tp,"sp")
			local sg=g:Select(tp,1,1,nil)
			rssf.SpecialSummon(sg)
		end
	end
end