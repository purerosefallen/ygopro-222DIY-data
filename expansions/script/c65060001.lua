--甜美色 万华镜
function c65060001.initial_effect(c)
	--kaleidoscope
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetTarget(c65060001.sptg)
	e1:SetOperation(c65060001.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--itself
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e3:SetCost(c65060001.spkcost)
	e3:SetTarget(c65060001.spktg)
	e3:SetOperation(c65060001.spkop)
	c:RegisterEffect(e3)
end

function c65060001.spkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return c:IsAbleToGraveAsCost() and (ft>-1 or (ft>0 and c:IsLocation(LOCATION_HAND))) end
	Duel.SendtoGrave(c,REASON_COST)
end

function c65060001.spkfil(c,e,tp)
   return c:IsSetCard(0x6da3) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end

function c65060001.spktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c65060001.spkfil,tp,LOCATION_HAND,0,1,c,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end

function c65060001.spkop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local g=Duel.SelectMatchingCard(tp,c65060001.spkfil,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c65060001.spfil(c,e,tp)
   return c:IsCode(65060001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end

function c65060001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65060001.spfil,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end

function c65060001.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local mt=Duel.GetMatchingGroupCount(c65060001.spfil,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	if mt>ft then mt=ft end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then mt=1 end
	local g=Duel.SelectMatchingCard(tp,c65060001.spfil,tp,LOCATION_HAND+LOCATION_DECK,0,mt,mt,nil,e,tp)
	if mt>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c65060001.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function c65060001.splimit(e,c)
	return not c:IsSetCard(0x6da3)
end