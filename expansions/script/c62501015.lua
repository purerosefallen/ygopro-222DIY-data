--陰義 因果応報・天罰覿面
function c62501015.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,62501015+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c62501015.condition)
	e1:SetTarget(c62501015.target)
	e1:SetOperation(c62501015.activate)
	c:RegisterEffect(e1)
end
function c62501015.condition(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetAttacker()
	local at=tg:GetAttack()
	return Duel.GetTurnPlayer()~=tp 
end
function c62501015.filter(c,lp)
	return c:IsFaceup() 
end
function c62501015.atfilter(c,g)
	return c:IsCode(62501006)
end
function c62501015.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lp=Duel.GetLP(1-tp)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg  and c62501015.filter(chkc,lp) end
	if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,0)
	
end
function c62501015.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.NegateAttack() then
		local atk=tc:GetTextAttack()
		if atk<0 then atk=0 end
		local val=Duel.Damage(tp,atk,REASON_EFFECT)
		if val>0 and Duel.GetLP(tp)>0 then
			Duel.BreakEffect()
			Duel.Damage(1-tp,val,REASON_EFFECT)
		end
	
	if  Duel.IsExistingMatchingCard(c62501015.atfilter,tp,LOCATION_MZONE+LOCATION_SZONE,0,1,nil) then
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local dg=Group.CreateGroup()
		local sc=g:GetFirst()
		while sc do
			local preatk=sc:GetAttack()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-atk)
			sc:RegisterEffect(e1)
			if preatk~=0 and sc:IsAttack(0) then dg:AddCard(sc) end
		sc=g:GetNext()
		end
		Duel.Destroy(dg,REASON_EFFECT)
	end

end
end
end
