--布劳克德
function c69696905.initial_effect(c)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69696905,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,69696905)
	e1:SetCondition(c69696905.discon)
	e1:SetCost(c69696905.discost)
	e1:SetTarget(c69696905.distg)
	e1:SetOperation(c69696905.disop)
	c:RegisterEffect(e1)
end
function c69696905.filter(c,tp)
	return c:GetControler()~=tp and c:IsAbleToRemove() and c:IsType(TYPE_MONSTER)
end
function c69696905.discon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev) and re:GetHandler():IsType(TYPE_LINK) and Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_MZONE
end
function c69696905.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c69696905.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c69696905.disop(e,tp,eg,ep,ev,re,r,rp)
		local lg=re:GetHandler():GetLinkedGroup():Filter(c69696905.filter,nil,tp)
		if lg:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(69696905,0)) then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
			local g=lg:Select(1-tp,1,1,nil)
			Duel.HintSelection(g)
			Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
		else if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(eg,REASON_EFFECT)
		end
		end
end



