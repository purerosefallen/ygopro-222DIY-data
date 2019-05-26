--崩坏总选举 北欧
function c75646208.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,75646208)
	e1:SetCondition(c75646208.condition)
	e1:SetTarget(c75646208.target)
	e1:SetOperation(c75646208.activate)
	c:RegisterEffect(e1)
end
function c75646208.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,75646209)==0
end
function c75646208.filter(c)
	return aux.IsCodeListed(c,75646208) and c:IsSetCard(0x2c0) 
		and c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function c75646208.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646208.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c75646208.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,75646209)~=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c75646208.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(100)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,75646208,0,0,1)
end