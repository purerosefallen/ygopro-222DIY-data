--玲珑法师-牡丹
function c21520064.initial_effect(c)
	--special summon from grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520064,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,21520064+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c21520064.spcost)
	e1:SetTarget(c21520064.sptg)
	e1:SetOperation(c21520064.spop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21520064,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_RELEASE)
	e2:SetCountLimit(1,21520064+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c21520064.thtg)
	e2:SetOperation(c21520064.thop)
	c:RegisterEffect(e2)
	--to deck and draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21520064,2))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_RELEASE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c21520064.drtg)
	e3:SetOperation(c21520064.drop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(21520064,ACTIVITY_SPSUMMON,c21520064.counterfilter)
end
function c21520064.counterfilter(c)
	if c:GetSummonLocation()==LOCATION_EXTRA then
		return c:IsRace(RACE_SPELLCASTER)
	else
		return c:IsSetCard(0x495)
	end
end
function c21520064.spfilter(c,e,tp,lv)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) and c:GetLevel()+lv==6 and c:IsSetCard(0x3495)
end
function c21520064.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	if c:IsLocation(LOCATION_EXTRA) then
		return not c:IsRace(RACE_SPELLCASTER)
	else
		return not c:IsSetCard(0x495)
	end
end
function c21520064.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(21520064,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c21520064.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c21520064.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520064.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,e:GetHandler():GetLevel()) 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c21520064.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c21520064.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp,c:GetLevel())
	if c:IsRelateToEffect(e) and g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
function c21520064.thfilter(c,code)
	return c:IsAbleToHand() and c:IsSetCard(0x495) and c:GetCode()~=code
end
function c21520064.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520064.thfilter,tp,LOCATION_DECK,0,1,nil,e:GetHandler():GetCode()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
end
function c21520064.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c21520064.thfilter,tp,LOCATION_DECK,0,nil,c:GetCode())
	if c:IsRelateToEffect(e) and g:GetCount()>0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c21520064.rfilter(c)
	return c:IsReleasable() and c:IsType(TYPE_MONSTER)
end
function c21520064.drfilter(c)
	return c:IsSetCard(0x495) and c:IsAbleToDeck()
end
function c21520064.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c21520064.drfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingTarget(c21520064.drfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c21520064.drfilter,tp,LOCATION_GRAVE,0,1,6,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c21520064.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if tg and tg:FilterCount(Card.IsRelateToEffect,nil,e)~=0 then
		Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
		local g=Duel.GetOperatedGroup()
		if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
		local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		if ct>0 then
			Duel.Draw(tp,1,REASON_EFFECT)
			if Duel.IsExistingMatchingCard(c21520064.rfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(21520064,3)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				local g=Duel.SelectMatchingCard(tp,c21520064.rfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
				Duel.Release(g,REASON_EFFECT)
			end
		end
	end
end
