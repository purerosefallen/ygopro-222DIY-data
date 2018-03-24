--狂风骤雨
function c22202003.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c22202003.target)
	e1:SetCost(c22202003.cost)
	e1:SetOperation(c22202003.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
end
function c22202003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if c:IsLocation(LOCATION_HAND) then
			return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,c)
		else
			return true
		end
	end
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,1,c)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c22202003.filter1(c,ec)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c~=ec and c:IsAbleToDeck()
end
function c22202003.filter2(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) and bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0 and c:IsAbleToDeck()
end
function c22202003.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c22202003.filter1(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c22202003.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c22202003.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	local tc=g:GetFirst()
	if bit.band(tc:GetOriginalType(),TYPE_MONSTER)~=0 then
		local b1=Duel.IsExistingTarget(c22202003.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tc,e:GetHandler())
		local b2=e:IsHasType(EFFECT_TYPE_ACTIVATE)
		local b3=true
		if chk==0 then return b1 or b2 or b3 end
		local off=1
		local ops={}
		local opval={}
		if b1 then
			ops[off]=aux.Stringid(22202003,0)
			opval[off-1]=1
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(22202003,1)
			opval[off-1]=2
			off=off+1
		end
		if b3 then
			ops[off]=aux.Stringid(22202003,2)
			opval[off-1]=3
			off=off+1
		end
		local op=Duel.SelectOption(tp,table.unpack(ops))
		local sel=opval[op]
		e:SetLabel(sel)
		if sel==1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			g=Duel.SelectTarget(tp,c22202003.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,tc,e:GetHandler())
			g:AddCard(tc)
			Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
		elseif sel==2 then
			Duel.SetChainLimit(aux.FALSE)
		elseif sel==3 then
		end
	else
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	end
end
function c22202003.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end