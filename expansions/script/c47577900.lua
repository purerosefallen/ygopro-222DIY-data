--堕天司的诡计
function c47577900.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,47577900+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c47577900.target)
	e1:SetOperation(c47577900.activate)
	c:RegisterEffect(e1) 
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(47577900,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,47577901)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c47577900.inmtg)
	e2:SetOperation(c47577900.inmop)
	c:RegisterEffect(e2)   
end
function c47577900.filter(c)
	return c:IsSetCard(0x95de) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c47577900.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c47577900.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c47577900.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c47577900.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c47577900.inmfilter(c)
	return c:IsRace(RACE_FAIRY)
end
function c47577900.inmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c47577900.inmfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c47577900.inmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c47577900.efilter)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
		tc:RegisterEffect(e1)
	end
end
function c47577900.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end