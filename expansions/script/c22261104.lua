--相互厮杀吧 兄弟
function c22261104.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22261104+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c22261104.condition)
	e1:SetTarget(c22261104.target)
	e1:SetOperation(c22261104.activate)
	c:RegisterEffect(e1)
end
c22261104.Desc_Contain_NanayaShiki=1
function c22261104.IsNanayaShiki(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_NanayaShiki
end
function c22261104.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c22261104.cfilter(c)
	return c:IsFaceup() and c22261104.IsNanayaShiki(c)
end
function c22261104.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingMatchingCard(c22261104.cfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c22261104.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if (not tc:IsRelateToEffect(e)) or tc:IsFacedown() then return end
	local rg=Duel.GetMatchingGroup(c22261104.cfilter,tp,LOCATION_MZONE,0,nil)
	local rc=rg:GetFirst()
	local i=0
	while rc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(tc:GetAttack())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e1)
		rc=rg:GetNext()
		i=i+1
	end
	if i>0 then
		Duel.BreakEffect()
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetTarget(c22261104.tg)
		e2:SetValue(700)
		Duel.RegisterEffect(e2,tp)
	end
end
function c22261104.tg(e,c)
	return c:IsFaceup()
end