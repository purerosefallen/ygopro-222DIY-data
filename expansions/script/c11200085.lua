--鹰已击中
function c11200085.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,11200085+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c11200085.condition)
	e1:SetOperation(c11200085.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,21200084)
	e2:SetCondition(c11200085.condition1)
	e2:SetCost(c11200085.cost)
	e2:SetOperation(c11200085.activate)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,31200085)
	e3:SetTarget(c11200085.target2)
	e3:SetOperation(c11200085.activate2)
	c:RegisterEffect(e3)
	
end
function c11200085.filter(c)
	return c:IsSetCard(0x131) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c11200085.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c11200085.filter,tp,LOCATION_MZONE+LOCATION_REMOVED,0,1,nil)
end
function c11200085.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c11200085.filter,tp,LOCATION_MZONE+LOCATION_REMOVED,0,1,nil) and Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
end
function c11200085.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	local g=Group.CreateGroup()
	g:AddCard(c)
	Duel.HintSelection(g)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c11200085.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c11200085.acfilter,tp,0,LOCATION_MZONE,nil)
	local op=1
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		op=Duel.SelectOption(tp,aux.Stringid(11200085,0),aux.Stringid(11200085,1))
	end
	if op==0 then
		if g:GetCount()>0 then
			local sc=g:GetFirst()
			while sc do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				e1:SetValue(-550)
				sc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_UPDATE_DEFENSE)
				sc:RegisterEffect(e2)
				sc=g:GetNext()
			end
		end
	elseif op==1 then
		Duel.Damage(1-tp,1100,REASON_EFFECT)
	end
	--local e1=Effect.CreateEffect(e:GetHandler())
	--e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	--e1:SetCode(EVENT_DAMAGE)
	--e1:SetCondition(c11200085.ctcon)
	--e1:SetOperation(c11200085.ctop)
	--Duel.RegisterEffect(e1,tp)
end
function c11200085.cfilter(c)
	return c:IsSetCard(0x131) and c:IsType(TYPE_MONSTER) and c:IsOnField()
end
function c11200085.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and tp==rp and ((bit.band(r,REASON_BATTLE)~=0 and c11200085.cfilter(eg:GetFirst())) or (bit.band(r,REASON_EFFECT)~=0) and c11200085.cfilter(re:GetHandler()))
end
function c11200085.ctop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,550,REASON_EFFECT)
end
function c11200085.filter2(c)
	return c:IsSetCard(0x131) and c:IsFaceup()
end
function c11200085.rcheck(c,sg)
	return c:IsSetCard(0x131) and c:IsFaceup() and sg:IsExists(aux.TRUE,1,c)
end
function c11200085.rselect(c,tp,mg,sg)
	sg:AddCard(c)
	local res=false
	if sg:GetCount()<2 then
		res=mg:IsExists(c11200085.rselect,1,sg,tp,mg,sg)
	else
		res=sg:IsExists(c11200085.rcheck,1,nil,sg)
	end
	sg:RemoveCard(c)
	return res
end
function c11200085.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetFieldGroup(tp,LOCATION_REMOVED,0)
	local sg=Group.CreateGroup()
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) end
	if chk==0 then return Duel.IsExistingTarget(c11200085.filter2,tp,LOCATION_REMOVED,0,1,nil) and Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_REMOVED,0,2,nil) end
	while sg:GetCount()<2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g=mg:FilterSelect(tp,c11200085.rselect,1,1,sg,tp,mg,sg)
		sg:Merge(g)
	end
	Duel.SetTargetCard(sg)
end
function c11200085.activate2(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Clone()
	if not sg:IsExists(Card.IsRelateToEffect,2,nil,e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=sg:Select(tp,1,1,nil)
	sg:Sub(g) 
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)
	if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.Remove(e:GetHandler(),POS_FACEDOWN,REASON_EFFECT)
	end
end
