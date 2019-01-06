--樱迷宫的巨爪 Passionlip
function c18713103.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(92418590,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,18713103)
	e1:SetTarget(c18713103.target)
	e1:SetOperation(c18713103.operation)
	c:RegisterEffect(e1)
	--destroy and set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,187131030)
	e2:SetTarget(c18713103.settg)
	e2:SetOperation(c18713103.setop)
	c:RegisterEffect(e2)
end
function c18713103.filter(c)
	return c:IsSetCard(0xab6) and c:IsAbleToHand() and c:IsFaceup()
end
function c18713103.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToHand() end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	if chk==0 then return Duel.IsExistingTarget(c18713103.filter,tp,LOCATION_ONFIELD,LOCATION_MZONE,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c18713103.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	else
	if chk==0 then return Duel.IsExistingTarget(c18713103.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	local g=Duel.SelectTarget(tp,c18713103.filter,tp,LOCATION_MZONE,0,1,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c18713103.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c18713103.setfilter(c)
	return c:IsSetCard(0xab6) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c18713103.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c18713103.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c18713103.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c18713103.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end