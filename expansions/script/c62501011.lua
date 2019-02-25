--武者 相州五郎入道正宗
function c62501011.initial_effect(c)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x624),7,2,c62501011.ovfilter,aux.Stringid(62501011,0),2,c62501011.xyzop)
	c:EnableReviveLimit()
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_CODE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(62501006)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(c62501011.eqtg)
	e2:SetOperation(c62501011.eqop)
	c:RegisterEffect(e2)
	 local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c62501011.discost)
	e3:SetTarget(c62501011.target)
	e3:SetOperation(c62501011.activate)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_INACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c62501011.effcon)
	e4:SetValue(c62501011.effectfilter)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(162501011,1))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BATTLE_DESTROYING)
	e5:SetCountLimit(1)
	e5:SetCondition(c62501011.xyzcon)
	e5:SetTarget(c62501011.xyztg)
	e5:SetOperation(c62501011.xyzzop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_DISEFFECT)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c62501011.effcon)
	e6:SetValue(c62501011.effectfilter)
	c:RegisterEffect(e6)
end
function c62501011.ovfilter(c)
	return c:IsFaceup() and c:IsCode(62501001) and c:GetEquipCount()>0
end
function c62501011.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,62501011)==0 end
	Duel.RegisterFlagEffect(tp,62501011,RESET_PHASE+PHASE_END,0,1)
end
function c62501011.eqfil(c)
	return c:IsCode(62501006) 
end
function c62501011.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c62501011.eqfil,tp,LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,0,0)
end
function c62501011.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c62501011.eqfil,tp,LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		local g=Duel.SelectMatchingCard(tp,c62501011.eqfil,tp,LOCATION_GRAVE,0,1,1,nil)
		local tc=g:GetFirst()
		local c=e:GetHandler()
		Duel.Equip(tp,tc,c)
		if Duel.Equip(tp,tc,c)==0 then return end
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
	   e2:SetCode(EFFECT_EQUIP_LIMIT)
	   e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	   e2:SetValue(c62501011.eqlimit)
	  e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	   tc:RegisterEffect(e2)
		--atkup 
	end
end
function c62501011.eqlimit(e,c)
	return e:GetOwner()==c
end
function c62501011.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and te:IsActiveType(TYPE_SPELL+TYPE_TRAP) and bit.band(loc,LOCATION_ONFIELD)~=0
end
function c62501011.effcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c62501011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetTargetCard(g)
end
function c62501011.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c62501011.filter(c,e)
	return c:IsFaceup() and c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e)
end
function c62501011.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c62501011.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
	local c=e:GetHandler()
	local tc=sg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SWAP_BASE_AD)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=sg:GetNext()
	end
end
function c62501011.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if not c:IsRelateToBattle() or c:IsFacedown() then return false end
	e:SetLabelObject(tc)
	return tc:IsLocation(LOCATION_GRAVE) and tc:IsType(TYPE_MONSTER) and tc:IsReason(REASON_BATTLE)
end
function c62501011.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) end
	local tc=e:GetLabelObject()
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,tc,1,0,0)
end
function c62501011.xyzzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Overlay(c,tc)
	end
end