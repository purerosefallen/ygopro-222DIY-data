--灰姑娘女孩·岛村卯月
function c81011301.initial_effect(c)
	aux.EnableDualAttribute(c)
	--add counter
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SUMMON_SUCCESS)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(c81011301.ctcon)
	e0:SetOperation(c81011301.ctop)
	c:RegisterEffect(e0)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(aux.IsDualState)
	e1:SetTarget(c81011301.indtg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c81011301.aclimit)
	e2:SetCondition(c81011301.actcon)
	c:RegisterEffect(e2)
end
function c81011301.ctfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_DUAL) and c:IsControler(tp)
end
function c81011301.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81011301.ctfilter,1,nil,tp) and aux.IsDualState(e)
end
function c81011301.ctop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,81011301)
	Duel.Damage(1-tp,500,REASON_EFFECT)
end
function c81011301.indtg(e,c)
	return c:IsType(TYPE_DUAL) and Duel.GetAttacker()==c
end
function c81011301.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c81011301.actcon(e)
	local tc=Duel.GetAttacker()
	local tp=e:GetHandlerPlayer()
	return tc and tc:IsControler(tp) and tc:IsType(TYPE_DUAL) and aux.IsDualState(e)
end
