--钢铁天使-赤红之翼
function c10173074.initial_effect(c)
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--summon with 3 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(c10173074.ttcon)
	e1:SetOperation(c10173074.ttop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	e2:SetCondition(c10173074.setcon)
	c:RegisterEffect(e2) 
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetValue(c10173074.atkval)
	c:RegisterEffect(e3)
	--act limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(0,1)
	e4:SetValue(c10173074.aclimit)
	c:RegisterEffect(e4)
	--cannot release
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_CANNOT_RELEASE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(0,1)
	c:RegisterEffect(e5)
end
function c10173074.atkval(e,c)
	local ct=Duel.GetMatchingGroupCount(Card.IsType,e:GetHandlerPlayer(),0,LOCATION_ONFIELD,nil,TYPE_TRAP+TYPE_SPELL)
	local ct2=c:GetAttackAnnouncedCount()
	if ct2<ct then return ct
	else return 0
	end
end
function c10173074.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_TRAP+TYPE_SPELL) and not re:GetHandler():IsImmuneToEffect(e)
end
function c10173074.otfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_TRAP) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c10173074.otfilter(c)
	return c:IsType(TYPE_TRAP+TYPE_SPELL)
end
function c10173074.ttcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local ct=Duel.GetMatchingGroupCount(c10173074.otfilter,tp,0,LOCATION_ONFIELD,nil)
	local ct2=3
	ct2=ct2-ct
	if ct2<0 then ct2=0 end
	return minc<=ct2 and ((Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and ct2==0) or (ct2>0 and Duel.CheckTribute(c,ct2)))
end
function c10173074.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local ct=Duel.GetMatchingGroupCount(c10173074.otfilter,tp,0,LOCATION_ONFIELD,nil)
	local ct2=3
	ct2=ct2-ct
	if ct2<0 then return end
	local g=Duel.SelectTribute(tp,c,ct2,ct2)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c10173074.setcon(e,c,minc)
	if not c then return true end
	return false
end