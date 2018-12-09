--Answer·盐见周子·Dream
function c81007226.initial_effect(c)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(81007226,2))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,81007226+EFFECT_COUNT_CODE_DUEL)
	e4:SetCondition(c81007226.thcon)
	e4:SetCost(c81007226.thcost)
	e4:SetTarget(c81007226.thtg)
	e4:SetOperation(c81007226.thop)
	c:RegisterEffect(e4)
end
function c81007226.thcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c81007226.cfilter(c)
	return c:IsAttack(0) and c:IsRace(RACE_ZOMBIE) and c:IsDiscardable()
end
function c81007226.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81007226.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c81007226.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c81007226.thfilter(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsAttack(1000) and c:IsAbleToHand()
end
function c81007226.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c81007226.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c81007226.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c81007226.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c81007226.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
