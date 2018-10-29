--通往末路的末路
function c81009048.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81009048+EFFECT_COUNT_CODE_OATH+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c81009048.condition)
	e1:SetTarget(c81009048.target)
	e1:SetOperation(c81009048.activate)
	c:RegisterEffect(e1)
end
function c81009048.filter(c)
	return c:IsFaceup() and c:IsCode(81010019)
end
function c81009048.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c81009048.filter,tp,LOCATION_MZONE,0,nil)
	return g:GetCount()>=4 and g:GetClassCount(Card.GetOriginalCode)==g:GetCount()
end
function c81009048.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_SKIP_TURN) end
end
function c81009048.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_SKIP_TURN)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
end