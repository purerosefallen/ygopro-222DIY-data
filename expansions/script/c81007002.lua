--静流·Defiance
function c81007002.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c81007002.ffilter,2,false)
	aux.EnablePendulumAttribute(c,false)
	--spsummon bgm
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(c81007002.sumcon)
	e0:SetOperation(c81007002.sumsuc)
	c:RegisterEffect(e0)
	--increase atk
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,81007002)
	e3:SetCondition(c81007002.atkcon)
	e3:SetOperation(c81007002.atkop)
	c:RegisterEffect(e3)
	--cannot target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(aux.indoval)
	c:RegisterEffect(e5)
	--spsummon
	local e6=aux.AddRitualProcEqual2(c,c81007002.ritfilter,LOCATION_REMOVED+LOCATION_GRAVE)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetCode(0)
	e6:SetCountLimit(1,81007902)
	e6:SetRange(LOCATION_MZONE)
	--pendulum
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_DESTROYED)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCondition(c81007002.pencon)
	e7:SetTarget(c81007002.pentg)
	e7:SetOperation(c81007002.penop)
	c:RegisterEffect(e7)
end
function c81007002.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c81007002.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(81007002,1))
end
function c81007002.ffilter(c)
	return c:IsFusionType(TYPE_RITUAL) and c:IsFusionType(TYPE_PENDULUM) and c:IsLevel(8)
end
function c81007002.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=eg:GetFirst()
	return rc==Duel.GetAttacker() and rc:IsStatus(STATUS_OPPO_BATTLE) and rc:IsFaceup()
		and bit.band(rc:GetType(),0x81)==0x81 and rc:IsType(TYPE_PENDULUM) and rc:IsControler(tp)
end
function c81007002.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetAttacker()
	if tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function c81007002.ritfilter(c)
	return c:IsType(TYPE_PENDULUM)
end
function c81007002.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c81007002.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c81007002.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
