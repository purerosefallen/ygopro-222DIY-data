--STSS·岿然不动
function c107898403.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(107898403,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c107898403.spcon)
	e1:SetCost(c107898403.cost)
	e1:SetTarget(c107898403.sptg)
	e1:SetOperation(c107898403.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCategory(CATEGORY_DEFCHANGE)
	e2:SetDescription(aux.Stringid(107898403,1))
	e2:SetTarget(c107898403.sptg2)
	e2:SetOperation(c107898403.spop2)
	c:RegisterEffect(e2)
end
function c107898403.filter(c)
	return c:IsCode(107898101) and c:IsFaceup()
end
function c107898403.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2 and Duel.GetTurnPlayer()==tp
end
function c107898403.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetLevel()==1
	or Duel.IsCanRemoveCounter(tp,1,0,0x1,math.floor(e:GetHandler():GetLevel()/2),REASON_COST)
	and e:GetHandler():IsAbleToRemoveAsCost() end
	if e:GetHandler():GetLevel()>1 then
		Duel.RemoveCounter(tp,1,0,0x1,math.floor(e:GetHandler():GetLevel()/2),REASON_COST)
	end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c107898403.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c107898403.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c107898403.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,107898150,0x575,0x4011,0,e:GetHandler():GetDefense(),10,RACE_ROCK,ATTRIBUTE_LIGHT) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c107898403.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c107898403.filter2(c)
	return c:IsSetCard(0x575) and c:IsFaceup() and c:IsType(TYPE_TOKEN)
end
function c107898403.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c107898403.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c107898403.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingTarget(c107898403.filter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c107898403.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c107898403.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local gcd=tc:GetDefense()
	if gcd<0 then gcd=0 end
	local gcd2=c:GetDefense()
	if gcd2<0 then gcd2=0 end
	local tdef=gcd+gcd2
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,107898150,0x575,0x4011,0,tdef,10,RACE_ROCK,ATTRIBUTE_LIGHT) then return end
	local token=Duel.CreateToken(tp,107898150)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_DEFENSE)
	e1:SetValue(tdef)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	token:RegisterEffect(e1)
	Duel.SpecialSummonComplete()
	if e:GetHandler():IsRelateToEffect(e) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
	end
end
function c107898403.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local gcd=tc:GetDefense()
	if gcd<0 then gcd=0 end
	local gcd2=c:GetDefense()
	if gcd2<0 then gcd2=0 end
	local tdef=gcd+gcd2
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c107898403.filter2,tp,LOCATION_MZONE,0,1,1,nil)
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