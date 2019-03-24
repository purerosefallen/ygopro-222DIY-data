
function c107898414.initial_effect(c)
	c:EnableReviveLimit()
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(107898414,0))
	e1:SetCategory(CATEGORY_LVCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c107898414.condition)
	e1:SetCost(c107898414.cost)
	e1:SetOperation(c107898414.operation)
	c:RegisterEffect(e1)
end
function c107898414.cfilter(c)
	return c:IsFaceup() and c:IsCode(107898102)
end
function c107898414.cffilter(c)
	return (c:IsSetCard(0x575a) or c:IsSetCard(0x575b) or c:IsSetCard(0x575c)) and not c:IsPublic()
end
function c107898414.condition(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.IsExistingMatchingCard(c107898414.cfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetTurnPlayer()==tp
end
function c107898414.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetLevel()==1
	or Duel.IsCanRemoveCounter(tp,1,0,0x1,math.floor(e:GetHandler():GetLevel()/2),REASON_COST)
	and e:GetHandler():IsAbleToRemoveAsCost()
	and Duel.IsExistingMatchingCard(c107898414.cffilter,tp,LOCATION_HAND,0,1,e:GetHandler())
	end
	if e:GetHandler():GetLevel()>1 then
		Duel.RemoveCounter(tp,1,0,0x1,math.floor(e:GetHandler():GetLevel()/2),REASON_COST)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c107898414.cffilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	local cc=g:GetFirst()
	e:SetLabelObject(cc)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c107898414.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetLabelObject(e:GetLabelObject())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetCountLimit(1)
	e1:SetCondition(c107898414.thcon)
	e1:SetOperation(c107898414.thop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN,1)
	Duel.RegisterEffect(e1,tp)
end
function c107898414.thfilter(c,cc)
	return c:IsCode(cc:GetCode()) and c:IsAbleToHand()
end
function c107898414.thfilter2(c,cc)
	return c107898414.thfilter(c,cc) and c:IsFaceup()
end
function c107898414.thcon(e,tp,eg,ep,ev,re,r,rp)
	local cc=e:GetLabelObject()
	return Duel.IsExistingMatchingCard(c107898414.thfilter2,tp,LOCATION_REMOVED,0,1,nil,cc) or Duel.IsExistingMatchingCard(c107898414.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,cc) and Duel.GetTurnPlayer()==tp
end
function c107898414.thop(e,tp,eg,ep,ev,re,r,rp)
	local cc=e:GetLabelObject()
	Duel.Hint(HINT_CARD,0,107898414)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.GetMatchingGroup(c107898414.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,cc)
	local g2=Duel.GetMatchingGroup(c107898414.thfilter2,tp,LOCATION_REMOVED,0,nil,cc)
	g1:Merge(g2)
	local g=g1:Select(tp,1,3,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end