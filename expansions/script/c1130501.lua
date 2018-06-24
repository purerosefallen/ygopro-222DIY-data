--莱姆狐-上神狐民
local m=1130501
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Hinbackc=true
--
function c1130501.initial_effect(c)
--
	c:EnableReviveLimit()
--
	local e0_1=Effect.CreateEffect(c)
	e0_1:SetType(EFFECT_TYPE_SINGLE)
	e0_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0_1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0_1:SetValue(aux.ritlimit)
	c:RegisterEffect(e0_1)
--
	local e0_2=Effect.CreateEffect(c)
	e0_2:SetType(EFFECT_TYPE_SINGLE)
	e0_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0_2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0_2:SetValue(c1130501.val0_2)
	c:RegisterEffect(e0_2)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1130501,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetCondition(c1130501.con1)
	e1:SetTarget(c1130501.tg1)
	e1:SetOperation(c1130501.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1130501,2))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c1130501.con2)
	e2:SetTarget(c1130501.tg2)
	e2:SetOperation(c1130501.op2)
	c:RegisterEffect(e2)
--
end
--
function c1130501.val0_2(e,se,sp,st)
	return se:GetHandler()==e:GetHandler()
end
--
function c1130501.cfilter1(c,tp)
	return muxu.check_set_Hinbackc(c) and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp and c:IsReason(REASON_EFFECT)
end
function c1130501.con1(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and r and bit.band(r,REASON_EFFECT)~=0
		and eg:IsExists(c1130501.cfilter1,1,nil,tp)
end
--
function c1130501.ofilter1(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and not c:IsForbidden()
end
function c1130501.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lp=Duel.GetLP(tp)
	local sg=eg:Filter(c1130501.cfilter1,nil,tp)
	local sc=sg:GetFirst()
	local lv=0
	while sc do
		lv=lv+sc:GetLevel()
		sc=sg:GetNext()
	end
	if chk==0 then
		local num1=math.min(lv,c:GetLevel())
		local num2=math.max(lv,c:GetLevel())
		return num1>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false)
		and Duel.CheckLPCost(tp,(num2-num1)*600)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c1130501.ofilter1,tp,LOCATION_DECK,0,1,1,nil)
	end
	e:SetLabel(lv)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
--
function c1130501.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local lv=e:GetLabel()
	local num1=math.min(lv,c:GetLevel())
	local num2=math.max(lv,c:GetLevel())
	if num1<1 then return end
	local lp=Duel.GetLP(tp)
	if lp<(num2-num1)*600 then return end
	Duel.PayLPCost(tp,(num2-num1)*600)
	c:SetMaterial(nil)
	Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
	c:CompleteProcedure()
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local cg=Duel.GetMatchingGroup(c1130501.ofilter1,tp,LOCATION_DECK,0,nil)
	if cg:GetCount()<1 then return end
	local cn=cg:GetClassCount(Card.GetCode)
	local num=math.min(ft,cn)
	if num<1 then return end
	local tg=Group.CreateGroup()
	for i=1,num do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local cc=cg:Select(tp,1,1,nil):GetFirst()
		tg:AddCard(cc)
		local code=cc:GetCode()
		local rg=cg:Filter(Card.IsCode,nil,code)
		cg:Sub(rg)
	end
	if tg:GetCount()<1 then return end
	Duel.BreakEffect()
	local tc=tg:GetFirst()
	while tc do
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1_1=Effect.CreateEffect(c)
		e1_1:SetDescription(aux.Stringid(1130501,1))
		e1_1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1_1:SetCode(EVENT_PHASE+PHASE_END)
		e1_1:SetRange(LOCATION_SZONE)
		e1_1:SetCountLimit(1)
		e1_1:SetOperation(c1130501.op1_1)
		e1_1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1_1,true)
		tc=tg:GetNext()
	end
end
--
function c1130501.op1_1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
end
--
function c1130501.con2(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
--
function c1130501.tfilter2(c)
	return c:IsAbleToHand() and c:IsCode(1131301)
end
function c1130501.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.RegisterFlagEffect(tp,1130501,0,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
--
function c1130501.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.Remove(c,POS_FACEDOWN,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,c1130501.tfilter2,tp,LOCATION_DECK,0,1,1,nil)
		if sg:GetCount()<1 then return end
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
--
