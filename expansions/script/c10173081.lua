--钢铁天使-白银之翼
function c10173081.initial_effect(c)
	--summon with 3 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(c10173081.ttcon)
	e1:SetOperation(c10173081.ttop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	e2:SetCondition(c10173081.setcon)
	c:RegisterEffect(e2)  
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c10173081.efilter)
	c:RegisterEffect(e3) 
	--cannot attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_ATTACK)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c10173081.antarget)
	c:RegisterEffect(e4) 
	--ma
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_BATTLED)
	e5:SetOperation(c10173081.maop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_DAMAGE_STEP_END)
	e6:SetOperation(c10173081.maop2)
	e6:SetLabelObject(e5)
	c:RegisterEffect(e6)
end
function c10173081.setcon(e,c,minc)
	if not c then return true end
	return false
end
function c10173081.atkfilter(c,tc)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and not c:IsStatus(STATUS_BATTLE_DESTROYED+STATUS_DESTROY_CONFIRMED) and c:IsCanBeBattleTarget(tc)
end
function c10173081.maop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if e:GetHandler()==a and d and Duel.IsExistingMatchingCard(c10173081.atkfilter,tp,0,LOCATION_MZONE,1,nil,a) and Duel.SelectEffectYesNo(tp,e:GetHandler()) then e:SetLabel(1)
	else e:SetLabel(0) end
end
function c10173081.maop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabelObject():GetLabel()==1 and c:IsRelateToBattle() and c:IsChainAttackable(0,true) and Duel.IsExistingMatchingCard(c10173081.atkfilter,tp,0,LOCATION_MZONE,1,nil,c) then
	   Duel.Hint(HINT_CARD,0,10173081)
	   Duel.ChainAttack()
	   local e1=Effect.CreateEffect(c)
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	   e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	   e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE+PHASE_DAMAGE_CAL)
	   c:RegisterEffect(e1)
	   local e2=Effect.CreateEffect(c)
	   e2:SetType(EFFECT_TYPE_SINGLE)
	   e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	   e2:SetValue(c10173081.bttg)
	   c:RegisterEffect(e2)
	end
end
function c10173081.bttg(e,c)
	return not c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c10173081.antarget(e,c)
	return c~=e:GetHandler()
end
function c10173081.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c10173081.otfilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c10173081.ttcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local ct=Duel.GetMatchingGroupCount(c10173081.otfilter,tp,0,LOCATION_MZONE,nil)
	local ct2=3
	ct2=ct2-ct
	if ct2<0 then ct2=0 end
	return minc<=ct2 and ((Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and ct2==0) or (ct2>0 and Duel.CheckTribute(c,ct2)))
end
function c10173081.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local ct=Duel.GetMatchingGroupCount(c10173081.otfilter,tp,0,LOCATION_MZONE,nil)
	local ct2=3
	ct2=ct2-ct
	if ct2<0 then return end
	local g=Duel.SelectTribute(tp,c,ct2,ct2)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
