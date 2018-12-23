--自由色 万华镜
function c65060006.initial_effect(c)
	--kaleidoscope
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetTarget(c65060006.sptg)
	e1:SetOperation(c65060006.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--linked
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,65060006)
	e3:SetCondition(c65060006.tgcon)
	e3:SetTarget(c65060006.tgtg)
	e3:SetOperation(c65060006.tgop)
	c:RegisterEffect(e3)
end

function c65060006.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_LINK 
end

function c65060006.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_ONFIELD)
end

function c65060006.tgspfil(c,e,tp)
	return c:IsSetCard(0x6da3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c65060006.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local code=tc:GetCode()
		local mp=tc:GetOwner()
		local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil,code)
		if g:GetCount()>0 then
			if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then 
				if sp==tp and Duel.IsExistingMatchingCard(c65060006.tgspfil,sp,LOCATION_HAND,0,1,nil,e,tp) and Duel.SelectYesNo(sp,aux.Stringid(65060006,0)) then
					Duel.BreakEffect()
					local sg=Duel.SelectMatchingCard(sp,c65060006.tgspfil,sp,LOCATION_HAND,0,1,1,nil,e,tp)
					Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
				elseif sp~=tp and Duel.IsExistingMatchingCard(Card.IsCanBeSpecialSummoned,sp,LOCATION_HAND,0,1,nil,e,0,sp,false,false) and Duel.SelectYesNo(sp,aux.Stringid(65060006,0)) then
					 Duel.BreakEffect()
					local sg=Duel.SelectMatchingCard(sp,Card.IsCanBeSpecialSummoned,sp,LOCATION_HAND,0,1,1,nil,e,0,sp,false,false)
					Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
	end
end

function c65060006.spfil(c,e,tp)
   return c:IsCode(65060006) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end

function c65060006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end

function c65060006.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local mt=Duel.GetMatchingGroupCount(c65060006.spfil,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	if mt>ft then mt=ft end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then mt=1 end
	local g=Duel.SelectMatchingCard(tp,c65060006.spfil,tp,LOCATION_HAND+LOCATION_DECK,0,mt,mt,nil,e,tp)
	if mt>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c65060006.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function c65060006.splimit(e,c)
	return not c:IsSetCard(0x6da3)
end

