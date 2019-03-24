--STSS·催化剂
function c107898417.initial_effect(c)
	c:EnableReviveLimit()
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(107898411,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c107898417.condition)
	e1:SetCost(c107898417.cost)
	e1:SetTarget(c107898417.target)
	e1:SetOperation(c107898417.operation)
	c:RegisterEffect(e1)
end
function c107898417.cfilter(c)
	return c:IsFaceup() and c:IsCode(107898102)
end
function c107898417.cfilterx(c)
	return c:IsFaceup() and c:IsCode(107898102) and c:GetCounter(0x1009)>0
end
function c107898417.condition(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.IsExistingMatchingCard(c107898417.cfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetTurnPlayer()==tp
end
function c107898417.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetLevel()==1
	or Duel.IsCanRemoveCounter(tp,1,0,0x1,math.floor(e:GetHandler():GetLevel()/2),REASON_COST)
	and e:GetHandler():IsAbleToRemoveAsCost() end
	if e:GetHandler():GetLevel()>1 then
		Duel.RemoveCounter(tp,1,0,0x1,math.floor(e:GetHandler():GetLevel()/2),REASON_COST)
	end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c107898417.ctfilter(c)
	return c:GetCounter(0x1009)>0 and c:IsCanAddCounter(0x1009,c:GetCounter(0x1009)*2)
end
function c107898417.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetCounter(0x1009)>0 and chkc:IsCanAddCounter(0x1009,chkc:GetCounter(0x1009)*2) end
	local y1=Duel.IsExistingTarget(c107898417.ctfilter,tp,0,LOCATION_MZONE,1,nil) 
	local y2=Duel.IsExistingTarget(c107898417.cfilterx,tp,LOCATION_MZONE,0,1,nil) and not Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil)
	if chk==0 then return y1 or y2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	if y1 then
		local g=Duel.SelectTarget(tp,c107898417.ctfilter,tp,0,LOCATION_MZONE,1,1,nil)
	end
	if y2 then
		local g=Duel.SelectTarget(tp,c107898417.cfilterx,tp,LOCATION_MZONE,0,1,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0)
end
function c107898417.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if tc:IsCanAddCounter(0x1009,tc:GetCounter(0x1009)*2) then
		local atk=tc:GetAttack()
		tc:AddCounter(0x1009,tc:GetCounter(0x1009)*2)
		if atk>0 and tc:IsAttack(0) then
			Duel.RaiseEvent(tc,EVENT_CUSTOM+54306223,e,0,0,0,0)
		end
	end
end
