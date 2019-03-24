
function c107898406.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(107898406,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_DEFCHANGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c107898406.spcon)
	e1:SetCost(c107898406.cost)
	e1:SetTarget(c107898406.sptg)
	e1:SetOperation(c107898406.spop)
	c:RegisterEffect(e1)
end
function c107898406.filter(c)
	return c:IsCode(107898101) and c:IsFaceup()
end
function c107898406.filter2(c)
	return c:IsSetCard(0x575) and c:IsFaceup() and c:IsType(TYPE_TOKEN)
end
function c107898406.htfilter(c)
	return c:IsCode(107898151) and c:IsAbleToHand()
end
function c107898406.htfilter2(c)
	return c107898406.htfilter(c) and c:IsFaceup()
end
function c107898406.htfilter3(c)
	return c:IsCode(107898151) and not c:IsPublic()
end
function c107898406.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2 and Duel.GetTurnPlayer()==tp
end
function c107898406.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetLevel()==1
	or Duel.IsCanRemoveCounter(tp,1,0,0x1,math.floor(e:GetHandler():GetLevel()/2),REASON_COST)
	and ((not Duel.IsPlayerAffectedByEffect(tp,107898504) and e:GetHandler():IsAbleToGraveAsCost()) 
	or (Duel.IsPlayerAffectedByEffect(tp,107898504) and e:GetHandler():IsAbleToRemoveAsCost()))
	end
	if e:GetHandler():GetLevel()>1 then
		Duel.RemoveCounter(tp,1,0,0x1,math.floor(e:GetHandler():GetLevel()/2),REASON_COST)
	end
	if Duel.IsPlayerAffectedByEffect(tp,107898504) then
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	else
		Duel.SendtoGrave(e:GetHandler(),REASON_COST)
	end
end
function c107898406.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c107898406.filter(chkc)
	and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,107898150,0x575,0x4011,0,e:GetHandler():GetDefense(),10,RACE_ROCK,ATTRIBUTE_LIGHT))
	or Duel.IsExistingTarget(c107898406.filter2,tp,LOCATION_MZONE,0,1,nil) end
	local g1=Duel.GetMatchingGroup(c107898406.htfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	local g2=Duel.GetMatchingGroup(c107898406.htfilter2,tp,LOCATION_REMOVED,0,nil)
	local g3=Duel.GetMatchingGroup(c107898406.htfilter3,tp,LOCATION_HAND,0,nil)
	g1:Merge(g2)
	if chk==0 then return Duel.IsExistingTarget(c107898406.filter,tp,LOCATION_MZONE,0,1,nil) and (g1:GetCount()>=2 or g3:GetCount()>=2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c107898406.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c107898406.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local g1=Duel.GetMatchingGroup(c107898406.htfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	local g2=Duel.GetMatchingGroup(c107898406.htfilter2,tp,LOCATION_REMOVED,0,nil)
	local g3=Duel.GetMatchingGroup(c107898406.htfilter3,tp,LOCATION_HAND,0,nil)
	g1:Merge(g2)
	local op2=0
	if g1:GetCount()>=2 and g3:GetCount()>=2 then
		op2=Duel.SelectOption(tp,aux.Stringid(107898406,3),aux.Stringid(107898406,4))
	elseif g1:GetCount()>=2 then
		op2=0
	else
		op2=1
	end
	if op2==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=g1:Select(tp,2,2,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,c107898406.htfilter3,tp,LOCATION_HAND,0,2,2,nil)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
	local gcd=tc:GetDefense()
	if gcd<0 then gcd=0 end
	local gcd2=c:GetDefense()
	if gcd2<0 then gcd2=0 end
	local tdef=gcd+gcd2
	local y1=(Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,107898150,0x575,0x4011,0,tdef,10,RACE_ROCK,ATTRIBUTE_LIGHT))
	local y2=Duel.IsExistingTarget(c107898406.filter2,tp,LOCATION_MZONE,0,1,nil)
	local op=0
	if y1 and y2 then
		op=Duel.SelectOption(tp,aux.Stringid(107898406,1),aux.Stringid(107898406,2))
	elseif y1 then
		op=0
	else
		op=1
	end
	if op==0 then
		local token=Duel.CreateToken(tp,107898150)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_DEFENSE)
		e1:SetValue(tdef)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,c107898406.filter2,tp,   LOCATION_MZONE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			local rc=g:GetFirst()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_DEFENSE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			e1:SetValue(tdef)
			rc:RegisterEffect(e1)
		end
	end
end
function c107898406.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end