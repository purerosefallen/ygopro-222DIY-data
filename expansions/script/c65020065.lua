--辉忆的具象
function c65020065.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65020065)
	e1:SetTarget(c65020065.target)
	e1:SetOperation(c65020065.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,65020065)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c65020065.thtg)
	e2:SetOperation(c65020065.thop)
	c:RegisterEffect(e2)
end
c65020065.fit_monster={65020058,65020059,65020060}
function c65020065.thfil1(c)
	return c:IsCode(65020058) and c:IsAbleToHand()
end
function c65020065.thfil2(c)
	return c:IsCode(65020059) and c:IsAbleToHand()
end
function c65020065.thfil3(c)
	return c:IsCode(65020060) and c:IsAbleToHand()
end
function c65020065.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65020065.thfil1,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c65020065.thfil2,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c65020065.thfil3,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65020065.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c65020065.thfil1,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c65020065.thfil2,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c65020065.thfil3,tp,LOCATION_DECK,0,1,nil) then
		local g1=Duel.GetFirstMatchingCard(c65020065.thfil1,tp,LOCATION_DECK,0,nil)
		local g2=Duel.GetFirstMatchingCard(c65020065.thfil2,tp,LOCATION_DECK,0,nil)
		local g3=Duel.GetFirstMatchingCard(c65020065.thfil3,tp,LOCATION_DECK,0,nil)
		local g=Group.CreateGroup()
		g:AddCard(g1)
		g:AddCard(g2)
		g:AddCard(g3)
		Duel.ConfirmCards(1-tp,g)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local tg=g:Select(1-tp,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end

function c65020065.filter(c,e,tp,m)
	if bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) or not (c:IsLevelAbove(8) and c:IsSetCard(0x5da3)) then return false end
	if c.mat_filter then
		m=m:Filter(c.mat_filter,nil)
	end
	return m:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
end
function c65020065.matfilter(c)
	return c:IsSetCard(0x5da3) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4) and c:IsAbleToGrave()
end
function c65020065.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		local mg=Duel.GetMatchingGroup(c65020065.matfilter,tp,LOCATION_DECK,0,nil)
		return Duel.IsExistingMatchingCard(c65020065.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c65020065.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local mg=Duel.GetMatchingGroup(c65020065.matfilter,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c65020065.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,nil)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
		tc:SetMaterial(mat)
		Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
