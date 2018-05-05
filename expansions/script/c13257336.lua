--超时空破坏胶囊
function c13257336.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13257336,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(c13257336.destg)
	e1:SetOperation(c13257336.desop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13257336,1))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c13257336.target)
	e2:SetOperation(c13257336.activate)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(c13257336.drcost)
	e3:SetTarget(c13257336.drtg)
	e3:SetOperation(c13257336.drop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetRange(LOCATION_REMOVED)
	c:RegisterEffect(e4)
	
end
--function c13257336.check(c,tp)
--  return c and c:IsControler(tp) and c:IsSetCard(0x351)
--end
function c13257336.pcfilter(c)
	return c:IsSetCard(0x351) and c:IsFaceup()
end
function c13257336.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	--if chk==0 then return c13257336.check(Duel.GetAttacker(),tp) or c13257336.check(Duel.GetAttackTarget(),tp) end
	if chkc==0 then return chkc:IsOnField and c13257336.pcfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c13257336.pcfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetChainLimit(c13257336.chlimit)
end
function c13257336.chlimit(e,ep,tp)
	return e:IsActiveType(TYPE_MONSTER)
end
function c13257336.desfilter(c)
	return c:IsFaceup() and (c:GetAttack()==0 or (c:GetDefense()==0 and not c:IsType(TYPE_LINK)))
end
function c13257336.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(12,0,aux.Stringid(13257336,7))
	local g=Duel.GetMatchingGroup(c13257336.acfilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local sc=g:GetFirst()
		while sc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(-1000)
			sc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			sc:RegisterEffect(e2)
			sc=g:GetNext()
		end
		g=Duel.GetMatchingGroup(c13257336.desfilter,tp,0,LOCATION_MZONE,nil)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function c13257336.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x351) and c:IsCanAddCounter(0x351,1)
end
function c13257336.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c13257336.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c13257336.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c13257336.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x351)
end
function c13257336.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsCanAddCounter(0x351,1) then
		Duel.Hint(12,0,aux.Stringid(13257326,7))
		tc:AddCounter(0x351,1)
	end
end
function c13257336.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c13257336.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and c:IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c13257336.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SendtoDeck(c,nil,0,REASON_EFFECT)~=0 then
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
