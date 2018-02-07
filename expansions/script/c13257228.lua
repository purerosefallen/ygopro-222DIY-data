--B.E.S 镭射四腕
function c13257228.initial_effect(c)
	c:EnableCounterPermit(0x1f)
	--Destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c13257228.desreptg)
	e1:SetOperation(c13257228.desrepop)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(c13257228.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(13257228,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetHintTiming(0,0x1e0)
	e4:SetTarget(c13257228.destg)
	e4:SetOperation(c13257228.desop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(13257228,2))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c13257228.destg2)
	e5:SetOperation(c13257228.desop2)
	c:RegisterEffect(e5)
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e12:SetCode(EVENT_SUMMON_SUCCESS)
	e12:SetOperation(c13257228.bgmop)
	c:RegisterEffect(e12)
	local e13=e12:Clone()
	e13:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e13)
	
end
function c13257228.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReason(REASON_EFFECT+REASON_BATTLE)
		and e:GetHandler():GetCounter(0x1f)>0 end
	return true
end
function c13257228.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(ep,0x1f,1,REASON_EFFECT)
end
function c13257228.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x1f,1)
end
function c13257228.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c13257228.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c13257228.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c13257228.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c13257228.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c13257228.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c13257228.filter2(c,def)
	return c:IsFaceup() and c:IsAttackBelow(def)
end
function c13257228.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c13257228.filter2,tp,0,LOCATION_MZONE,1,c,c:GetDefense()) end
	local g=Duel.GetMatchingGroup(c13257228.filter2,tp,0,LOCATION_MZONE,c,c:GetDefense())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c13257228.desop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(c13257228.filter2,tp,0,LOCATION_MZONE,c,c:GetDefense())
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c13257228.bgmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(11,0,aux.Stringid(13257228,4))
end
