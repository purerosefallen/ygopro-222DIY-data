--梦染
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400023.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71400023,1))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,71400023+EFFECT_COUNT_CODE_DUEL)
	e1:SetHintTiming(0,0x1f0)
	e1:SetTarget(c71400023.tg1)
	e1:SetOperation(c71400023.op1)
	c:RegisterEffect(e1)
	--ac in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(yume.nonYumeCon)
	c:RegisterEffect(e0)
	--banish
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71400023,2))
	e2:SetCategory(CATEGORY_BANISH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c71400023.tg2)
	e2:SetOperation(c71400023.op2)
	c:RegisterEffect(e2)
end
function c71400023.filter1(c,tp)
	return c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp) and c:IsSetCard(0x3714)
end
function c71400023.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400023.filter1,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c71400023.op1(e,tp,eg,ep,ev,re,r,rp)
	c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(71400023,0))
	local tc=Duel.SelectMatchingCard(tp,c71400023.filter1,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		local flag=Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		if flag then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_MSET)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetRange(LOCATION_FZONE)
			e1:SetTargetRange(1,1)
			e1:SetTarget(aux.TRUE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CANNOT_SSET)
			tc:RegisterEffect(e2,true)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_CANNOT_TURN_SET)
			tc:RegisterEffect(e3,true)
			local e4=e1:Clone()
			e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e4:SetTarget(c71400023.sumlimit)
			tc:RegisterEffect(e4,true)
		end
	end
end
function c71400023.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return bit.band(sumpos,POS_FACEDOWN)>0
end
function c71400023.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_BANISH)
	local g1=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_BANISH)
	local g2=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_BANISH,g1,2,0,0)
end
function c71400023.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()==2 then
		Duel.Remove(sg,REASON_EFFECT)
	end
end