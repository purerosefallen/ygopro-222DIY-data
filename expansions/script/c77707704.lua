--Vessel of Sin 克洛克沃克人偶
function c77707704.initial_effect(c)
	 local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,77707704+EFFECT_COUNT_CODE_DUEL)
	e1:SetCost(c77707704.cost)
	e1:SetOperation(c77707704.operation)
	c:RegisterEffect(e1)
end
function c77707704.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetFieldGroup(tp,0,LOCATION_SZONE+LOCATION_MZONE):FilterCount(Card.IsFacedown,nil)>0 end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c77707704.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_SZONE+LOCATION_MZONE):Filter(Card.IsFacedown,nil)
	if #g>0 then
	Duel.ConfirmCards(tp,g)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_TRIGGER)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetTargetRange(0,LOCATION_SZONE)
	e2:SetTarget(c77707704.distg)
	e2:SetCondition(c77707704.effcon)
	Duel.RegisterEffect(e2,tp)
end
function c77707704.effcon(e)
	return not Duel.IsExistingMatchingCard(Card.IsFacedown,e:GetHandlerPlayer(),LOCATION_SZONE,0,1,nil)
end
function c77707704.distg(e,c)
	return c:IsFacedown()
end
