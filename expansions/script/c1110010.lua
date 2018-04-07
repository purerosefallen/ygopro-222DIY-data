--蜇居·风雪旖旎
local m=1110010
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
--
function c1110010.initial_effect(c)
--
	c:EnableReviveLimit()
--
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c1110010.con1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1110010,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c1110010.cost2)
	e2:SetTarget(c1110010.tg2)
	e2:SetOperation(c1110010.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(c1110010.op3)
	c:RegisterEffect(e3)
--
end
--
function c1110010.cfilter1(c)
	return muxu.check_set_Soul(c) and c:IsFaceup()
end
function c1110010.con1(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c1110010.cfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
--
function c1110010.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_DECK,0,1,1,nil)
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
--
function c1110010.tfilter2_1(c)
	return c:IsAbleToDeck() and muxu.check_set_Legend(c)
end
function c1110010.tfilter2_2(c)
	return c:IsCanAddCounter(0x1111,1)
end
function c1110010.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c1110010.tfilter2_1,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(c1110010.tfilter2_2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
--
function c1110010.op2(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=Duel.SelectMatchingCard(tp,c1110010.tfilter2_1,tp,LOCATION_GRAVE,0,1,1,nil)
	if sg:GetCount()<1 then return end
	if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1110010,1))
	local tg=Duel.SelectMatchingCard(tp,c1110010.tfilter2_2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if tg:GetCount()<1 then return end
	local tc=tg:GetFirst()
	tc:AddCounter(0x1111,1)
end
--
function c1110010.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e3_1=Effect.CreateEffect(c)
	e3_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3_1:SetDescription(1104)
	e3_1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3_1:SetCode(EVENT_PHASE+PHASE_END)
	e3_1:SetRange(LOCATION_MZONE)
	e3_1:SetCountLimit(1)
	e3_1:SetReset(RESET_EVENT+0x1ee0000+RESET_PHASE+PHASE_END)
	e3_1:SetCondition(aux.SpiritReturnCondition)
	e3_1:SetTarget(c1110010.tg3_1)
	e3_1:SetOperation(c1110010.op3_1)
	c:RegisterEffect(e3_1)
	local e3_2=e3_1:Clone()
	e3_2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	c:RegisterEffect(e3_2)
end
--
function c1110010.tg3_1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
--
function c1110010.op3_1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if not c:IsFaceup() then return end
	if Duel.SendtoHand(c,nil,REASON_EFFECT)<1 then return end
	if not c:IsLocation(LOCATION_HAND) then return end
	local e3_1_1=Effect.CreateEffect(c)
	e3_1_1:SetType(EFFECT_TYPE_SINGLE)
	e3_1_1:SetCode(EFFECT_PUBLIC)
	e3_1_1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e3_1_1)
	c:RegisterFlagEffect(1110010,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,66)
	c:RegisterFlagEffect(1110011,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	c:RegisterFlagEffect(1110012,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,2)
	local e3_1_2=Effect.CreateEffect(c)
	e3_1_2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e3_1_2:SetType(EFFECT_TYPE_FIELD)
	e3_1_2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3_1_2:SetReset(RESET_PHASE+PHASE_END,2)
	e3_1_2:SetTargetRange(1,0)
	e3_1_2:SetTarget(c1110010.tg3_1_2)
	Duel.RegisterEffect(e3_1_2,tp)
end
--
function c1110010.tg3_1_2(e,c)
	return c:GetFlagEffect(1110011)~=c:GetFlagEffect(1110012)
end
--
