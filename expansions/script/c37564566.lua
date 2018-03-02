--Nanahira & Hanatan
local m=37564566
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_desc_with_nanahira=true
function cm.initial_effect(c)
	Senya.Nanahira(c)
	aux.AddSynchroProcedure2(c,aux.FilterBoolFunction(Card.IsCode,37564765),aux.FilterBoolFunction(Card.IsCode,37564765))
	c:EnableReviveLimit()
	Senya.AddSummonMusic(c,m*16,SUMMON_TYPE_SYNCHRO)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(Senya.SummonTypeCondition(SUMMON_TYPE_SYNCHRO))
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.target1)
	e1:SetOperation(cm.operation1)
	c:RegisterEffect(e1)
end
function cm.filter(c)
	return c.Senya_desc_with_nanahira and c:IsSSetable(true) and c:IsType(TYPE_TRAP)
end
function cm.check(g)
	return g:GetClassCount(Card.GetCode)==#g
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil)
		return Duel.GetLocationCount(tp,LOCATION_SZONE)>=5 and Senya.CheckGroup(g,cm.check,nil,5,5)
	end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if not cm.target(e,tp,eg,ep,ev,re,r,rp,0) then return end
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil)
	local tg=Senya.SelectGroup(tp,HINTMSG_SET,g,cm.check,nil,5,5)
	for tc in aux.Next(tg) do
		Duel.SSet(tp,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UNRELEASABLE_SUM)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3)
		cm[tc]={e1,e2,e3}
		if e:GetHandler():IsFaceup() and e:GetHandler():IsRelateToEffect(e) then
			e:GetHandler():SetCardTarget(tc)
		end
	end
	Duel.ConfirmCards(1-tp,tg)
end
function cm.rfilter(c,ec)
	return cm[c] and c:IsType(TYPE_TRAP) and ec:IsHasCardTarget(c)
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and cm.rfilter(chkc,ec) end
	if chk==0 then return Duel.IsExistingTarget(cm.rfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.rfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,c)
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local eset=cm[tc]
		if eset then
			for _,te in ipairs(tc) do
				te:Reset()
			end
			cm[tc]=nil
		end
		if c:IsHasCardTarget(tc) then c:CancelCardTarget(tc) end
	end
end