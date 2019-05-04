--永恒的重生再诞
function c65040031.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c65040031.tg)
	e1:SetOperation(c65040031.op)
	c:RegisterEffect(e1)
end
function c65040031.tgfil(c,e,tp)
	local code=c:GetOriginalCode()
	local rk=c:GetOriginalRank()
	return c:IsFaceup() and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) and c:IsType(TYPE_XYZ) and Duel.GetLocationCountFromEx(tp,tp,c)>0 and Duel.IsExistingMatchingCard(c65040031.xyzfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,code,rk,c) and not c:IsImmuneToEffect(e)
end
function c65040031.xyzfil(c,e,tp,code,rk,matc)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,false) and c:GetRank()>rk and c:IsCode(code) and matc:IsCanBeXyzMaterial(c)
end
function c65040031.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c65040031.tgfil(chkc,e,tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c65040031.tgfil,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	local g=Duel.SelectTarget(tp,c65040031.tgfil,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c65040031.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c65040031.tgfil(tc,e,tp) then
		local code=tc:GetCode()
		local rk=tc:GetRank()
		local g=Duel.SelectMatchingCard(tp,c65040031.xyzfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,code,rk,tc)
		local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,true,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
	end
end