--传承的冒险遗产
function c18001011.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c18001011.condition)
	e1:SetTarget(c18001011.target)
	e1:SetOperation(c18001011.activate)
	c:RegisterEffect(e1)
end
c18001011.setname="advency"
function c18001011.condition(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev) 
end
function c18001011.cfilter(chkc)
	return chkc:IsFaceup() and chkc:IsRace(RACE_WARRIOR) and chkc:GetEquipCount()>0
end
function c18001011.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c18001011.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c18001011.cfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c18001011.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
	   local dg=eg:Clone()
	   dg:Merge(g)
	   Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
	end
end
function c18001011.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)>0 and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 then
	   Duel.BreakEffect()
	   Duel.Draw(tp,1,REASON_EFFECT)
	end
end