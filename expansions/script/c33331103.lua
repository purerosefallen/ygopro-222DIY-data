--尾圈小狐
if not pcall(function() require("expansions/script/c33331100") end) then require("script/c33331100") end
local m=33331103
local cm=_G["c"..m]
function cm.initial_effect(c)
	rslf.SpecialSummonFunction(c,m,cm.con,cm.op,cm.buff)
end
function cm.cfilter(c)
	return c:IsAbleToDeckAsCost() and c:IsSetCard(0x2553)
end
function cm.con(e,tp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,nil)
end
function cm.op(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
function cm.buff(c)
	local e1,e2=rsef.SV_INDESTRUCTABLE({c,true},"battle,effect")
	local e3=rsef.I({c,true},{m,0},1,"dr,td",nil,LOCATION_MZONE,cm.drcon,nil,cm.drtg,cm.drop)
	return e1,e2,e3
end
function cm.drcon(e,tp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)-Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,ct) and ct2>0 end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,ct2,tp,LOCATION_HAND)
end
function cm.drop(e,tp)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local ct2=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	if ct>0 and Duel.Draw(tp,ct,REASON_EFFECT)~=0 and ct2>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,ct2,ct2,nil)
		if #tg>0 then
			Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
		end
	end
end