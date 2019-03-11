--拟魂 身识
if not pcall(function() require("expansions/script/c18005001") end) then require("script/c18005001") end
local m=18005007
local cm=_G["c"..m]
cm.rssetcode="PseudoSoul"
function cm.initial_effect(c)
	rsps.EndPhasePFun(c,true)
	rsps.EndPhaseMFun(c)
	rsps.FieldToHandFun(c)
	rsps.SummonSucessFun(c,m,nil,0,rstg.target(rsop.list(Card.IsAbleToRemove,"rm",LOCATION_ONFIELD,LOCATION_ONFIELD)),cm.op)
end
function cm.op(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #tg>0 then
		Duel.HintSelection(tg)
		Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
	end
end