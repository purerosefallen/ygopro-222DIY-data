--古记绒棉 温德
function c76121001.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(76121001,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_BECOME_TARGET)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c76121001.spcon)
	e1:SetCost(c76121001.spcost)
	e1:SetTarget(c76121001.sptg)
	e1:SetOperation(c76121001.spop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(76121001,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,76121001)
	e2:SetCondition(c76121001.thcon1)
	e2:SetTarget(c76121001.thtg)
	e2:SetOperation(c76121001.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c76121001.thcon2)
	c:RegisterEffect(e3)
	c76121001[c]=e2
end
function c76121001.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end
function c76121001.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function c76121001.spfilter(c,e,tp)
	return not c:IsCode(76121001) and c:IsSetCard(0xea1) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c76121001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c76121001.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c76121001.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c76121001.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)  
	end
end
function c76121001.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return re and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0xea1)
end
function c76121001.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c76121001.filter(c)
	return (c:IsSetCard(0xea1) or c:IsCode(87430998) or c:IsCode(87624166) or c:IsCode(69112325) or c:IsCode(37322745) or c:IsCode(60398723)) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(76121001) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function c76121001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c76121001.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c76121001.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c76121001.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectYesNo(tp,aux.Stringid(76121001,2))) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end