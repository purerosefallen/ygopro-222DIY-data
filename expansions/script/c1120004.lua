--读心少女·米切尔
function c1120004.initial_effect(c)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c1120004.con1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetCondition(c1120004.con2)
	e2:SetValue(c1120004.efilter2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c1120004.op3)
	c:RegisterEffect(e3)
--
end
--
function c1120004.con1(e,c)
	if c==nil then return true end
	return Duel.GetTurnCount()>1 
		and Duel.GetMZoneCount(c:GetControler())>0
end
--
function c1120004.con2(e)
	local p=e:GetHandlerPlayer()
	return p==Duel.GetTurnPlayer()
end
--
function c1120004.efilter2(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
--
function c1120004.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local b=a:GetBattleTarget()
	if a:IsControler(1-tp) then a,b=b,a end
	local e3_1=Effect.CreateEffect(c)
	e3_1:SetType(EFFECT_TYPE_SINGLE)
	e3_1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3_1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e3_1:SetRange(LOCATION_MZONE)
	e3_1:SetValue(0)
	e3_1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	a:RegisterEffect(e3_1,true)
	local e3_2=Effect.CreateEffect(c)
	e3_2:SetType(EFFECT_TYPE_SINGLE)
	e3_2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3_2:SetCode(EFFECT_SET_ATTACK_FINAL)
	e3_2:SetRange(LOCATION_MZONE)
	e3_2:SetValue(0)
	e3_2:SetReset(RESET_PHASE+PHASE_DAMAGE)
	b:RegisterEffect(e3_2,true)
	local e3_3=Effect.CreateEffect(c)
	e3_3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3_3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3_3:SetCode(EVENT_BATTLED)
	e3_3:SetLabelObject(b)
	e3_3:SetRange(LOCATION_MZONE)
	e3_3:SetOperation(c1120004.op3_3)
	e3_3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
	c:RegisterEffect(e3_3)
end
--
function c1120004.op3_3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b=e:GetLabelObject()
	local e3_3_1=Effect.CreateEffect(c)
	e3_3_1:SetType(EFFECT_TYPE_SINGLE)
	e3_3_1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e3_3_1:SetRange(LOCATION_MZONE)
	e3_3_1:SetValue(0)
	e3_3_1:SetReset(RESET_EVENT+0x1fe0000)
	b:RegisterEffect(e3_3_1)
end
--
