--瓶之骑士 兔
function c65010116.initial_effect(c)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(65010116)   
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x5da0),2,2) 
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65010116,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,65010116)
	e1:SetCondition(c65010116.thcon)
	e1:SetTarget(c65010116.thtg)
	e1:SetOperation(c65010116.thop)
	c:RegisterEffect(e1)
	--link
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,65010216)
	e2:SetCondition(c65010116.lkcon)
	e2:SetTarget(c65010116.lktg)
	e2:SetOperation(c65010116.lkop)
	c:RegisterEffect(e2)
end
function c65010116.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c65010116.thfilter(c)
	return c:IsSetCard(0x5da0) and c:IsAbleToHand()
end
function c65010116.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65010116.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65010116.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65010116.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c65010116.lkcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.GetTurnPlayer()~=tp
end
function c65010116.matfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5da0)
end
function c65010116.lkfilter(c)
	return c:IsSetCard(0x5da0) and c:IsType(TYPE_LINK) and c:IsSpecialSummonable(SUMMON_TYPE_LINK)
end
function c65010116.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local linktbl={}
		local mg=Duel.GetMatchingGroup(c65010116.matfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
		local g=Duel.GetMatchingGroup(nil,tp,0xff,0xff,mg)
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
			e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			tc:RegisterEffect(e1,true)
			table.insert(linktbl,e1)
		end
		local res=Duel.IsExistingMatchingCard(c65010116.lkfilter,tp,LOCATION_EXTRA,0,1,nil)
		for _,e in ipairs(linktbl) do
			e:Reset()
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c65010116.lkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local linktbl={}
	local mg=Duel.GetMatchingGroup(c65010116.matfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
	local g=Duel.GetMatchingGroup(nil,tp,0xff,0xff,mg)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
		e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		tc:RegisterEffect(e1,true)
		table.insert(linktbl,e1)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c65010116.lkfilter,tp,LOCATION_EXTRA,0,1,1,nil):GetFirst()
	if sc then
		Duel.SpecialSummonRule(tp,sc,SUMMON_TYPE_LINK)
	end
	for _,e in ipairs(linktbl) do
		e:Reset()
	end
end