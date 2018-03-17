--晴碧的星伞-小暑
function c60707.initial_effect(c)
	--umb
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60707,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCountLimit(1,60707)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c60707.condition)
	e1:SetCost(c60707.cost)
	e1:SetTarget(c60707.target)
	e1:SetOperation(c60707.negop)
	c:RegisterEffect(e1)
	--
end
c60707.DescSetName = 0x229
function c60707.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasCategory(CATEGORY_SPECIAL_SUMMON) and ep~=tp and not re:GetHandler():IsLocation(LOCATION_REMOVED)
end
function c60707.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c60707.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,400)
	Duel.SetChainLimit(aux.FALSE)
end
function c60707.negop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsRelateToEffect(re) then
		if Duel.Remove(re:GetHandler(),POS_FACEUP,REASON_EFFECT)>0 then
			Duel.Damage(1-tp,400,REASON_EFFECT)
		end
	end
end
