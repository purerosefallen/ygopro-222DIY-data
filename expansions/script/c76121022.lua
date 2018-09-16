--超新兵 波尔多拉
function c76121022.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xea2),3,3)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c76121022.efilter)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(76121022,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c76121022.cfcost)
	e2:SetTarget(c76121022.cftg)
	e2:SetOperation(c76121022.cfop)
	c:RegisterEffect(e2)
end
function c76121022.efilterefilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c76121022.cfilter(c)
	return c:IsSetCard(0xea2) and (c:IsType(TYPE_MONSTER) or c:IsType(TYPE_TRAP)) and c:IsAbleToDeckOrExtraAsCost()
end
function c76121022.cfcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local dg=Duel.GetMatchingGroup(c76121022.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if chk==0 then return dg:GetClassCount(Card.GetCode)>=4 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg1=dg:Select(tp,1,1,nil)
	dg:Remove(Card.IsCode,nil,sg1:GetFirst():GetCode())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg2=dg:Select(tp,1,1,nil)
	dg:Remove(Card.IsCode,nil,sg2:GetFirst():GetCode())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg3=dg:Select(tp,1,1,nil)
	dg:Remove(Card.IsCode,nil,sg3:GetFirst():GetCode())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg4=dg:Select(tp,1,1,nil)
	sg1:Merge(sg2)
	sg1:Merge(sg3)
	sg1:Merge(sg4)
	Duel.SendtoDeck(sg1,nil,2,REASON_COST)
end
function c76121022.cftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
		and (Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 or Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0) end
end
function c76121022.msfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE,1-tp)
end
function c76121022.ssfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c76121022.sfilter(c,e,tp)
	return (c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE,1-tp)) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable())
end
function c76121022.cfop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()==0 then return end
	Duel.ConfirmCards(tp,g)
	local b1=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
	local b2=Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0
	if not b1 and not b2 then return end
	if b1 and b2 then
		local sg1=g:Filter(c76121022.sfilter,nil,e,tp)
		if sg1:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local setg1=sg1:Select(tp,1,1,nil)
			local tc1=setg1:GetFirst()
			if tc1:IsType(TYPE_MONSTER) then
				Duel.SpecialSummon(tc1,0,tp,1-tp,false,false,POS_FACEDOWN_DEFENSE)
			else
				Duel.SSet(tp,tc1,1-tp)
			end
			Duel.ConfirmCards(1-tp,tc1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc1:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CANNOT_TRIGGER)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc1:RegisterEffect(e2,true)
		end
	elseif b1 then
		local sg2=g:Filter(c76121022.msfilter,nil,e,tp)
		if sg2:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local setg2=sg2:Select(tp,1,1,nil)
			local tc2=setg2:GetFirst()
			Duel.SpecialSummon(tc2,0,tp,1-tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,tc2)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc2:RegisterEffect(e2,true)
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_CANNOT_TRIGGER)
			e4:SetReset(RESET_EVENT+0x1fe0000)
			tc2:RegisterEffect(e4,true)
		end
	else
		local sg3=g:Filter(c76121022.ssfilter,nil)
		if sg3:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local setg3=sg3:Select(tp,1,1,nil)
			local tc3=setg3:GetFirst()
			Duel.SSet(tp,tc3,1-tp)
			Duel.ConfirmCards(1-tp,tc3)
			local e5=Effect.CreateEffect(e:GetHandler())
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
			e5:SetReset(RESET_EVENT+0x1fe0000)
			tc3:RegisterEffect(e5,true)
			local e6=Effect.CreateEffect(e:GetHandler())
			e6:SetType(EFFECT_TYPE_SINGLE)
			e6:SetCode(EFFECT_CANNOT_TRIGGER)
			e6:SetReset(RESET_EVENT+0x1fe0000)
			tc3:RegisterEffect(e6,true)
		end
	end
	Duel.ShuffleHand(1-tp)
end