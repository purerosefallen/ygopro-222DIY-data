--休憩片刻\
Duel.LoadScript("c22280001.lua")
function c22281001.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22281001+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c22281001.cost)
	e1:SetTarget(c22281001.target)
	e1:SetOperation(c22281001.activate)
	c:RegisterEffect(e1)
end
function c22281001.costfilter(c)
	return scorp.check_set_Zero(c) and c:IsFaceup() and c:IsAbleToHandAsCost()
end
function c22281001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22281001.costfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c22281001.costfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_COST)
	end 
end
function c22281001.thfilter(c)
	return c:IsCode(22280004) and c:IsAbleToHand()
end
function c22281001.tokenfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL)
end
function c22281001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22281001.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22281001.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22281001.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.GetMatchingGroupCount(c22281001.tokenfilter,tp,LOCATION_MZONE,0,nil)<1 and Duel.IsPlayerCanSpecialSummonMonster(tp,22280999,0,0x4011,1000,500,2,RACE_ROCK,ATTRIBUTE_EARTH) and Duel.GetMZoneCount(tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(22281001,0)) then
			local token=Duel.CreateToken(tp,22280999)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end