
function c107898404.initial_effect(c)
	c:EnableReviveLimit()
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(107898404,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c107898404.condition)
	e1:SetCost(c107898404.cost)
	e1:SetTarget(c107898404.target)
	e1:SetOperation(c107898404.operation)
	c:RegisterEffect(e1)
end
function c107898404.cfilter(c)
	return c:IsFaceup() and c:IsCode(107898101)
end
function c107898404.condition(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.IsExistingMatchingCard(c107898404.cfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetTurnPlayer()==tp
end
function c107898404.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetLevel()==1
	or Duel.IsCanRemoveCounter(tp,1,0,0x1,math.floor(e:GetHandler():GetLevel()/2),REASON_COST)
	and e:GetHandler():IsAbleToRemoveAsCost() end
	if e:GetHandler():GetLevel()>1 then
		Duel.RemoveCounter(tp,1,0,0x1,math.floor(e:GetHandler():GetLevel()/2),REASON_COST)
	end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c107898404.filter(c)
	return not c:IsType(TYPE_EQUIP) and not c:IsType(TYPE_FUSION) and not c:IsType(TYPE_LINK) and c:IsSetCard(0x575) and c:IsFaceup() and c:GetCode()~=107898404 and c:IsAbleToHand()
end
function c107898404.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c107898404.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c107898404.filter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c107898404.filter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c107898404.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
