--tricoro·工藤忍
function c81019002.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c81019002.matfilter,2,2,c81019002.lcheck)
	c:EnableReviveLimit()
	--lv
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81019002,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,81019002)
	e1:SetHintTiming(TIMINGS_CHECK_MONSTER)
	e1:SetTarget(c81019002.target)
	e1:SetOperation(c81019002.operation)
	c:RegisterEffect(e1)
	--level
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_LEVEL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsLevelAbove,1))
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function c81019002.matfilter(c)
	return c:IsLevelAbove(1)
end
function c81019002.lcheck(g,lc)
	return g:GetClassCount(Card.GetLevel)==g:GetCount()
end
function c81019002.filter(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function c81019002.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c81019002.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c81019002.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c81019002.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c81019002.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
	end
end
