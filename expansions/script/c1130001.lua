--莱姆狐-捕鱼小队
local m=1130001
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Hinbackc=true
--
function c1130001.initial_effect(c)
--
	if not c1130001.global_check then
		c1130001.global_check=true
		local e0=Effect.GlobalEffect()
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_REMOVE)
		e0:SetCondition(c1130001.con0)
		e0:SetOperation(c1130001.op0)
		Duel.RegisterEffect(e0,0)
	end
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c1130001.con1)
	e1:SetTarget(c1130001.tg1)
	e1:SetOperation(c1130001.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1130001,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c1130001.tg2)
	e2:SetOperation(c1130001.op2)
	c:RegisterEffect(e2)
--
end
--
function c1130001.cfilter0(c)
	return muxu.check_set_Hinbackc(c) and c:IsFaceup()
end
function c1130001.con0(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1130001.cfilter0,1,nil)
end
--
function c1130001.op0(e,tp,eg,ep,ev,re,r,rp)
	local sg=eg:Filter(c1130001.cfilter0,nil)
	local sc=sg:GetFirst()
	while sc do
		local p=sc:GetPreviousControler()
		Duel.RegisterFlagEffect(p,1130001,RESET_PHASE+PHASE_END,0,1)
		sc=sg:GetNext()
	end
end
--
function c1130001.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,1130001)>0
end
--
function c1130001.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsSummonable(true,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,c,1,0,0)
end
--
function c1130001.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Summon(tp,c,true,nil)
end
--
function c1130001.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
--
function c1130001.ofilter2(c,checknum)
	return c:IsAbleToHand() and (
		(checknum==3 and c:IsType(TYPE_TRAP)) or
		(checknum==2 and c:IsType(TYPE_SPELL)) or
		(checknum==1 and c:IsType(TYPE_MONSTER)))
end
function c1130001.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<1 then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	local checknum=0
	if tc:IsType(TYPE_TRAP) then checknum=3 end
	if tc:IsType(TYPE_SPELL) then checknum=2 end
	if tc:IsType(TYPE_MONSTER) then checknum=1 end
	Duel.ShuffleDeck(tp)
	local sg=Duel.GetMatchingGroup(c1130001.ofilter2,tp,LOCATION_GRAVE,0,nil,checknum)
	if sg:GetCount()<1 then return end
	local tg=sg:RandomSelect(tp,1)
	if Duel.SendtoHand(tg,nil,REASON_EFFECT)<1 then return end
	Duel.ConfirmCards(1-tp,tg)
	Duel.ShuffleHand(tp)
	Duel.BreakEffect()
	Duel.Recover(tp,800,REASON_EFFECT)
end
--
