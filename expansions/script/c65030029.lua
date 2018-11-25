--迷落的观景者
function c65030029.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP_ATTACK,1)
	e1:SetCondition(c65030029.spcon)
	c:RegisterEffect(e1)
	--tohand
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_LEAVE_FIELD)
	e7:SetOperation(c65030029.teop)
	c:RegisterEffect(e7)
end
function c65030029.confil(c)
	return not c:IsType(TYPE_SPELL)
end
function c65030029.spcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and
		Duel.GetMatchingGroupCount(c65030029.confil,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,nil)==0 and Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD+LOCATION_GRAVE,0)>0
end
function c65030029.teop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
end