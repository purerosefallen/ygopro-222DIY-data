--宝物-胜bbbb
function c10140018.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)   
	--SpecialSummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10140018,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetLabel(0x3333)
	e4:SetCountLimit(1,10140018)
	e4:SetTarget(c10140018.sptg)
	e4:SetOperation(c10140018.spop)
	c:RegisterEffect(e4)
	--SpecialSummon 2
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10140018,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetLabel(0x5333)
	e5:SetTarget(c10140018.sptg)
	e5:SetOperation(c10140018.spop)
	c:RegisterEffect(e5)
end
function c10140018.spfilter(c,e,tp,tid)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (c:GetTurnID()==tid or e:GetLabel()==0x5333) and c:IsSetCard(e:GetLabel())
end
function c10140018.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c10140018.spfilter(chkc,e,tp,Duel.GetTurnCount()) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c10140018.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,Duel.GetTurnCount()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c10140018.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,Duel.GetTurnCount())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
end
function c10140018.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and e:GetLabel()==0x3333 then
	   local e1=Effect.CreateEffect(c)
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetCode(EFFECT_DISABLE)
	   e1:SetReset(RESET_EVENT+0x1fe0000)
	   tc:RegisterEffect(e1)
	   local e2=Effect.CreateEffect(c)
	   e2:SetType(EFFECT_TYPE_SINGLE)
	   e2:SetCode(EFFECT_DISABLE_EFFECT)
	   e2:SetReset(RESET_EVENT+0x1fe0000)
	   tc:RegisterEffect(e2)
	end
end
function c10140018.accost(e,c,tp)
	return c:IsLocation(LOCATION_HAND) and Duel.IsExistingMatchingCard(c10140018.cfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c10140018.cfilter(c)
	return (c:IsSetCard(0x3333) or c:IsSetCard(0x5333)) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c10140018.acop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10140018.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
	   Duel.Remove(g,POS_FACEUP,0)
	end
end