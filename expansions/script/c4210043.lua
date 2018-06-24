--猫耳天堂-反击陷阱2
function c4210043.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c4210043.condition)
	e1:SetCost(c4210043.cost)
	e1:SetTarget(c4210043.target)
	e1:SetOperation(c4210043.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(function(e)return Duel.GetMatchingGroupCount(function(c) return c:IsFaceup() and c:IsSetCard(0x2af)end,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil)>=3 end)
	c:RegisterEffect(e2)
end
function c4210043.cfilter(c,ft)
	return c:IsFaceup() and c:IsSetCard(0x2af) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function c4210043.setfilter(c)
    return c:IsSetCard(0x2af) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsSSetable() and not c:IsCode(4210043)
end
function c4210043.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c4210043.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4210043.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c4210043.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetFirst():GetFlagEffect(4210010)~=0 then e:SetLabel(1) else e:SetLabel(0) end
	Duel.Release(g,REASON_COST)
end
function c4210043.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c4210043.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
	if e:GetLabel()==1 and Duel.SelectYesNo(tp,aux.Stringid(4210043,4))
		and Duel.IsExistingMatchingCard(c4210043.setfilter,tp,LOCATION_GRAVE,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c4210043.setfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SSet(tp,g:GetFirst())
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
