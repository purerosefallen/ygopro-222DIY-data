--玲珑法师-茉莉
function c21520062.initial_effect(c)
	--special summon from grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520062,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,21520062+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c21520062.spcost)
	e1:SetTarget(c21520062.sptg)
	e1:SetOperation(c21520062.spop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21520062,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_RELEASE)
	e2:SetCountLimit(1,21520062+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c21520062.thtg)
	e2:SetOperation(c21520062.thop)
	c:RegisterEffect(e2)
	--destroy and draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21520062,2))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW+CATEGORY_RELEASE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c21520062.ddtg)
	e3:SetOperation(c21520062.ddop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(21520062,ACTIVITY_SPSUMMON,c21520062.counterfilter)
end
function c21520062.counterfilter(c)
	if c:GetSummonLocation()==LOCATION_EXTRA then
		return c:IsRace(RACE_SPELLCASTER)
	else
		return c:IsSetCard(0x495)
	end
end
function c21520062.spfilter(c,e,tp,lv)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) and c:GetLevel()+lv==6 and c:IsSetCard(0x3495)
end
function c21520062.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	if c:IsLocation(LOCATION_EXTRA) then
		return not c:IsRace(RACE_SPELLCASTER)
	else
		return not c:IsSetCard(0x495)
	end
end
function c21520062.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(21520062,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c21520062.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c21520062.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520062.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,e:GetHandler():GetLevel()) 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c21520062.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c21520062.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp,c:GetLevel())
	if c:IsRelateToEffect(e) and g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
function c21520062.thfilter(c,code)
	return c:IsAbleToHand() and c:IsSetCard(0x495) and c:GetCode()~=code
end
function c21520062.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520062.thfilter,tp,LOCATION_DECK,0,1,nil,e:GetHandler():GetCode()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
end
function c21520062.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c21520062.thfilter,tp,LOCATION_DECK,0,nil,c:GetCode())
	if c:IsRelateToEffect(e) and g:GetCount()>0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c21520062.rfilter(c)
	return c:IsReleasable() and c:IsType(TYPE_MONSTER)
end
function c21520062.ddtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsDestructable() and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,0,1)
end
function c21520062.ddop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then 
		if Duel.Destroy(tc,REASON_EFFECT)>0 and Duel.IsPlayerCanDraw(tc:GetPreviousControler()) then 
			if Duel.Draw(tc:GetPreviousControler(),1,REASON_EFFECT) then 
				if Duel.IsExistingMatchingCard(c21520062.rfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(21520062,3)) then
					Duel.BreakEffect()
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
					local g=Duel.SelectMatchingCard(tp,c21520062.rfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil)
					Duel.Release(g,REASON_EFFECT)
				end
			end
		end
	end
end
