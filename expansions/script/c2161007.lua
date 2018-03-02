--天狐秘术-断
function c2161007.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,2161007+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c2161007.target)
	e1:SetOperation(c2161007.activate)
	c:RegisterEffect(e1)
end
function c2161007.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c2161007.filter2(c,tp)
	return c:IsType(TYPE_SPELL) and c:IsLocation(LOCATION_ONFIELD) and c:IsSetCard(0x21e) and c:IsControler(tp)
end
function c2161007.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c2161007.filter,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
		and Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c2161007.filter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
	if g1:IsExists(c2161007.filter2,1,nil,tp)  then
	 Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
end
function c2161007.filter3(c,tp)
	return c:IsType(TYPE_SPELL) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsSetCard(0x21e) and c:IsControler(tp)
end
function c2161007.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 and Duel.Destroy(sg,REASON_EFFECT)>0 and Duel.GetOperatedGroup():IsExists(c2161007.filter3,1,nil,tp) then
	Duel.BreakEffect()
	Duel.Draw(tp,1,REASON_EFFECT)
	end
end
