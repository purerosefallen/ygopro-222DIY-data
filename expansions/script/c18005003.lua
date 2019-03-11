--拟魂 耳识
if not pcall(function() require("expansions/script/c18005001") end) then require("script/c18005001") end
local m=18005003
local cm=_G["c"..m]
cm.rssetcode="PseudoSoul"
function cm.initial_effect(c)
	rsps.EndPhasePFun(c)
	rsps.EndPhaseMFun(c)
	rsps.MBPSummonFun(c)
	rsps.OtherSummonFun(c,m,"th,sum",cm.tg,cm.op,cm.cfilter)
end
function cm.cfilter(c,tp)
	return c:IsAbleToHand() and Duel.GetMZoneCount(tp,c,tp)>0
end
function cm.sumfilter(c)
	return c:CheckSetCard("PseudoSoul") and c:IsSummonable(true,nil)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,nil,tp) and Duel.IsExistingMatchingCard(cm.sumfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.op(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
	if #g>0 then
		Duel.Summon(tp,g:GetFirst(),true,nil)
	end
end