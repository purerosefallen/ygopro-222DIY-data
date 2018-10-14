--元素火花破裂
function c10110007.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10110007,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,10110007)
	e1:SetTarget(c10110007.target)
	e1:SetOperation(c10110007.activate)
	c:RegisterEffect(e1)  
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10110007,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCountLimit(1,10110007)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c10110007.descon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c10110007.destg)
	e2:SetOperation(c10110007.desop)
	c:RegisterEffect(e2)	
end
function c10110007.rfilter2(c,g)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsAbleToRemove() and c:IsSetCard(0x9332) and c:CheckFusionMaterial(g)
end
function c10110007.ffilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c10110007.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(c10110007.ffilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c10110007.rfilter2(chkc,g) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c10110007.rfilter2,tp,LOCATION_MZONE,0,1,nil,g) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c10110007.rfilter2,tp,LOCATION_MZONE,0,1,1,nil,g)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c10110007.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c10110007.ffilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 and tc:IsLocation(LOCATION_REMOVED) then
	   local e1=Effect.CreateEffect(e:GetHandler())
	   e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	   e1:SetCode(EVENT_PHASE+PHASE_END)
	   e1:SetReset(RESET_PHASE+PHASE_END)
	   e1:SetLabelObject(tc)
	   e1:SetCountLimit(1)
	   e1:SetOperation(c10110007.retop)
	   Duel.RegisterEffect(e1,tp)
	   if g:GetCount()>0 and tc:CheckFusionMaterial(g) then
		  local tg=Duel.SelectFusionMaterial(tp,tc,g)
		  Duel.HintSelection(tg)
		  Duel.SendtoHand(tg,nil,REASON_EFFECT)
	   end
	end
end
function c10110007.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c10110007.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c10110007.rfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c10110007.rfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,1,0,LOCATION_MZONE)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,1,0,LOCATION_ONFIELD)
end
function c10110007.desop(e,tp,eg,ep,ev,re,r,rp)
	local ex,g1=Duel.GetOperationInfo(0,CATEGORY_REMOVE)
	local ex,g2=Duel.GetOperationInfo(0,CATEGORY_DESTROY)
	local tc1,tc2=g1:GetFirst(),g2:GetFirst()
	if tc1:IsRelateToEffect(e) and tc1:IsControler(tp) and Duel.Remove(tc1,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 and tc1:IsLocation(LOCATION_REMOVED) then
	   local e1=Effect.CreateEffect(e:GetHandler())
	   e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	   e1:SetCode(EVENT_PHASE+PHASE_END)
	   e1:SetReset(RESET_PHASE+PHASE_END)
	   e1:SetLabelObject(tc1)
	   e1:SetCountLimit(1)
	   e1:SetOperation(c10110007.retop)
	   Duel.RegisterEffect(e1,tp)
	   if tc2:IsRelateToEffect(e) and tc2:IsControler(1-tp) then
		  Duel.Destroy(tc2,REASON_EFFECT)
	   end
	end
end
function c10110007.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c10110007.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c10110007.rfilter(c)
	return c:IsSetCard(0x9332) and c:IsFaceup() and c:IsAbleToRemove()
end