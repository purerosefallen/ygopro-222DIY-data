--觉醒后的坚强 丘依儿
function c12005002.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12005002,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c12005002.spcon)
	e1:SetTarget(c12005002.sptg)
	e1:SetOperation(c12005002.spop)
	c:RegisterEffect(e1)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetDescription(aux.Stringid(12005002,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,12005002)
	e1:SetCost(c12005002.rthcost)
	e1:SetTarget(c12005002.rthtg)
	e1:SetOperation(c12005002.rthop)
	c:RegisterEffect(e1)
end
function c12005002.rthcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xfbb) and c:IsAbleToHandAsCost()
end
function c12005002.rthcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c12005002.rthcfilter,tp,LOCATION_ONFIELD,0,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c12005002.rthcfilter,tp,LOCATION_ONFIELD,0,1,1)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function c12005002.rthtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c12005002.rthop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c12005002.cfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0xfbb)
end
function c12005002.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c12005002.cfilter1,1,nil)
end
function c12005002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c12005002.filter1(c,e,tp)
	return c:IsSetCard(0xfbb) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12005002.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	Duel.BreakEffect()
	if Duel.IsExistingMatchingCard(c12005002.filter1,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	   if Duel.SelectYesNo(tp,aux.Stringid(12005002,2)) then
		   local g=Duel.SelectMatchingCard(tp,c12005002.filter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
			   if g:GetCount()>0 then
					  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			   end
	   end
	end
end
