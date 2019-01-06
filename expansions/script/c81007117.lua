--HappySky·宫尾美也
function c81007117.initial_effect(c)
	--level
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetValue(c81007117.lvval)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetCondition(c81007117.indcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,81007117)
	e4:SetCost(c81007117.spcost2)
	e4:SetTarget(c81007117.sptg2)
	e4:SetOperation(c81007117.spop2)
	c:RegisterEffect(e4)
end
function c81007117.lvval(e,c)
	local tp=c:GetControler()
	return Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,0,nil,TYPE_TOKEN):GetSum(Card.GetLevel)
end
function c81007117.indcon(e)
	return Duel.IsExistingMatchingCard(Card.IsType,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,TYPE_TOKEN)
end
function c81007117.cfilter(c,ft,tp)
	return c:IsType(TYPE_TOKEN)
		and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5))
end
function c81007117.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-2 and Duel.CheckReleaseGroup(tp,c81007117.cfilter,2,nil,ft,tp) end
	local g=Duel.SelectReleaseGroup(tp,c81007117.cfilter,2,2,nil,ft,tp)
	Duel.Release(g,REASON_COST)
end
function c81007117.filter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsLevelBelow(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c81007117.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c81007117.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c81007117.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c81007117.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c81007117.spop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
