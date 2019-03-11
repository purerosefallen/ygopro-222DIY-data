--拟魂 目识
if not pcall(function() require("expansions/script/c18005001") end) then require("script/c18005001") end
local m=18005005
local cm=_G["c"..m]
cm.rssetcode="PseudoSoul"
function cm.initial_effect(c)
	rsps.EndPhasePFun(c)
	rsps.EndPhaseMFun(c)
	rsps.MBPSummonFun(c)
	rsps.OtherSummonFun(c,m,"th",rstg.target(rsop.list(Card.IsAbleToHand,"th",LOCATION_ONFIELD),rsop.list(Card.IsAbleToHand,"th",0,LOCATION_ONFIELD)),cm.op,nil,true)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local target=e:GetTarget()
	if not target(e,tp,eg,ep,ev,re,r,rp,0) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tg1=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tg2=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
	tg1:Merge(tg2)
	Duel.HintSelection(tg1)
	Duel.SendtoHand(tg1,nil,REASON_EFFECT)
end