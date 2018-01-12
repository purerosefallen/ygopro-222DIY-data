--Rabbis的羁绊
local m=50000108
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.tfilter(c,code,e,tp)
	return c:IsSetCard(0x50d) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.filter(c,e,tp)
	return c:IsFaceup() and c:IsRace(RACE_BEAST)
		and Duel.IsExistingMatchingCard(cm.tfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode(),e,tp)
end
function cm.chkfilter(c,code)
	return c:IsFaceup() and c:IsRace(RACE_BEAST) and not c:IsCode(code)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.chkfilter(chkc,e:GetLabel()) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	e:SetLabel(g:GetFirst():GetCode())
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local code=tc:GetCode()
	if Duel.SendtoGrave(tc,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,cm.tfilter,tp,LOCATION_DECK,0,1,1,nil,code,e,tp)
	if sg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		sg:GetFirst():CompleteProcedure()
	end
end
