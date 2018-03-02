--IDOL 大哥
function c14804817.initial_effect(c)
	--link summon
	c:SetUniqueOnField(1,0,aux.FilterBoolFunction(Card.IsCode,14804817),LOCATION_MZONE,LOCATION_MZONE)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x4848),2)
	c:EnableReviveLimit()
	--boost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c14804817.atktg)
	e2:SetValue(800)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c14804817.limcon)
	e3:SetTarget(c14804817.rmtarget)
	e3:SetTargetRange(0xff,0xff)
	e3:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e3)
	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(14804817,0))
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_TO_HAND)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c14804817.atkcon)
	e4:SetOperation(c14804817.atkop)
	c:RegisterEffect(e4)
end
function c14804817.atktg(e,c)
	return c:IsSetCard(0x4848)
end
function c14804817.cfilter1(c)
	return c:IsSetCard(0x4848)
end
function c14804817.limcon(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.IsExistingMatchingCard(c14804817.cfilter1,tp,LOCATION_ONFIELD,0,8,nil)
end
function c14804817.rmtarget(e,c)
	return not c:IsSetCard(0x4848)
end

function c14804817.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK) 
end
function c14804817.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c14804817.cfilter,1,nil,1-tp)
end
function c14804817.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup()  then
		Duel.Hint(HINT_CARD,0,14804817)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(400)
		c:RegisterEffect(e1)
	end
end