--康娜霍德
function c75646707.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,2)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75646707,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,75646707)
	e1:SetTarget(c75646707.target)
	e1:SetOperation(c75646707.operation)
	c:RegisterEffect(e1)
	--Damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75646707,2))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c75646707.damtg)
	e3:SetOperation(c75646707.damop)
	c:RegisterEffect(e3)
	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(75646707,3))
	e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e4:SetCode(EVENT_DAMAGE)
	e4:SetCondition(c75646707.atkcon)
	e4:SetOperation(c75646707.atkop)
	c:RegisterEffect(e4)
end
c75646707.card_code_list={75646700}
function c75646707.filter(c)
	return aux.IsCodeListed(c,75646700) and c:IsAbleToHand()
end
function c75646707.efilter(c)
	return c:IsCode(75646700) and c:IsAbleToHand()
end
function c75646707.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646707.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c75646707.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c75646707.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	end
	if Duel.IsEnvironment(75646701) and Duel.IsExistingMatchingCard(c75646707.efilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(75646707,1)) then
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c75646707.efilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g1:GetCount()>0 then
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
		end
	end
end
function c75646707.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,TYPE_MONSTER) end
	Duel.SetTargetPlayer(1-tp)
	local dam=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_MONSTER)*50
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c75646707.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local dam=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_MONSTER)*50
	Duel.Damage(p,dam,REASON_EFFECT)
end
function c75646707.atkcon(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return false end
	if bit.band(r,REASON_EFFECT)~=0 then 
	return re:GetHandler()==e:GetHandler() end
	return e:GetHandler():IsRelateToBattle()
end
function c75646707.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(300)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end