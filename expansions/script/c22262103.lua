--这就是 所谓的杀死事物
function c22262103.initial_effect(c)
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e0:SetCondition(c22262103.actcon)
	c:RegisterEffect(e0)
	--ACTIVATE
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c22262103.condition)
	e1:SetTarget(c22262103.target)
	e1:SetOperation(c22262103.activate)
	c:RegisterEffect(e1)
end
c22262103.Desc_Contain_NanayaShiki=1
function c22262103.IsNanayaShiki(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_NanayaShiki
end
function c22262103.actfilter(c)
	return c:IsFaceup() and c22262103.IsNanayaShiki(c)
end
function c22262103.actcon(e)
	return Duel.IsExistingMatchingCard(c22262103.actfilter,e:GetHandler():GetControler(),LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c22262103.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>0
end
function c22262103.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) and Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function c22262103.filter(c)
	return c22262103.IsNanayaShiki(c) and c:IsType(TYPE_MONSTER)
end
function c22262103.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)
		local g=Duel.GetOperatedGroup()
		if g:FilterCount(c22262103.filter,nil)>0 then Duel.Draw(tp,1,REASON_EFFECT) end
	end
end