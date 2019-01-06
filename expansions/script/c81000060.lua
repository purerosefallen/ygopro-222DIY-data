--鱼·IKARUS
function c81000060.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	c:EnableReviveLimit()
	--cannot activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(1,1)
	e1:SetValue(c81000060.aclimit)
	c:RegisterEffect(e1)
	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetCondition(c81000060.dircon)
	c:RegisterEffect(e2)
	--activate limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(c81000060.actcon)
	e3:SetValue(c81000060.actlimit)
	c:RegisterEffect(e3)
	--synchro level
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_SYNCHRO_LEVEL)
	e4:SetValue(c81000060.slevel)
	c:RegisterEffect(e4)
	--spsummon bgm
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(81000060,0))
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(c81000060.sumcon)
	e0:SetOperation(c81000060.sumsuc)
	c:RegisterEffect(e0)
end
function c81000060.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c81000060.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(81000060,1))
end
function c81000060.aclimit(e,re,tp)
	if not re:IsHasType(EFFECT_TYPE_ACTIVATE) or not re:IsActiveType(TYPE_TRAP) then return false end
	local c=re:GetHandler()
	return not c:IsLocation(LOCATION_SZONE)
end
function c81000060.dircon(e)
	return e:GetHandler():GetColumnGroupCount()==0
end
function c81000060.actcon(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c81000060.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e)
end
function c81000060.slevel(e,c)
	local lv=e:GetHandler():GetLevel()
	return 1*65536+lv
end