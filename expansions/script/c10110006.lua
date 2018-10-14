--元素火花 降生
function c10110006.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(10110006,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,10110006)
	e1:SetTarget(c10110006.target)
	e1:SetOperation(c10110006.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10110006,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,10110006)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c10110006.thtg)
	e2:SetOperation(c10110006.thop)
	c:RegisterEffect(e2)
end
function c10110006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,10110006,0,0x4011,0,0,1,RACE_ROCK,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c10110006.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft,c=Duel.GetLocationCount(tp,LOCATION_MZONE),e:GetHandler()
	if ft<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,10110006,0,0x4011,0,0,1,RACE_ROCK,ATTRIBUTE_DARK) then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	ft=math.min(ft,4)
	local op,ct={},1
	for i=1,ft do
		op[ct]=i
		ct=ct+1
	end
	local sct,token=Duel.AnnounceNumber(tp,table.unpack(op))
	for v=1,sct do
		token=Duel.CreateToken(tp,10110008)
		if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
		   local e1=Effect.CreateEffect(c)
		   e1:SetType(EFFECT_TYPE_SINGLE)
		   e1:SetCode(EFFECT_CHANGE_FUSION_ATTRIBUTE)
		   e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		   e1:SetRange(LOCATION_MZONE)
		   e1:SetValue(ATTRIBUTE_EARTH+ATTRIBUTE_FIRE+ATTRIBUTE_WATER+ATTRIBUTE_WIND)
		   e1:SetReset(RESET_EVENT+0x1fe0000)
		   token:RegisterEffect(e1,true)
		   local e2=Effect.CreateEffect(c)
		   e2:SetType(EFFECT_TYPE_FIELD)
		   e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		   e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		   e2:SetRange(LOCATION_MZONE)
		   e2:SetAbsoluteRange(tp,1,0)
		   e2:SetTarget(c10110006.splimit)
		   e2:SetReset(RESET_EVENT+0x1fe0000)
		   token:RegisterEffect(e2,true)
		end
	end
	Duel.SpecialSummonComplete()
end
function c10110006.splimit(e,c)
	return not c:IsSetCard(0x9332)
end
function c10110006.thfilter(c)
	return c:IsCode(10110005) and c:IsAbleToHand()
end
function c10110006.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10110006.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c10110006.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10110006.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end