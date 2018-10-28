--伊瑟琳·抹茶芭菲
function c75646602.initial_effect(c)
	--RECOVER
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75646602,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,75646602)
	e1:SetCost(c75646602.cost)
	e1:SetOperation(c75646602.operation)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75646602,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,75646602)
	e2:SetCondition(c75646602.condition)
	e2:SetCost(c75646602.cost1)
	e2:SetOperation(c75646602.operation1)
	c:RegisterEffect(e2)
end
c75646602.card_code_list={75646600}
function c75646602.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c75646602.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetCondition(c75646602.con1)
	e1:SetOperation(c75646602.op1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c75646602.con1(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and bit.band(r,REASON_BATTLE)==REASON_BATTLE
end
function c75646602.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,700,REASON_EFFECT)
end
function c75646602.cfilter(c)
	return aux.IsCodeListed(c,75646600) and c:IsDiscardable()
end
function c75646602.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable()
		and Duel.IsExistingMatchingCard(c75646602.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c75646602.cfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SendtoGrave(g,REASON_DISCARD+REASON_COST)
end
function c75646602.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetCondition(c75646602.con2)
	e1:SetOperation(c75646602.op2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c75646602.con2(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp 
end
function c75646602.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,ev,REASON_EFFECT)
	if Duel.SelectYesNo(tp,aux.Stringid(75646602,2)) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c75646602.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,75646600)~=0
end