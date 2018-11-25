--寂寥色 万华镜
function c65060005.initial_effect(c)
	--kaleidoscope
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetTarget(c65060005.sptg)
	e1:SetOperation(c65060005.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--linked
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,65060005)
	e3:SetCondition(c65060005.tgcon)
	e3:SetTarget(c65060005.tgtg)
	e3:SetOperation(c65060005.tgop)
	c:RegisterEffect(e3)
end

function c65060005.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_LINK 
end

function c65060005.tgfil(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x6da3)
end

function c65060005.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and chkc:IsType(TYPE_MONSTER) and chkc:IsSetCard(0x6da3) end
	if chk==0 then return Duel.IsExistingTarget(c65060005.tgfil,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectTarget(tp,c65060005.tgfil,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,tp,LOCATION_GRAVE)
end

function c65060005.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local sp=tc:GetControler()
	if tc:IsRelateToEffect(e) then
		local code=tc:GetCode()
		local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,code)
		if g:GetCount()>0 then
			if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 and Duel.SelectYesNo(tp,aux.Stringid(65060005,0)) then
				Duel.BreakEffect()
				local sg=Duel.SelectMatchingCard(sp,Card.IsCanBeSpecialSummoned,sp,LOCATION_DECK,0,1,1,nil,e,0,sp,false,false)
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end

function c65060005.spfil(c,e,tp)
   return c:IsCode(65060005) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end

function c65060005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65060005.spfil,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end

function c65060005.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local mt=Duel.GetMatchingGroupCount(c65060005.spfil,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	if mt>ft then mt=ft end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then mt=1 end
	local g=Duel.SelectMatchingCard(tp,c65060005.spfil,tp,LOCATION_HAND+LOCATION_DECK,0,mt,mt,nil,e,tp)
	if mt>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c65060005.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function c65060005.splimit(e,c)
	return not c:IsSetCard(0x6da3)
end