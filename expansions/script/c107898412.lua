--STSS·子弹时间
function c107898412.initial_effect(c)
	c:EnableReviveLimit()
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(107898412,0))
	e1:SetCategory(CATEGORY_LVCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c107898412.condition)
	e1:SetCost(c107898412.cost)
	e1:SetOperation(c107898412.operation)
	c:RegisterEffect(e1)
end
function c107898412.cfilter(c)
	return c:IsFaceup() and c:IsCode(107898102)
end
function c107898412.condition(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.IsExistingMatchingCard(c107898412.cfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetTurnPlayer()==tp
end
function c107898412.cost(e,tp,eg,ep,ev,re,r,rp,chk)
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
function c107898412.lvfilter(c)
	return c:IsLevelAbove(1) and (c:IsSetCard(0x575a) or c:IsSetCard(0x575b) or c:IsSetCard(0x575c))
end
function c107898412.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<=0 then return end
	Duel.ConfirmCards(1-tp,Duel.GetFieldGroup(tp,LOCATION_HAND,0))
	local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Filter(c107898412.lvfilter,nil)
	local tc=hg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=hg:GetNext()
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DRAW)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end