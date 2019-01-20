--强者的威风
function c1120005.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c1120005.con1)
	e1:SetTarget(c1120005.tg1)
	e1:SetOperation(c1120005.op1)
	c:RegisterEffect(e1)
--
end
--
function c1120005.con1(e,tp,eg,ep,ev,re,r,rp)
	local cg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local mg=Group.CreateGroup()
	if cg:GetCount()>0 then
		mg=cg:GetMaxGroup(Card.GetAttack)
	end
	return tp==Duel.GetTurnPlayer() or (mg:GetCount()>0 and mg:FilterCount(Card.IsControler,nil,tp)<1)
end
--
function c1120005.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local lg=sg:GetMinGroup(Card.GetAttack)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,lg,1,0,0)
end
--
function c1120005.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
--
	local cg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if cg:GetCount()<1 then return end
	local mg=cg:GetMaxGroup(Card.GetAttack)
	if tp~=Duel.GetTurnPlayer() then
		if mg:FilterCount(Card.IsControler,nil,tp)>0 then return end
	end
--
	local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if sg:GetCount()>0 then
		local lg=sg:GetMinGroup(Card.GetAttack)
		if lg:GetCount()<1 then return end
		local dg=Group.CreateGroup()
		local lc=lg:GetFirst()
		while lc do
			if not lc:IsDisabled() then
				local e1_1=Effect.CreateEffect(c)
				e1_1:SetType(EFFECT_TYPE_SINGLE)
				e1_1:SetCode(EFFECT_DISABLE)
				e1_1:SetReset(RESET_EVENT+RESETS_STANDARD)
				lc:RegisterEffect(e1_1)
				Duel.AdjustInstantly()
				Duel.NegateRelatedChain(lc,RESET_TURN_SET)
				dg:AddCard(lc)
			end
			lc=lg:GetNext()
		end
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
