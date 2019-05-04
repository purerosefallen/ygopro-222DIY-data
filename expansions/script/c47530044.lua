--卡贝拉·迪特拉改
function c47530044.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,47530044+EFFECT_COUNT_CODE_OATH)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(c47530044.condition)
	e1:SetTarget(c47530044.thtg)
	e1:SetOperation(c47530044.thop)
	c:RegisterEffect(e1) 
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(47530044,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,47530045+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c47530044.spcon)
	e2:SetTarget(c47530044.sptg)
	e2:SetOperation(c47530044.spop)
	c:RegisterEffect(e2) 
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c47530044.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=eg:GetFirst()
	return eg:GetCount()==1 and c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_LINK) and c:GetSummonLocation()==LOCATION_EXTRA
end
function c47530044.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c47530044.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
		local nseq=math.log(s,2)
		Duel.MoveSequence(tc,nseq)
	end
end
function c47530044.cfilter2(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsLevel(10)
end
function c47530044.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c47530044.cfilter2,1,nil,tp)
end
function c47530044.filter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAbleToHand() and c:IsLevelAbove(4)
end
function c47530044.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and Duel.IsExistingTarget(c47530044.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,1,1,0,0)
end
function c47530044.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c47530044.filter,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end		
	end
end