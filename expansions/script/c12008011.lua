--双色的分歧
function c12008011.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,12008011+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c12008011.condition)
	e1:SetTarget(c12008011.target)
	e1:SetOperation(c12008011.activate)
	c:RegisterEffect(e1)  
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77693536,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,0x1e0)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,12008111)
	e2:SetCondition(c12008011.thcon)
	e2:SetTarget(c12008011.thtg)
	e2:SetOperation(c12008011.thop)
	c:RegisterEffect(e2)  
end
function c12008011.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c12008011.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xfbb) and c:IsAbleToHand()
end
function c12008011.thfilter2(c)
	return c:IsSetCard(0xfbc) and c:IsAbleToHand() and c:IsType(TYPE_SPELL)
end
function c12008011.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or Duel.SendtoHand(tc,nil,REASON_EFFECT)<=0 or not tc:IsLocation(LOCATION_HAND) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)	
	local g=Duel.SelectMatchingCard(tp,c12008011.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
	   Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c12008011.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c12008011.thfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c12008011.thfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(c12008011.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c12008011.thfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c12008011.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c12008011.filter1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c12008011.filter2,tp,LOCATION_DECK,0,1,c,e,tp,c) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c12008011.filter2(c,e,tp,rc)
	return ((c:IsSetCard(0x1fb3) and rc:IsSetCard(0xfbb)) or (rc:IsSetCard(0x1fb3) and c:IsSetCard(0xfbb))) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
end
function c12008011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12008011.filter1,tp,LOCATION_DECK,0,1,nil,e,tp) and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c12008011.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or not Duel.IsExistingMatchingCard(c12008011.filter1,tp,LOCATION_DECK,0,1,nil,e,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(12008011,0))
	local g1=Duel.SelectMatchingCard(tp,c12008011.filter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.SpecialSummonStep(g1:GetFirst(),0,tp,tp,false,false,POS_FACEUP)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(12008011,1))
	local g2=Duel.SelectMatchingCard(tp,c12008011.filter2,tp,LOCATION_DECK,0,1,1,g1,e,tp,g1:GetFirst())
	Duel.SpecialSummonStep(g2:GetFirst(),0,tp,1-tp,false,false,POS_FACEUP)
	Duel.SpecialSummonComplete()
	g1:Merge(g2) 
	for tc in aux.Next(g1) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end