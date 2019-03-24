
function c107898407.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(107898407,0))
	e1:SetCategory(CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c107898407.spcon)
	e1:SetCost(c107898407.cost)
	e1:SetTarget(c107898407.sptg)
	e1:SetOperation(c107898407.spop)
	c:RegisterEffect(e1)
end
function c107898407.filter(c)
	return c:IsCode(107898101) and c:IsFaceup()
end
function c107898407.filter2(c,e)
	return c:IsSetCard(0x575) and c:GetBaseAttack()==0 and c:IsType(TYPE_TOKEN) and c:IsFaceup()
end
function c107898407.filter3(c,e)
	return c:IsSetCard(0x575) and c:GetBaseAttack()==0 and c:IsType(TYPE_TOKEN) and c:IsFaceup() and not c:IsImmuneToEffect(e)
end
function c107898407.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2 and Duel.GetTurnPlayer()==tp
end
function c107898407.cost(e,tp,eg,ep,ev,re,r,rp,chk)
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
function c107898407.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c107898407.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c107898407.filter2,tp,LOCATION_MZONE,0,1,nil) end
end
function c107898407.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c107898407.filter3,tp,   LOCATION_MZONE,0,nil,e)
	if g:GetCount()>0 then
		local rc=g:GetFirst()
		while rc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			e1:SetValue(rc:GetDefense()*2)
			rc:RegisterEffect(e1)
			rc=g:GetNext()
		end
	end
end