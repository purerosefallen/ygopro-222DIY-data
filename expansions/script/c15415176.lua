--时符·幻符『杀人玩偶』
function c15415176.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,15415176+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c15415176.thcon)
	e1:SetCost(c15415176.damcost)
	e1:SetTarget(c15415176.damtg)
	e1:SetOperation(c15415176.damop)
	c:RegisterEffect(e1)	  
end
function c15415176.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x160)
end
function c15415176.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c15415176.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) and Duel.GetCounter(tp,1,1,0x16f)>4
end
function c15415176.filter(c)
	return c:GetCounter(0x16f)>0
end
function c15415176.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c15415176.filter,tp,LOCATION_ONFIELD,0,1,nil) end
	local g=Duel.GetMatchingGroup(c15415176.filter,tp,LOCATION_ONFIELD,0,nil)
	local tc=g:GetFirst()
	local s=0
	while tc do
		local ct=tc:GetCounter(0x16f)
		s=s+ct
		tc:RemoveCounter(tp,0x16f,ct,REASON_COST)
		tc=g:GetNext()
	end
	e:SetLabel(s*700)
end
function c15415176.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetLabel())
end
function c15415176.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end