--兔子翩翩飘落
function c1157501.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c1157501.mfilter,2)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1157501,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c1157501.con1)
	e1:SetTarget(c1157501.tg1)
	e1:SetOperation(c1157501.op1)
	c:RegisterEffect(e1)
--
	if not c1157501.gchk then
		c1157501.gchk=true
		c1157501[0]=3
		c1157501[1]=3
		local e2=Effect.GlobalEffect()
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_REMOVE)
		e2:SetCondition(c1157501.con2)
		e2:SetOperation(c1157501.op2)
		Duel.RegisterEffect(e2,0)
	end 
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1157501,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_CUSTOM+1157501)
	e3:SetRange(LOCATION_REMOVED)
	e1:SetCountLimit(1,1157501)
	e3:SetTarget(c1157501.tg3)
	e3:SetOperation(c1157501.op3)
	c:RegisterEffect(e3)
--
end
--
function c1157501.mfilter(c)
	return c:IsLinkRace(RACE_BEAST) and c:IsLinkType(TYPE_TUNER)
end
--
function c1157501.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(c:GetSummonType(),SUMMON_TYPE_FUSION)~=0
end
--
function c1157501.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
end
--
function c1157501.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() then return end
	if not c:IsRelateToEffect(e) then return end
	Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
end
--
function c1157501.cfilter2(c)
	return c:IsRace(RACE_BEAST) and not c:IsCode(1157501)
end
function c1157501.con2(e,tp,eg,ep,ev,re,r,rp)
	return r and bit.band(r,REASON_EFFECT)~=0
		and eg:IsExists(c1157501.cfilter2,1,nil)
end
--
function c1157501.op2(e,tp,eg,ep,ev,re,r,rp)
	if c1157501[rp]<=1 then
		c1157501[rp]=3
		Duel.RaiseEvent(eg,EVENT_CUSTOM+1157501,re,r,rp,ep,ev)
	else c1157501[rp]=c1157501[rp]-1 end
end
--
function c1157501.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
--
function c1157501.op3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e3_1=Effect.CreateEffect(c)
		e3_1:SetType(EFFECT_TYPE_FIELD)
		e3_1:SetCode(EFFECT_CANNOT_ATTACK)
		e3_1:SetRange(LOCATION_MZONE)
		e3_1:SetTargetRange(LOCATION_MZONE,0)
		e3_1:SetTarget(c1157501.tg3_1)
		e3_1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e3_1,true) 
		local e3_2=Effect.CreateEffect(c)
		e3_2:SetType(EFFECT_TYPE_FIELD)
		e3_2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
		e3_2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3_2:SetTargetRange(0,1)
		e3_2:SetValue(1)
		e3_2:SetRange(LOCATION_MZONE)
		e3_2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e3_2,true)
		local e3_2=Effect.CreateEffect(c)
		e3_2:SetType(EFFECT_TYPE_FIELD)
		e3_2:SetCode(EFFECT_BP_TWICE)
		e3_2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3_2:SetTargetRange(1,0)
		e3_2:SetRange(LOCATION_MZONE)
		e3_2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e3_2,true)   
	end
end
--
function c1157501.tg3_1(e,c)
	return not c:IsRace(RACE_BEAST)
end
--
