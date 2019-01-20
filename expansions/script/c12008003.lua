--探索机械最深的根源，波恋达斯
function c12008003.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(12008003,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetCost(c12008003.cost)
	e1:SetTarget(c12008003.target)
	e1:SetOperation(c12008003.operation)
	c:RegisterEffect(e1) 
	local e4=e1:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_HAND)
	e4:SetHintTiming(TIMINGS_CHECK_MONSTER)
	e4:SetCondition(c12008003.tdcon2)
	c:RegisterEffect(e4)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12008003,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c12008003.spcon)
	e2:SetTarget(c12008003.sptg)
	e2:SetOperation(c12008003.spop)
	c:RegisterEffect(e2)
end
function c12008003.tdcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,12008029)>0
end
function c12008003.cfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x1fb3)
end
function c12008003.spcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return (Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 or not Duel.IsExistingMatchingCard(c12008003.cfilter,tp,LOCATION_MZONE,0,1,nil))
end
function c12008003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,LOCATION_GRAVE)
end
function c12008003.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
	   local e1=Effect.CreateEffect(c)
	   e1:SetDescription(aux.Stringid(12008003,2))
	   e1:SetCategory(CATEGORY_HANDES+CATEGORY_TOGRAVE+CATEGORY_RECOVER+CATEGORY_REMOVE)
	   e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	   e1:SetCode(EVENT_LEAVE_FIELD)
	   e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	   e1:SetReset(RESET_EVENT+RESET_TOFIELD+RESET_TODECK+RESET_OVERLAY+RESET_TURN_SET)
	   e1:SetCondition(c12008003.sccon)
	   e1:SetTarget(c12008003.sctg)
	   e1:SetOperation(c12008003.scop)
	   c:RegisterEffect(e1)
	end
end
function c12008003.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(e:GetHandler())
end
function c12008003.sccon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP)
end
function c12008003.scop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local b1=(Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) and not c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c:IsAbleToGrave())
	local b2=(not c:IsLocation(LOCATION_REMOVED) and c:IsAbleToRemove())
	if not b1 and not b2 then return end
	if b1 and (not b2 or not Duel.SelectYesNo(1-tp,aux.Stringid(12008003,3))) then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	   local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil)
	   if Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)~=0 then
		  Duel.SendtoGrave(c,REASON_EFFECT)
	   end
	else
	   if Duel.Recover(tp,1000,REASON_EFFECT)~=0 then
		  Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
	   end
	end
end
function c12008003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() and Duel.CheckReleaseGroupEx(tp,c12008003.rfilter,1,c) end
	local g=Duel.SelectReleaseGroupEx(tp,c12008003.rfilter,1,1,c)
	g:AddCard(c)
	Duel.Release(g,REASON_COST)
end
function c12008003.rfilter(c)
	return c:IsRace(RACE_MACHINE) and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function c12008003.spfilter(c,e,tp)
	return c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xfb1)
end
function c12008003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12008003.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c12008003.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c12008003.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end