--IDOL 思思
function c14804810.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	c:SetUniqueOnField(1,1,aux.FilterBoolFunction(Card.IsCode,14804810),LOCATION_MZONE)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetTargetRange(1,0)
	e1:SetCondition(c14804810.splimcon)
	e1:SetTarget(c14804810.splimit)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c14804810.atktg)
	e2:SetValue(-400)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c14804810.atkval)
	c:RegisterEffect(e3)

	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_BE_MATERIAL)
	e6:SetCondition(c14804810.indcon)
	e6:SetOperation(c14804810.indop)
	c:RegisterEffect(e6)
end
function c14804810.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c14804810.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsRace(RACE_FAIRY) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c14804810.atktg(e,c)
	return not c:IsSetCard(0x4848)
end
function c14804810.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x4848)
end
function c14804810.atkval(e,c)
	return Duel.GetMatchingGroupCount(c14804810.filter,c:GetControler(),LOCATION_ONFIELD,0,nil)*200
end

function c14804810.indcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_LINK
end
function c14804810.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	if not rc:IsRace(RACE_FAIRY) then return end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c14804810.atkval1)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e3,true)
	rc:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(14804810,0))
end
function c14804810.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x4848)
end
function c14804810.atkval1(e,c)
	return Duel.GetMatchingGroupCount(c14804810.filter1,c:GetControler(),LOCATION_ONFIELD,0,nil)*200
end