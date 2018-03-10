--反骨的志士 勇
function c10126001.initial_effect(c)
	--SearchCard
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10126001,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,10126001)
	e1:SetTarget(c10126001.thtg)
	e1:SetOperation(c10126001.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)  
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10126001,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,10126001)
	e3:SetCost(c10126001.spcost)
	e3:SetTarget(c10126001.sptg)
	e3:SetOperation(c10126001.spop)
	c:RegisterEffect(e3)
end
function c10126001.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fz1,fz2=LOCATION_HAND+LOCATION_ONFIELD,LOCATION_SZONE 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then 
	   fz1=LOCATION_MZONE 
	   fz2=0
	end
	if chk==0 then return Duel.IsExistingMatchingCard(c10126001.costfilter,tp,fz1,fz2,1,nil,tp,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=-1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=Duel.SelectMatchingCard(tp,c10126001.costfilter,tp,fz1,fz2,1,1,nil,tp,false)
	fz1,fz2=LOCATION_HAND+LOCATION_ONFIELD,LOCATION_SZONE 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==-1 then 
	   fz1=LOCATION_MZONE 
	   fz2=0
	end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g2=Duel.SelectMatchingCard(tp,c10126001.costfilter,tp,fz1,fz2,1,1,g1:GetFirst(),tp,true)
	g1:Merge(g2)
	Duel.Release(g1,REASON_COST)
end
function c10126001.costfilter(c,tp,stop)
	local fz1,fz2=LOCATION_HAND+LOCATION_ONFIELD,LOCATION_SZONE 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==-1 then 
	   fz1=LOCATION_MZONE 
	   fz2=0
	end 
	if c:IsHasEffect(EFFECT_CANNOT_RELEASE) or not Duel.IsPlayerCanRelease(tp,c) then return false end
	--if not c:IsReleasable() then return false end
	local ec=c:GetEquipTarget()
	return ((ec and ec:IsControler(tp)) or c:IsSetCard(0x1335)) and (stop==true or Duel.IsExistingMatchingCard(c10126001.costfilter,tp,fz1,fz2,1,c,tp,true))
end
function c10126001.filter1(c,tp)
	local ec=c:GetEquipTarget()
	return ec and ec:IsControler(tp) and c:IsAbleToGraveAsCost()
end
function c10126001.spfilter(c,e,tp)
	return c:IsSetCard(0x1335) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c10126001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10126001.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c10126001.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10126001.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
	   Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10126001.thfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x1335)
end
function c10126001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10126001.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10126001.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10126001.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
	   Duel.SendtoHand(g,nil,REASON_EFFECT)
	   Duel.ConfirmCards(1-tp,g)
	end
end