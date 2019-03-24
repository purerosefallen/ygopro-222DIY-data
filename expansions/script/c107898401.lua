--STSS·突破极限
function c107898401.initial_effect(c)
	c:EnableReviveLimit()
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(107898401,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c107898401.condition)
	e1:SetCost(c107898401.cost)
	e1:SetTarget(c107898401.target)
	e1:SetOperation(c107898401.operation)
	c:RegisterEffect(e1)
end
function c107898401.efilter(e,te)
	return not te:GetOwner():IsSetCard(0x575)
end
function c107898401.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2 and Duel.GetTurnPlayer()==tp
end
function c107898401.filter(c)
	return c:IsCode(107898101) and c:IsFaceup()
end
function c107898401.cost(e,tp,eg,ep,ev,re,r,rp,chk)
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
function c107898401.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c107898401.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c107898401.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c107898401.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c107898401.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(tc:GetAttack()*2)
		tc:RegisterEffect(e1)
	end
end