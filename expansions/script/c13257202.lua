--宇宙战争兵器 外壳 覆甲镭射
function c13257202.initial_effect(c)
	c:EnableReviveLimit()
	--equip limit
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_EQUIP_LIMIT)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e11:SetValue(c13257202.eqlimit)
	c:RegisterEffect(e11)
	--immune
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_IMMUNE_EFFECT)
	e12:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e12:SetRange(LOCATION_SZONE)
	e12:SetCondition(c13257202.econ)
	e12:SetValue(c13257202.efilter)
	c:RegisterEffect(e12)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c13257202.value)
	c:RegisterEffect(e1)
	--actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(c13257202.aclimit)
	e3:SetCondition(c13257202.actcon)
	c:RegisterEffect(e3)
	c:RegisterFlagEffect(13257201,0,0,0,1)
	
end
function c13257202.eqlimit(e,c)
	local eg=c:GetEquipGroup()
	local lv=c:GetOriginalLevel()
	if lv==nil then lv=0 end
	if not eg:IsContains(e:GetHandler()) then
		eg:AddCard(e:GetHandler())
	end
	local cl=c:GetFlagEffectLabel(13257200)
	if cl==nil then
		cl=0
	end
	local er=e:GetHandler():GetFlagEffectLabel(13257201)
	if er==nil then
		er=0
	end
	return not (er>cl) and not (eg:Filter(Card.IsSetCard,nil,0x354):GetSum(Card.GetLevel)>lv) and not c:GetEquipGroup():IsExists(Card.IsCode,1,e:GetHandler(),e:GetHandler():GetCode())
end
function c13257202.econ(e)
	return e:GetHandler():GetEquipTarget()
end
function c13257202.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function c13257202.value(e,c)
	return c:GetLevel()*200
end
function c13257202.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c13257202.actcon(e)
	local tc=e:GetHandler():GetEquipTarget()
	return Duel.GetAttacker()==tc or Duel.GetAttackTarget()==tc
end
