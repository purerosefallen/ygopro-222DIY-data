
function c107898405.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(107898405,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DEFCHANGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c107898405.spcon)
	e1:SetCost(c107898405.cost)
	e1:SetTarget(c107898405.sptg)
	e1:SetOperation(c107898405.spop)
	c:RegisterEffect(e1)
end
function c107898405.filter(c)
	return c:IsCode(107898101) and c:IsFaceup()
end
function c107898405.filter2(c)
	return c:IsSetCard(0x575) and c:IsFaceup() and c:IsType(TYPE_TOKEN)
end
function c107898405.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2 and Duel.GetTurnPlayer()==tp
end
function c107898405.cost(e,tp,eg,ep,ev,re,r,rp,chk)
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
function c107898405.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c107898405.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c107898405.filter,tp,LOCATION_MZONE,0,1,nil)
	and ((Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,107898150,0x575,0x4011,0,e:GetHandler():GetDefense(),10,RACE_ROCK,ATTRIBUTE_LIGHT))
	or Duel.IsExistingTarget(c107898405.filter2,tp,LOCATION_MZONE,0,1,nil)) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c107898405.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c107898405.atcost(e,c,tp)
	local ct=Duel.GetFlagEffect(tp,107898405)
	return Duel.CheckLPCost(tp,600*ct)
end
function c107898405.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,600)
end
function c107898405.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local gcd=tc:GetDefense()
	if gcd<0 then gcd=0 end
	local gcd2=c:GetDefense()
	if gcd2<0 then gcd2=0 end
	local tdef=gcd+gcd2
	local y1=(Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,107898150,0x575,0x4011,0,tdef,10,RACE_ROCK,ATTRIBUTE_LIGHT))
	local y2=Duel.IsExistingTarget(c107898405.filter2,tp,LOCATION_MZONE,0,1,nil)
	local op=0
	if y1 and y2 then
		op=Duel.SelectOption(tp,aux.Stringid(107898405,1),aux.Stringid(107898405,2))
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
		local g=Duel.SelectMatchingCard(tp,c107898405.filter2,tp,   LOCATION_MZONE,0,1,1,nil)
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
	--attack cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ATTACK_COST)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetCost(c107898405.atcost)
	e2:SetOperation(c107898405.atop)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e2,tp)
	--accumulate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(0x10000000+107898405)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	c:RegisterEffect(e3,tp)
end