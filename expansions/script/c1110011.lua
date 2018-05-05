--海梦·须臾永恒
function c1110011.initial_effect(c)
--
	c:EnableReviveLimit()
--
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c1110011.con1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1110011,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c1110011.cost2)
	e2:SetTarget(c1110011.tg2)
	e2:SetOperation(c1110011.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(c1110011.op3)
	c:RegisterEffect(e3)
--
end
--
function c1110011.cfilter1(c)
	return c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_SPIRIT)
end
function c1110011.con1(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and not Duel.IsExistingMatchingCard(c1110011.cfilter1,c:GetControler(),LOCATION_GRAVE,0,1,nil)
end
--
function c1110011.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local num=Duel.GetFlagEffect(tp,1110011)+1
	if chk==0 then return Duel.CheckLPCost(tp,num*800) end
	Duel.PayLPCost(tp,num*800)
end
--
function c1110011.tfilter2(c)
	return c:IsAbleToGrave() and c:IsType(TYPE_SPIRIT) and c:IsType(TYPE_MONSTER)
end
function c1110011.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) and Duel.IsExistingMatchingCard(c1110011.tfilter2,tp,LOCATION_MZONE+LOCATION_HAND,0,1,c) end
	Duel.RegisterFlagEffect(tp,1110011,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_MZONE+LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
--
function c1110011.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,c1110011.tfilter2,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,c)
	if sg:GetCount()<1 then return end
	if Duel.SendtoGrave(sg,REASON_EFFECT)<1 then return end
	Duel.Draw(tp,2,REASON_EFFECT)
end
--
function c1110011.op3(e,tp,eg,ep,ev,re,r,rp)
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
	e3_1:SetTarget(c1110011.tg3_1)
	e3_1:SetOperation(c1110011.op3_1)
	c:RegisterEffect(e3_1)
	local e3_2=e3_1:Clone()
	e3_2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	c:RegisterEffect(e3_2)
end
--
function c1110011.tg3_1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
--
function c1110011.op3_1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if not c:IsFaceup() then return end
	if Duel.SendtoHand(c,nil,REASON_EFFECT)<1 then return end
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<1 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,1110197,0,0x4011,0,4800,3,RACE_PSYCHO,ATTRIBUTE_WATER) then return end
	local token=Duel.CreateToken(tp,1110197)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	local e3_1_1=Effect.CreateEffect(c)
	e3_1_1:SetType(EFFECT_TYPE_SINGLE)
	e3_1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3_1_1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e3_1_1:SetValue(1)
	e3_1_1:SetReset(RESET_EVENT+0x1fe0000)
	token:RegisterEffect(e3_1_1,true)
	local e3_1_2=e3_1_1:Clone()
	e3_1_2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	token:RegisterEffect(e3_1_2,true)
	local e3_1_3=e3_1_1:Clone()
	e3_1_3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	token:RegisterEffect(e3_1_3,true)
	local e3_1_4=e3_1_1:Clone()
	e3_1_4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	token:RegisterEffect(e3_1_4,true)
	local e3_1_5=e3_1_1:Clone()
	e3_1_5:SetCode(EFFECT_UNRELEASABLE_SUM)
	token:RegisterEffect(e3_1_5,true)
	local e3_1_6=e3_1_1:Clone()
	e3_1_6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	token:RegisterEffect(e3_1_6,true)
end
--
