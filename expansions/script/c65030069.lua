--终景见证·起
function c65030069.initial_effect(c)
	--act
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65030069+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c65030069.tg)
	e1:SetOperation(c65030069.op)
	c:RegisterEffect(e1)
end
function c65030069.thfil(c)
	return c:IsSetCard(0x6da2) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c65030069.spfil(c,e,tp,code)
	return c:IsSetCard(0x6da2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(code)
end
function c65030069.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65030069.thfil,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65030069.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c65030069.thfil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,tp,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		local code=g:GetFirst():GetCode()
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c65030069.spfil,tp,LOCATION_HAND,0,1,nil,e,tp,code) and Duel.SelectYesNo(tp,aux.Stringid(65030069,0)) then
			local sg=Duel.SelectMatchingCard(tp,c65030069.spfil,tp,LOCATION_HAND,0,1,1,nil,e,tp,code)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end