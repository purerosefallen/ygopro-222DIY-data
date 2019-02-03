--雾落视界
function c65030049.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,65030049)
	e2:SetTarget(c65030049.thtg)
	e2:SetOperation(c65030049.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--recover
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_RECOVER)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTarget(c65030049.rectg)
	e5:SetOperation(c65030049.recop)
	c:RegisterEffect(e5)
end

function c65030049.thckfil(c,tp)
	return c:IsSetCard(0x5da2) and c:GetSummonPlayer()==tp
end

function c65030049.thfil(c)
	return c:IsSetCard(0x5da2) and c:IsAbleToHand()
end
function c65030049.thfil2(c)
	return c:IsSetCard(0x5da2) and c:IsAbleToHand()
end

function c65030049.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c65030049.thckfil,1,nil,tp) and Duel.IsExistingMatchingCard(c65030049.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0)
end

function c65030049.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c65030049.thfil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c65030049.recfil(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_FIEND)
end

function c65030049.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	local ct=g:FilterCount(c65030049.recfil,nil)
	local rec=ct*500
	local tp=Duel.GetTurnPlayer()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(rec)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
	Duel.SetChainLimit(c65030049.chlimit)
end
function c65030049.chlimit(e,ep,tp)
	return ep~=tp
end
function c65030049.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end