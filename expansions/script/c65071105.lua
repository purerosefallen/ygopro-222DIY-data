--月光
function c65071105.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c65071105.condition)
	e1:SetTarget(c65071105.target)
	e1:SetOperation(c65071105.activate)
	c:RegisterEffect(e1)
end

function c65071105.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and re:GetHandler():IsActiveType(TYPE_MONSTER)
end

function c65071105.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(re:GetHandler())
end

function c65071105.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local mp=tc:GetControler()
		local rec=tc:GetAttack()
		Duel.Recover(mp,rec,REASON_EFFECT)
		if Duel.GetLP(mp)>=10000 then
		Duel.BreakEffect()
		local lp=Duel.GetLP(mp)
		Duel.SetLP(mp,lp/2)
		Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end