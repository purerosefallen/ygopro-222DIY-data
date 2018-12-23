--Trilogy·塔尼亚
function c81014023.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--level up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81014023,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c81014023.lvtg)
	e1:SetOperation(c81014023.lvop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,81014023)
	e2:SetCondition(c81014023.spcon)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c81014023.atkcon)
	e3:SetValue(c81014023.atkval)
	c:RegisterEffect(e3)
end
function c81014023.lvfilter(c)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_PENDULUM) and c:GetLevel()>2
end
function c81014023.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81014023.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c81014023.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(c81014023.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=tg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(-2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		tc:RegisterEffect(e1)
		tc=tg:GetNext()
	end
end
function c81014023.cfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(7) and c:IsType(TYPE_PENDULUM)
end
function c81014023.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c81014023.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c81014023.atkcon(e)
	local ph=Duel.GetCurrentPhase()
	local tp=Duel.GetTurnPlayer()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c81014023.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c81014023.atkval(e,c)
	return Duel.GetMatchingGroupCount(c81014023.atkfilter,c:GetControler(),0,LOCATION_ONFIELD,nil)*500
end
