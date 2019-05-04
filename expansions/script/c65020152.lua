--一页曲形-邪律指引-
function c65020152.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65020152)
	e1:SetTarget(c65020152.target)
	e1:SetOperation(c65020152.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCountLimit(1,65020152)
	e2:SetCondition(c65020152.spcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c65020152.sptg)
	e2:SetOperation(c65020152.spop)
	c:RegisterEffect(e2)
end
function c65020152.filter(c,e,tp)
	return c:IsSetCard(0x3da7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function c65020152.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(c65020152.filter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(c65020152.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK+LOCATION_HAND)
end
function c65020152.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c65020152.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local g2=Duel.SelectMatchingCard(tp,c65020152.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		g1:Merge(g2)
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		Duel.ConfirmCards(1-tp,g1)
	end
end
function c65020152.spconfil(c,tp)
	return c:IsPreviousPosition(POS_FACEUP)
		and c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp and c:IsSetCard(0x3da7) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c65020152.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65020152.spconfil,1,nil,tp)
end
function c65020152.filter1(c,e,tp)
	return c:IsSetCard(0x3da7) and c:IsType(TYPE_MONSTER) and ((c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 and not Duel.IsPlayerAffectedByEffect(tp,59822133)) or c:IsAbleToHand())
end
function c65020152.filter2(c,g)
	return g:IsExists(c65020152.filter3,1,c,c:GetCode())
end
function c65020152.filter3(c,code)
	return not c:IsCode(code)
end
function c65020152.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c65020152.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
		return g:IsExists(c65020152.filter2,1,nil,g)
	end
end
function c65020152.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c65020152.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	local dg=g:Filter(c65020152.filter2,nil,g)
	if dg:GetCount()>=1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=dg:Select(tp,1,1,nil)
		local tc1=sg:GetFirst()
		dg:Remove(Card.IsCode,nil,tc1:GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc2=dg:Select(tp,1,1,nil):GetFirst()
		local g=Group.FromCards(tc1,tc2)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.SelectYesNo(tp,aux.Stringid(65020152,0)) then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,g)
		else
			Duel.SendtoHand(g,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
