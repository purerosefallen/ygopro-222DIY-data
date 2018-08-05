--禁弹『过去を刻む时计』
function c15415165.initial_effect(c)
	c:EnableCounterPermit(0x16f)
	c:SetUniqueOnField(1,0,15415165)	
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,15415165+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)   
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(c15415165.condition)
	e2:SetCost(c15415165.cost)
	e2:SetOperation(c15415165.activate)
	c:RegisterEffect(e2) 
end
function c15415165.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x168)
end
function c15415165.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and Duel.IsExistingMatchingCard(c15415165.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c15415165.cfilter(c)
	return c:IsSetCard(0x161) and c:IsAbleToRemoveAsCost()
end
function c15415165.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c15415165.cfilter,tp,LOCATION_GRAVE+LOCATION_MZONE+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c15415165.cfilter,tp,LOCATION_GRAVE+LOCATION_MZONE+LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c15415165.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and Duel.NegateAttack() then
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
	end
end