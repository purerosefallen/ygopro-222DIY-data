--陰義 飢餓虛空
function c62501017.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,62501017+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c62501017.condition)
	e1:SetTarget(c62501017.target)
	e1:SetOperation(c62501017.activate)
	c:RegisterEffect(e1)
end
function c62501017.cfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x624) or c:IsSetCard(0x625))
end
function c62501017.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c62501017.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c62501017.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
		if re:GetHandler():IsType(TYPE_MONSTER) then
			Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,re:GetHandler():GetBaseAttack())
		end
	end
end
function c62501017.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove() 
end
function c62501017.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re)
		and Duel.Destroy(eg,REASON_EFFECT)~=0  then
		Duel.ClearTargetCard()
		local g=Duel.SelectMatchingCard(tp,c62501017.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		local tc=g:GetFirst()
		if  Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		  --  Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetLabelObject(tc)
			e1:SetCountLimit(1)
			e1:SetOperation(c62501017.retop)
			Duel.RegisterEffect(e1,tp)
		end
		
	end
   
end
function c62501017.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetFlagEffect(62501017)~=0
end 
function c62501017.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end