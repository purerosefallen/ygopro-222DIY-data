--霞色的华美青空
function c65030083.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.NonTuner(c65030083.synfil),nil,nil,aux.Tuner(nil),2,99)
	c:EnableReviveLimit()
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_NEGATE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c65030083.negcon)
	e1:SetTarget(c65030083.negtg)
	e1:SetOperation(c65030083.negop)
	c:RegisterEffect(e1)
	--token
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetOperation(aux.chainreg)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_CHAIN_SOLVED)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c65030083.con)
	e5:SetTarget(c65030083.tg)
	e5:SetOperation(c65030083.op)
	c:RegisterEffect(e5)
end
c65030083.card_code_list={65030086}
function c65030083.synfil(c)
	return aux.IsCodeListed(c,65030086) and c:IsType(TYPE_SYNCHRO)
end
function c65030083.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and rp~=tp
end
function c65030083.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
	if chk==0 then return g:GetCount()>0 and Duel.IsPlayerCanDraw(tp) and Duel.IsPlayerCanSpecialSummon(tp) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,0,0,tp,g:GetCount()-1)
end
function c65030083.checkfil(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and aux.IsCodeListed(c,65030086)
end
function c65030083.negop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
	if g:GetCount()>0 then 
		local num=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		if num>0 then
			Duel.Draw(tp,num-1,REASON_EFFECT)
			if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummon(tp) then
				Duel.BreakEffect()
				local tgg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
				local tc=tgg:RandomSelect(1-tp,1)
				if c65030083.checkfil(tc,e,tp) then
					Duel.NegateActivation(ev)
					Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
	end
end

function c65030083.con(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and e:GetHandler():GetFlagEffect(1)>0
end
function c65030083.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_HAND,nil)
	if chk==0 then return g:GetCount()>0 and Duel.IsPlayerCanDraw(1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,0,0,tp,g:GetCount()+1)
end
function c65030083.optg(e,c)
	return aux.IsCodeListed(c,65030086)
end
function c65030083.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_HAND,nil)
	if g:GetCount()>0 then 
		local tgg=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		if tgg>0 then
			Duel.Draw(1-tp,tgg+1,REASON_EFFECT)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetTargetRange(LOCATION_MZONE,0)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetTarget(c65030083.optg)
			e1:SetValue(tgg*300)
			Duel.RegisterEffect(e1,tp)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			Duel.RegisterEffect(e2,tp)
		end
	end
end