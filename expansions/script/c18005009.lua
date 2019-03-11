--真拟魂 K觉K者G
if not pcall(function() require("expansions/script/c18005001") end) then require("script/c18005001") end
local m=18005009
local cm=_G["c"..m]
cm.rssetcode="PseudoSoul"
function cm.initial_effect(c)
	rsps.EndPhasePFun(c,true)
	rsps.EndPhaseMFun(c)
	rsps.FieldToHandFun(c)
	rsps.SummonSucessFun(c,m,nil,3,cm.tg,cm.op)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA+LOCATION_HAND)>2 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_EXTRA+LOCATION_HAND)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,1-tp,LOCATION_EXTRA+LOCATION_HAND,0,nil,TYPE_MONSTER)
	if #g>2 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local sg=g:Select(1-tp,3,3,nil)
		Duel.HintSelection(sg)
		Duel.Remove(sg,POS_FACEUP,REASON_RULE)
	end
end