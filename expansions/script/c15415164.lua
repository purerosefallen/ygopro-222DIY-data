--禁弹『カタディオプトリック』
function c15415164.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCountLimit(1,15415164)
	e1:SetCost(c15415164.cost2)
	e1:SetCondition(c15415164.condition)
	e1:SetTarget(c15415164.target)
	e1:SetOperation(c15415164.activate)
	c:RegisterEffect(e1)
end
function c15415164.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x16f,1,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.RemoveCounter(tp,1,1,0x16f,1,REASON_COST)
end
function c15415164.filters(c)
	return c:IsFaceup() and c:IsSetCard(0x168)
end
function c15415164.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and Duel.IsExistingMatchingCard(c15415164.filters,tp,LOCATION_MZONE,0,1,nil)
end
function c15415164.filter(c)
	return c:IsAttackPos()
end
function c15415164.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c15415164.filter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c15415164.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c15415164.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c15415164.filter,tp,0,LOCATION_MZONE,nil)
	local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local sc=sg:GetFirst()
		while sc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(-500)
			sc:RegisterEffect(e1)
			sc=sg:GetNext()
		end
		Duel.Destroy(g,REASON_EFFECT)
	end
end
