--牺牲的沉沦，波恋达斯
function c12008010.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCondition(c12008010.regcon)
	e1:SetOperation(c12008010.regop)
	c:RegisterEffect(e1)  
	--sp1
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12008010,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCountLimit(1,12008010)
	e2:SetTarget(c12008010.sptg)
	e2:SetOperation(c12008010.spop)
	c:RegisterEffect(e2)   
	e1:SetLabelObject(e2)
	local e7=e2:Clone()
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetHintTiming(TIMINGS_CHECK_MONSTER)
	e7:SetCondition(c12008010.tdcon2)
	c:RegisterEffect(e7)  
	--tograve
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12008010,2))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,12008110)
	e4:SetTarget(c12008010.tgtg)
	e4:SetOperation(c12008010.tgop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e5)
end
function c12008010.tdcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,12008029)>0
end
function c12008010.tgfilter(c)
	return c:IsSetCard(0x1fb3) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c12008010.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12008010.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c12008010.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c12008010.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c12008010.regcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0x1fb3)
end
function c12008010.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	e:GetLabelObject():SetLabelObject(nil)
	if Duel.SelectYesNo(tp,aux.Stringid(12008010,0)) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		e:GetLabelObject():SetLabelObject(e1)
	end
end
function c12008010.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsReason(REASON_EFFECT) and c:GetReasonEffect():GetHandler():IsSetCard(0x1fb3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12008010.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and Duel.IsExistingMatchingCard(c12008010.spfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,e,tp) and e:GetLabelObject() and Duel.IsPlayerCanSpecialSummonCount(tp,2) end
	e:SetLabelObject(nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c12008010.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)<=0 or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c12008010.spfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil,e,tp)
	if g:GetCount()>0 then
	   Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
