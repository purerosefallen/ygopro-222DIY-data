--扎古·弗利帕
local m=47530002
local cm=_G["c"..m]
function c47530002.initial_effect(c)
	c:SetSPSummonOnce(47530002)
	--link summon
	aux.AddLinkProcedure(c,c47530002.lfilter,2,2)
	c:EnableReviveLimit()  
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(47530002,1))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c47530002.reccon)
	e1:SetTarget(c47530002.rectg)
	e1:SetOperation(c47530002.recop)
	c:RegisterEffect(e1)  
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(47530002,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,47530002)
	e2:SetTarget(c47530002.sptg)
	e2:SetOperation(c47530002.spop)
	c:RegisterEffect(e2)
end
function c47530002.lfilter(c)
	return c:IsLevel(10) and c:IsRace(RACE_MACHINE)
end
function c47530002.filter(c)
	return c:IsFaceup()
end
function c47530002.reccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c47530002.rectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c47530002.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c47530002.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c47530002.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetFirst():GetAttack())
end
function c47530002.penfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function c47530002.recop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT) and Duel.SelectYesNo(tp,aux.Stringid(47530002,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local g=Duel.SelectMatchingCard(tp,c47530002.penfilter,tp,LOCATION_EXTRA,0,1,1,nil)
			local tc=g:GetFirst()
			if tc then
				Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			end
		end
	end
end
function c47530002.lkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c47530002.spfilter(c,e,tp,zone)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c47530002.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local zone=aux.GetMultiLinkedZone(tp)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c47530002.spfilter(chkc,e,tp,zone) end
	if chk==0 then return zone~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c47530002.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c47530002.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp,zone)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c47530002.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=aux.GetMultiLinkedZone(tp)
	local tc=Duel.GetFirstTarget()
	if zone~=0 and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c47530002.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp) 
end
function c47530002.splimit(e,c)
	return not c:IsRace(RACE_MACHINE)
end