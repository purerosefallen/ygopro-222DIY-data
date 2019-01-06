--CAnswer·栋方爱海
function c81000516.initial_effect(c)
	--hand link
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c81000516.matcon)
	e1:SetValue(c81000516.matval)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(c81000516.ctcon)
	e2:SetOperation(c81000516.ctop)
	c:RegisterEffect(e2)
end
function c81000516.matcon(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),81000516)==0
end
function c81000516.mfilter(c)
	return c:IsLocation(LOCATION_MZONE)
end
function c81000516.exmfilter(c)
	return c:IsLocation(LOCATION_HAND) and c:IsCode(81000516)
end
function c81000516.matval(e,c,mg)
	return mg:IsExists(c81000516.mfilter,1,nil) and not mg:IsExists(c81000516.exmfilter,1,nil)
end
function c81000516.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
function c81000516.ctop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,81000516,RESET_PHASE+PHASE_END,0,1)
end
