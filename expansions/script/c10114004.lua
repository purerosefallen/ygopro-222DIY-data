--夜鸦·TGSX-Ⅰ
if not pcall(function() require("expansions/script/c10114001") end) then require("script/c10114001") end
local m=10114004
local cm=_G["c"..m]
function cm.initial_effect(c)
	nrrsv.NightRavenSpecialSummonRule(c,6)
	nrrsv.NightRavenSpecialSummonEffect(c,CATEGORY_REMOVE,cm.rmtg,cm.rmop)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_ONFIELD)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
	   Duel.HintSelection(g)
	   Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end