--拟魂 鼻识
if not pcall(function() require("expansions/script/c18005001") end) then require("script/c18005001") end
local m=18005002
local cm=_G["c"..m]
cm.rssetcode="PseudoSoul"
function cm.initial_effect(c)
	rsps.EndPhasePFun(c)
	rsps.EndPhaseMFun(c)
	rsps.MBPSummonFun(c)
	rsps.OtherSummonFun(c,m,"th,dr",cm.tg,cm.op)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.op(e,tp)
	Duel.Draw(tp,1,REASON_EFFECT)
end