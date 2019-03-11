--拟魂 末那识
if not pcall(function() require("expansions/script/c18005001") end) then require("script/c18005001") end
local m=18005004
local cm=_G["c"..m]
cm.rssetcode="PseudoSoul"
function cm.initial_effect(c)
	rsps.EndPhasePFun(c,true)
	rsps.EndPhaseMFun(c)
	rsps.FieldToHandFun(c)
	rsps.SummonSucessFun(c,m,nil,1,rstg.target2(cm.fun,rsop.list(Card.IsAbleToDeck,"td",LOCATION_ONFIELD,LOCATION_ONFIELD)),cm.op)
end
function cm.fun(g)
	Duel.SetChainLimit(cm.chlimit)
end
function cm.chlimit(e,ep,tp)
	return tp==ep
end
function cm.op(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #tg>0 then
		Duel.HintSelection(tg)
		Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
	end
end