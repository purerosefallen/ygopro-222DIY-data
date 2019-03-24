
function c107898413.initial_effect(c)
	c:EnableReviveLimit()
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(107898413,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c107898413.condition)
	e1:SetCost(c107898413.cost)
	e1:SetOperation(c107898413.operation)
	c:RegisterEffect(e1)
end
function c107898413.cfilter(c)
	return c:IsFaceup() and c:IsCode(107898102)
end
function c107898413.condition(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.IsExistingMatchingCard(c107898413.cfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetTurnPlayer()==tp
end
function c107898413.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetLevel()==1
	or Duel.IsCanRemoveCounter(tp,1,0,0x1,math.floor(e:GetHandler():GetLevel()/2),REASON_COST)
	and ((not Duel.IsPlayerAffectedByEffect(tp,107898504) and e:GetHandler():IsAbleToGraveAsCost()) 
	or (Duel.IsPlayerAffectedByEffect(tp,107898504) and e:GetHandler():IsAbleToRemoveAsCost()))
	end
	if e:GetHandler():GetLevel()>1 then
		Duel.RemoveCounter(tp,1,0,0x1,math.floor(e:GetHandler():GetLevel()/2),REASON_COST)
	end
	if Duel.IsPlayerAffectedByEffect(tp,107898504) then
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	else
		Duel.SendtoGrave(e:GetHandler(),REASON_COST)
	end
end
function c107898413.htfilter(c)
	return c:IsCode(107898153) and c:IsAbleToHand()
end
function c107898413.htfilter2(c)
	return c107898413.htfilter(c) and c:IsFaceup()
end
function c107898413.operation(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c107898413.htfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	local g2=Duel.GetMatchingGroup(c107898413.htfilter2,tp,LOCATION_REMOVED,0,nil)
	g1:Merge(g2)
	local yn=0
	if g1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(107898413,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=g1:Select(tp,1,1,nil)
		yn=Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLED)
	if yn==0 then
		e1:SetCountLimit(3)
	else
		e1:SetCountLimit(2)
	end
	e1:SetCondition(c107898413.thcon)
	e1:SetTarget(c107898413.thtg)
	e1:SetOperation(c107898413.thop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c107898413.thcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c107898413.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=Duel.GetAttacker()
	if chkc then return chkc==bc end
	if chk==0 then return bc:IsCode(107898153) and bc:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,bc,1,0,0)
end
function c107898413.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local bc=Duel.GetAttacker()
	if bc:IsFaceup() then
		Duel.SendtoHand(bc,nil,REASON_EFFECT)
	end
end