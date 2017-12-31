--水歌 永奏的提亚丝
local m=12003010
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	c:EnableReviveLimit()
	
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(cm.spcost)
	e4:SetTarget(cm.sptg)
	e4:SetOperation(cm.spop)
	c:RegisterEffect(e4)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return e:GetHandler():GetFlagEffect(m)==0 and not e:GetHandler():IsStatus(STATUS_CHAINING)
	end)
	e4:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.CheckReleaseGroup(tp,cm.cfilter1,1,nil,tp) end
		local g1=Duel.SelectReleaseGroup(tp,cm.cfilter1,1,1,nil,tp)
		Duel.Release(g1,REASON_COST)
	end)
	e4:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		if not e:GetHandler():IsRelateToEffect(e) then return end
		local resct=Duel.GetCurrentPhase()<=PHASE_STANDBY and 2 or 1
		e:GetHandler():RegisterFlagEffect(m,0x1fe1000+RESET_PHASE+PHASE_STANDBY,0,resct)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetRange(LOCATION_GRAVE)
		e1:SetCountLimit(1)
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
			return Duel.GetTurnCount()~=e:GetLabel() and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		end)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			Duel.Hint(HINT_CARD,0,m)
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end)
		e1:SetReset(0x1fe1000+RESET_PHASE+PHASE_STANDBY,resct)
		e:GetHandler():RegisterEffect(e1)
	end)
	c:RegisterEffect(e4)
end
function cm.cfilter(c,g,tp)
	return c:IsRace(RACE_SEASERPENT) and c:IsAbleToGraveAsCost() and g:IsContains(c) and Duel.GetMZoneCount(tp,c,tp)>0
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e:GetHandler():GetLinkedGroup(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e:GetHandler():GetLinkedGroup(),tp)
	Duel.SendtoGrave(g,POS_FACEUP,REASON_COST)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0,0x4011,0,0,3,RACE_SEASERPENT,ATTRIBUTE_WATER) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0,0x4011,0,0,3,RACE_SEASERPENT,ATTRIBUTE_WATER) then
		local token=Duel.CreateToken(tp,m+1)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.cfilter1(c,tp)
	return c:IsRace(RACE_SEASERPENT)
end