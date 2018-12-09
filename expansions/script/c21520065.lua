--玲珑法师-水仙
function c21520065.initial_effect(c)
	--special summon from grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520065,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,21520065+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c21520065.spcost)
	e1:SetTarget(c21520065.sptg)
	e1:SetOperation(c21520065.spop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21520065,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_RELEASE)
	e2:SetCountLimit(1,21520065+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c21520065.thtg)
	e2:SetOperation(c21520065.thop)
	c:RegisterEffect(e2)
	--release and to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21520065,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_RELEASE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c21520065.ddtg)
	e3:SetOperation(c21520065.ddop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(21520065,ACTIVITY_SPSUMMON,c21520065.counterfilter)
end
function c21520065.counterfilter(c)
	if c:GetSummonLocation()==LOCATION_EXTRA then
		return c:IsRace(RACE_SPELLCASTER)
	else
		return c:IsSetCard(0x495)
	end
end
function c21520065.spfilter(c,e,tp,lv)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) and c:GetLevel()+lv==6 and c:IsSetCard(0x3495)
end
function c21520065.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	if c:IsLocation(LOCATION_EXTRA) then
		return not c:IsRace(RACE_SPELLCASTER)
	else
		return not c:IsSetCard(0x495)
	end
end
function c21520065.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(21520065,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c21520065.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c21520065.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520065.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,e:GetHandler():GetLevel()) 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c21520065.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c21520065.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp,c:GetLevel())
	if c:IsRelateToEffect(e) and g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
function c21520065.thfilter(c,code)
	return c:IsAbleToHand() and c:IsSetCard(0x495) and c:GetCode()~=code
end
function c21520065.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520065.thfilter,tp,LOCATION_DECK,0,1,nil,e:GetHandler():GetCode()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
end
function c21520065.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c21520065.thfilter,tp,LOCATION_DECK,0,nil,c:GetCode())
	if c:IsRelateToEffect(e) and g:GetCount()>0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c21520065.rfilter(c)
	return c:IsReleasableByEffect() and c:IsSetCard(0x495)
end
function c21520065.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520065.rfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,0,LOCATION_ONFIELD+LOCATION_HAND)
end
function c21520065.ddop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c21520065.rfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
	if g:GetCount()>0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RELEASE)
		if Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) 
			and Duel.SelectYesNo(tp,aux.Stringid(21520065,3)) then 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local thg=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			Duel.SendtoHand(thg,nil,REASON_EFFECT)
		end
	end
end
