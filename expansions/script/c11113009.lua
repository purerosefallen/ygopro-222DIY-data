--战场女武神 莉艾拉
function c11113009.initial_effect(c)
    --salvage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11113009,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetCountLimit(1,11113009)
	e1:SetCondition(c11113009.condition)
	e1:SetTarget(c11113009.target)
	e1:SetOperation(c11113009.operation)
	c:RegisterEffect(e1)
	--to hand
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11113009,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,11113009)
	e2:SetTarget(c11113009.thtg)
	e2:SetOperation(c11113009.thop)
	c:RegisterEffect(e2)
end
function c11113009.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
	    and e:GetHandler():GetReasonCard():IsSetCard(0x15c)
end
function c11113009.filter(c)
	return c:IsSetCard(0x15c) and (c:GetType()==TYPE_SPELL or c:IsType(TYPE_QUICKPLAY)) and c:IsAbleToHand()
end
function c11113009.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c11113009.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11113009.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11113009.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
	    Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c11113009.thfilter(c)
	return c:IsSetCard(0x15c) and c:IsType(TYPE_TUNER) and not c:IsType(TYPE_PENDULUM) and not c:IsCode(11113009) and c:IsAbleToHand()
end
function c11113009.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11113009.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11113009.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11113009.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
	end
end