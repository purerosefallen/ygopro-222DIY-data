--月姬武圆舞
function c75646507.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,75646507+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c75646507.target)
	e1:SetOperation(c75646507.activate)
	c:RegisterEffect(e1)
end
function c75646507.remfilter(c,tp)
	return c:IsSetCard(0x32c1) and c:IsType(TYPE_MONSTER) 
		and Duel.IsExistingMatchingCard(c75646507.gyfilter,tp,0,LOCATION_ONFIELD,1,nil,c:GetColumnGroup())
end
function c75646507.gyfilter(c,g)
	return g:IsContains(c)
end
function c75646507.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646507.remfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,1-tp,LOCATION_ONFIELD)
end
function c75646507.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.SelectMatchingCard(tp,c75646507.remfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	if mg:GetCount()==0 then return end
	local g=Duel.GetMatchingGroup(c75646507.gyfilter,tp,0,LOCATION_ONFIELD,nil,mg:GetFirst():GetColumnGroup())
	local rt=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	if rt>0 then
		Duel.BreakEffect()
		Duel.Damage(1-tp,rt*1500,REASON_EFFECT)
	end
end



