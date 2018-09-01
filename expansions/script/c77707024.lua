--逆转墓碑的新玛丽安
function c77707024.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c77707024.con)
	e1:SetTarget(c77707024.tg)
	e1:SetOperation(c77707024.op)
	c:RegisterEffect(e1)
end
function c77707024.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN2 and Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)==3 
end
function c77707024.tgfil(c,e)
	return c:IsAttackable() and not c:IsImmuneToEffect(e) and Duel.IsExistingMatchingCard(c77707024.tgfil2,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,e)
end
function c77707024.tgfil2(c,e)
	return not c:IsImmuneToEffect(e)
end
function c77707024.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77707024.tgfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e) end
end
function c77707024.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(77707024,0))
	local g=Duel.SelectMatchingCard(tp,c77707024.tgfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(77707024,1))
		local sg=Duel.SelectMatchingCard(tp,c77707024.tgfil2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,tc,e)
		Duel.HintSelection(sg)
		local sc=sg:GetFirst()
		if tc and sc then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			Duel.NegateRelatedChain(sc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			local e3=e1:Clone()
			sc:RegisterEffect(e3)
			local e4=e2:Clone()
			sc:RegisterEffect(e4)
			Duel.CalculateDamage(tc,sc)
		end
	end
end