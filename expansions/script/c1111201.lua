--灵都·流莹水榭
local m=1111201
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Urban=true
--
function c1111201.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c1111201.cost2)
	e2:SetTarget(c1111201.tg2)
	e2:SetOperation(c1111201.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1111201,3))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c1111201.con3)
	e3:SetOperation(c1111201.op3)
	c:RegisterEffect(e3)
--
end
--
function c1111201.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(sg,nil,1,REASON_COST)
end
--
function c1111201.tfilter2(c)
	return muxu.check_set_Urban(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c1111201.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1111201.tfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
--
function c1111201.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=Duel.SelectMatchingCard(tp,c1111201.tfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if sg:GetCount()<1 then return end
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
end
--
function c1111201.con3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if not bc then return false end
	if bc:IsControler(1-tp) then
		e:SetLabelObject(bc)
		bc=tc
	else
		e:SetLabelObject(tc)
	end
	return bc:IsFaceup() and muxu.check_set_Urban(bc)
end
--
function c1111201.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if tc:IsRelateToBattle() and tc:IsFaceup() and tc:IsControler(1-tp) then
		local e3_1=Effect.CreateEffect(c)
		e3_1:SetType(EFFECT_TYPE_SINGLE)
		e3_1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
		e3_1:SetRange(LOCATION_MZONE)
		e3_1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e3_1:SetValue(0)
		e3_1:SetReset(RESET_PHASE+PHASE_DAMAGE)
		tc:RegisterEffect(e3_1,true)
		local e3_2=Effect.CreateEffect(c)
		e3_2:SetType(EFFECT_TYPE_SINGLE)
		e3_2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
		e3_2:SetRange(LOCATION_MZONE)
		e3_2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e3_2:SetValue(0)
		e3_2:SetReset(RESET_PHASE+PHASE_DAMAGE)
		tc:RegisterEffect(e3_2,true)
	end
end
--
