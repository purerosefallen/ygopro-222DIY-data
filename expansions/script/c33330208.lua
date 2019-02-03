local m=33330208
local cm=_G["c"..m]
cm.name="境界交错 鸟居残阳"
-- 境界交错 鸟居残阳
cm.set=0x55a	--字 段
cm.IsMirrorCross=true   --内 置 字 段
function c33330208.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	--aux.AddLinkProcedure(c,c33330208.matfilter,1)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x55a),1,1)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33330208,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1)
	e1:SetCondition(c33330208.thcon)
	e1:SetTarget(c33330208.target)
	e1:SetOperation(c33330208.operation)
	c:RegisterEffect(e1)
	--banish
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(33330208,1))
	e11:SetCategory(CATEGORY_TODECK+CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e11:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e11:SetCode(EVENT_SPSUMMON_SUCCESS)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCondition(c33330208.rmcon)
	e11:SetTarget(c33330208.rmtg)
	e11:SetOperation(c33330208.rmop)
	c:RegisterEffect(e11)
end
function c33330208.matfilter(c)
	return c:GetLevel()==8 and (c:IsSetCard(cm.set) or c.IsMirrorCross)
end
function c33330208.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c33330208.filter(c,e,tp,zone)
	return c:GetLevel()==8 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c33330208.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local zone=e:GetHandler():GetLinkedZone(tp)
		return zone~=0 and Duel.IsExistingMatchingCard(c33330208.filter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,zone)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c33330208.operation(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(tp)
	if zone==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c33330208.filter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp,zone)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
--banish
function c33330208.cfilter(c,ec)
	if c:IsLocation(LOCATION_MZONE) then
		return ec:GetLinkedGroup():IsContains(c)
	else
		return bit.band(ec:GetLinkedZone(c:GetPreviousControler()),bit.lshift(0x1,c:GetPreviousSequence()))~=0
	end
end
function c33330208.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33330208.cfilter,1,nil,e:GetHandler())
end
function c33330208.sfilter(c,lg)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) 
end
function c33330208.spdfil(c,lg)
	return c:IsType(TYPE_MONSTER) and lg:IsContains(c) and c:IsSummonType(SUMMON_TYPE_SPECIAL) 
end
function c33330208.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	if chkc then return c33330208.spdfil(chkc,lg) and 
	chkc:IsLocation(LOCATION_MZONE) and c33330208.spdfil(chkc,lg) end
	if chk==0 then return Duel.IsExistingTarget(c33330208.spdfil,tp,LOCATION_MZONE,0,1,nil,lg) and Duel.IsExistingMatchingCard(c33330208.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,c33330208.spdfil,tp,LOCATION_MZONE,0,1,1,nil,lg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,1,0,0)
end
function c33330208.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if tc then
		local b1=tc:IsAbleToDeck()
		if b1 and Duel.SelectYesNo(tp,aux.Stringid(33330208,1)) then
			Duel.SendtoDeck(tc,nil,2,REASON_EFFECT) 
		else
			local opt=Duel.SelectOption(tp,aux.Stringid(33330208,2),aux.Stringid(33330208,3))
			if opt==0 then
				Duel.SendtoGrave(tc,REASON_EFFECT)
				else
				Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
				end 
			end
		end 
	end
end

