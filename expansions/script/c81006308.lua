--tricoro·姬塔
function c81006308.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--change level
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81006308,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c81006308.lvtg)
	e2:SetOperation(c81006308.lvop)
	c:RegisterEffect(e2)
end
function c81006308.lvfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
		and Duel.IsExistingMatchingCard(c81006308.lvcfilter,tp,LOCATION_HAND,0,1,nil,c)
end
function c81006308.lvcfilter(c,mc)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
		and (not mc or not c:IsLevel(mc:GetLevel()))
end
function c81006308.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c81006308.lvfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c81006308.lvfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c81006308.lvfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c81006308.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	local ec=tc
	if not tc:IsRelateToEffect(e) then ec=nil end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=Duel.SelectMatchingCard(tp,c81006308.lvcfilter,tp,LOCATION_HAND,0,1,1,nil,ec)
	if cg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,cg)
		local pc=cg:GetFirst()
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_PUBLIC)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		pc:RegisterEffect(e2)
		if tc:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(tc:GetLevel())
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			pc:RegisterEffect(e1)
		end
	end
end
