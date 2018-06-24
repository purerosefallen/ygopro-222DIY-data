--超越空间的恋香 丘依儿
function c12005003.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12005003,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCountLimit(1,12005003)
	e1:SetCondition(c12005003.spcon)
	e1:SetTarget(c12005003.sptg)
	e1:SetOperation(c12005003.spop)
	c:RegisterEffect(e1)
	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12005003,1))
	e3:SetCategory(CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCost(c12005003.cost)
	e3:SetCondition(c12005003.thcon)
	e3:SetTarget(c12005003.thtg)
	e3:SetOperation(c12005003.thop)
	c:RegisterEffect(e3)
end
function c12005003.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_DRAW)
end
function c12005003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c12005003.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c12005003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHandAsCost() end
	Duel.SendtoHand(c,nil,REASON_COST)
end
function c12005003.thcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c12005003.filter(c)
	return c:IsCode(12008006) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c12005003.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c12005003.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c12005003.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c12005003.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
		local e4_4=tc:GetActivateEffect()
			e4_4:SetProperty(0,EFFECT_FLAG2_COF)
			e4_4:SetHintTiming(0,0x1e0+TIMING_CHAIN_END)
			e4_4:SetCondition(c12005003.con4_4)
			tc:RegisterFlagEffect(12005003,RESET_EVENT+0x1fe0000,0,1)
			local e4_5=Effect.CreateEffect(c)
			e4_5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e4_5:SetCode(EVENT_ADJUST)
			e4_5:SetOperation(c12005003.op4_5)
			e4_5:SetLabelObject(tc)
			Duel.RegisterEffect(e4_5,tp)
	end
end
function c12005003.con4_4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function c12005003.op4_5(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(12005003)~=0 then return end
	local e4_5_1=tc:GetActivateEffect()
	e4_5_1:SetProperty(nil)
	e4_5_1:SetHintTiming(0)
	e4_5_1:SetCondition(aux.TRUE)
	e:Reset()   
end
