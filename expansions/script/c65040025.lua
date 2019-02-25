--永恒的觉醒再临
function c65040025.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c65040025.tg)
	e1:SetOperation(c65040025.op)
	c:RegisterEffect(e1)
end
function c65040025.tgfil(c,e,tp)
	local lv=c:GetOriginalLevel()
	local code=c:GetOriginalCode()
	local loc=0
	if (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or (c:GetSequence()<5 and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1)) then loc=loc+LOCATION_DECK end
	if Duel.GetLocationCountFromEx(tp,tp,c)>0 then loc=loc+LOCATION_EXTRA end
	return loc~=0 and lv>0 and c:IsFaceup() and c:IsAbleToGrave() and Duel.IsExistingMatchingCard(c65040025.spfil,tp,loc,0,1,nil,e,tp,lv,code)
end
function c65040025.spfil(c,e,tp,lv,code)
	return c:IsCode(code) and c:GetLevel()>lv and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsType(TYPE_MONSTER)
end
function c65040025.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c65040025.tgfil(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c65040025.tgfil,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	local g=Duel.SelectTarget(tp,c65040025.tgfil,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c65040025.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c65040025.tgfil(tc,e,tp) and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
		local lv=tc:GetOriginalLevel()
		local code=tc:GetOriginalCode()
		local loc=0
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_DECK end
		if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
		local g=Duel.SelectMatchingCard(tp,c65040025.spfil,tp,loc,0,1,1,nil,e,tp,lv,code)
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end