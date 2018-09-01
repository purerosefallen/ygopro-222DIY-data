--英雄之铠常染红
function c77707025.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c77707025.con)
	e1:SetOperation(c77707025.op)
	c:RegisterEffect(e1)
end
function c77707025.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)==3 
end
function c77707025.op(e,tp,eg,ep,ev,re,r,rp)
	--actlimit
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTargetRange(0,1)
	e2:SetValue(c77707025.aclimit)
	e2:SetCondition(c77707025.actcon)
	Duel.RegisterEffect(e2,tp)
end
function c77707025.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c77707025.actcon(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE 
end