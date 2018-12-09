--玲珑法师-鸢尾
function c21520066.initial_effect(c)
	--special summon from grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520066,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,21520066+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c21520066.spcost)
	e1:SetTarget(c21520066.sptg)
	e1:SetOperation(c21520066.spop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21520066,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_RELEASE)
	e2:SetCountLimit(1,21520066+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c21520066.thtg)
	e2:SetOperation(c21520066.thop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e3:SetCountLimit(1)
	e3:SetCost(c21520066.rcost)
	e3:SetTarget(c21520066.rtg)
	e3:SetOperation(c21520066.rop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(21520066,ACTIVITY_SPSUMMON,c21520066.counterfilter)
end
function c21520066.counterfilter(c)
	if c:GetSummonLocation()==LOCATION_EXTRA then
		return c:IsRace(RACE_SPELLCASTER)
	else
		return c:IsSetCard(0x495)
	end
end
function c21520066.spfilter(c,e,tp,lv)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) and c:GetLevel()+lv==6 and c:IsSetCard(0x3495)
end
function c21520066.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	if c:IsLocation(LOCATION_EXTRA) then
		return not c:IsRace(RACE_SPELLCASTER)
	else
		return not c:IsSetCard(0x495)
	end
end
function c21520066.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(21520066,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c21520066.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c21520066.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520066.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,e:GetHandler():GetLevel()) 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c21520066.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c21520066.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp,c:GetLevel())
	if c:IsRelateToEffect(e) and g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
function c21520066.thfilter(c,code)
	return c:IsAbleToHand() and c:IsSetCard(0x495) and c:GetCode()~=code
end
function c21520066.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520066.thfilter,tp,LOCATION_DECK,0,1,nil,e:GetHandler():GetCode()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
end
function c21520066.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c21520066.thfilter,tp,LOCATION_DECK,0,nil,c:GetCode())
	if c:IsRelateToEffect(e) and g:GetCount()>0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c21520066.rfilter(c)
	return c:IsSetCard(0x495) and not c:IsPublic()
end
function c21520066.rcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520066.rfilter,tp,LOCATION_HAND,0,1,nil) and e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c21520066.rfilter,tp,LOCATION_HAND,0,1,99,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
--		tc:RegisterFlagEffect(2295831,RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,66)
		tc=g:GetNext()
	end
	e:SetLabel(g:GetCount())
end
function c21520066.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) and Duel.IsPlayerCanDraw(1-tp))
		or (Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_DECK,1,nil)) end
end
function c21520066.rop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	local op=2
	if (Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) and Duel.IsPlayerCanDraw(1-tp)) and 
		(Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,1-tp,LOCATION_DECK,0,1,nil)) then
		op=Duel.SelectOption(tp,aux.Stringid(21520066,2),aux.Stringid(21520066,3))
	elseif (Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) and Duel.IsPlayerCanDraw(1-tp)) then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(21520066,2))
		op=0
	elseif (Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,1-tp,LOCATION_DECK,0,1,nil)) then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(21520066,3))
		op=1
	end
	if op==0 then 
		local hg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
		if hg:GetCount()<ct then ct=hg:GetCount() end
		local sg=hg:RandomSelect(tp,ct)
		if Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)>0 then Duel.Draw(1-tp,ct,REASON_EFFECT) end
	elseif op==1 then
		local dg=Duel.GetMatchingGroup(Card.IsAbleToDeck,1-tp,LOCATION_GRAVE,0,nil)
		if dg:GetCount()<ct then ct=dg:GetCount() end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=dg:Select(tp,ct,ct,nil)
		Duel.ConfirmCards(1-tp,sg)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		local osg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_DECK,nil)
		Duel.ConfirmCards(tp,osg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=osg:Select(tp,ct,ct,nil)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
end
