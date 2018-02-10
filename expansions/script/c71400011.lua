--梦之书的管理员
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400011.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,yume.YumeCheck(c),4,2)
	c:EnableReviveLimit()
	--summon limit
	yume.AddYumeSummonLimit(c,1)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71400011,0))
	e1:SetCountLimit(1,71400011)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c71400011.cost)
	e1:SetTarget(c71400011.target1)
	e1:SetOperation(c71400011.operation1)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	c:RegisterEffect(e1)
	--fly away
	--currently null
end
function c71400011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c71400011.filter(c)
	return c:IsSetCard(0x714)
end
function c71400011.xyzfilter(c,e,tp)
	return c:IsSetCard(0x3715) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71400011.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingTarget(c71400011.filter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(c71400011.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g1=Duel.SelectTarget(tp,c71400011.filter,tp,LOCATION_GRAVE,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g1,g1:GetCount(),tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c71400011.operation1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	local g=Duel.GetMatchingGroup(c71400011.xyzfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if g:GetCount()==0 then return end
	local mg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if mg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	local sc=sg:GetFirst()
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		Duel.Overlay(sc,mg)
	end
end