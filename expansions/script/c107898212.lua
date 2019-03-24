
function c107898212.initial_effect(c)
	c:SetUniqueOnField(1,0,107898212)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c107898212.eqcost)
	e1:SetTarget(c107898212.target)
	e1:SetOperation(c107898212.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c107898212.eqlimit)
	c:RegisterEffect(e2)
	--eq
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(107898212,1))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCategory(CATEGORY_COUNTER)
	e6:SetCode(EVENT_PREDRAW)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(c107898212.countcon)
	e6:SetTarget(c107898212.counttg)
	e6:SetOperation(c107898212.countop)
	c:RegisterEffect(e6)
end
function c107898212.efilter(e,te)
	return not te:GetOwner():IsSetCard(0x575)
end
function c107898212.eqfilter1(c)
	return c:IsFaceup() and c:IsCode(107898101)
end
function c107898212.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c107898212.eqfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c107898212.eqfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c107898212.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() and c:CheckUniqueOnField(tp) then
		if Duel.Equip(tp,c,tc) and tc:IsCanAddCounter(0x1,1) then
			Duel.BreakEffect()
			tc:AddCounter(0x1,1) 
		end
	end
end
function c107898212.eqlimit(e,c)
	return c:IsCode(107898101)
end
function c107898212.tdfilter(c)
	return c:IsCode(107898151) and c:IsAbleToDeckAsCost()
end
function c107898212.tdfilter2(c)
	return c107898212.htfilter(c) and c:IsFaceup()
end
function c107898212.showfilter(c)
	return c:IsCode(107898151) and not c:IsPublic()
end
function c107898212.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(c107898212.tdfilter,tp,LOCATION_GRAVE,0,nil)
	local g2=Duel.GetMatchingGroup(c107898212.tdfilter2,tp,LOCATION_REMOVED,0,nil)
	g1:Merge(g2)
	local g3=Duel.GetMatchingGroup(c107898212.showfilter,tp,LOCATION_HAND,0,nil)
	if chk==0 then return g1:GetCount()>=2 or g3:GetCount()>=2 end
	local op=0
	if g1:GetCount()>=2 and g3:GetCount()>=2 then
		op=Duel.SelectOption(tp,aux.Stringid(107898212,1),aux.Stringid(107898212,2))
	elseif g1:GetCount()>=2 then
		op=0
	else
		op=1
	end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=g1:Select(tp,2,2,nil)
		if g:GetCount()>0 then
			Duel.SendtoDeck(g,nil,2,REASON_COST)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,c107898212.htfilter2,tp,LOCATION_HAND,0,2,2,nil)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
end
function c107898212.countcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c107898212.counttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler():GetEquipTarget()
	if chk==0 then return ec:IsFaceup() and ec:IsCanAddCounter(0x1,1) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x1)
end
function c107898212.countop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	if ec and ec:IsCanAddCounter(0x1,1) and ec:IsFaceup() and e:GetHandler():IsRelateToEffect(e) then
		ec:AddCounter(0x1,1) 
	end
end