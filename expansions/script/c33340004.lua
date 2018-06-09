--热核污染病毒-Æ
local m=33340004
local cm=_G["c"..m]
if not RcoreVal then
   RcoreVal=RcoreVal or {}
   rccv=RcoreVal
function rccv.publiceffect(c)   
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCondition(function(e)
	  return not e:GetHandler():IsReason(REASON_DRAW)
	end)
	e1:SetOperation(function(e)
	  local e1=Effect.CreateEffect(e:GetHandler())
	  e1:SetType(EFFECT_TYPE_SINGLE)
	  e1:SetCode(EFFECT_PUBLIC)
	  e1:SetReset(RESET_EVENT+0x1fe0000)
	  e:GetHandler():RegisterEffect(e1)
	end)
	c:RegisterEffect(e1)
end
function rccv.pubcon(e,tp)   
	return e:GetHandler():IsPublic() and Duel.GetTurnPlayer()==tp
end
function rccv.pubcon2(e)   
	return e:GetHandler():IsPublic()
end

end
------------------------------------------------------------------
if cm then
function cm.initial_effect(c)
	rccv.publiceffect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1) 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1)
	e2:SetCondition(rccv.pubcon)
	e2:SetTarget(cm.thtg2)
	e2:SetOperation(cm.thop2)
	c:RegisterEffect(e2) 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,3))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1)
	e3:SetCondition(rccv.pubcon)
	e3:SetOperation(cm.thop3)
	c:RegisterEffect(e3) 
end
cm.setcard="Rcore"
function cm.thop3(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if g1:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local ag1=g1:Select(tp,1,1,nil)
	Duel.SendtoHand(ag1,1-tp,REASON_RULE) 
end
function cm.filter(c)
	return c:IsFaceup() and c:IsAttackAbove(0)
end
function cm.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,0,nil)
	local tg=g:GetMaxGroup(Card.GetAttack)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,1,0,0)
end
function cm.thop2(e,tp,eg,ep,ev,re,r,rp)
	local lp=Duel.GetLP(tp)
	if lp<=800 then Duel.SetLP(tp,0) return end
	Duel.SetLP(tp,lp-800)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then
		Duel.BreakEffect()
		local tg=g:GetMaxGroup(Card.GetAttack)
		if tg:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local sg=tg:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
		else Duel.SendtoHand(tg,nil,REASON_EFFECT) end
	end
end
function cm.thfilter(c)
	return c.setcard=="Rcore" and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
	   Duel.ConfirmCards(1-tp,g)
	   local tg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
	   if tg:GetCount()>0 and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		  local tg2=tg:Select(tp,1,1,nil)
		  if Duel.SendtoDeck(tg2,nil,0,REASON_EFFECT)~=0 then 
			 Duel.Draw(tp,1,REASON_EFFECT)
		  end
	   end
	end 
	if e:GetHandler():IsRelateToEffect(e) then
	   e:GetHandler():CancelToGrave(true)
	   Duel.SendtoHand(e:GetHandler(),1-tp,REASON_EFFECT)
	end
end



end