--宇宙战争兵器 护罩 覆盖罩
function c13257220.initial_effect(c)
	c:EnableReviveLimit()
	--equip limit
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_EQUIP_LIMIT)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e11:SetValue(c13257220.eqlimit)
	c:RegisterEffect(e11)
	--immune
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_IMMUNE_EFFECT)
	e12:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e12:SetRange(LOCATION_SZONE)
	e12:SetCondition(c13257220.econ)
	e12:SetValue(c13257220.efilter)
	c:RegisterEffect(e12)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(13257220,0))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_BECOME_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCost(c13257220.cost)
	e4:SetCondition(c13257220.condition)
	e4:SetOperation(c13257220.activate)
	c:RegisterEffect(e4)
	c:RegisterFlagEffect(13257201,0,0,0,1)
	
end
function c13257220.eqlimit(e,c)
	local cl=c:GetFlagEffectLabel(13257200)
	if cl==nil then
		cl=0
	end
	local er=e:GetHandler():GetFlagEffectLabel(13257201)
	if er==nil then
		er=0
	end
	return not (er>cl) and (c:GetOriginalLevel()>=e:GetHandler():GetRank()) and not c:GetEquipGroup():IsExists(Card.IsSetCard,1,e:GetHandler(),0x9354)
end
function c13257220.econ(e)
	return e:GetHandler():GetEquipTarget()
end
function c13257220.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function c13257220.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler():GetEquipTarget()
	if chk==0 then return ec and ec:IsCanRemoveCounter(tp,0x353,1,REASON_COST) end
	ec:RemoveCounter(tp,0x353,1,REASON_COST)
end
function c13257220.condition(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and eg:IsContains(ec)
end
function c13257220.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if ec and c:IsRelateToEffect(e) and ec:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
		e1:SetValue(c13257220.efilter1)
		ec:RegisterEffect(e1)
	end
end
function c13257220.efilter1(e,te)
	return te:GetOwner()~=e:GetOwner()
end
