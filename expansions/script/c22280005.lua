--晶石侵染者
Duel.LoadScript("c22280001.lua")
c22280005.named_with_Spar=true
function c22280005.initial_effect(c)
	c:EnableReviveLimit()
	--Remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22280005,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c22280005.con)
	e1:SetOperation(c22280005.op)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c22280005.immcon)
	e2:SetValue(c22280005.efilter)
	c:RegisterEffect(e2)
	--redirect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(LOCATION_HAND)
	e3:SetCondition(c22280005.immcon)
	c:RegisterEffect(e3)
end
function c22280005.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c22280005.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=c:GetMaterial():Filter(Card.IsType,nil,TYPE_MONSTER)
	local att=0
	if cg:IsExists(Card.IsAttribute,nil,1,ATTRIBUTE_EARTH) then att=att+0x01 end 
	if cg:IsExists(Card.IsAttribute,nil,1,ATTRIBUTE_WATER) then att=att+0x02 end 
	if cg:IsExists(Card.IsAttribute,nil,1,ATTRIBUTE_FIRE) then att=att+0x04 end 
	if cg:IsExists(Card.IsAttribute,nil,1,ATTRIBUTE_WIND) then att=att+0x08 end 
	if cg:IsExists(Card.IsAttribute,nil,1,ATTRIBUTE_LIGHT) then att=att+0x10 end 
	if cg:IsExists(Card.IsAttribute,nil,1,ATTRIBUTE_DARK) then att=att+0x20 end 
	if cg:IsExists(Card.IsAttribute,nil,1,ATTRIBUTE_DEVINE) then att=att+0x40 end 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetLabel(att)
	e1:SetCountLimit(1)
	e1:SetOperation(c22280005.effectop)
	Duel.RegisterEffect(e1,tp)
end
function c22280005.rfilter(c,att)
	return c:IsAttribute(att) and c:IsFaceup() and c:IsAbleToRemove()
end
function c22280005.effectop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,22280005)
	local rg=Duel.GetMatchingGroup(c22280005.rfilter,tp,0,LOCATION_MZONE,nil,e:GetLabel())
	if rg:GetCount()>0 then Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT) end
end
function c22280005.immcon(e)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_RITUAL) and c:IsFaceup()
end
function c22280005.efilter(e,re)
	if not re:IsActiveType(TYPE_MONSTER) then return false end
	if re:GetHandlerPlayer()==e:GetHandlerPlayer() then return false end
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if c:GetColumnGroup():IsContains(rc) then return false end
	return true
end
function c22280005.spreg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
	e1:SetValue(LOCATION_DECKBOT)
	c:RegisterEffect(e1)
end