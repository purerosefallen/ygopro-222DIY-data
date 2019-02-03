--小黑
function c12031011.initial_effect(c)
	c:SetSPSummonOnce(12031011)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,2,c12031011.ovfilter,aux.Stringid(12031011,0))
	c:EnableReviveLimit()
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c12031011.discon)
	e1:SetOperation(c12031011.disop)
	c:RegisterEffect(e1)

	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12031011,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c12031011.thcost)
	e4:SetTarget(c12031011.thtg)
	e4:SetOperation(c12031011.thop)
	c:RegisterEffect(e4)
	if not c12031011.global_check then
		c12031011.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(c12031011.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c12031011.cfilter(c,tp)
	return c:IsType(TYPE_MONSTER)
end
function c12031011.checkop(e,tp,eg,ep,ev,re,r,rp)
	if not eg and re and re:IsHasType(0x7e0) and re:GetHandler():IsReason(REASON_COST) and c: then return end
	local sg=eg:Filter(c12031011.cfilter,nil,tp)
	local tc=sg:GetFirst()
	while tc do
		Duel.RegisterFlagEffect(tp,12031011+100,RESET_PHASE+PHASE_END,0,1)
		tc=sg:GetNext()
	end
end
function c12031011.ovfilter(c)
	return c:IsFaceup() and c:IsCode(12031000)
end
function c12031011.discon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c12031011.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tt=c:GetOverlayCount()
	if Duel.GetFlagEffect(tp,12031011)==0 then 
	if not ( re:IsHasType(EFFECT_TYPE_ACTIVATE) and not re:GetHandler():IsType(TYPE_CONTINUOUS) )  then
	Duel.Overlay(c,Group.FromCards(re:GetHandler()))
	   Duel.BreakEffect()
	   local ff=c:GetOverlayCount()
	   if ff>tt then
		Duel.RegisterFlagEffect(tp,12031011,RESET_PHASE+PHASE_END,0,1)
		c:RegisterFlagEffect(12031011,RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(12031011,4))
	   else
		  Duel.NegateEffect(ev)
	   end
	else
		Duel.NegateEffect(ev)
	end
	end
end
function c12031011.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c12031011.thfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToHand()
end
function c12031011.thfilter1(c)
	return c:IsAttribute(ATTRIBUTE_DARK) or c:IsAttribute(ATTRIBUTE_EARTH) and c:IsAbleToHand()
end
function c12031011.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
end
function c12031011.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cc=Duel.GetFlagEffect(tp,12031011+100)
	if Duel.GetFlagEffect(tp,12031011+100)==0 or Duel.IsExistingMatchingCard(c12031011.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,cc,nil) then return end
	if cc<3 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local ct=Duel.SelectMatchingCard(tp,c12031011.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,cc,cc,nil)
	   if Duel.SendtoHand(ct,tp,REASON_EFFECT)>0 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	   Duel.DiscardHand(tp,nil,cc-1,cc-1,nil)
	   end
	else
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local ct=Duel.SelectMatchingCard(tp,c12031011.thfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,cc,cc,nil)
	   if Duel.SendtoHand(ct,tp,REASON_EFFECT)>0 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	   Duel.DiscardHand(tp,nil,cc-1,cc-1,nil)
	   end
	end
end