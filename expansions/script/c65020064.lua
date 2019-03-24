--辉忆的残片
function c65020064.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65020064)
	e1:SetTarget(c65020064.target)
	e1:SetOperation(c65020064.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,65020064)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c65020064.thtg)
	e2:SetOperation(c65020064.thop)
	c:RegisterEffect(e2)
end
c65020064.fit_monster={65020054,65020055,65020056,65020057}
function c65020064.thfil1(c)
	return c:IsCode(65020054) and c:IsAbleToHand()
end
function c65020064.thfil2(c)
	return c:IsCode(65020055) and c:IsAbleToHand()
end
function c65020064.thfil3(c)
	return c:IsCode(65020056) and c:IsAbleToHand()
end
function c65020064.thfil4(c)
	return c:IsCode(65020057) and c:IsAbleToHand()
end
function c65020064.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65020064.thfil1,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c65020064.thfil2,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c65020064.thfil3,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c65020064.thfil4,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65020064.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c65020064.thfil1,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c65020064.thfil2,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c65020064.thfil3,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c65020064.thfil4,tp,LOCATION_DECK,0,1,nil) then
		local g1=Duel.GetFirstMatchingCard(c65020064.thfil1,tp,LOCATION_DECK,0,nil)
		local g2=Duel.GetFirstMatchingCard(c65020064.thfil2,tp,LOCATION_DECK,0,nil)
		local g3=Duel.GetFirstMatchingCard(c65020064.thfil3,tp,LOCATION_DECK,0,nil)
		local g4=Duel.GetFirstMatchingCard(c65020064.thfil4,tp,LOCATION_DECK,0,nil)
		local g=Group.CreateGroup()
		g:AddCard(g1)
		g:AddCard(g2)
		g:AddCard(g3)
		g:AddCard(g4)
		Duel.ConfirmCards(1-tp,g)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local tg=g:Select(1-tp,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end

function c65020064.spfilter(c,e,tp,mc)
	return c:IsSetCard(0x5da3) and c:IsLevelBelow(4) and bit.band(c:GetType(),0x81)==0x81 and (not c.mat_filter or c.mat_filter(mc))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
		and mc:IsCanBeRitualMaterial(c)
end
function c65020064.rfilter(c,mc)
	local mlv=mc:GetRitualLevel(c)
	if mlv==mc:GetLevel() then return false end
	local lv=c:GetLevel()
	return lv==bit.band(mlv,0xffff) or lv==bit.rshift(mlv,16)
end
function c65020064.filter(c,e,tp)
	local sg=Duel.GetMatchingGroup(c65020064.spfilter,tp,LOCATION_DECK,0,c,e,tp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if c:IsLocation(LOCATION_MZONE) then ft=ft+1 end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	return sg:IsExists(c65020064.rfilter,1,nil,c) or sg:CheckWithSumEqual(Card.GetLevel,c:GetLevel(),1,ft)
end
function c65020064.mfilter(c)
	return c:GetLevel()>0 and c:IsAbleToGrave()
end
function c65020064.mzfilter(c,tp)
	return c:IsControler(tp) and c:IsLevelAbove(8)
end
function c65020064.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<0 then return false end
		local mg=Duel.GetRitualMaterial(tp):Filter(c65020064.mzfilter,nil,tp)
		return mg:IsExists(c65020064.filter,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c65020064.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<0 then return end
	local mg=Duel.GetRitualMaterial(tp):Filter(c65020064.mzfilter,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local mat=mg:FilterSelect(tp,c65020064.filter,1,1,nil,e,tp)
	local mc=mat:GetFirst()
	if not mc then return end
	local sg=Duel.GetMatchingGroup(c65020064.spfilter,tp,LOCATION_DECK,0,mc,e,tp,mc)
	if mc:IsLocation(LOCATION_MZONE) then ft=ft+1 end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local b1=sg:IsExists(c65020064.rfilter,1,nil,mc)
	local b2=sg:CheckWithSumEqual(Card.GetLevel,mc:GetLevel(),1,ft)
	if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(65020064,0))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:FilterSelect(tp,c65020064.rfilter,1,1,nil,mc)
		local tc=tg:GetFirst()
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:SelectWithSumEqual(tp,Card.GetLevel,mc:GetLevel(),1,ft)
		local tc=tg:GetFirst()
		while tc do
			tc:SetMaterial(mat)
			tc=tg:GetNext()
		end
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		tc=tg:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			tc:CompleteProcedure()
			tc=tg:GetNext()
		end
		Duel.SpecialSummonComplete()
	end
end