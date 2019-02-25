--性感手枪全装填
if not pcall(function() require("expansions/script/c18004001") end) then require("script/c18004001") end
local m=18004015
local cm=_G["c"..m]
cm.rssetcode="SexGun"
function cm.initial_effect(c)
	local e1=rsef.SV(c,EFFECT_QP_ACT_IN_SET_TURN,nil,nil,cm.con)
	local e2=rsef.ACT(c,nil,nil,{1,m,1},"td,dr,des","tg",nil,nil,cm.tg,cm.op)
end
function cm.con(e)
	return Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_GRAVE,0,6,nil,18004005)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local f=function(c)
		return c:IsCode(18004005) and c:IsAbleToDeck()
	end
	if chkc or chk==0 then return rstg.TargetCheck(e,tp,eg,ep,ev,re,r,rp,chk,chkc,{f,"td",LOCATION_GRAVE,0,6}) and Duel.IsPlayerCanDraw(tp,1) end
	rstg.TargetSelect(e,tp,eg,ep,ev,re,r,rp,{f,"td",LOCATION_GRAVE,0,6})
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.op(e,tp)
	local g=rsgf.GetTargetGroup()
	if #g<=0 or Duel.SendtoDeck(g,nil,0,REASON_EFFECT)<=0 then return end
	local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_DECK)
	if #og>0 then
		for i=1,#og do 
			 local tc=og:RandomSelect(tp,1):GetFirst()
			 Duel.MoveSequence(tc,0)
		end
	end
	Duel.BreakEffect()
	if Duel.Draw(tp,1,REASON_EFFECT)~=0 then
		local tc=Duel.GetOperatedGroup():GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		Duel.BreakEffect()
		if rssg.IsSexGun(tc) and Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,aux.ExceptThisCard(e))and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,aux.ExceptThisCard(e))
			Duel.Destroy(sg,REASON_EFFECT)
		end
		Duel.ShuffleHand(tp)
	end
end