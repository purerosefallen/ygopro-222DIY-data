--恶念督视
if not pcall(function() require("expansions/script/c33310023") end) then require("script/c33310023") end
local m=33310005
local cm=_G["c"..m]
function cm.initial_effect(c)
	--tigger
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_DESTROY+CATEGORY_HANDES+CATEGORY_TOGRAVE)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCondition(cm.condition)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2)	
end
cm.setcard="terraria"
function cm.cfilter(c,tp)
	return c:IsControler(1-tp) and not c:IsReason(REASON_DRAW)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function cm.desfilter(c)
	return c.setcard=="terraria" and c:IsFaceup()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local d1=Duel.Draw(tp,1,REASON_EFFECT)
	local d2=Duel.Draw(1-tp,1,REASON_EFFECT)
	if d1==0 or d2==0 then return end
	local g1=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_HAND,nil)
	local g2=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_ONFIELD,0,e:GetHandler())
	if g1:GetCount()<=0 or g2:GetCount()<=0 or not Duel.SelectYesNo(tp,aux.Stringid(m,0)) then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=g2:Select(tp,1,g1:GetCount(),nil)
	local ct=Duel.Destroy(dg,REASON_EFFECT)
	if ct>0 then
	   local g3=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	   Duel.ConfirmCards(1-tp,g3)
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	   local tg=g3:Select(tp,ct,ct,nil)
	   if Duel.SendtoGrave(tg,REASON_EFFECT)~=0 then
		  local og=Duel.GetOperatedGroup()
		  for tc in aux.Next(og) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		  end
	   end
	   Duel.ShuffleHand(1-tp)
	end
end

