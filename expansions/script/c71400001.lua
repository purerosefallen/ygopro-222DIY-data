--梦见
function c71400001.initial_effect(c)
	--Activate(nofield)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71400001,1))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c71400001.condition1)
	e1:SetTarget(c71400001.target1)
	e1:SetCost(c71400001.cost)
	e1:SetOperation(c71400001.activate1)
	e1:SetCountLimit(1,71400001+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	--Activate(field)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71400001,2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c71400001.condition2)
	e2:SetTarget(c71400001.target2)
	e2:SetCost(c71400001.cost)
	e2:SetOperation(c71400001.activate2)
	e2:SetCountLimit(1,71400001+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e2)
end
function c71400001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c71400001.condition1(e,tp,eg,ep,ev,re,r,rp)
	tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	return tc==nil or tc:IsFacedown() or not tc:IsSetCard(0x3714)
end
function c71400001.condition2(e,tp,eg,ep,ev,re,r,rp)
	tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	return tc and tc:IsFaceup() and tc:IsSetCard(0x3714)
end
function c71400001.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(71400001,0))
	local tc=Duel.SelectMatchingCard(tp,c71400001.filter1,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,71400001,te,0,tp,tp,Duel.GetCurrentChain())
	end
end
function c71400001.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c71400001.filter2,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c71400001.filter1(c,tp)
	return c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp) and c:IsSetCard(0xb714)
end
function c71400001.filter2(c,tp)
	return c:IsSetCard(0x714) and c:IsAbleToHand() and not c:IsCode(71400001)
end
function c71400001.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400001.filter1,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c71400001.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400001.filter2,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end