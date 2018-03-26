--LA SG Wrath 憂拉斯
function c12010016.initial_effect(c)
	--tograve+copy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12010016,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,12010016)
	e2:SetTarget(c12010016.tgtg)
	e2:SetOperation(c12010016.tgop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--to grave
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_RECOVER+CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,1200116)
	e4:SetTarget(c12010016.target2)
	e4:SetOperation(c12010016.operation2)
	c:RegisterEffect(e4)
end
function c12010016.tgfilter(c)
	return (c:IsSetCard(0xfba) or c:IsSetCard(0x1fb3)) and c:IsReleasable() and c:IsType(TYPE_MONSTER)
end
function c12010016.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12010016.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c12010016.spfilter(c,e,tp,rec,att)
	return  (c:IsSetCard(0xfba) or c:IsSetCard(0x1fb3))  and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(12010016) and c:IsType(TYPE_MONSTER) and (c:IsRace(rec) or c:IsAttribute(att))
end
function c12010016.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsExistingMatchingCard(c12010016.tgfilter,tp,LOCATION_HAND,0,1,nil) then return false end
	local g=Duel.SelectMatchingCard(tp,c12010016.tgfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g then 
		local tc=g:GetFirst()
		if Duel.Release(tc,REASON_EFFECT) then
			if Duel.SelectYesNo(tp,aux.Stringid(12010016,1)) then
				local rec=tc:GetRace()
				local att=tc:GetAttribute()
				local sg=Duel.SelectMatchingCard(tp,c12010016.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp,rec,att)
				if sg then 
					Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
	end
end
function c12010016.filter1(c)
	return  (c:IsSetCard(0xfba) or c:IsSetCard(0x1fb3))  and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(12010016)
end
function c12010016.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c12010016.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12010016.filter1,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectTarget(tp,c12010016.filter1,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,1,0,0)
end
function c12010016.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg then 
		Duel.SendtoHand(sg,nil,2,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
