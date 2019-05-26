local m=33330320
local cm=_G["c"..m]
cm.name="THE SOUL 魂之影像"
--配 置 信 息
cm.draw=1   --抽 卡 数

function cm.initial_effect(c)
	c:EnableReviveLimit()
	--Fusion
	aux.AddFusionProcMix(c,false,true,cm.mfilter1,cm.mfilter2)
	--Special Summon Rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cm.sprcon)
	e1:SetOperation(cm.sprop)
	e1:SetValue(SUMMON_TYPE_FUSION)
	c:RegisterEffect(e1)
	--To Deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.tdtg)
	e2:SetOperation(cm.tdop)
	c:RegisterEffect(e2)
	--Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(cm.spcon)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e4)
end
--Fusion
function cm.mfilter1(c)
	return c:IsRace(RACE_WARRIOR) and c:IsLevel(2) and c:IsType(TYPE_TUNER)
end
function cm.mfilter2(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT)
end
--Special Summon Rule
function cm.mfilter(c,fc)
	return (cm.mfilter1(c) or cm.mfilter2(c)) and c:IsFaceup()
		and c:IsCanBeFusionMaterial(fc) and c:IsAbleToGrave()
end
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	return c:CheckFusionMaterial(mg,nil,tp)
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local g=Duel.SelectFusionMaterial(tp,c,mg,nil,tp)
	Duel.HintSelection(g)
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_COST)
end
--To Deck
function cm.tdfilter(c)
	return c:IsRace(RACE_WARRIOR) and c:IsAbleToDeck()
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and cm.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	local tc=g:GetFirst()
	if tc:IsSetCard(0x2552) or tc.HopeSoul then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,cm.draw)
	end
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)~=0 then
		local g=Duel.GetOperatedGroup()
		if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
		if (tc:IsSetCard(0x2552) or tc.HopeSoul) and tc:IsLocation(LOCATION_DECK)
			and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
--Special Summon
function cm.spfilter(c,e,tp)
	return (c:IsSetCard(0x2552) or c.HopeSoul) and c:IsType(TYPE_MONSTER)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.thfilter(c)
	return c:GetSummonLocation()~=LOCATION_HAND
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
	end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()==0 then return end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	local sg=Duel.GetMatchingGroup(cm.thfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
end