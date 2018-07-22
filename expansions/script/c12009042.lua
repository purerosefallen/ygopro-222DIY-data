--天鹅绒之音 蕾恩缇娅
function c12009042.initial_effect(c)
	--deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12009042,0))
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c12009042.target)
	e1:SetCountLimit(1,12009042)
	e1:SetOperation(c12009042.operation)
	c:RegisterEffect(e1)	
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2) 
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12009042,1))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,12009042)
	e3:SetTarget(c12009042.thtg)
	e3:SetOperation(c12009042.thop)
	c:RegisterEffect(e3)
end
function c12009042.tdfilter(c)
	return c:IsAttackBelow(500) and c:IsAbleToDeck()
end
function c12009042.thfilter(c)
	return c:IsAttackBelow(500) and c:IsAbleToHand()
end
function c12009042.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return ((c12009042.tdfilter(chkc) and c:IsAbleToHand()) or (c12009042.thfilter(chkc) and c:IsAbleToDeck())) and chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and chkc~=c end
	if chk==0 then	  
		local sel=0
		if Duel.IsExistingTarget(c12009042.tdfilter,tp,LOCATION_GRAVE,0,1,c) and c:IsAbleToHand() then sel=sel+1 end
		if Duel.IsExistingTarget(c12009042.thfilter,tp,LOCATION_GRAVE,0,1,c) and c:IsAbleToDeck() then sel=sel+2 end
		e:SetLabel(sel)
		return sel~=0
	end
	local sel=e:GetLabel()
	if sel==3 then
		sel=Duel.SelectOption(tp,aux.Stringid(12009042,3),aux.Stringid(12009042,4))+1
	elseif sel==1 then
		Duel.SelectOption(tp,aux.Stringid(12009042,3))
	else
		Duel.SelectOption(tp,aux.Stringid(12009042,4))
	end
	e:SetLabel(sel)
	if sel==1 then
		local g=Duel.SelectTarget(tp,c12009042.tdfilter,tp,LOCATION_GRAVE,0,1,1,c)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
	else
		local g=Duel.SelectTarget(tp,c12009042.thfilter,tp,LOCATION_GRAVE,0,1,1,c)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
	end
end
function c12009042.thop(e,tp,eg,ep,ev,re,r,rp)
	local c,tc=e:GetHandler(),Duel.GetFirstTarget()
	local sel=e:GetLabel()
	if sel==1 then
	   if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 and tc:IsRelateToEffect(e) then
		  Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	   end
	else
	   if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then
		  Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	   end
	end
end
function c12009042.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroup(tp,LOCATION_DECK,0):GetCount()>0 end
end
function c12009042.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,1)
	local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
	if not tc or not tc:IsAttackBelow(500) then return end
	local b1=tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local b2=Duel.IsPlayerCanDiscardDeck(tp,1) and Duel.IsPlayerCanDraw(tp,1) and Duel.GetDecktopGroup(tp,2):GetCount()==2
	if not b1 and not b2 then
	   Duel.SendtoGrave(tc,REASON_RULE)
	return 
	end
	if b1 and (not b2 or not Duel.SelectYesNo(tp,aux.Stringid(12009042,1))) then
	   Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	else
	   Duel.SendtoGrave(tc,REASON_EFFECT+REASON_REVEAL)
	   Duel.Draw(tp,1,REASON_EFFECT)
	end
end