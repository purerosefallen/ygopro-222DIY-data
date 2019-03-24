--神圣之门的迎击
function c61000011.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_BATTLE_PHASE,0x980+TIMING_BATTLE_PHASE)
	e1:SetTarget(c61000011.tg)
	e1:SetOperation(c61000011.op)
	c:RegisterEffect(e1)
end
function c61000011.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c61000011.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c61000011.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c61000011.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c61000011.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c61000011.posfilter(c)
	return c:IsFacedown() and c:IsSetCard(0x980)
end
function c61000011.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
		local tg=Duel.GetMatchingGroup(c61000011.posfilter,tp,LOCATION_MZONE,0,nil)
		if tg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(61000011,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
			local sg=tg:Select(tp,1,tg:GetCount(),nil)
			Duel.ChangePosition(sg,POS_FACEUP_ATTACK)
		end
	end
end

