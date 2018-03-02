--夜鸦·TGSX-Ⅲ
if not pcall(function() require("expansions/script/c10114001") end) then require("script/c10114001") end
local m=10114006
local cm=_G["c"..m]
function cm.initial_effect(c)
	nrrsv.NightRavenSpecialSummonRule(c,6)
	nrrsv.NightRavenSpecialSummonEffect(c,CATEGORY_TODECK,cm.tdtg,cm.tdop)
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_GRAVE)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsAbleToDeck),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,3,nil)
	if g:GetCount()>0 then
	   Duel.HintSelection(g)
	   Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end