--栀子色之希
function c1150028.initial_effect(c)
--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_TO_HAND)
	e0:SetCondition(c1150028.con0)
	e0:SetOperation(c1150028.op0)
	c:RegisterEffect(e0)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1150028+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c1150028.con1)
	e1:SetTarget(c1150028.tg1)
	e1:SetOperation(c1150028.op1)
	c:RegisterEffect(e1)  
--  
end
--
function c1150028.con0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	return ct<2
end
--
function c1150028.op0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_HAND) then
		Duel.Hint(HINT_CARD,0,c:GetCode())
		local e0_1=Effect.CreateEffect(c)
		e0_1:SetType(EFFECT_TYPE_SINGLE)
		e0_1:SetCode(EFFECT_PUBLIC)
		e0_1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e0_1)
		c:RegisterFlagEffect(1150028,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,66)
	end
end
--
function c1150028.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(1150028)~=0
end
--
function c1150028.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2  end
	local sg=Duel.GetMatchingGroup(aux.TURE,tp,0,LOCATION_ONFIELD,nil)
	if sg:GetCount()>2 then
	   Duel.SetChainLimit(c1150028.limit1)
	end
end
--
function c1150028.limit1(e,ep,tp)
	return tp==ep
end
--
function c1150028.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 then
		Duel.ConfirmDecktop(tp,3)	
		local g=Duel.GetDecktopGroup(tp,3)
		local gn=Group.CreateGroup()
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			while tc do
				if tc:IsType(TYPE_MONSTER) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
					gn:AddCard(tc)
				end
				tc=g:GetNext()
			end
		end
		if gn:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
			if Duel.IsPlayerAffectedByEffect(tp,59822133) then 
				ft=1 
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=gn:Select(tp,ft,ft,nil)
			local stc=sg:GetFirst()
			while stc do
				Duel.SpecialSummonStep(stc,0,tp,tp,false,false,POS_FACEUP)
				g:RemoveCard(stc)
				stc=sg:GetNext()
			end
			Duel.SpecialSummonComplete()
		end
		if g:GetCount()>0 then
			local num=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			Duel.Draw(tp,num,REASON_EFFECT)
		end
	end
end
