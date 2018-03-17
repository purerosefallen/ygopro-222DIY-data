--落樱的和伞-春分
function c60320.initial_effect(c)
	--link summon
	Nef.AddLinkProcedureWithDesc(c,c60320.matfilter,1,1,nil,aux.Stringid(60320,0))
	c:EnableReviveLimit()
	--link summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetDescription(aux.Stringid(60320,1))
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c60320.lkcon)
	e1:SetOperation(c60320.lkop)
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	--e2:SetCondition(c60320.incon)
	e2:SetTarget(c60320.tgtg)
	e2:SetValue(aux.imval1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--去世
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetDescription(aux.Stringid(60320,2))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCountLimit(1)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c60320.spcost)
	e4:SetTarget(c60320.sptg)
	e4:SetOperation(c60320.spop)
	c:RegisterEffect(e4)
end
function c60320.matfilter(c)
	return c:IsLinkType(TYPE_EFFECT) and c:IsLinkAttribute(ATTRIBUTE_WATER)
end
c60320.DescSetName = 0x229
function c60320.umbfilter(c)
	local code=c:GetOriginalCode()
	local mt=_G["c" .. code]
	return mt and mt.DescSetName == 0x229 and c:IsDiscardable()
end
function c60320.lkcon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c60320.umbfilter,tp,LOCATION_HAND,0,nil)
	return mg:GetCount()>0 and Duel.GetLocationCountFromEx(tp)>0
end
function c60320.lkop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c60320.umbfilter,tp,LOCATION_HAND,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
	local sg=mg:Select(tp,1,1,nil)
	c:SetMaterial(sg)
	Duel.SendtoGrave(sg,REASON_MATERIAL+REASON_LINK+REASON_DISCARD)
end
function c60320.incon(e)
	local c=e:GetHandler()
	return c:IsLinkState()
end
function c60320.tgtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c) or c==e:GetHandler()
end
function c60320.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToGraveAsCost()
end
function c60320.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60320.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c60320.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c60320.sfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsAttack(400) and c:IsAbleToGrave()
end
function c60320.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>-1
		and Duel.IsExistingMatchingCard(c60320.sfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_DECK)
end
function c60320.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c60320.sfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
