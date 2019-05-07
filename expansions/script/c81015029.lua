--迎春贺正·北上丽花
require("expansions/script/c81000000")
function c81015029.initial_effect(c)
	c:SetUniqueOnField(1,0,81015029)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c81015029.spcon)
	c:RegisterEffect(e1)
	--disable field
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_DISABLE_FIELD)
	e2:SetProperty(EFFECT_FLAG_REPEAT)
	e2:SetOperation(c81015029.disop)
	c:RegisterEffect(e2)
	--token
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,81015029)
	e3:SetTarget(c81015029.sptg)
	e3:SetOperation(c81015029.spop)
	c:RegisterEffect(e3)
end
function c81015029.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x81a)
end
function c81015029.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Tenka.ReikaCon(e) then return false end
	return Duel.IsExistingMatchingCard(c81015029.spfilter,tp,LOCATION_MZONE,0,2,nil)
end
function c81015029.disop(e,tp)
	local c=e:GetHandler()
	return c:GetColumnZone(LOCATION_SZONE)
end
function c81015029.cfilter(c)
	return c:GetSequence()<5
end
function c81015029.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(c81015029.cfilter,tp,0,LOCATION_SZONE,nil)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,81015999,0x81a,0x4011,0,0,6,RACE_FAIRY,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c81015029.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=Duel.GetMatchingGroupCount(c81015029.cfilter,tp,0,LOCATION_SZONE,nil)
	if ft>ct then ft=ct end
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,81015999,0x81a,0x4011,0,0,6,RACE_FAIRY,ATTRIBUTE_EARTH) then return end
	local ctn=true
	while ft>0 and ctn do
		local token=Duel.CreateToken(tp,81015999)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		ft=ft-1
		if ft<=0 or not Duel.SelectYesNo(tp,aux.Stringid(81015029,1)) then ctn=false end
	end
	Duel.SpecialSummonComplete()
end
