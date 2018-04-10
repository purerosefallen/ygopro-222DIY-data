--灵都·命运交错
local m=1111501
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Urban=true
--
function c1111501.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c1111501.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1111501,2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c1111501.cost2)
	e2:SetTarget(c1111501.tg2)
	e2:SetOperation(c1111501.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1111501,3))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(c1111501.cost3)
	e3:SetTarget(c1111501.tg3)
	e3:SetOperation(c1111501.op3)
	c:RegisterEffect(e3)
--
end
--
function c1111501.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,1111501)>0 then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,1110199,0,0x4011,100,100,3,RACE_FAIRY,ATTRIBUTE_LIGHT) and Duel.SelectYesNo(tp,aux.Stringid(1111501,0)) then
		Duel.RegisterFlagEffect(tp,1111501,RESET_PHASE+PHASE_END,0,0)
		local token=Duel.CreateToken(tp,1110199)
		if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)<1 then return end
		local e1_1=Effect.CreateEffect(c)
		e1_1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1_1:SetCode(EVENT_BE_MATERIAL)
		e1_1:SetCondition(c1111501.con1_1)
		e1_1:SetOperation(c1111501.op1_1)
		e1_1:SetReset(RESET_EVENT+0x1fe0000)
		token:RegisterEffect(e1_1)
	end
end
--
function c1111501.con1_1(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_LINK)~=0 
end
function c1111501.op1_1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
--	rc:RegisterFlagEffect(1111501,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(1111501,1))
	local e1_1_1=Effect.CreateEffect(c)
	e1_1_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1_1_1:SetType(EFFECT_TYPE_FIELD)
	e1_1_1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1_1_1:SetTargetRange(1,1)
	e1_1_1:SetLabelObject(rc)
	e1_1_1:SetTarget(c1111501.tg1_1_1)
	Duel.RegisterEffect(e1_1_1,tp)
end
--
function c1111501.tg1_1_1(e,c)
	local rc=e:GetLabelObject()
	return c:IsControler(rc:GetSummonPlayer()) and c:IsType(TYPE_LINK) --and rc:GetFlagEffect(1111501)>0
end
--
function c1111501.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(g,nil,1,REASON_COST)
end
--
function c1111501.tfilter2(c)
	return c:IsCode(1110004) and c:IsAbleToHand()
end
function c1111501.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1111501.tfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
--
function c1111501.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=Duel.SelectMatchingCard(tp,c1111501.tfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if sg:GetCount()<1 then return end
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
end
--
function c1111501.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
--
function c1111501.tfilter3(c,e,tp)
	return c:IsCode(1110003) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1111501.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c1111501.tfilter3,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,LOCATION_DECK)
end
--
function c1111501.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1111501.tfilter3,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()<1 then return end
	local tc=g:GetFirst()
	if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 and Duel.SelectYesNo(tp,aux.Stringid(1111501,4)) then
		local e3_1=Effect.CreateEffect(c)
		e3_1:SetType(EFFECT_TYPE_SINGLE)
		e3_1:SetCode(EFFECT_UPDATE_LEVEL)
		e3_1:SetValue(2)
		e3_1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3_1)
	end
end
--
