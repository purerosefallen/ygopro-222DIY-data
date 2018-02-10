--IDOL 守年
function c14804813.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	c:SetUniqueOnField(1,1,aux.FilterBoolFunction(Card.IsCode,14804813),LOCATION_MZONE)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetTargetRange(1,0)
	e1:SetCondition(c14804813.splimcon)
	e1:SetTarget(c14804813.splimit)
	c:RegisterEffect(e1)
	--pendulum set
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c14804813.pctg)
	e3:SetOperation(c14804813.pcop)
	c:RegisterEffect(e3)
	
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c14804813.reptg)
	e4:SetValue(c14804813.repval)
	e4:SetOperation(c14804813.repop)
	c:RegisterEffect(e4)
--
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_BE_MATERIAL)
	e6:SetCondition(c14804813.indcon)
	e6:SetOperation(c14804813.indop)
	c:RegisterEffect(e6)
end
function c14804813.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c14804813.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsRace(RACE_FAIRY) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c14804813.pcfilter(c)
	return c:IsSetCard(0x4848) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c14804813.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c14804813.pcfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c14804813.pcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c14804813.pcfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		Duel.Draw(1-tp,1,REASON_EFFECT)
	end
end
function c14804813.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x4848) and c:IsOnField() and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function c14804813.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c14804813.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c14804813.repval(e,c)
	return c14804813.repfilter(c,e:GetHandlerPlayer())
end
function c14804813.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(1-tp,1,REASON_EFFECT+REASON_REPLACE)
end

function c14804813.indcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_LINK
end
function c14804813.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	if not rc:IsRace(RACE_FAIRY) then return end
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(14804808,0))
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c14804813.reptg1)
	e4:SetValue(c14804813.repval1)
	e4:SetOperation(c14804813.repop1)
	e4:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e4,true)
	rc:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(14804813,1))
end

function c14804813.repfilter1(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x4848) and c:IsOnField() and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function c14804813.reptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c14804813.repfilter1,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c14804813.repval1(e,c)
	return c14804813.repfilter1(c,e:GetHandlerPlayer())
end
function c14804813.repop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(1-tp,1,REASON_EFFECT+REASON_REPLACE)
end
