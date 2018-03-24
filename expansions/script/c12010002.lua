--LA Da'ath 基礎的珈百璃
function c12010002.initial_effect(c)
	--deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12010002,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,12010002)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(c12010002.target)
	e1:SetOperation(c12010002.operation)
	c:RegisterEffect(e1)
	--copylevel
	local e2=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12010002,2))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c12010002.tg)
	e2:SetOperation(c12010002.op)
	c:RegisterEffect(e2)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12010002,3))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,12010102)
	e2:SetCost(c12010002.spcost)
	e2:SetTarget(c12010002.sptg)
	e2:SetOperation(c12010002.spop)
	c:RegisterEffect(e2)
end
function c12010002.cfilter1(c,ft,tp)
	return c:IsSetCard(0xfbc)
end
function c12010002.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>0 and Duel.IsExistingMatchingCard(c12010002.cfilter1,tp,LOCATION_ONFIELD,0,1,nil) end
	local sg=Duel.SelectMatchingCard(tp,c12010002.cfilter1,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c12010002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c12010002.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c12010002.filter(c)
	return c:IsSetCard(0xfba) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c12010002.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGrave() and Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(c12010002.filter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function c12010002.cfilter(c)
	return c:IsDiscardable()
end
function c12010002.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c12010002.filter,tp,LOCATION_HAND,0,1,e:GetHandler()) then return false end
	local dis=false
	if Duel.IsPlayerCanDraw(1) and Duel.IsChainDisablable(0) then
		local g=Duel.GetMatchingGroup(c12010002.cfilter,tp,0,LOCATION_HAND,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(12010002,1)) then
			Duel.DiscardHand(1-tp,Card.IsDiscardable,1,1,REASON_EFFECT,nil)
			Duel.ShuffleHand(1-tp)
			dis=true
		end
	end
	if not dis then 
		local sg=Duel.SelectMatchingCard(tp,c12010002.filter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
		Duel.ConfirmCards(1-tp,sg)
		if Duel.IsPlayerCanDraw(tp,1) then
			Duel.BreakEffect()
			if Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT) then
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	end
end
function c12010002.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
end
function c12010002.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsType(TYPE_LINK) then
		local lv=0
		if tc:IsType(TYPE_XYZ) then
			lv=tc:GetRank()
		else
			lv=tc:GetLevel()
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e:GetHandler():RegisterEffect(e1)
	end
end

