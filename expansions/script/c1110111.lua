--灵都·静寂彼岸
local m=1110111
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Urban=true
--
function c1110111.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,1110004,c1110111.filter,1,true,true)
--  
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1110111,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,1110111)
	e1:SetCondition(c1110111.con1)
	e1:SetTarget(c1110111.tg1)
	e1:SetOperation(c1110111.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1110111,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1c0+TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,1110111)
	e2:SetCondition(c1110111.con2)
	e2:SetTarget(c1110111.tg2)
	e2:SetOperation(c1110111.op1)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetTarget(c1110111.tg3)
	e3:SetOperation(c1110111.op3)
	c:RegisterEffect(e3)
--
end
--
function c1110111.filter(c)
	return c:IsCode(1110001) or c:IsCode(1110121)
end
--
function c1110111.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(c:GetSummonType(),SUMMON_TYPE_FUSION)~=0 and c:GetMaterialCount()>0 
end
--
function c1110111.tfilter1(c)
	local seq=c:GetSequence()
	return c:IsFaceup() and not (c:IsLocation(LOCATION_MZONE) and seq>4)
end
function c1110111.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1110111.tfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.GetFlagEffect(tp,1110004)<1 end
end
--
function c1110111.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tg=Duel.SelectMatchingCard(tp,c1110111.tfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if tg:GetCount()<1 then return end
	local tc=tg:GetFirst()
	Duel.NegateRelatedChain(tc,RESET_TURN_SET)
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetType(EFFECT_TYPE_SINGLE)
	e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1_1:SetCode(EFFECT_DISABLE)
	e1_1:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e1_1)
	local e1_2=Effect.CreateEffect(c)
	e1_2:SetType(EFFECT_TYPE_SINGLE)
	e1_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1_2:SetCode(EFFECT_DISABLE_EFFECT)
	e1_2:SetValue(RESET_TURN_SET)
	e1_2:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e1_2)
	local e1_3=Effect.CreateEffect(c)
	e1_3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1_3:SetType(EFFECT_TYPE_SINGLE)
	e1_3:SetCode(EFFECT_CANNOT_TRIGGER)
	e1_3:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e1_3)
	local e1_4=Effect.CreateEffect(c)
	e1_4:SetType(EFFECT_TYPE_SINGLE)
	e1_4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1_4:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	e1_4:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e1_4)
	local e1_5=Effect.CreateEffect(c)
	e1_5:SetType(EFFECT_TYPE_SINGLE)
	e1_5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1_5:SetCode(EFFECT_CANNOT_ATTACK)
	e1_5:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e1_5)
	local e1_6=Effect.CreateEffect(c)
	e1_6:SetType(EFFECT_TYPE_SINGLE)
	e1_6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1_6:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e1_6:SetValue(1)
	e1_6:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e1_6)
	local e1_7=Effect.CreateEffect(c)
	e1_7:SetType(EFFECT_TYPE_SINGLE)
	e1_7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1_7:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e1_7:SetValue(1)
	e1_7:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e1_7)
	local e1_8=Effect.CreateEffect(c)
	e1_8:SetType(EFFECT_TYPE_SINGLE)
	e1_8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1_8:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e1_8:SetValue(1)
	e1_8:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e1_8)
	local e1_9=Effect.CreateEffect(c)
	e1_9:SetType(EFFECT_TYPE_SINGLE)
	e1_9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1_9:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1_9:SetValue(1)
	e1_9:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e1_9)
end
--
function c1110111.con2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
--
function c1110111.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1110111.tfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.GetFlagEffect(tp,1110004)>0 end
end
--
function c1110111.tfilter3(c)
	return c:IsCode(1110141) and c:IsAbleToHand()
end
function c1110111.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c1110111.tfilter3,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
--
function c1110111.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1110111.tfilter3,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()<1 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end
--
