--涅奥
function c107898100.initial_effect(c)
	c:EnableReviveLimit()
	--special summon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c107898100.spscon)
	e1:SetOperation(c107898100.spsop)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(107898100,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,107898100+EFFECT_COUNT_CODE_SINGLE)
	e2:SetCost(c107898100.spcost1)
	e2:SetTarget(c107898100.sptg1)
	e2:SetOperation(c107898100.spop1)
	c:RegisterEffect(e2)
	--to pzone
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(107898100,3))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,107898100+EFFECT_COUNT_CODE_SINGLE)
	e3:SetTarget(c107898100.pctg)
	e3:SetOperation(c107898100.pcop)
	c:RegisterEffect(e3)
	--counter
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(107898100,6))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,107898100)
	e4:SetCondition(c107898100.ctcon)
	e4:SetTarget(c107898100.cttg)
	e4:SetOperation(c107898100.ctop)
	c:RegisterEffect(e4)
	--reg
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetOperation(c107898100.tgop)
	c:RegisterEffect(e5)
end
function c107898100.spscon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity() and Duel.GetLocationCountFromEx(tp,tp,e:GetHandler())>0 and (Duel.IsExistingMatchingCard(c107898100.costfilter1,tp,LOCATION_EXTRA,0,1,nil,tp) or Duel.IsExistingMatchingCard(c107898100.igfilter,tp,LOCATION_GRAVE,0,1,nil,tp))
end
function c107898100.spsop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	Duel.ConfirmCards(1-tp,e:GetHandler())
	if Duel.IsExistingMatchingCard(c107898100.igfilter,tp,LOCATION_GRAVE,0,1,nil,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c107898100.costfilter1,tp,LOCATION_EXTRA,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c107898100.costfilter2,tp,LOCATION_EXTRA,0,1,1,g1:GetFirst())
	g1:Merge(g2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g3=Duel.SelectMatchingCard(tp,c107898100.costfilter3,tp,LOCATION_EXTRA,0,1,1,g1:GetFirst())
	g1:Merge(g3)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g4=Duel.SelectMatchingCard(tp,c107898100.costfilter4,tp,LOCATION_EXTRA,0,1,1,g1:GetFirst())
	g1:Merge(g4)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g5=Duel.SelectMatchingCard(tp,c107898100.costfilter5,tp,LOCATION_EXTRA,0,1,1,g1:GetFirst())
	g1:Merge(g5)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g6=Duel.SelectMatchingCard(tp,c107898100.costfilter6,tp,LOCATION_EXTRA,0,1,1,g1:GetFirst())
	g1:Merge(g6)
	Duel.SendtoGrave(g1,REASON_COST)
end
function c107898100.costfilter1(c,tp)
	return c:IsCode(107898199) and c:IsAbleToGraveAsCost()
	and Duel.IsExistingMatchingCard(c107898100.costfilter2,tp,LOCATION_EXTRA,0,1,c) 
	and Duel.IsExistingMatchingCard(c107898100.costfilter3,tp,LOCATION_EXTRA,0,1,c) 
	and Duel.IsExistingMatchingCard(c107898100.costfilter4,tp,LOCATION_EXTRA,0,1,c)
	and Duel.IsExistingMatchingCard(c107898100.costfilter5,tp,LOCATION_EXTRA,0,1,c)
	and Duel.IsExistingMatchingCard(c107898100.costfilter6,tp,LOCATION_EXTRA,0,1,c)
end
function c107898100.costfilter2(c)
	return c:IsCode(107898499) and c:IsAbleToGraveAsCost()
end
function c107898100.costfilter3(c)
	return c:IsCode(107898498) and c:IsAbleToGraveAsCost()
end
function c107898100.costfilter4(c)
	return c:IsCode(107898601) and c:IsAbleToGraveAsCost()
end
function c107898100.costfilter5(c)
	return c:IsCode(107898497) and c:IsAbleToGraveAsCost()
end
function c107898100.costfilter6(c)
	return c:IsCode(107898602) and c:IsAbleToGraveAsCost()
end
function c107898100.igfilter(c,tp)
	return c:IsCode(107898199) 
	and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,c,107898499)
	and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,c,107898498) 
	and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,c,107898601)
	and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,c,107898497) 
	and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,c,107898602) 
end
function c107898100.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c107898100.spfilter(c,e,tp)
	return c:IsCode(107898101) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c107898100.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c107898100.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c107898100.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c107898100.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
function c107898100.pcfilter(c)
	return c:IsCode(107898102) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c107898100.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.IsExistingMatchingCard(c107898100.pcfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c107898100.pcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c107898100.pcfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
	Duel.BreakEffect()
	Duel.Destroy(c,REASON_EFFECT)
end
function c107898100.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(107898100,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c107898100.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(107898100)>0
end
function c107898100.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsCanAddCounter(0x1,3) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,0x1,3) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,0x1,3)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,3,0,0)
end
function c107898100.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsCanAddCounter(0x1,3) then
		tc:AddCounter(0x1,3)
	end
end